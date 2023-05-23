import { getComponentValue } from "@latticexyz/recs";
import { awaitStreamValue, keccak256 } from "@latticexyz/utils";
import { ClientComponents } from "./createClientComponents";
import { SetupNetworkResult } from "./setupNetwork";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  { worldContract, worldSend, txReduced$, singletonEntity }: SetupNetworkResult,
  {
    SwapExecuted,
    LiquidityAdded,
    LiquidityRemoved,
    Health,
    HealthRegen,
    FirePower,
    CargoSpace,
    Speed,
    Position,
    Salt,
    Spices,
    Iron,
    Sugar,
    Coins,
    LPTokens,
    Ports,
  }: ClientComponents
) {
  const move = async (x: number, y: number) => {
    const tx = await worldSend("move", [x, y]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(Position, singletonEntity);
  };

  const getShipResources = async () => {
    const salt = getComponentValue(Salt, singletonEntity);
    const spices = getComponentValue(Spices, singletonEntity);
    const iron = getComponentValue(Iron, singletonEntity);
    const sugar = getComponentValue(Sugar, singletonEntity);
    const coins = getComponentValue(Coins, singletonEntity);
    const lpTokens = getComponentValue(LPTokens, singletonEntity);
    return { salt, spices, iron, sugar, coins, lpTokens };
  };

  const getShipStats = async () => {
    const health = getComponentValue(Health, singletonEntity);
    const healthRegen = getComponentValue(HealthRegen, singletonEntity);
    const firePower = getComponentValue(FirePower, singletonEntity);
    const cargoSpace = getComponentValue(CargoSpace, singletonEntity);
    const speed = getComponentValue(Speed, singletonEntity);
    return { health, healthRegen, firePower, cargoSpace, speed };
  };
  // ONLY CALL IF IT'S A PORT
  const getPortStats = async (port: string) => {
    const res = port as typeof singletonEntity;
    if (getComponentValue(Ports, res)?.port_name.length === 0) {
      return null;
    }

    const tx = await worldSend("manufacture", [port]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    const salt = getComponentValue(Salt, res);
    const spices = getComponentValue(Spices, res);
    const iron = getComponentValue(Iron, res);
    const sugar = getComponentValue(Sugar, res);
    const coins = getComponentValue(Coins, res);
    const lpTokens = getComponentValue(LPTokens, res);
    return { salt, spices, iron, sugar, coins, lpTokens };
  };
  const attack = async (target: string) => {
    const tx = await worldSend("attack", [target]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(Health, singletonEntity);
  };

  // AMM LOGIC

  const initPort = async (xCoord: number, yCoord: number) => {
    const tx = await worldSend("simpleInitPort", [xCoord, yCoord]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
  };

  const buyWithCoins = async (item: number, port: string, amount: bigint) => {
    const tx = await worldSend("buyWithCoins", [item, port, amount]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(SwapExecuted, singletonEntity)?.amountOut;
  };

  const sellForCoins = async (item: number, port: string, amount: bigint) => {
    const tx = await worldSend("sellForCoins", [item, port, amount]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(SwapExecuted, singletonEntity)?.amountOut;
  };

  const swap = async (
    Item0: number,
    Item1: number,
    port: string,
    amount: bigint
  ) => {
    const tx = await worldSend("swap", [amount, port, Item0, Item1]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(SwapExecuted, singletonEntity);
  };

  const addLiquidity = async (amount: bigint, port: string) => {
    const res = port as typeof singletonEntity;
    const tx = await worldSend("joinPoolSimple", [res, amount]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(LiquidityAdded, singletonEntity);
  };

  const removeLiquidity = async (amount: bigint, port: string) => {
    const res = port as typeof singletonEntity;
    const tx = await worldSend("exitPool", [res, amount]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(LiquidityRemoved, singletonEntity);
  };

  // TERRAIN LOGIC

  const getTerrainType = (terrain: string): number => {
    let terrainType: number;

    switch (terrain) {
      case keccak256("terrain.Sand"):
        terrainType = 1;
        break;
      case keccak256("terrain.Grass"):
        terrainType = 2;
        break;
      case keccak256("terrain.Mountain"):
        terrainType = 3;
        break;
      case keccak256("terrain.Shallow_Water"):
        terrainType = 4;
        break;
      case keccak256("terrain.Deep_Water"):
        terrainType = 5;
        break;
      default:
        terrainType = -1;
        break;
    }

    return terrainType;
  };

  const getObjectType = (object: string): number => {
    let objectType: number;
    if (object === keccak256("object.Port")) {
      objectType = 1;
    } else if (object === keccak256("object.Reef")) {
      objectType = 2;
    } else {
      objectType = 0;
    }
    return objectType;
  };

  const getMap = async (chunk_1: number, chunk_2: number) => {
    const [x1, y1] = [chunk_1 % 256, Math.floor(chunk_1 / 256)];
    const [x2, y2] = [chunk_2 % 256, Math.floor(chunk_2 / 256)];
    const terrainMatrix = [];

    for (let y = y1; y <= y2; y++) {
      const row = [];
      for (let x = x1; x <= x2; x++) {
        // const tx = await worldSend("getTerrain", [x, y]);
        // await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
        const terrain = (
          await worldContract.callStatic.getTerrain(x, y)
        ).toString();
        const object = (
          await worldContract.callStatic.getObject(x, y)
        ).toString();
        const terrainObject =
          getTerrainType(terrain) * 10 + getObjectType(object);
        row.push(terrainObject);
      }
      terrainMatrix.push(row);
    }

    return terrainMatrix;
  };

  const shipWreckExists = async (x: number, y: number) => {
    return await worldContract.callStatic.shipWreckExists(x, y);
  };

  // Haven't implemented shipwreck looting logic

  return {
    getShipResources,
    move,
    attack,
    initPort,
    swap,
    getShipStats,
    sellForCoins,
    buyWithCoins,
    getPortStats,
    addLiquidity,
    removeLiquidity,
    shipWreckExists,
    getMap,
  };
}
