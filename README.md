<p align="center">
    <picture>
        <source srcset=".docs/mjlogo.png">
    </picture>
</p>

# Trade Wars

This is a on-chain game for the [EthGlobal Autonomous Worlds](https://ethglobal.com/events/autonomous) Hackathon.

**Contributors:** @bitzoic @mergd @CometShock

## Overview 

⛵️🪙Sail the seas as a merchant and arbitrage trades between ports, but stay vigilant for other pirating players! 🏴‍☠️ A MUD v2 infinite merchant trading game where ports trade using Balancer pools. Ports continually consume resources, perpetually updating prices.

## Description 

Engage in thrilling merchant trading at sea and prepare for combat against pirating players in Trade Wars. In this game, you'll actively trade as a merchant ship at sea while defending against attacks from other pirating players, or looting others as a pirate yourself. The game uses MUD v2 and a browser-based React frontend to drive a 2D autonomous world with a near-infinite (int256 x int256) world map and an autonomous, position-bound AMM economy for players to perpetually interact with.

The economy is built on unique Balancer pools implemented at each trading port, and players must navigate to the port's location in order to interact with it. Each trading port continually generates a specific resource while consuming other resources. This results in arbitrage opportunities for merchant players to capture. A player's score can be recognized by the total coins they currently have, as well as their high water mark for most coins held at any point.

The world map's terrain and object (port) locations are procedurally generated using Perlin noise. The positioning system is built using a chunk-based system where it takes users a certain amount of travel time to "sail" across each chunk. The attack system also relies on this chunk system, where to maintain security a player can only attack another if within the same chunk. If a player dies, all their stats are reset and a shipwreck is created. Players can come and loot this shipwreck. While attacking, players are again bound by the "physics" of the game and need to wait for their weapons to reload before firing again. If a player is located in a port, they are safe from attack. This mechanic is user-friendly, as a player in a port may "logout" and not get attacked. Additionally, the players can repair their ships bound by the time spent in the port, and optionally upgrade them with coins.

## Technical Overview 

The entire game is on-chain and uses the MUDv2 framework. 
The frontend uses nes-ui-react.

#### World

The world is on-chain and procedurally generated using Perlin noise with a 2-layer system: Terrain and Objects. The terrain includes various depths of the ocean as well as varying heights of land. Objects sit atop terrain with applied restrictions for their particular location. The game currently has 2 types of objects with the option to expand further; ports and reefs.

#### Player Movement

Since we can't use a fixed update function like in traditional game development, we needed to get creative on how to determine where a player is. So we made a positioning system based on chunks, which are currently set to be 10x10. Upon entering and leaving a chunk, a transaction should be made. The world's on-chain "physics" requires that you take a certain amount of time to "sail" across this chunk as a function of distance, speed, and time. This provides both security to prevent players from teleporting and a seamless experience from either a UI or the command line. Further restrictions are added to ensure that players can only move on water, adhering to the on-chain world.

#### Ports

Ports are placed only on the sand terrain bordering the ocean. Trading ports are Balancer pools with resources continuously consumed by the town which reflects updates on the prices of goods. Players may purchase goods and sail to another port, arbitraging the difference. As players are restricted on their cargo capacity, they must make decisions on the trade-off between low-weight/low-value goods and high-weight/high-value or find the perfect blend of the two. This provides for a truly dynamic experience in this autonomous world.

#### Player Fighting

Players must be careful when sailing the high seas. Robbery may happen by other players in our on-chain attack system. The attacking system again uses the chunk system to ensure that a player is within firing range, following the on-chain rules. They must also adhere to the physics of the world with reload times. When a player dies, all their stats are reset and they respawn in the middle of the map. A shipwreck is created where they died which may be looted by the attacking player, collecting their goods. As this autonomous world lives on-chain and doesn't stop, we needed a way for players to "logout" and not have their loot stolen. So, ports became a safe haven where virtual docking means you are safe from the high seas of robbery. When leaving a port, you in effect become "online" and vulnerable to attack.

#### Player Health Regen

Players may regen their health after taking damage. In exchange for coins, they may have their ship "rebuilt" on-chain. Rebuilding takes time and is restricted by the on-chain rules, players must wait in ports for their ship to be rebuilt. Due to the nature of everything on-chain being initialized at 0, health works backward in our game where 0 is full health and 100 is no health.

#### Player Upgrades 

Each player starts with hardcoded base stats. As no transactions are created to spawn a player(everything starts at 0), each function uses a base value plus an upgrade amount. Players may purchase upgrades using the coins they have earned through arbitrage or plunder. The current upgrades include cargo space, speed, firepower, fire rate, and health.

#### Trading

We refactored Balancer's design to be compatible with the systems & tables framework in MUD. All data is now stored in tables, and the continuous port resource generation/consumption is handled by calling manufacture() within the trading functions. 

## Future Work 

As we have limited our scope to ensure completion by the deadline for the hackathon, there are a few key areas we would like to expand on. 

##### - World: Additions to the on-chain world could include objects such as lighthouses as well as terrain elements such as rivers.
##### - Events: High desired, we would like to add events such as hurricanes to the world. Other events could also include attacks from sea monsters.
##### - Ownership of Ports: To further expand on the autonomous world, we would like to add the ownership of ports, where users themselves may own a port, build its defenses, and manage its town.
##### - Frontend with improved assets, UI, UX
##### - Trading Overlay: Frontend Uniswap-like trading overlay on selected port, and nearby ports have a small overlay that autopopulates the live expected profitability of the trade.
##### - Implementing open_ports: live_player Ratio (or Curve): Adjust live ports based on estimated live players, mitigating risk of hyperinflationary economy (i.e. preventing 10 players with 1000 open ports).
##### - Proposed basic port:player ratio:  8:5
##### - Proposed advanced curve: open_ports = 2*live_players^0.87
##### - Game Parameter Governance: gov modifying game parameters to encourage evolving play & strategy
