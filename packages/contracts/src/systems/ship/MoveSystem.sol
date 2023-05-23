// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Position, Health, HealthRegen, Speed } from "../../codegen/Tables.sol";
import { CHUNK_SIZE, HEALTH_REGEN_RATE, BASE_SPEED } from "../../constants.sol";
import { SHALLOW_OCEAN, DEEP_OCEAN, REEF, PORT } from "../world/terrainPrimitives.sol";
import { TerrainLibrary } from "../world/terrain.sol";
import { ObjectLibrary } from "../world/objects.sol";

contract MoveSystem is System {

    function move(int256 newPositionX, int256 newPositionY) public {
        bytes32 playerId = keccak256(abi.encodePacked(_msgSender()));

        // Get playerId location information
        int256 currentPositionX = Position.getPos_x(playerId);
        int256 currentPositionY = Position.getPos_y(playerId);

        int256 currentChunkX = currentPositionX / CHUNK_SIZE;
        int256 currentChunkY = currentPositionY / CHUNK_SIZE;
        int256 newChunkX = newPositionX / CHUNK_SIZE;
        int256 newChunkY = newPositionY / CHUNK_SIZE;

        // Make sure that this update is to an adjacent chunk or same the chunk and not a move across the map.
        // In practice forces players to update their position consistenly over time like a fixed update function.
        require(
            (newChunkX == currentChunkX || newChunkX - 1 == currentChunkX || newChunkX + 1 == currentChunkX) 
            && (newChunkY == currentChunkY || newChunkY - 1 == currentChunkY || newChunkY + 1 == currentChunkY), 
            "Moving too fast!");

        // sqrt((x2 - x1)^2 + (y2 - y1)^2)
        uint256 distance = sqrt(((newPositionX - currentPositionX) * (newPositionX - currentPositionX)) + ((newPositionY - currentPositionY) * (newPositionY - currentPositionY)));

        // Makes sure that the move is a function of speed and time.
        // In practice forces players to slowly "sail" across the map.
        // Note that the speed of the player is an increase atop of the base as everything initializes at 0
        // d = v * t
        uint256 lastPositionUpdate = Position.getLast_update(playerId);
        require(distance <= (Speed.get(playerId) + BASE_SPEED) * (block.timestamp - lastPositionUpdate), "Breaking the laws of physics!");
    
        // Make sure the move is in the ocean of the world, we can't sail accross land!
        uint256 newTerrain = TerrainLibrary.getTerrain(newPositionX, newPositionY);
        require(newTerrain == SHALLOW_OCEAN || newTerrain == DEEP_OCEAN , "Ships cannot sail on land!");

        // If the previous position was a port, check to make sure we if started regen
        uint256 lastHealthRegen = HealthRegen.get(playerId);
        if (ObjectLibrary.getObject(currentPositionX, currentPositionX) == PORT && lastPositionUpdate < lastHealthRegen) {
            update_health(playerId, lastHealthRegen);
        }

        // Now we can update to the new position
        Position.setPos_x(playerId, newPositionX);
        Position.setPos_y(playerId, newPositionY);
        Position.setLast_update(playerId, block.timestamp);
    }

    function update_health(bytes32 playerId, uint256 lastHealthRegen) private {
        // The amount to subtract from health, 0 is perfect health
        uint256 newHealth = HEALTH_REGEN_RATE * (block.timestamp - lastHealthRegen);
        uint256 playerHealth = Health.getHealth(playerId);

        // Health will either be the rate at which we stayed at the port or max
        Health.setHealth(playerId, playerHealth <= newHealth ? 0 : playerHealth - newHealth);
    }

    function sqrt(int256 x) private pure returns (uint256) {
        if (x == 0) {
            return 0;
        }

        int256 z = (x + 1) / 2;
        int256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return uint256(y);
    }

    function getTerrain(int256 positionX, int256 positionY) public pure returns (uint256) {
        return TerrainLibrary.getTerrain(positionX, positionY);
    }

    function getObject(int256 positionX, int256 positionY) public pure returns (uint256) {
        return ObjectLibrary.getObject(positionX, positionY);
    }
}
