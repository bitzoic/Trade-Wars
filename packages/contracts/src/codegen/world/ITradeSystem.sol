// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

import { Items } from "./../../constants.sol";

interface ITradeSystem {
  function buyWithCoins(uint256 amount, bytes32 portId, Items item) external;

  function sellForCoins(uint256 amount, bytes32 portId, Items item) external;

  function swap(uint256 amount, bytes32 portId, Items item0, Items item1) external returns (uint256);

  function joinPoolSimple(bytes32 portId, uint256 poolAmountOut) external returns (uint256);

  function joinPool(bytes32 portId, uint256 poolAmountOut, uint256[5] memory maxAmount) external returns (uint256);

  function exitPool(uint256 portId_, uint256 amount) external returns (uint256);

  function checkValidLocation(bytes32 shipId, bytes32 portId) external view returns (bool);

  function quoteToken(uint256 amount, bytes32 portId, Items item0, Items item1) external returns (uint256);

  function getBalance(Items item_, bytes32 entity) external returns (uint256 balance);
}
