// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Position, Health, HealthRegen, Coins } from "../../codegen/Tables.sol";
import { CHUNK_SIZE, REGEN_COST } from "../../constants.sol";
import { PORT } from "../world/terrainPrimitives.sol";
import { ObjectSystem } from "../world/objects.sol";

contract HealthRegenSystem is System {

    function regen() public {
        address player = _msgSender();
        int256 currentPositionX = Position.getPos_x(keccak256(abi.encodePacked(player)));
        int256 currentPositionY = Position.getPos_y(keccak256(abi.encodePacked(player)));
        uint256 currentHealth = Health.getHealth(keccak256(abi.encodePacked(player)));
        uint256 maxHealth = Health.getMax_health(keccak256(abi.encodePacked(player)));
        uint256 currentCoins = Coins.get(keccak256(abi.encodePacked(player)));

        uint256 worldObject = ObjectSystem.getObject(currentPositionX, currentPositionY);
        require(worldObject == PORT, "Must be in port");

        uint256 regenCost = REGEN_COST * (maxHealth - currentHealth);
        require(currentCoins >= regenCost, "Not enough coins");

        // Remove the cost of regen
        Coins.set(keccak256(abi.encodePacked(player)), currentCoins - regenCost);
        HealthRegen.set(keccak256(abi.encodePacked(player)), block.timestamp);
    }
}
