// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Position, Sugar, Coins, CargoSpace } from "../../codegen/Tables.sol";
import { Speed } from "../../codegen/Tables.sol";
import { CHUNK_SIZE, SUGAR_WEIGHT } from "../../constants.sol";
import { PORT } from "../world/terrainPrimitives.sol";
import { ObjectSystem } from "../world/objects.sol";

contract TradeSugarSystem is System {

    function sell_sugar(uint256 amount) public {
        int256 currentPositionX = Position.getPos_x(keccak256(abi.encodePacked(msg.sender)));
        int256 currentPositionY = Position.getPos_y(keccak256(abi.encodePacked(msg.sender)));
        uint256 currentSugar = Sugar.get(keccak256(abi.encodePacked(msg.sender)));
        uint256 currentCoins = Coins.get(keccak256(abi.encodePacked(msg.sender)));
        uint256 currentCargoWeight = CargoSpace.getCargo(keccak256(abi.encodePacked(msg.sender)));

        require(amount <= currentSugar, "Not enough sugar");
        // Require we are in the same chunk as a port
        uint256 worldObject = ObjectSystem.getObject(currentPositionX, currentPositionY);
        require(worldObject == PORT, "Must be in port");

        // TODO: Get port we are at
        // TODO: Sugar price = AMM_price * currentSugar; REPLACE THIS CONSTANT
        uint256 sell_cost = amount * 5;

        Coins.set(keccak256(abi.encodePacked(msg.sender)), currentCoins + sell_cost);
        Sugar.set(keccak256(abi.encodePacked(msg.sender)), currentSugar - amount);
        CargoSpace.setCargo(keccak256(abi.encodePacked(msg.sender)), currentCargoWeight - (amount * SUGAR_WEIGHT));
    }

    function buy_sugar(uint256 amount) public {
        int256 currentPositionX = Position.getPos_x(keccak256(abi.encodePacked(msg.sender)));
        int256 currentPositionY = Position.getPos_y(keccak256(abi.encodePacked(msg.sender)));
        uint256 currentCoins = Coins.get(keccak256(abi.encodePacked(msg.sender)));
        uint256 currentCargoWeight = CargoSpace.getCargo(keccak256(abi.encodePacked(msg.sender)));
        uint256 currentSugar = Sugar.get(keccak256(abi.encodePacked(msg.sender)));

        // Require we are in the same chunk as a port
        uint256 worldObject = ObjectSystem.getObject(currentPositionX, currentPositionY);
        require(worldObject == PORT, "Must be in port");

        // TODO: Get port we are at
        // TODO: Get price from AMM; REPLACE THIS CONSTANT
        uint256 buy_cost = amount * 5;

        require(currentCoins >= buy_cost, "Not enough coins");
