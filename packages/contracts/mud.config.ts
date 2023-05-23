import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  systems: {
    TradeSystem: {
      name: "trading",
      openAccess: true,
    },
    PortSystem: {
      name: "port",
      openAccess: true,
    },
  },
  tables: {
    SwapExecuted: {
      schema: {
        receiver: "bytes32",
        amountIn: "uint256",
        amountOut: "uint256",
        item0: "uint16",
        item1: "uint16",
      },
      ephemeral: true,
    },
    LiquidityAdded: {
      schema: {
        amount: "uint256",
        receiver: "bytes32",
      },
      ephemeral: true,
    },
    LiquidityRemoved: {
      schema: {
        amount: "uint256",
        receiver: "bytes32",
      },
      ephemeral: true,
    },
    Health: {
      schema: {
        health: "uint256",
        max_health: "uint256",
      },
    },
    HealthRegen: {
      schema: {
        last_update: "uint256",
      },
    },
    FirePower: {
      schema: {
        power: "uint256",
        rate: "uint256",
        last_update: "uint256",
      },
    },
    CargoSpace: {
      schema: {
        cargo: "uint256",
        max_cargo: "uint256",
      },
    },
    Speed: {
      schema: {
        max_speed: "uint256",
      },
    },
    Position: {
      schema: {
        pos_x: "int256",
        pos_y: "int256",
        chunk_x: "int256",
        chunk_y: "int256",
        last_update: "uint256",
      },
    },
    Salt: {
      schema: {
        amount: "uint256",
      },
    },
    Spices: {
      schema: {
        amount: "uint256",
      },
    },
    Iron: {
      schema: {
        amount: "uint256",
      },
    },
    Sugar: {
      schema: {
        amount: "uint256",
      },
    },
    Coins: {
      schema: {
        amount: "uint256",
      },
    },
    LPTokens: {
      // Port -> Owner -> Amount
      keySchema: {
        owner: "bytes32",
      },
      schema: {
        amount: "uint256",
      },
    },
    Ports: {
      keySchema: {
        port_id: "bytes32",
      },
      schema: {
        port_owner: "address",
        last_updated: "uint256",
        port_speeds: "int256[5]",
        port_name: "string",
      },
    },
    ShipWreck: {
      schema: {
        playerId: "bytes32",
      },
    },
  },
});
