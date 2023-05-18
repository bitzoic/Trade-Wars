import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  tables: {
        Health: {
            schema: { 
                health: "uint256", 
                max_health: "uint256",
            },
        },
        FirePower: {
            schema: { 
                power: "uint256", 
                rate: "uint256",
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
                pos_x: "uint256", 
                pos_y: "uint256",
                chunk_x: "uint256", 
                chunk_y: "uint256",
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
    },
});
