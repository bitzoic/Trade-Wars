// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

// Objects - This should be pulled out for reusability/appending more objects
uint256 constant PORT = uint256(keccak256("object.Port"));
uint256 constant REEF = uint256(keccak256("object.Reef"));
int256 constant OBJECT_SCALE = 10; // "higher scale = more sparse"

// Terrain
uint256 constant SAND = uint256(keccak256("terrain.Sand"));
uint256 constant GRASS = uint256(keccak256("terrain.Grass"));
uint256 constant MOUNTAIN = uint256(keccak256("terrain.Mountain"));
uint256 constant SHALLOW_OCEAN = uint256(keccak256("terrain.Shallow_Water"));
uint256 constant DEEP_OCEAN = uint256(keccak256("terrain.Shallow_Water"));
int256 constant TERRAIN_SCALE = 22; // "higher scale = wider oceans"
