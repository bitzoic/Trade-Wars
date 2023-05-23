// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Position, Health, HealthRegen, Coins } from "../../codegen/Tables.sol";
import { CHUNK_SIZE, REGEN_COST } from "../../constants.sol";
import { PORT } from "../world/terrainPrimitives.sol";
import { ObjectLibrary } from "../world/objects.sol";

contract HealthRegenSystem is System {

    function regen() public {
        bytes32 player = keccak256(abi.encodePacked(_msgSender()));

        // The player can only "rebuild" their ship if they are in a port
        require(ObjectLibrary.getObject(Position.getPos_x(player), Position.getPos_y(player)) == PORT, "Must be in port");

        // The cost to repair is the difference between the player's current health and their max health
        // at the set repair cost rate. Remember, max health is 0 because everything initalized at 0
        uint256 currentCoins = Coins.get(player);
        uint256 regenCost = REGEN_COST * Health.getHealth(player);
        require(currentCoins >= regenCost, "Not enough coins");

        // Remove the cost of regen and start regenerating health
        Coins.set(player, currentCoins - regenCost);
        HealthRegen.set(player, block.timestamp);
    }
}
