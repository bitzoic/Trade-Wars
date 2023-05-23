// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

interface IShipWreckSystem {
  function createShipWreck(
    bytes32 playerId,
    int256 newPositionX,
    int256 newPositionY,
    uint256 iron,
    uint256 salt,
    uint256 sugar,
    uint256 spices
  ) external;

  function shipWreckExists(int256 positionX, int256 positionY) external returns (bytes32);

  function claimShipWreckIron(int256 positionX, int256 positionY) external;

  function claimShipWreckSalt(int256 positionX, int256 positionY, uint256 amount) external;

  function claimShipWreckSpices(int256 positionX, int256 positionY, uint256 amount) external;

  function claimShipWreckSugar(int256 positionX, int256 positionY, uint256 amount) external;
}
