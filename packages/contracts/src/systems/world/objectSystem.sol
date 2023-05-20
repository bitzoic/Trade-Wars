// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { SHALLOW_OCEAN, DEEP_OCEAN, REEF, PORT } from "./terrainPrimitives.sol";
import { CHUNK_SIZE } from "../../constants.sol";
// import { Perlin } from "@latticexyz/noise/contracts/Perlin.sol";

contract ObjectSystem is System {

    function getObject(uint256 positionX, uint256 positionY) public returns (uint256) {
        //uint256 terrainId = IWorld(_world()).getTerrain(currentPositionX, currentPositionY);
        uint256 terrainId = 0;

        if (terrainId == SHALLOW_OCEAN) {
            return getShallowOceanObject(positionX, positionY);
        } else if (terrainId != DEEP_OCEAN) {
            return getLandObject(positionX, positionY);
        } else {
            return 0;
        }
    }

    function getShallowOceanObject(uint256 positionX, uint256 positionY) private pure returns (uint256) {
        // Only one object per chunk  
        uint256 currentChunkX = positionX / CHUNK_SIZE;
        uint256 currentChunkY = positionY / CHUNK_SIZE;
        // Perlin noise on this position, package issues
        // uint128 perlinNoise = Perlin.noise2d(currentChunkX, currentChunkY, 0, 0);
        uint128 perlinNoise = 0;

        // 10% chance of reef
        // if (perlinNoise >= 0.90) {
        //     return REEF;
        // } else {
        //     return 0;
        // }
        return 0;
    }

    function getLandObject(uint256 positionX, uint256 positionY) private pure returns (uint256) {
        // Only one object per chunk  
        uint256 currentChunkX = positionX / CHUNK_SIZE;
        uint256 currentChunkY = positionY / CHUNK_SIZE;
        // Perlin noise on this position, package issues
        // uint128 perlinNoise = Perlin.noise2d(currentChunkX, currentChunkY, 0, 0);
        uint128 perlinNoise = 0;

        // 20% chance of port
        // if (perlinNoise >= 0.80) {
        //     return PORT;
        // } else {
        //     return 0;
        // }
        return 0;
    }
}