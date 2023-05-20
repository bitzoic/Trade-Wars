// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { IWorld } from "../../codegen/world/IWorld.sol";
import { Ports} from "../../codegen/Tables.sol";
contract PortSystem is System {

    function init(bytes32 portId, uint256[5] calldata amounts) external {
    require(Ports.get(portId).owner == address(0), "ERR_PORT_EXISTS");
    Ports.set(portId,));
    
    emit PortCreated(portId, msg.sender);
}
    }

    
    
}