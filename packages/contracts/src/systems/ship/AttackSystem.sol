// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Position, FirePower, Health, Sugar, Iron, Spices, Salt, Coins, CargoSpace, Speed } from "../../codegen/Tables.sol";
import { CHUNK_SIZE, BASE_FIRE_POWER, BASE_FIRE_RATE, BASE_HEALTH } from "../../constants.sol";
import { PORT } from "../world/terrainPrimitives.sol";
import { ObjectLibrary } from "../world/objects.sol";
import { IShipWreckSystem } from "../../codegen/world/IShipWreckSystem.sol";

contract AttackSystem is System {

    function attack(bytes32 otherPlayerId) public {
        bytes32 playerId = keccak256(abi.encodePacked(_msgSender()));

        // Get player positions
        int256 currentPositionX = Position.getPos_x(playerId);
        int256 currentPositionY = Position.getPos_y(playerId);
        int256 otherPlayerPositionX = Position.getPos_x(otherPlayerId);
        int256 otherPlayerPositionY = Position.getPos_y(otherPlayerId);

        // Make sure the two player are in the same chunk to attack
        require(currentPositionX / CHUNK_SIZE == otherPlayerPositionX / CHUNK_SIZE 
            && currentPositionY / CHUNK_SIZE == otherPlayerPositionY / CHUNK_SIZE, 
            "Not within firing distance"
        );

        // Make sure we are out at sea, the port is saftey
        require(ObjectLibrary.getObject(currentPositionX, currentPositionY) != PORT, "Cannot attack in port");

        // Can only fire at a specified rate of BASE_FIRE_RATE minus the fire rate upgrade
        // Upgrades to fire rate decrease the rate
        require(FirePower.getLast_update(playerId) + (BASE_FIRE_RATE - FirePower.getRate(playerId)) >= block.timestamp, "Reloading");
        
        uint256 otherPlayerHealth = Health.getHealth(otherPlayerId);
        uint256 firePower = FirePower.getPower(playerId);
        // Because everything starts at 0, health goes from 0 to max, where max is dead
        if (otherPlayerHealth + (firePower + BASE_FIRE_POWER) >= Health.getMax_health(otherPlayerId)) {
            // Player is dead
            death(otherPlayerId, otherPlayerPositionX, otherPlayerPositionY);
        }
        else { 
            // Damage taken
            Health.setHealth(otherPlayerId, otherPlayerHealth + (firePower + BASE_FIRE_POWER));
        }
        
        FirePower.setLast_update(playerId, block.timestamp);
    }

    function death(bytes32 playerId, int256 positionX, int256 positionY) internal {
        // Create a shipwreck for other players to loot
        IShipWreckSystem(_world()).createShipWreck(playerId, positionX, positionY, Iron.get(playerId), Salt.get(playerId), Sugar.get(playerId), Spices.get(playerId));

        // Move the current player back to spawn and reset ALL their stats, this game is hard
        Position.setPos_x(playerId, 0);
        Position.setPos_y(playerId, 0);
        Position.setLast_update(playerId, block.timestamp);
        Iron.set(playerId, 0);
        Salt.set(playerId, 0);
        Sugar.set(playerId, 0);
        Spices.set(playerId, 0);
        Health.setHealth(playerId, 0);
        Health.setMax_health(playerId, 0);
        CargoSpace.setCargo(playerId, 0);
        CargoSpace.setMax_cargo(playerId, 0);
        FirePower.setRate(playerId, 0);
        FirePower.setPower(playerId, 0);
        Speed.set(playerId, 0);
        Coins.set(playerId, 0);
    }
}