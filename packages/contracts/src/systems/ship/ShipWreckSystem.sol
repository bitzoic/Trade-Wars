// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Position, ShipWreck, CargoSpace, Sugar, Salt, Iron, Spices } from "../../codegen/Tables.sol";
import { SHALLOW_OCEAN, DEEP_OCEAN, REEF } from "../world/terrainPrimitives.sol";
import { TerrainLibrary } from "../world/terrain.sol";
import { ObjectLibrary } from "../world/objects.sol";
import { IRON_WEIGHT, SUGAR_WEIGHT, SALT_WEIGHT, SPICES_WEIGHT, CHUNK_SIZE, BASE_CARGO } from "../../constants.sol";

contract ShipWreckSystem is System {

    // NOTE: This function is public. This is a major security problem where anyone can come in 
    // and spawn as many ship wrecks as they like, breaking the game's economics. This NEEDS to be resolved.
    function createShipWreck(bytes32 playerId, int256 newPositionX, int256 newPositionY, uint256 iron, uint256 salt, uint256 sugar, uint256 spices) public {
        bytes memory data = new bytes(64);
        assembly {
            mstore(add(data, 32), newPositionX)
            mstore(add(data, 64), newPositionY)
        }

        // Make sure the ship wreck is in the water
        uint256 worldTerrain = TerrainLibrary.getTerrain(newPositionX, newPositionY);
        require(worldTerrain == SHALLOW_OCEAN || worldTerrain == DEEP_OCEAN , "Ships wrecks are only on water!");

        bytes32 shipWreckId = keccak256(data);
        Sugar.set(shipWreckId, sugar);
        Iron.set(shipWreckId, iron);
        Salt.set(shipWreckId, salt);
        Spices.set(shipWreckId, spices);
        ShipWreck.set(shipWreckId, playerId);
    }  

    function shipWreckExists(int256 positionX, int256 positionY) public returns (bytes32) {
        // Make sure there is a wreck here
        bytes memory data = new bytes(64);
        assembly {
            mstore(add(data, 32), positionX)
            mstore(add(data, 64), positionY)
        }

        bytes32 shipWreckId = keccak256(data);
        require(ShipWreck.get(shipWreckId) != 0, "Ship Wreck doesn't exist");

        return shipWreckId;
    }

    function nearShipWreck(int256 positionX, int256 positionY) private returns (bytes32) {
        bytes32 playerId = keccak256(abi.encodePacked(_msgSender()));

        // Make sure the player is where they say they are, at the shipwreck
        int256 currentPositionX = Position.getPos_x(playerId);
        int256 currentPositionY = Position.getPos_y(playerId);
        require(currentPositionX / CHUNK_SIZE == positionX / CHUNK_SIZE 
            && currentPositionY / CHUNK_SIZE == positionY / CHUNK_SIZE, 
            "Not within claiming distance"
        );
        
        return playerId;
    }

    function claimShipWreckIron(int256 positionX, int256 positionY) public {
        bytes32 shipWreckId = shipWreckExists(positionX, positionY);
        bytes32 playerId = nearShipWreck(positionX, positionY);

        // Make sure there is iron in the ship wreck
        uint256 shipWreckIron = Iron.get(shipWreckId);
        require(shipWreckIron >= amount, "Not enough iron");

        // Make sure they have enough space for the iron
        uint256 ironWeight = amount * IRON_WEIGHT;
        uint256 playerCargo = CargoSpace.getCargo(playerId);
        require(ironWeight + playerCargo <= CargoSpace.getMax_cargo(playerId) + BASE_CARGO, "Not enough cargo space");

        Iron.set(playerId, Iron.get(playerId) + amount);
        CargoSpace.setCargo(playerId, playerCargo + ironWeight);
        // If all the iron is gone, delete the record
        if (shipWreckIron == amount) {
            Iron.deleteRecord(shipWreckId);
        } else {
            Iron.set(shipWreckId, shipWreckIron - amount);
        }
    }

    function claimShipWreckSalt(int256 positionX, int256 positionY, uint256 amount) public {
        bytes32 shipWreckId = shipWreckExists(positionX, positionY);
        bytes32 playerId = nearShipWreck(positionX, positionY);

        // Make sure there is salt in the ship wreck
        uint256 shipWreckSalt = Salt.get(shipWreckId);
        require(shipWreckSalt >= amount, "Not enough salt");

        // Make sure they have enough space for the salt
        uint256 saltWeight = amount * SALT_WEIGHT;
        uint256 playerCargo = CargoSpace.getCargo(playerId);
        require(saltWeight + playerCargo <= CargoSpace.getMax_cargo(playerId) + BASE_CARGO, "Not enough cargo space");

        Salt.set(playerId, Salt.get(playerId) + amount);
        CargoSpace.setCargo(playerId, playerCargo + saltWeight);
        // If all the salt is gone, delete the record
        if (shipWreckSalt == amount) {
            Salt.deleteRecord(shipWreckId);
        } else {
            Salt.set(shipWreckId, shipWreckSalt - amount);
        }
    }

    function claimShipWreckSpices(int256 positionX, int256 positionY, uint256 amount) public {
        bytes32 shipWreckId = shipWreckExists(positionX, positionY);
        bytes32 playerId = nearShipWreck(positionX, positionY);

        // Make sure there is spices in the ship wreck
        uint256 shipWreckSpices = Spices.get(shipWreckId);
        require(shipWreckSpices >= amount, "Not enough spices");

        // Make sure they have enough space for the spices
        uint256 spicesWeight = amount * SPICES_WEIGHT;
        uint256 playerCargo = CargoSpace.getCargo(playerId);
        require(spicesWeight + playerCargo <= CargoSpace.getMax_cargo(playerId) + BASE_CARGO, "Not enough cargo space");

        Spices.set(playerId, Spices.get(playerId) + amount);
        CargoSpace.setCargo(playerId, playerCargo + spicesWeight);
        // If all the spcies are gone, delete the record
        if (shipWreckSpices == amount) {
            Spices.deleteRecord(shipWreckId);
        } else {
            Spices.set(shipWreckId, shipWreckSpices - amount);
        }
    }

    function claimShipWreckSugar(int256 positionX, int256 positionY, uint256 amount) public {
        bytes32 shipWreckId = shipWreckExists(positionX, positionY);
        bytes32 playerId = nearShipWreck(positionX, positionY);

        // Make sure there is sugar in the ship wreck
        uint256 shipWreckSugar = Sugar.get(shipWreckId);
        require(shipWreckSugar >= amount, "Not enough sugar");

        // Make sure they have enough space for the sugar
        uint256 sugarWeight = amount * SUGAR_WEIGHT;
        uint256 playerCargo = CargoSpace.getCargo(playerId);
        require(sugarWeight + playerCargo <= CargoSpace.getMax_cargo(playerId) + BASE_CARGO, "Not enough cargo space");

        Sugar.set(playerId, Sugar.get(playerId) + amount);
        CargoSpace.setCargo(playerId, playerCargo + sugarWeight);
        // If all the sugar is gone, delete the record
        if (shipWreckSugar == amount) {
            Sugar.deleteRecord(shipWreckId);
        } else {
            Sugar.set(shipWreckId, shipWreckSugar - amount);
        }
    }
}