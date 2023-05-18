// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Position, PositionData } from "../../codegen/Tables.sol";
import { Speed } from "../../codegen/Tables.sol";
import { CHUNK_SIZE } from "../../constants.sol";

contract MoveSystem is System {

    function move(uint256 newPositionX, uint256 newPositionY) public {
        uint256 currentPositionX = Position.getPos_x(keccak256(abi.encodePacked(msg.sender)));
        uint256 currentPositionY = Position.getPos_y(keccak256(abi.encodePacked(msg.sender)));

        uint256 currentChunkX = currentPositionX / CHUNK_SIZE;
        uint256 currentChunkY = currentPositionY / CHUNK_SIZE;
        uint256 newChunkX = newPositionX / CHUNK_SIZE;
        uint256 newChunkY = newPositionY / CHUNK_SIZE;

        // Make sure that this update is to a neighboring chunk or same chunk and not a move across the map.
        // In practice forces players to update their position consistenly over time like a update function.
        require(
            (newChunkX == currentChunkX || newChunkX - 1 == currentChunkX || newChunkX + 1 == currentChunkX) 
            && (newChunkY == currentChunkY || newChunkY - 1 == currentChunkY || newChunkY + 1 == currentChunkY), 
            "Moving too fast!");

        uint256 lastUpdate = Position.getLast_update(keccak256(abi.encodePacked(msg.sender)));
        uint256 shipSpeed = Speed.get(keccak256(abi.encodePacked(msg.sender)));

        uint256 distance = sqrt(((newPositionX - currentPositionX) * (newPositionX - currentPositionX)) + ((newPositionY - currentPositionY) * (newPositionY - currentPositionY)));

        // Makes sure that the move is a function of speed and time.
        // In practice forces players to slowly "sail" across the map.
        require(distance <= shipSpeed * (block.timestamp - lastUpdate), "Breaking the laws of physics!");
    
        // Now we can update the position
        Position.setPos_x(keccak256(abi.encodePacked(msg.sender)), newPositionX);
        Position.setPos_y(keccak256(abi.encodePacked(msg.sender)), newPositionY);
        Position.setLast_update(keccak256(abi.encodePacked(msg.sender)), block.timestamp);
    }

    function sqrt(uint256 x) private pure returns (uint256) {
        if (x == 0) {
            return 0;
        }

        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }

}
