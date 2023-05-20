// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { SHALLOW_OCEAN, SAND, REEF, PORT, OBJECT_SCALE } from "./terrainPrimitives.sol";
import { CHUNK_SIZE } from "../../constants.sol";
import { Perlin } from "./Perlin.sol";
import { IWorld } from "../../codegen/world/IWorld.sol";
import { TerrainLibrary } from "./terrain.sol";

library ObjectSystem {

    int128 constant _0_90 = 16_602_069_666_338_596_454; // 0.95 * 2**64
    int128 constant _0_80 = 14_757_395_258_967_641_292; // 0.80 * 2**64

    function getObject(int256 positionX, int256 positionY) internal pure returns (uint256) {
        uint256 terrainId = TerrainLibrary.getTerrain(positionX, positionY);

        if (terrainId == SHALLOW_OCEAN) {
            return getShallowOceanObject(positionX, positionY);
        } else if (terrainId == SAND) {
            return getLandObject(positionX, positionY);
        } else {
            return 0;
        }
    }

    function getShallowOceanObject(int256 positionX, int256 positionY) internal pure returns (uint256) {
        // Only one object per chunk  
        int256 currentChunkX = positionX / CHUNK_SIZE;
        int256 currentChunkY = positionY / CHUNK_SIZE;
        // Perlin noise on this chunk
        int128 perlinNoise = Perlin.noise2d(currentChunkX, currentChunkY, OBJECT_SCALE, 64);

        // 10% chance of reef
        if (perlinNoise >= _0_90) {
            return REEF;
        } else {
            return 0;
        }
    }

    function getLandObject(int256 positionX, int256 positionY) internal pure returns (uint256) {
        // Only one object per chunk  
        int256 currentChunkX = positionX / CHUNK_SIZE;
        int256 currentChunkY = positionY / CHUNK_SIZE;
        // Perlin noise on this chunk
        int128 perlinNoise = Perlin.noise2d(currentChunkX, currentChunkY, OBJECT_SCALE, 64);

        // 20% chance of port
        if (perlinNoise >= _0_80) {
            return PORT;
        } else {
            return 0;
        }
    }
}