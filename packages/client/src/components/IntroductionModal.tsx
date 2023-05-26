import { useState } from "react";
import {
  Heading,
  Container,
  Row,
  Button,
  Br,
  Text,
  IconButton,
  PixelIcon,
  Toast,
} from "nes-ui-react";

export const IntroductionModal = () => {
  const [isOpen, setIsOpen] = useState(true);

  const handleClose = () => {
    setIsOpen(false);
  };

  return (
    <Container>
      <Row>
        <Heading size="large">Welcome to the Trade Wars!</Heading>
      </Row>
      <Row>
        <Container align="left" title="The background">
          <Toast>
            <Text size="medium">
              Engage in thrilling merchant trading at sea and prepare for combat
              against pirating players in Trade Wars. In this game, you&apos;ll
              actively trade as a merchant ship at sea while defending against
              attacks from other pirating players, or looting others as a pirate
              yourself.
            </Text>
          </Toast>
        </Container>
      </Row>
      <Row>
        <Text size="medium">
          To play, click on the spawn button and then click on the map to move
          and the swap button to interact with ports.
        </Text>
      </Row>
      <Row style={{ display: "block" }}>
        <IconButton
          style={{ float: "left" }}
          fontColor="black"
          color="success"
          size="large"
          onClick={handleClose}
        >
          <Text size="medium">Begin! </Text>

          <PixelIcon
            inverted={false}
            name="pixelicon-checkmark"
            size="medium"
          />
        </IconButton>
      </Row>
    </Container>
  );
};
