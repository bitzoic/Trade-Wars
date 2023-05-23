// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {System} from "@latticexyz/world/src/System.sol";
import {
    Position,
    Sugar,
    Iron,
    Spices,
    Salt,
    Coins,
    CargoSpace,
    LPTokens,
    Ports,
    SwapExecuted,
    SwapExecutedData,
    LiquidityAdded,
    LiquidityAddedData,
    LiquidityRemoved,
    LiquidityRemovedData
} from "../../codegen/Tables.sol";
import {IWorld} from "../../codegen/world/IWorld.sol";

import {Speed} from "../../codegen/Tables.sol";
import {
    CHUNK_SIZE,
    SUGAR_WEIGHT,
    IRON_WEIGHT,
    SPICES_WEIGHT,
    SALT_WEIGHT,
    Items,
    SCALE,
    AMM_FEE
} from "../../constants.sol";
import {PORT} from "../world/terrainPrimitives.sol";

contract TradeSystem is System {
    function buyWithCoins(uint256 amount, bytes32 portId, Items item) public {
        swap(amount, portId, item, Items.COINS);
    }

    function sellForCoins(uint256 amount, bytes32 portId, Items item) public {
        swap(amount, portId, Items.COINS, item);
    }

    function swap(uint256 amount, bytes32 portId, Items item0, Items item1)
        public
        manufacture(portId)
        returns (uint256)
    {
        if(Ports.lengthPort_name(portId) == 0) {
            revert("Port does not exist yet");
        }
        bytes32 shipId = keccak256(abi.encodePacked(_msgSender()));
        require(checkValidLocation(shipId, portId), "Not in the same chunk as port");

        uint256 outputAmount = (quoteToken(amount, portId, item0, item1) * (SCALE - AMM_FEE)) / SCALE;

        setWeight(shipId, amount, outputAmount, item0, item1);
        transferToken(shipId, portId, item0, amount, true);
        transferToken(shipId, portId, item1, outputAmount, false);

        SwapExecuted.emitEphemeral(
            portId,
            SwapExecutedData({
                receiver: shipId,
                amountIn: amount,
                amountOut: outputAmount,
                item0: uint16(item0),
                item1: uint16(item1)
            })
        );
        return outputAmount;
    }

    function joinPoolSimple(bytes32 portId, uint256 poolAmountOut) external returns (uint256) {
        uint256[5] memory maxAmount;
        maxAmount[0] = type(uint256).max;
        maxAmount[1] = type(uint256).max;
        maxAmount[2] = type(uint256).max;
        maxAmount[3] = type(uint256).max;
        maxAmount[4] = type(uint256).max;
        return joinPool(portId, poolAmountOut, maxAmount);
    }

    function joinPool(bytes32 portId, uint256 poolAmountOut, uint256[5] memory maxAmount)
        public
        manufacture(portId)
        returns (uint256)
    {
        bytes32 shipId = keccak256(abi.encodePacked(_msgSender()));
        require(checkValidLocation(shipId, portId), "Not in the same chunk as port");
        uint256 totalLiquidity = LPTokens.get(portId);
        uint256 weight_ = CargoSpace.getCargo(shipId);
        uint256 ratio;
        if (totalLiquidity == 0) {
            // init pool liquidity
            ratio = SCALE;
        } else {
            ratio = poolAmountOut * SCALE / totalLiquidity;
        }
        for (uint256 i = 0; i < 4; i++) {
            uint256 maxAmountIn = maxAmount[i];
            if (i == 0) {
                uint256 bal = Coins.get(portId);
                uint256 tokenAmountIn = (bal * ratio) / SCALE;
                require(tokenAmountIn <= maxAmountIn, "ERR_MAX_AMOUNT");
                transferToken(shipId, portId, Items.COINS, tokenAmountIn, false);
            } else if (i == 1) {
                uint256 bal = Sugar.get(portId);
                uint256 tokenAmountIn = (bal * ratio) / SCALE;
                require(tokenAmountIn <= maxAmountIn, "ERR_MAX_AMOUNT");
                weight_ -= tokenAmountIn * SUGAR_WEIGHT;
                transferToken(shipId, portId, Items.SUGAR, tokenAmountIn, false);
            } else if (i == 2) {
                uint256 bal = Iron.get(portId);
                uint256 tokenAmountIn = (bal * ratio) / SCALE;
                require(tokenAmountIn <= maxAmountIn, "ERR_MAX_AMOUNT");
                weight_ -= tokenAmountIn * IRON_WEIGHT;
                transferToken(shipId, portId, Items.IRON, tokenAmountIn, false);
            } else if (i == 3) {
                uint256 bal = Spices.get(portId);
                uint256 tokenAmountIn = (bal * ratio) / SCALE;
                require(tokenAmountIn <= maxAmountIn, "ERR_MAX_AMOUNT");
                weight_ -= tokenAmountIn * SPICES_WEIGHT;
                transferToken(shipId, portId, Items.SPICES, tokenAmountIn, false);
            } else if (i == 4) {
                uint256 bal = Salt.get(portId);
                uint256 tokenAmountIn = (bal * ratio) / SCALE;
                require(tokenAmountIn <= maxAmountIn, "ERR_MAX_AMOUNT");
                weight_ -= tokenAmountIn * SALT_WEIGHT;
                transferToken(shipId, portId, Items.SALT, tokenAmountIn, false);
            }
        }
        LPTokens.set(portId, totalLiquidity + poolAmountOut); // For recordkeeping
        LPTokens.set(shipId, LPTokens.get(shipId) + poolAmountOut);
        CargoSpace.setCargo(shipId, weight_);
        LiquidityAdded.emitEphemeral(shipId, LiquidityAddedData(poolAmountOut, shipId));

        return poolAmountOut;
    }

    function exitPool(uint256 portId_, uint256 amount) public returns (uint256) {
        bytes32 portId = bytes32(portId_);
        bytes32 shipId = keccak256(abi.encodePacked(_msgSender()));
        uint256 weight_ = CargoSpace.getCargo(shipId);
        uint256 totalLiquidity = LPTokens.get(portId);
        require(checkValidLocation(shipId, portId), "ERR_INVALID_LOCATION");
        uint256 poolAmountOut = (amount * totalLiquidity) / LPTokens.get(shipId);
        require(poolAmountOut > 0, "ERR_ZERO_AMOUNT");
        LPTokens.set(portId, totalLiquidity - poolAmountOut);
        LPTokens.set(shipId, LPTokens.get(shipId) - amount);
        uint256 ratio = poolAmountOut * SCALE / totalLiquidity;
        for (uint256 i = 0; i < 4; i++) {
            if (i == 0) {
                uint256 bal = Coins.get(portId);
                uint256 tokenAmountIn = (bal * ratio) / SCALE;
                transferToken(shipId, portId, Items.COINS, tokenAmountIn, true);
            } else if (i == 1) {
                uint256 bal = Sugar.get(portId);
                uint256 tokenAmountIn = (bal * ratio) / SCALE;
                weight_ += tokenAmountIn * SUGAR_WEIGHT;
                transferToken(shipId, portId, Items.SUGAR, tokenAmountIn, true);
            } else if (i == 2) {
                uint256 bal = Iron.get(portId);
                uint256 tokenAmountIn = (bal * ratio) / SCALE;
                weight_ += tokenAmountIn * IRON_WEIGHT;
                transferToken(shipId, portId, Items.IRON, tokenAmountIn, true);
            } else if (i == 3) {
                uint256 bal = Spices.get(portId);
                uint256 tokenAmountIn = (bal * ratio) / SCALE;
                weight_ += tokenAmountIn * SPICES_WEIGHT;
                transferToken(shipId, portId, Items.SPICES, tokenAmountIn, true);
            } else if (i == 4) {
                uint256 bal = Salt.get(portId);
                uint256 tokenAmountIn = (bal * ratio) / SCALE;
                weight_ += tokenAmountIn * SALT_WEIGHT;
                transferToken(shipId, portId, Items.SALT, tokenAmountIn, true);
            }
        }
        require(weight_ <= CargoSpace.getMax_cargo(shipId), "ERR_CARGO_FULL");
        CargoSpace.setCargo(shipId, weight_);
        LiquidityRemoved.emitEphemeral(shipId, LiquidityRemovedData(poolAmountOut, shipId));
        return amount;
    }

    function checkValidLocation(bytes32 shipId, bytes32 portId) public view returns (bool) {
        int256 currentChunkX = Position.getPos_x(shipId) / CHUNK_SIZE;
        int256 currentChunkY = Position.getPos_y(shipId) / CHUNK_SIZE;
        int256 portChunkX = Position.getPos_x(portId) / CHUNK_SIZE;
        int256 portChunkY = Position.getPos_y(portId) / CHUNK_SIZE;
        return (currentChunkX == portChunkX && currentChunkY == portChunkY);
    }

    function transferToken(bytes32 shipId, bytes32 portId, Items item_, uint256 amount, bool direction) internal {
        bytes32 sender;
        bytes32 receiver;
        uint256 item = uint256(item_);
        if (direction) {
            sender = shipId;
            receiver = portId;
        } else {
            sender = portId;
            receiver = shipId;
        }
        if (item == 0) {
            uint256 current = Coins.get(sender);
            if (current < amount) revert("Not enough coins");
            Coins.set(sender, current - amount);
            Coins.set(receiver, Coins.get(receiver) + amount);
        } else if (item == 1) {
            uint256 current = Sugar.get(sender);
            if (current < amount) revert("Not enough sugar");
            Sugar.set(sender, current - amount);
            Sugar.set(receiver, Sugar.get(receiver) + amount);
        } else if (item == 2) {
            uint256 current = Iron.get(sender);
            if (current < amount) revert("Not enough iron");
            Iron.set(sender, current - amount);
            Iron.set(receiver, Iron.get(receiver) + amount);
        } else if (item == 3) {
            uint256 current = Spices.get(sender);
            if (current < amount) revert("Not enough spices");
            Spices.set(sender, current - amount);
            Spices.set(receiver, Spices.get(receiver) + amount);
        } else if (item == 4) {
            uint256 current = Salt.get(sender);
            if (current < amount) revert("Not enough salt");
            Salt.set(sender, current - amount);
            Salt.set(receiver, Salt.get(receiver) + amount);
        }
        // emit an event here?
    }

    function quoteToken(uint256 amount, bytes32 portId, Items item0, Items item1) public returns (uint256) {
        uint256 balanceA = getBalance(item0, portId);
        uint256 balanceB = getBalance(item1, portId);
        uint256 weightA = getNormalizedWeight(item1, portId);
        uint256 weightB = getNormalizedWeight(item0, portId);
        return ((balanceA * weightB / balanceB) * amount) / weightA;
    }

    function getNormalizedWeight(Items item_, bytes32 portId) internal view returns (uint256) {
        uint256 weight;
        uint256 item = uint256(item_);
        if (item == 0) {
            weight = Coins.get(portId);
        } else if (item == 1) {
            weight = Sugar.get(portId);
        } else if (item == 2) {
            weight = Iron.get(portId);
        } else if (item == 3) {
            weight = Spices.get(portId);
        } else if (item == 4) {
            weight = Salt.get(portId);
        }
        return (weight * SCALE) / getTotalValue(portId);
    }

    function getTotalValue(bytes32 portId) internal view returns (uint256) {
        uint256 totalValue;
        totalValue += Coins.get(portId);
        totalValue += Sugar.get(portId);
        totalValue += Spices.get(portId);
        totalValue += Salt.get(portId);
        totalValue += Iron.get(portId);
        return totalValue;
    }

    function setWeight(bytes32 shipId, uint256 amount, uint256 amountOut, Items item0_, Items item1_) internal {
        uint256 weight = CargoSpace.getCargo(shipId);
        uint256 item0 = uint256(item0_);
        uint256 item1 = uint256(item1_);
        if (item0 == 1) {
            weight += amount * SUGAR_WEIGHT;
        } else if (item0 == 2) {
            weight += amount * IRON_WEIGHT;
        } else if (item0 == 3) {
            weight += amount * SPICES_WEIGHT;
        } else if (item0 == 4) {
            weight += amount * SALT_WEIGHT;
        } else if (item1 == 1) {
            weight -= amountOut * SUGAR_WEIGHT;
        } else if (item1 == 2) {
            weight -= amountOut * IRON_WEIGHT;
        } else if (item1 == 3) {
            weight -= amountOut * SPICES_WEIGHT;
        } else if (item1 == 4) {
            weight -= amountOut * SALT_WEIGHT;
        }
        CargoSpace.setCargo(shipId, weight);
        if (weight > CargoSpace.getMax_cargo(shipId)) revert("Not enough cargo space");
    }

    function getBalance(Items item_, bytes32 entity) public returns (uint256 balance) {
        uint256 item = uint256(item_);
        if (Ports.lengthPort_name(entity) == 0) {
            IWorld(_world()).manufacture(entity);
        }
        if (item == 0) {
            balance = Coins.get(entity);
        } else if (item == 1) {
            balance = Sugar.get(entity);
        } else if (item == 2) {
            balance = Iron.get(entity);
        } else if (item == 3) {
            balance = Spices.get(entity);
        } else if (item == 4) {
            balance = Salt.get(entity);
        }
    }

    modifier manufacture(bytes32 portId) {
        IWorld(_world()).manufacture(portId);
        _;
    }
}
