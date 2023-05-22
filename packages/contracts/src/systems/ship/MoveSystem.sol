// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Position } from "../../codegen/Tables.sol";
import { Speed } from "../../codegen/Tables.sol";
import { CHUNK_SIZE } from "../../constants.sol";
import { SHALLOW_OCEAN, DEEP_OCEAN, REEF } from "../world/terrainPrimitives.sol";
import { TerrainLibrary } from "../world/terrain.sol";

contract MoveSystem is System {

    function move(int256 newPositionX, int256 newPositionY) public {
        address player = _msgSender();
        int256 currentPositionX = Position.getPos_x(keccak256(abi.encodePacked(player)));
        int256 currentPositionY = Position.getPos_y(keccak256(abi.encodePacked(player)));

        int256 currentChunkX = currentPositionX / CHUNK_SIZE;
        int256 currentChunkY = currentPositionY / CHUNK_SIZE;
        int256 newChunkX = newPositionX / CHUNK_SIZE;
        int256 newChunkY = newPositionY / CHUNK_SIZE;

        // Make sure that this update is to a neighboring chunk or same chunk and not a move across the map.
        // In practice forces players to update their position consistenly over time like a update function.
        require(
            (newChunkX == currentChunkX || newChunkX - 1 == currentChunkX || newChunkX + 1 == currentChunkX) 
            && (newChunkY == currentChunkY || newChunkY - 1 == currentChunkY || newChunkY + 1 == currentChunkY), 
            "Moving too fast!");

        uint256 lastUpdate = Position.getLast_update(keccak256(abi.encodePacked(player)));
        uint256 shipSpeed = Speed.get(keccak256(abi.encodePacked(player)));

        uint256 distance = sqrt(((newPositionX - currentPositionX) * (newPositionX - currentPositionX)) + ((newPositionY - currentPositionY) * (newPositionY - currentPositionY)));

        // Makes sure that the move is a function of speed and time.
        // In practice forces players to slowly "sail" across the map.
        require(distance <= shipSpeed * (block.timestamp - lastUpdate), "Breaking the laws of physics!");
    
        // Make sure the move is in the ocean of the world
        uint256 worldTerrain = TerrainLibrary.getTerrain(newPositionX, newPositionY);
        require(worldTerrain == SHALLOW_OCEAN || worldTerrain == DEEP_OCEAN , "Cannot attack in port");

        // Now we can update the position
        Position.setPos_x(keccak256(abi.encodePacked(player)), newPositionX);
        Position.setPos_y(keccak256(abi.encodePacked(player)), newPositionY);
        Position.setLast_update(keccak256(abi.encodePacked(player)), block.timestamp);

        // TODO: Updates for when leaving the port
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

}
