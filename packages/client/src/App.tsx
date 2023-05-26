// import { useComponentValue } from "@latticexyz/react";
import { useMUD } from "./MUDContext";
import { useState, useEffect } from "react";
import {
  Text,
  Row,
  Heading,
  Br,
  IconButton,
  PixelIcon,
  Container,
  Modal,
  Header,
  Spacer,
  ModalContent,
  Button,
  Footer,
} from "nes-ui-react";

import Sand from "./assets/sand.png";
import ShallowWater from "./assets/AnimatedWaterShallow.gif";
import Land from "./assets/land.png";
import DeepWater from "./assets/AnimatedWaterDark.gif";
import Ship from "./assets/Boats.png";
import Port from "./assets/port.png";

import "./App.css";

import { SwapModal } from "./components/SwapModal";

import { IntroductionModal } from "./components/IntroductionModal";

export const App = () => {
  const {
    systemCalls: { getMap, move, attack, shipWreckExists, getShipResources },
    network: { singletonEntity },
  } = useMUD();

  const [x1, setX1] = useState("0");
  const [y1, setY1] = useState("0");
  const [x2, setX2] = useState("30");
  const [y2, setY2] = useState("10000");
  const [map, setMap] = useState<number[][]>([]);
  const [demoDialogOpen, setDemoDialogOpen] = useState(false);
  const [showIntroductionModal, setShowIntroductionModal] = useState(false);
  const [shipVisible, setShipVisible] = useState(false);

  const terrainImageStyle = {
    width: "20px",
    height: "20px",
  };
  const shipStyle = {
    width: "30px",
    height: "30px",
  };

  const handleSpawnClick = () => {
    setShipVisible(true);
  };

  useEffect(() => {
    setShowIntroductionModal(true);
    handleGetMap();
  }, []);

  useEffect(() => {
    handleGetMap();
  }, [x1, y1, x2, y2]);

  const findImage = (value: number) => {
    const terrainType = Math.floor(value / 10);
    let terrainImage;

    switch (terrainType) {
      case 1:
        terrainImage = Sand;
        break;
      case 2:
        terrainImage = Land;
        break;
      case 3:
        terrainImage = Land;
        break;
      case 4:
        terrainImage = ShallowWater;
        break;
      case 5:
        terrainImage = DeepWater;
        break;
      default:
        terrainImage = ShallowWater;
    }

    if (value % 10 === 1) {
      return (
        <div style={terrainImageStyle}>
          <img
            src={terrainImage}
            alt={`Terrain ${terrainType}`}
            style={terrainImageStyle}
          />
          <img src={Port} alt="Port" style={terrainImageStyle} />
        </div>
      );
    }

    return (
      <img
        src={terrainImage}
        alt={`Terrain ${terrainType}`}
        style={terrainImageStyle}
      />
    );
  };

  const handleGetMap = async () => {
    const result = await getMap(Number(x1), Number(y1), Number(x2), Number(y2));
    setMap(result);
  };
  return (
    <>
      <Modal
        open={showIntroductionModal}
        onClose={() => setShowIntroductionModal(false)}
      >
        <IntroductionModal />
      </Modal>

      <div></div>
      <div>
        <Container align="center" title="Game Map">
          {console.log(map)}
          {map.map((row, rowIndex) => (
            <div key={rowIndex} className="map-row">
              {row.map((value, colIndex) => (
                <span key={`${rowIndex}-${colIndex}`}>{findImage(value)}</span>
              ))}
              <img
                src={Ship}
                alt="Ship"
                className={shipVisible ? "visible" : "hidden"}
                style={{ position: "absolute", top: "200px", left: "50px" }}
              />
            </div>
          ))}
        </Container>
        <Button color="success" onClick={handleSpawnClick}>
          Spawn
        </Button>
      </div>
      <div>
        <IconButton
          borderInverted
          color="primary"
          onClick={() => setDemoDialogOpen(true)}
          style={{ position: "fixed", bottom: "20px", right: "20px" }}
        >
          <Text size="small">Swap</Text>
          <PixelIcon name="pixelicon-checkmark" size="small" />
        </IconButton>
        <Modal open={demoDialogOpen} onClose={() => setDemoDialogOpen(false)}>
          <SwapModal currentPort="e" />
        </Modal>
      </div>
    </>
  );
};
