// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {System} from "@latticexyz/world/src/System.sol";
import {IWorld} from "../../codegen/world/IWorld.sol";
import {Position, Sugar, Iron, Spices, Salt, Coins, Ports} from "../../codegen/Tables.sol";

contract PortSystem is System {
    function initPort(
        uint256 xCoord,
        uint256 yCoord,
        string calldata name,
        uint256[5] calldata amounts,
        uint256[5] calldata speeds
    ) public {
        bytes32 portId = keccak256(abi.encodePacked(xCoord, yCoord));
        Ports.set(portId, _msgSender(), name, speeds, block.timestamp);
        Position.setPos_x(portId, xCoord);
        Position.setPos_y(portId, yCoord);
        Coins.set(portId, amounts[0]);
        Sugar.set(portId, amounts[1]);
        Iron.set(portId, amounts[2]);
        Spices.set(portId, amounts[3]);
        Salt.set(portId, amounts[4]);
    }

    function initPort(uint256 xCoord, uint256 yCoord, uint256[5] calldata amounts, uint256[5] calldata speeds) public {
        this.initPort(xCoord, yCoord, "Port", amounts, speeds);
    }

    function manufacture(bytes32 portId) public {
        uint256[5] memory amounts_ = previewManufacture(portId);
        Coins.set(portId, amounts_[0]);
        Sugar.set(portId, amounts_[1]);
        Iron.set(portId, amounts_[2]);
        Spices.set(portId, amounts_[3]);
        Salt.set(portId, amounts_[4]);
    }

    function previewManufacture(bytes32 portId) public view returns (uint256[5] memory amounts) {
        uint256 lastUpdated = Ports.getLast_updated(portId);
        uint256 timeSinceLastUpdate = block.timestamp - lastUpdated;
        uint256[5] memory speeds = Ports.getPort_speeds(portId);
        uint256[5] memory amounts_ = getBalance(portId);
        uint256[5] memory newAmounts;
        for (uint256 i = 0; i < 5; i++) {
            newAmounts[i] = amounts_[i] + speeds[i] * timeSinceLastUpdate;
        }
        return newAmounts;
    }

    function getBalance(bytes32 portId) public view returns (uint256[5] memory amounts) {
        amounts[0] = Coins.get(portId);
        amounts[1] = Sugar.get(portId);
        amounts[2] = Iron.get(portId);
        amounts[3] = Spices.get(portId);
        amounts[4] = Salt.get(portId);
    }
}
