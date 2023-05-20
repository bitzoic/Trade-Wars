// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { Perlin } from "./Perlin.sol";
import "./terrainPrimitives.sol";

library TerrainLibrary {

    int128 constant _0_95 = 17_524_406_870_023_073_035; // 0.95 * 2**64
    int128 constant _0_80 = 14_757_395_258_967_641_292; // 0.80 * 2**64
    int128 constant _0_75 = 13_835_058_055_282_163_712; // 0.75 * 2**64
    int128 constant _0_50 = 9_223_372_036_854_775_808; // 0.50 * 2**64

    function getTerrain(int256 positionX, int256 positionY) internal pure returns (uint256) {
        int128 perlinNoise = Perlin.noise2d(positionX, positionY, TERRAIN_SCALE, 64);
        //uint128 perlinNoise = 0;

        // 5% chance of mountain
        // 15% chance of grass
        // 10% chance of sand
        // Total: 25% chance of land

        // 25% chance of shallow ocean
        // 50% chance of deep ocean
        // Total: 75% chance of ocean
        if (perlinNoise >= _0_95) {
            return MOUNTAIN;
        } else if (perlinNoise >= _0_80 && perlinNoise < _0_95) {
            return GRASS;
        } else if (perlinNoise >= _0_75 && perlinNoise < _0_80) {
            return SAND;
        } else if (perlinNoise >= _0_50 && perlinNoise < _0_75) {
            return SHALLOW_OCEAN;
        } else {
            return DEEP_OCEAN;
        }
    }
}