// import { useComponentValue } from "@latticexyz/react";
import { useMUD } from "./MUDContext";
import { useState } from "react";
import {
  Text,
  Row,
  Heading,
  Br,
  IconButton,
  PixelIcon,
  Modal,
  Header,
  Spacer,
  ModalContent,
  Footer,
} from "nes-ui-react";

import "./App.css";

import { SwapModal } from "./components/SwapModal";

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

  const handleGetMap = async () => {
    const result = await getMap(Number(x1), Number(y1), Number(x2), Number(y2));
    setMap(result);
  };
  return (
    <>
      <div>
        <label>
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
        </label>
        <button type="button" onClick={handleGetMap}>
          Show Map
        </button>
      </div>
      <div className="map-container">
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
        <IconButton
          borderInverted
          color="primary"
          onClick={() => setDemoDialogOpen(true)}
        >
          <Text size="small">Open Modal</Text>
          <PixelIcon name="pixelicon-checkmark" size="small" />
        </IconButton>
        <Modal open={demoDialogOpen} onClose={() => setDemoDialogOpen(false)}>
          <SwapModal currentPort={"e"} />
        </Modal>
      </div>
    </>
  );
};
