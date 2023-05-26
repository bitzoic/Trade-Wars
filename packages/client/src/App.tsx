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
  const [x2, setX2] = useState("10");
  const [y2, setY2] = useState("4");
  const [map, setMap] = useState<number[][]>([]);
  const [demoDialogOpen, setDemoDialogOpen] = useState(false);
  const [showIntroductionModal, setShowIntroductionModal] = useState(false);

  useEffect(() => {
    setShowIntroductionModal(true);
  }, []);

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

      <div>
        {/* <label>
          X1:
          <input
            type="text"
            value={x1}
            onChange={(e) => setX1(e.target.value)}
          />
        </label>
        <label>
          Y1:
          <input
            type="text"
            value={y1}
            onChange={(e) => setY1(e.target.value)}
          />
        </label>
        <label>
          X2:
          <input
            type="text"
            value={x2}
            onChange={(e) => setX2(e.target.value)}
          />
        </label>
        <label>
          Y2:
          <input
            type="text"
            value={y2}
            onChange={(e) => setY2(e.target.value)}
          />
        </label> */}
        <Button type="button" onClick={handleGetMap}>
          Show Map
        </Button>
      </div>
      <Container align="center" title="Game Map">
        {map.map((row, rowIndex) => (
          <div key={rowIndex} className="map-row">
            {row.map((value, colIndex) => (
              <span
                key={`${rowIndex}-${colIndex}`}
                style={{
                  padding: "0.5rem",
                  margin: "0.1rem",
                }}
              >
                {value}
              </span>
            ))}
          </div>
        ))}
      </Container>
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
