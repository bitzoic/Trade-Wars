// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Perlin } from "@latticexyz/noise/contracts/Perlin.sol";
import "./terrainPrimitives.sol";

contract TerrainSystem is System {

    function getTerrain(uint256 positionX, uint256 positionY) public pure returns (uint256) {
        uint128 perlinNoise = Perlin.noise2d(positionX, positionY, 0, 0);
        //uint128 perlinNoise = 0;

        // 5% chance of mountain
        // 15% chance of grass
        // 10% chance of sand
        // Total: 25% chance of land

        // 25% chance of shallow ocean
        // 50% chance of deep ocean
        // Total: 75% chance of ocean
        // if (perlinNoise >= 0.95) {
        //     return MOUNTAIN;
        // } else if (perlinNoise >= 0.8 && perlinNoise < 0.95) {
        //     return GRASS;
        // } else if (perlinNoise >= 0.75 && perlinNoise < 0.8) {
        //     return SAND;
        // } else if (perlinNoise >= 0.5 && perlinNoise < 0.75) {
        //     return SHALLOW_OCEAN;
        // } else {
        //     return DEEP_OCEAN;
        // }
    }
}