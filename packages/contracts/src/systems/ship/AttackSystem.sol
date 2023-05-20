// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Position, FirePower, Health } from "../../codegen/Tables.sol";
import { CHUNK_SIZE } from "../../constants.sol";
import { PORT } from "../world/terrainPrimitives.sol";
import { ObjectSystem } from "../world/objects.sol";

contract AttackSystem is System {

    function attack(address otherPlayer) public {
        int256 currentPositionX = Position.getPos_x(keccak256(abi.encodePacked(msg.sender)));
        int256 currentPositionY = Position.getPos_y(keccak256(abi.encodePacked(msg.sender)));
        int256 otherPlayerPositionX = Position.getPos_x(keccak256(abi.encodePacked(otherPlayer)));
        int256 otherPlayerPositionY = Position.getPos_y(keccak256(abi.encodePacked(otherPlayer)));

        int256 currentChunkX = currentPositionX / CHUNK_SIZE;
        int256 currentChunkY = currentPositionY / CHUNK_SIZE;
        int256 otherPlayerChunkX = otherPlayerPositionX / CHUNK_SIZE;
        int256 otherPlayerChunkY = otherPlayerPositionY / CHUNK_SIZE;

        // Make sure the two players are in the same chunk to attack
        require(currentChunkX == otherPlayerChunkX && currentChunkY == otherPlayerChunkY, "Not within firing distance");

        uint256 worldObject = ObjectSystem.getObject(currentPositionX, currentPositionY);
        require(worldObject != PORT, "Cannot attack in port");

        uint256 lastFire = FirePower.getLast_update(keccak256(abi.encodePacked(msg.sender)));
        uint256 fireRate = FirePower.getRate(keccak256(abi.encodePacked(msg.sender)));
        uint256 firePower = FirePower.getPower(keccak256(abi.encodePacked(msg.sender)));
        // Can only fire at a particular rate
        require(lastFire + fireRate >= block.timestamp, "Reloading");
        
        uint256 otherPlayerHealth = Health.getHealth(keccak256(abi.encodePacked(otherPlayer)));
        if (otherPlayerHealth - firePower <= 0) {
            death(otherPlayer);
        }
        else { 
            Health.setHealth(keccak256(abi.encodePacked(otherPlayer)), otherPlayerHealth - firePower);
        }
        FirePower.setLast_update(keccak256(abi.encodePacked(msg.sender)), block.timestamp);
    }

    function death(address player) internal {
        // TODO: handle death
    }
}