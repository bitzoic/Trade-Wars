// import { useComponentValue } from "@latticexyz/react";
import { useMUD } from "../MUDContext";
import { useState } from "react";
import "./App.css";
export const SwapModal = () => {
  const {
    components: { LPTokens },
    systemCalls: {
      sellForCoins,
      buyWithCoins,
      addLiquidity,
      removeLiquidity,
      swap,
    },
    network: { singletonEntity },
  } = useMUD();
  const [activeTab, setActiveTab] = useState("sell");
  const [sellAmount, setSellAmount] = useState("");
  const [buyAmount, setBuyAmount] = useState("");
  const [addAmount, setAddAmount] = useState("");
  const [removeAmount, setRemoveAmount] = useState("");
  const [maxAmount, setMaxAmount] = useState("");
  const handleSell = async () => {
    // Call the sellForCoins system call
    // const result = await sellForCoins();
    // console.log(result);
  };

  const handleBuy = async () => {
    // Call the buyWithCoins system call
    // const result = await buyWithCoins();
    // console.log(result);
  };

  const handleAddLiquidity = async () => {
    // Call the addLiquidity system call
    // const result = await addLiquidity();
    // console.log(result);
  };

  const handleRemoveLiquidity = async () => {
    // Call the removeLiquidity system call
    // const result = await removeLiquidity();
    // console.log(result);
  };

  const handleSwap = async () => {
    // Call the swap system call
    // const result = await swap();
    // console.log(result);
  };

  return (
    <div className="swap-container">
      <div className="swap-tabs">
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
      <div className="swap-content">
        {activeTab === "sell" && (
          <>
            <input
              type="number"
              value={sellAmount}
              onChange={(e) => setSellAmount(e.target.value)}
            />
            <button type="button" onClick={() => setSellAmount(maxAmount)}>
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
            <button type="button" onClick={() => setBuyAmount(maxAmount)}>
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
            <button type="button" onClick={() => setAddAmount(maxAmount)}>
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
            <button type="button" onClick={() => setRemoveAmount(maxAmount)}>
              Max
            </button>
            <button type="button" onClick={handleRemoveLiquidity}>
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
            <button type="button" onClick={() => setSellAmount(maxAmount)}>
              Max
            </button>
            <input
              type="number"
              value={buyAmount}
              onChange={(e) => setBuyAmount(e.target.value)}
            />
            <button type="button" onClick={() => setBuyAmount(maxAmount)}>
              Max
            </button>
            <button type="button" onClick={handleSwap}>
              Swap
            </button>
          </>
        )}
      </div>
    </div>
  );
};
