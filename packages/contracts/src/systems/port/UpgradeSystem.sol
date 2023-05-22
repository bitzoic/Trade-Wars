// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Position, Coins, Health, FirePower, CargoSpace } from "../../codegen/Tables.sol";
import { CHUNK_SIZE, HEALTH_COST, CARGO_COST, FIRE_POWER_COST, FIRE_RATE_COST } from "../../constants.sol";
import { PORT } from "../world/terrainPrimitives.sol";
import { ObjectSystem } from "../world/objects.sol";

contract UpgradeSystem is System {

    function upgrade_fire_power(uint256 amount) public {
        address player = _msgSender();
        int256 currentPositionX = Position.getPos_x(keccak256(abi.encodePacked(player)));
        int256 currentPositionY = Position.getPos_y(keccak256(abi.encodePacked(player)));
        uint256 currentFirePower = FirePower.getPower(keccak256(abi.encodePacked(player)));
        uint256 currentCoins = Coins.get(keccak256(abi.encodePacked(player)));

        // Require we are in the same chunk as a port
        uint256 worldObject = ObjectSystem.getObject(currentPositionX, currentPositionY);
        require(worldObject == PORT, "Must be in port");

        require(currentCoins >= FIRE_POWER_COST * amount, "Not enough coins");

        // Remove the cost of fire power
        Coins.set(keccak256(abi.encodePacked(player)), currentCoins - (FIRE_POWER_COST * amount));
        FirePower.setPower(keccak256(abi.encodePacked(player)), currentFirePower + amount);
    }

    function upgrade_fire_rate(uint256 amount) public {
        address player = _msgSender();
        int256 currentPositionX = Position.getPos_x(keccak256(abi.encodePacked(player)));
        int256 currentPositionY = Position.getPos_y(keccak256(abi.encodePacked(player)));
        uint256 currentFireRate = FirePower.getRate(keccak256(abi.encodePacked(player)));
        uint256 currentCoins = Coins.get(keccak256(abi.encodePacked(player)));
        
        // Require we are in the same chunk as a port
        uint256 worldObject = ObjectSystem.getObject(currentPositionX, currentPositionY);
        require(worldObject == PORT, "Must be in port");

        require(currentCoins >= FIRE_RATE_COST * amount, "Not enough coins");

        // Remove the cost of fire rate
        Coins.set(keccak256(abi.encodePacked(player)), currentCoins - (FIRE_RATE_COST * amount));
        FirePower.setPower(keccak256(abi.encodePacked(player)), currentFireRate + amount);
    }

    function upgrade_max_health(uint256 amount) public {
        address player = _msgSender();
        int256 currentPositionX = Position.getPos_x(keccak256(abi.encodePacked(player)));
        int256 currentPositionY = Position.getPos_y(keccak256(abi.encodePacked(player)));
        uint256 currentMaxHealth = Health.getMax_health(keccak256(abi.encodePacked(player)));
        uint256 currentCoins = Coins.get(keccak256(abi.encodePacked(player)));

        // Require we are in the same chunk as a port
        uint256 worldObject = ObjectSystem.getObject(currentPositionX, currentPositionY);
        require(worldObject == PORT, "Must be in port");

        require(currentCoins >= HEALTH_COST * amount, "Not enough coins");

        // Remove the cost of health and set health to max
        Coins.set(keccak256(abi.encodePacked(player)), currentCoins - (HEALTH_COST * amount));
        Health.setMax_health(keccak256(abi.encodePacked(player)), currentMaxHealth + amount);
        Health.setHealth(keccak256(abi.encodePacked(player)), currentMaxHealth + amount);
    } 

    function upgrade_cargo(uint256 amount) public {
        address player = _msgSender();
        int256 currentPositionX = Position.getPos_x(keccak256(abi.encodePacked(player)));
        int256 currentPositionY = Position.getPos_y(keccak256(abi.encodePacked(player)));
        uint256 currentMaxCargo = CargoSpace.getMax_cargo(keccak256(abi.encodePacked(player)));
        uint256 currentCoins = Coins.get(keccak256(abi.encodePacked(player)));

        // Require we are in the same chunk as a port
        uint256 worldObject = ObjectSystem.getObject(currentPositionX, currentPositionY);
        require(worldObject == PORT, "Must be in port");

        require(currentCoins >= CARGO_COST * amount, "Not enough coins");

        // Remove the cost of fire rate
        Coins.set(keccak256(abi.encodePacked(player)), currentCoins - (CARGO_COST * amount));
        CargoSpace.setMax_cargo(keccak256(abi.encodePacked(player)), currentMaxCargo + amount);
    }
}