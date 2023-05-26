// import { getComponentValue } from "@latticexyz/recs";
import { useMUD } from "../MUDContext";
import { useState } from "react";
import {
  Heading,
  Container,
  Row,
  Button,
  Br,
  Header,
  PixelIcon,
  IconButton,
  Spacer,
  Menu,
  Text,
  Col,
  Input,
} from "nes-ui-react";

import Green from "../assets/AnimatedRubyGreen.gif";

import { BigNumber } from "ethers";

type SwapModalProps = {
  currentPort: string;
};

export const SwapModal: React.FC<SwapModalProps> = ({ currentPort }) => {
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
  const [selectedAsset, setSelectedAsset] = useState("null");
  const [selected2Asset, setSelected2Asset] = useState("null");
  const [showMoreMenu, setShowMoreMenu] = useState(false);
  const [showMoreMenu2, setShowMoreMenu2] = useState(false);

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
    <div>
      <Header>
        <Spacer />
        <Heading
          size="large"
          style={{ alignContent: "center", paddingInline: "10px" }}
        >
          {" "}
          <img src={Green} style={{ width: "30px", height: "30px" }} />
          Port
        </Heading>
        <Spacer />
        <IconButton color="error" size="small">
          <PixelIcon name="pixelicon-close" size="small" />
        </IconButton>
      </Header>
      <Row className="swap-modal-tabs">
        <Button
          className={activeTab === "sell" ? "active" : ""}
          onClick={() => setActiveTab("sell")}
          color="primary"
        >
          Sell
        </Button>
        <Button
          className={activeTab === "buy" ? "active" : ""}
          onClick={() => setActiveTab("buy")}
          color="primary"
        >
          Buy
        </Button>
        <Button
          className={activeTab === "add" ? "active" : ""}
          onClick={() => setActiveTab("add")}
          color="primary"
        >
          Add Liquidity
        </Button>
        <Button
          className={activeTab === "remove" ? "active" : ""}
          onClick={() => setActiveTab("remove")}
          color="primary"
        >
          Remove Liquidity
        </Button>
        <Button
          className={activeTab === "swap" ? "active" : ""}
          onClick={() => setActiveTab("swap")}
          color="primary"
        >
          Swap
        </Button>
      </Row>

      {activeTab === "sell" && (
        <Row>
          <Input
            type="number"
            value={sellAmount}
            onChange={(e) => setSellAmount(e.target.value)}
          />
          <Button type="button" onClick={() => handleMax()}>
            Max
          </Button>
          <Button type="button" onClick={handleSell}>
            Sell for Coins
          </Button>
        </Row>
      )}
      {activeTab === "buy" && (
        <>
          <div>
            <Button
              borderInverted
              color="success"
              fontColor="black"
              onClick={() => setShowMoreMenu(true)}
            >
              {selectedAsset === "null" ? "Items >" : selectedAsset}
            </Button>

            <Menu
              open={showMoreMenu}
              modal
              onClose={() => setShowMoreMenu(false)}
            >
              <IconButton
                color="primary"
                size="small"
                onClick={() => setSelectedAsset("salt")}
              >
                {selectedAsset === "salt" ? (
                  <PixelIcon name="pixelicon-checkmark" size="small" />
                ) : null}
                <Text size="small"> 🧂 Salt </Text>
              </IconButton>

              <IconButton
                color="primary"
                size="small"
                onClick={() => setSelectedAsset("sugar")}
              >
                {selectedAsset === "sugar" ? (
                  <PixelIcon name="pixelicon-checkmark" size="small" />
                ) : null}
                <Text size="small"> 🍭 Sugar</Text>
              </IconButton>
              <IconButton
                color="primary"
                size="small"
                onClick={() => setSelectedAsset("iron")}
              >
                {selectedAsset === "iron" ? (
                  <PixelIcon name="pixelicon-checkmark" size="small" />
                ) : null}
                <Text size="small"> 🏗️ Iron</Text>
              </IconButton>

              <IconButton
                color="primary"
                size="small"
                onClick={() => setSelectedAsset("spices")}
              >
                {selectedAsset === "spices" ? (
                  <PixelIcon name="pixelicon-checkmark" size="small" />
                ) : null}
                <Text size="small"> 🌶️ Spices</Text>
              </IconButton>

              <IconButton
                color="primary"
                size="small"
                onClick={() => setSelectedAsset("coins")}
              >
                {selectedAsset === "coins" ? (
                  <PixelIcon name="pixelicon-checkmark" size="small" />
                ) : null}
                <Text size="small"> 💰 Coins</Text>
              </IconButton>
            </Menu>
          </div>
          <Col type="1-of-2">
            <Input
              type="number"
              value={buyAmount}
              onChange={(e) => setBuyAmount(e.target.value)}
            />
          </Col>
          <Button type="button" onClick={() => handleMax()}>
            Max
          </Button>
          <Button type="button" onClick={handleBuy}>
            Buy with Coins
          </Button>
        </>
      )}
      {activeTab === "add" && (
        <>
          <Input
            type="number"
            value={addAmount}
            onChange={(e) => setAddAmount(e.target.value)}
          />
          <Button type="button" onClick={() => handleMax()}>
            Max
          </Button>
          <Button type="button" onClick={handleAddLiquidity}>
            Add Liquidity
          </Button>
        </>
      )}
      {activeTab === "remove" && (
        <>
          <Input
            type="number"
            value={removeAmount}
            onChange={(e) => setRemoveAmount(e.target.value)}
          />
          <Button type="button" onClick={() => handleMax()}>
            Max
          </Button>
          <Button
            type="button"
            onClick={handleRemoveLiquidity(BigInt(sellAmount.toString()))}
          >
            Remove Liquidity
          </Button>
        </>
      )}
      {activeTab === "swap" && (
        <>
          <Row>
            <Col type="1-of-3">
              <Button
                borderInverted
                color="success"
                fontColor="black"
                onClick={() => setShowMoreMenu(true)}
              >
                {selectedAsset === "null" ? "Items >" : selectedAsset}
              </Button>
            </Col>
            <Col type="4-of-5">
              <Input
                type="number"
                value={sellAmount}
                onChange={(e) => setSellAmount(e.target.value)}
              />
            </Col>
            {/* <Button type="button" onClick={() => handleMax()}>
                Max
              </Button> */}
            <Menu
              open={showMoreMenu}
              modal
              onClose={() => setShowMoreMenu(false)}
            >
              <IconButton
                color="primary"
                size="small"
                onClick={() => setSelectedAsset("salt")}
              >
                {selectedAsset === "salt" ? (
                  <PixelIcon name="pixelicon-checkmark" size="small" />
                ) : null}
                <Text size="small"> 🧂 Salt </Text>
              </IconButton>

              <IconButton
                color="primary"
                size="small"
                onClick={() => setSelectedAsset("sugar")}
              >
                {selectedAsset === "sugar" ? (
                  <PixelIcon name="pixelicon-checkmark" size="small" />
                ) : null}
                <Text size="small"> 🍭 Sugar</Text>
              </IconButton>
              <IconButton
                color="primary"
                size="small"
                onClick={() => setSelectedAsset("iron")}
              >
                {selectedAsset === "iron" ? (
                  <PixelIcon name="pixelicon-checkmark" size="small" />
                ) : null}
                <Text size="small"> 🏗️ Iron</Text>
              </IconButton>

              <IconButton
                color="primary"
                size="small"
                onClick={() => setSelectedAsset("spices")}
              >
                {selectedAsset === "spices" ? (
                  <PixelIcon name="pixelicon-checkmark" size="small" />
                ) : null}
                <Text size="small"> 🌶️ Spices</Text>
              </IconButton>

              <IconButton
                color="primary"
                size="small"
                onClick={() => setSelectedAsset("coins")}
              >
                {selectedAsset === "coins" ? (
                  <PixelIcon name="pixelicon-checkmark" size="small" />
                ) : null}
                <Text size="small"> 💰 Coins</Text>
              </IconButton>
            </Menu>
          </Row>

          <Row>
            <Col type="1-of-3">
              <div>
                <Button
                  borderInverted
                  color="success"
                  fontColor="black"
                  onClick={() => setShowMoreMenu2(true)}
                >
                  {selected2Asset === "null" ? "Items >" : selected2Asset}
                </Button>

                <Menu
                  open={showMoreMenu2}
                  modal
                  onClose={() => setShowMoreMenu2(false)}
                >
                  <IconButton
                    color="primary"
                    size="small"
                    onClick={() => setSelected2Asset("salt")}
                  >
                    {selected2Asset === "salt" ? (
                      <PixelIcon name="pixelicon-checkmark" size="small" />
                    ) : null}
                    <Text size="small"> 🧂 Salt </Text>
                  </IconButton>

                  <IconButton
                    color="primary"
                    size="small"
                    onClick={() => setSelected2Asset("sugar")}
                  >
                    {selected2Asset === "sugar" ? (
                      <PixelIcon name="pixelicon-checkmark" size="small" />
                    ) : null}
                    <Text size="small"> 🍭 Sugar</Text>
                  </IconButton>
                  <IconButton
                    color="primary"
                    size="small"
                    onClick={() => setSelected2Asset("iron")}
                  >
                    {selected2Asset === "iron" ? (
                      <PixelIcon name="pixelicon-checkmark" size="small" />
                    ) : null}
                    <Text size="small"> 🏗️ Iron</Text>
                  </IconButton>

                  <IconButton
                    color="primary"
                    size="small"
                    onClick={() => setSelected2Asset("spices")}
                  >
                    {selected2Asset === "spices" ? (
                      <PixelIcon name="pixelicon-checkmark" size="small" />
                    ) : null}
                    <Text size="small"> 🌶️ Spices</Text>
                  </IconButton>

                  <IconButton
                    color="primary"
                    size="small"
                    onClick={() => setSelected2Asset("coins")}
                  >
                    {selected2Asset === "coins" ? (
                      <PixelIcon name="pixelicon-checkmark" size="small" />
                    ) : null}
                    <Text size="small"> 💰 Coins</Text>
                  </IconButton>
                </Menu>
              </div>
            </Col>
            <Col type="2-of-3">
              <Input
                type="number"
                value={buyAmount}
                onChange={(e) => setBuyAmount(e.target.value)}
              />
            </Col>
          </Row>

          <Button type="button" onClick={handleSwap}>
            Swap
          </Button>
        </>
      )}
    </div>
  );
};
