// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { Perlin } from "@latticexyz/noise/contracts/Perlin.sol";
import "./terrainPrimitives.sol";

library TerrainLibrary {

    function getTerrain(int256 positionX, int256 positionY) internal pure returns (uint256) {
        int128 perlinNoise = Perlin.noise2d(positionX, positionY, TERRAIN_SCALE, 4);

        // 5% chance of mountain
        // 15% chance of grass
        // 10% chance of sand
        // Total: 25% chance of land

        // Ocean: 40
        // Mountain: 30
        // Grass: 20
        // SAND: 10

        // 25% chance of shallow ocean
        // 50% chance of deep ocean
        // Total: 75% chance of ocean
        if (perlinNoise >= 12) {
            return MOUNTAIN;
        } else if (perlinNoise >= 9 && perlinNoise < 12) {
            return GRASS;
        } else if (perlinNoise > 7 && perlinNoise <= 9) {
            return SAND;
        } else if (perlinNoise >= 5 && perlinNoise <= 7) {
            return SHALLOW_OCEAN;
        } else {
            return DEEP_OCEAN;
        }
    }
}
