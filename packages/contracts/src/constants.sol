// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

uint256 constant SCALE = 1000;
uint256 constant CHUNK_SIZE = 10;
uint256 constant REGEN_COST = 50;
uint256 constant FIRE_POWER_COST = 1000;
uint256 constant FIRE_RATE_COST = 700;
uint256 constant CARGO_COST = 400;
uint256 constant HEALTH_COST = 300;

uint256 constant AMM_FEE = 50;

// Materials
uint256 constant IRON_WEIGHT = 100;
uint256 constant SUGAR_WEIGHT = 10;
uint256 constant SPICES_WEIGHT = 20;
uint256 constant SALT_WEIGHT = 30;

enum Items {
    COINS,
    SUGAR,
    IRON,
    SPICES,
    SALT
}
