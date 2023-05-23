// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Position, Coins, Health, FirePower, CargoSpace, Speed } from "../../codegen/Tables.sol";
import { CHUNK_SIZE, HEALTH_COST, CARGO_COST, FIRE_POWER_COST, FIRE_RATE_COST, BASE_FIRE_RATE, MIN_FIRE_RATE, SPEED_COST } from "../../constants.sol";
import { PORT } from "../world/terrainPrimitives.sol";
import { ObjectLibrary } from "../world/objects.sol";

contract UpgradeSystem is System {

    function upgrade_fire_power(uint256 amount) public {
        bytes32 playerId = keccak256(abi.encodePacked(_msgSender()));
        
        // Get player info
        int256 currentPositionX = Position.getPos_x(playerId);
        int256 currentPositionY = Position.getPos_y(playerId);
        uint256 currentFirePower = FirePower.getPower(playerId);
        uint256 currentCoins = Coins.get(playerId);

        // Require we are in the same chunk as a port
        require(ObjectLibrary.getObject(Position.getPos_x(playerId), Position.getPos_y(playerId)) == PORT, "Must be in port");

        // Must have enough money to buy the upgrade amount
        require(currentCoins >= FIRE_POWER_COST * amount, "Not enough coins");

        // Remove the cost of fire power
        Coins.set(playerId, currentCoins - (FIRE_POWER_COST * amount));
        FirePower.setPower(playerId, currentFirePower + amount);
    }

    function upgrade_fire_rate(uint256 amount) public {
        bytes32 playerId = keccak256(abi.encodePacked(_msgSender()));
        
        // Get player info
        int256 currentPositionX = Position.getPos_x(playerId);
        int256 currentPositionY = Position.getPos_y(playerId);
        uint256 currentFireRate = FirePower.getRate(playerId);
        uint256 currentCoins = Coins.get(playerId);
        
        // Require we are in the same chunk as a port
        require(ObjectLibrary.getObject(currentPositionX, currentPositionY) == PORT, "Must be in port");

        // Must have enough money to buy the upgrade amount
        require(currentCoins >= FIRE_RATE_COST * amount, "Not enough coins");

        // Cannot go below a fire rate of MIN_FIRE_RATE
        require(BASE_FIRE_RATE - (currentFireRate + amount) >= MIN_FIRE_RATE, "Upgrade maxed out");

        // Remove the cost of fire rate
        Coins.set(playerId, currentCoins - (FIRE_RATE_COST * amount));
        FirePower.setRate(playerId, currentFireRate + amount);
    }

    function upgrade_max_health(uint256 amount) public {
        bytes32 playerId = keccak256(abi.encodePacked(_msgSender()));
        
        // Get player info
        int256 currentPositionX = Position.getPos_x(playerId);
        int256 currentPositionY = Position.getPos_y(playerId);
        uint256 currentMaxHealth = Health.getMax_health(playerId);
        uint256 currentCoins = Coins.get(playerId);

        // Require we are in the same chunk as a port
        require(ObjectLibrary.getObject(currentPositionX, currentPositionY) == PORT, "Must be in port");

        // Must have enough money to buy the upgrade amount
        require(currentCoins >= HEALTH_COST * amount, "Not enough coins");

        // Remove the cost of health and set health to max
        Coins.set(playerId, currentCoins - (HEALTH_COST * amount));
        Health.setMax_health(playerId, currentMaxHealth + amount);
        Health.setHealth(playerId, currentMaxHealth + amount);
    } 

    function upgrade_cargo(uint256 amount) public {
        bytes32 playerId = keccak256(abi.encodePacked(_msgSender()));
        
        // Get player info
        int256 currentPositionX = Position.getPos_x(playerId);
        int256 currentPositionY = Position.getPos_y(playerId);
        uint256 currentMaxCargo = CargoSpace.getMax_cargo(playerId);
        uint256 currentCoins = Coins.get(playerId);

        // Require we are in the same chunk as a port
        require(ObjectLibrary.getObject(currentPositionX, currentPositionY) == PORT, "Must be in port");

        // Must have enough money to buy the upgrade amount
        require(currentCoins >= CARGO_COST * amount, "Not enough coins");

        // Remove the cost of cargo space
        Coins.set(playerId, currentCoins - (CARGO_COST * amount));
        CargoSpace.setMax_cargo(playerId, currentMaxCargo + amount);
    }

    function upgrade_speed(uint256 amount) public {
        bytes32 playerId = keccak256(abi.encodePacked(_msgSender()));
        
        // Get player info
        int256 currentPositionX = Position.getPos_x(playerId);
        int256 currentPositionY = Position.getPos_y(playerId);
        uint256 currentMaxSpeed = Speed.get(playerId);
        uint256 currentCoins = Coins.get(playerId);

        // Require we are in the same chunk as a port
        require(ObjectLibrary.getObject(currentPositionX, currentPositionY) == PORT, "Must be in port");

        // Must have enough money to buy the upgrade amount
        require(currentCoins >= SPEED_COST * amount, "Not enough coins");

        // Remove the cost of speed
        Coins.set(playerId, currentCoins - (SPEED_COST * amount));
        Speed.set(playerId, currentMaxSpeed + amount);
    }
}