// import { getComponentValue } from "@latticexyz/recs";
import { useMUD } from "../MUDContext";
import { useState } from "react";
import { Heading, Container, Row, Button, Br } from "nes-ui-react";
import { BigNumber } from "ethers";

export const SwapModal = (currentPort: string) => {
  const {
    components: { LPTokens },
    systemCalls: {
      sellForCoins,
      buyWithCoins,
      addLiquidity,
      removeLiquidity,
      swap,
      getShipResources,
    },
    network: { singletonEntity },
  } = useMUD();
  const [activeTab, setActiveTab] = useState("sell");
  const [sellAmount, setSellAmount] = useState("");
  const [buyAmount, setBuyAmount] = useState("");
  const [addAmount, setAddAmount] = useState("");
  const [removeAmount, setRemoveAmount] = useState("");
  const [selectedAsset, setSelectedAsset] = useState("Salt");

  const handleSell = async (amount: bigint, item: number) => {
    // Call the sellForCoins system call
    const result = await sellForCoins(item, currentPort, amount);
    console.log(result);
  };

  const handleBuy = async (amount: bigint, item: number) => {
    // Call the buyWithCoins system call
    const result = await buyWithCoins(item, currentPort, amount);
    console.log(result);
  };

  const handleAddLiquidity = async (amount: bigint) => {
    // Call the addLiquidity system call
    const result = await addLiquidity(amount, currentPort);
    console.log(result);
  };

  const handleRemoveLiquidity = async (amount: bigint) => {
    // Call the removeLiquidity system call
    const result = await removeLiquidity(amount, currentPort);
    console.log(result);
  };

  const handleSwap = async (Item0: number, Item1: number, amount: bigint) => {
    // Call the swap system call
    const result = await swap(Item0, Item1, currentPort, amount);
    console.log(result);
  };
  const handleMax = async () => {
    // Set the maxAmount to the maximum detected assets for the selected asset
    // const ship = await getShipResources();
    // switch (selectedAsset) {
    //   case "Salt":
    //     setSellAmount(ship.salt() || "");
    //     setBuyAmount();
    //     setAddAmount();
    //     setRemoveAmount();
    //     break;
    //   case "Spices":
    //     setSellAmount(getComponentValue(Spices, singletonEntity) || "");
    //     setBuyAmount(getComponentValue(Spices, singletonEntity) || "");
    //     setAddAmount(getComponentValue(Spices, singletonEntity) || "");
    //     setRemoveAmount(getComponentValue(Spices, singletonEntity) || "");
    //     break;
    //   case "Iron":
    //     setSellAmount(getComponentValue(Iron, singletonEntity) || "");
    //     setBuyAmount(getComponentValue(Iron, singletonEntity) || "");
    //     setAddAmount(getComponentValue(Iron, singletonEntity) || "");
    //     setRemoveAmount(getComponentValue(Iron, singletonEntity) || "");
    //     break;
    //   case "Sugar":
    //     setSellAmount(getComponentValue(Sugar, singletonEntity) || "");
    //     setBuyAmount(getComponentValue(Sugar, singletonEntity) || "");
    //     setAddAmount(getComponentValue(Sugar, singletonEntity) || "");
    //     setRemoveAmount(getComponentValue(Sugar, singletonEntity) || "");
    //     break;
    //   case "Coins":
    //     setSellAmount(getComponentValue(Coins, singletonEntity) || "");
    //     setBuyAmount(getComponentValue(Coins, singletonEntity) || "");
    //     setAddAmount(getComponentValue(Coins, singletonEntity) || "");
    //     setRemoveAmount(getComponentValue(Coins, singletonEntity) || "");
    //     break;
    //   case "LP Tokens":
    //     setSellAmount(getComponentValue(LPTokens, singletonEntity) || "");
    //     setBuyAmount(getComponentValue(LPTokens, singletonEntity) || "");
    //     setAddAmount(getComponentValue(LPTokens, singletonEntity) || "");
    //     setRemoveAmount(getComponentValue(LPTokens, singletonEntity) || "");
    //     break;
    //   default:
    //     break;
    // }
  };

  return (
    <div className="swap-modal-container">
      <div className="swap-modal-tabs">
        <button
          className={activeTab === "sell" ? "active" : ""}
          onClick={() => setActiveTab("sell")}
        >
          Sell
        </button>
        <button
          className={activeTab === "buy" ? "active" : ""}
          onClick={() => setActiveTab("buy")}
        >
          Buy
        </button>
        <button
          className={activeTab === "add" ? "active" : ""}
          onClick={() => setActiveTab("add")}
        >
          Add Liquidity
        </button>
        <button
          className={activeTab === "remove" ? "active" : ""}
          onClick={() => setActiveTab("remove")}
        >
          Remove Liquidity
        </button>
        <button
          className={activeTab === "swap" ? "active" : ""}
          onClick={() => setActiveTab("swap")}
        >
          Swap
        </button>
      </div>
      <div className="swap-modal-content">
        <select
          value={selectedAsset}
          onChange={(e) => setSelectedAsset(e.target.value)}
        >
          <option value="Salt">Salt</option>
          <option value="Spices">Spices</option>
          <option value="Iron">Iron</option>
          <option value="Sugar">Sugar</option>
          <option value="Coins">Coins</option>
        </select>
        {activeTab === "sell" && (
          <>
            <input
              type="number"
              value={sellAmount}
              onChange={(e) => setSellAmount(e.target.value)}
            />
            <button type="button" onClick={() => handleMax()}>
              Max
            </button>
            <button type="button" onClick={handleSell}>
              Sell for Coins
            </button>
          </>
        )}
        {activeTab === "buy" && (
          <>
            <input
              type="number"
              value={buyAmount}
              onChange={(e) => setBuyAmount(e.target.value)}
            />
            <button type="button" onClick={() => handleMax()}>
              Max
            </button>
            <button type="button" onClick={handleBuy}>
              Buy with Coins
            </button>
          </>
        )}
        {activeTab === "add" && (
          <>
            <input
              type="number"
              value={addAmount}
              onChange={(e) => setAddAmount(e.target.value)}
            />
            <button type="button" onClick={() => handleMax()}>
              Max
            </button>
            <button type="button" onClick={handleAddLiquidity}>
              Add Liquidity
            </button>
          </>
        )}
        {activeTab === "remove" && (
          <>
            <input
              type="number"
              value={removeAmount}
              onChange={(e) => setRemoveAmount(e.target.value)}
            />
            <button type="button" onClick={() => handleMax()}>
              Max
            </button>
            <button
              type="button"
              onClick={handleRemoveLiquidity(BigInt(sellAmount.toString()))}
            >
              Remove Liquidity
            </button>
          </>
        )}
        {activeTab === "swap" && (
          <>
            <input
              type="number"
              value={sellAmount}
              onChange={(e) => setSellAmount(e.target.value)}
            />
            <button type="button" onClick={() => handleMax()}>
              Max
            </button>
            <input
              type="number"
              value={buyAmount}
              onChange={(e) => setBuyAmount(e.target.value)}
            />

            <button type="button" onClick={handleSwap}>
              Swap
            </button>
          </>
        )}
      </div>
    </div>
  );
};
