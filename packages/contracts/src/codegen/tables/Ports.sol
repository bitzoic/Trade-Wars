// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

// Import schema type
import { SchemaType } from "@latticexyz/schema-type/src/solidity/SchemaType.sol";

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { Schema, SchemaLib } from "@latticexyz/store/src/Schema.sol";
import { PackedCounter, PackedCounterLib } from "@latticexyz/store/src/PackedCounter.sol";

bytes32 constant _tableId = bytes32(abi.encodePacked(bytes16(""), bytes16("Ports")));
bytes32 constant PortsTableId = _tableId;

struct PortsData {
  address port_owner;
  uint256 last_updated;
  int256[5] port_speeds;
  string port_name;
}

library Ports {
  /** Get the table's schema */
  function getSchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](4);
    _schema[0] = SchemaType.ADDRESS;
    _schema[1] = SchemaType.UINT256;
    _schema[2] = SchemaType.INT256_ARRAY;
    _schema[3] = SchemaType.STRING;

    return SchemaLib.encode(_schema);
  }

  function getKeySchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](1);
    _schema[0] = SchemaType.BYTES32;

    return SchemaLib.encode(_schema);
  }

  /** Get the table's metadata */
  function getMetadata() internal pure returns (string memory, string[] memory) {
    string[] memory _fieldNames = new string[](4);
    _fieldNames[0] = "port_owner";
    _fieldNames[1] = "last_updated";
    _fieldNames[2] = "port_speeds";
    _fieldNames[3] = "port_name";
    return ("Ports", _fieldNames);
  }

  /** Register the table's schema */
  function registerSchema() internal {
    StoreSwitch.registerSchema(_tableId, getSchema(), getKeySchema());
  }

  /** Register the table's schema (using the specified store) */
  function registerSchema(IStore _store) internal {
    _store.registerSchema(_tableId, getSchema(), getKeySchema());
  }

  /** Set the table's metadata */
  function setMetadata() internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    StoreSwitch.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Set the table's metadata (using the specified store) */
  function setMetadata(IStore _store) internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    _store.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Get port_owner */
  function getPort_owner(bytes32 port_id) internal view returns (address port_owner) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 0);
    return (address(Bytes.slice20(_blob, 0)));
  }

  /** Get port_owner (using the specified store) */
  function getPort_owner(IStore _store, bytes32 port_id) internal view returns (address port_owner) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 0);
    return (address(Bytes.slice20(_blob, 0)));
  }

  /** Set port_owner */
  function setPort_owner(bytes32 port_id, address port_owner) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.setField(_tableId, _keyTuple, 0, abi.encodePacked((port_owner)));
  }

  /** Set port_owner (using the specified store) */
  function setPort_owner(IStore _store, bytes32 port_id, address port_owner) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.setField(_tableId, _keyTuple, 0, abi.encodePacked((port_owner)));
  }

  /** Get last_updated */
  function getLast_updated(bytes32 port_id) internal view returns (uint256 last_updated) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 1);
    return (uint256(Bytes.slice32(_blob, 0)));
  }

  /** Get last_updated (using the specified store) */
  function getLast_updated(IStore _store, bytes32 port_id) internal view returns (uint256 last_updated) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 1);
    return (uint256(Bytes.slice32(_blob, 0)));
  }

  /** Set last_updated */
  function setLast_updated(bytes32 port_id, uint256 last_updated) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.setField(_tableId, _keyTuple, 1, abi.encodePacked((last_updated)));
  }

  /** Set last_updated (using the specified store) */
  function setLast_updated(IStore _store, bytes32 port_id, uint256 last_updated) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.setField(_tableId, _keyTuple, 1, abi.encodePacked((last_updated)));
  }

  /** Get port_speeds */
  function getPort_speeds(bytes32 port_id) internal view returns (int256[5] memory port_speeds) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 2);
    return toStaticArray_int256_5(SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_int256());
  }

  /** Get port_speeds (using the specified store) */
  function getPort_speeds(IStore _store, bytes32 port_id) internal view returns (int256[5] memory port_speeds) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 2);
    return toStaticArray_int256_5(SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_int256());
  }

  /** Set port_speeds */
  function setPort_speeds(bytes32 port_id, int256[5] memory port_speeds) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.setField(_tableId, _keyTuple, 2, EncodeArray.encode(fromStaticArray_int256_5(port_speeds)));
  }

  /** Set port_speeds (using the specified store) */
  function setPort_speeds(IStore _store, bytes32 port_id, int256[5] memory port_speeds) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.setField(_tableId, _keyTuple, 2, EncodeArray.encode(fromStaticArray_int256_5(port_speeds)));
  }

  /** Get the length of port_speeds */
  function lengthPort_speeds(bytes32 port_id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    uint256 _byteLength = StoreSwitch.getFieldLength(_tableId, _keyTuple, 2, getSchema());
    return _byteLength / 32;
  }

  /** Get the length of port_speeds (using the specified store) */
  function lengthPort_speeds(IStore _store, bytes32 port_id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    uint256 _byteLength = _store.getFieldLength(_tableId, _keyTuple, 2, getSchema());
    return _byteLength / 32;
  }

  /** Get an item of port_speeds (unchecked, returns invalid data if index overflows) */
  function getItemPort_speeds(bytes32 port_id, uint256 _index) internal view returns (int256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = StoreSwitch.getFieldSlice(_tableId, _keyTuple, 2, getSchema(), _index * 32, (_index + 1) * 32);
    return (int256(uint256(Bytes.slice32(_blob, 0))));
  }

  /** Get an item of port_speeds (using the specified store) (unchecked, returns invalid data if index overflows) */
  function getItemPort_speeds(IStore _store, bytes32 port_id, uint256 _index) internal view returns (int256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = _store.getFieldSlice(_tableId, _keyTuple, 2, getSchema(), _index * 32, (_index + 1) * 32);
    return (int256(uint256(Bytes.slice32(_blob, 0))));
  }

  /** Push an element to port_speeds */
  function pushPort_speeds(bytes32 port_id, int256 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.pushToField(_tableId, _keyTuple, 2, abi.encodePacked((_element)));
  }

  /** Push an element to port_speeds (using the specified store) */
  function pushPort_speeds(IStore _store, bytes32 port_id, int256 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.pushToField(_tableId, _keyTuple, 2, abi.encodePacked((_element)));
  }

  /** Pop an element from port_speeds */
  function popPort_speeds(bytes32 port_id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.popFromField(_tableId, _keyTuple, 2, 32);
  }

  /** Pop an element from port_speeds (using the specified store) */
  function popPort_speeds(IStore _store, bytes32 port_id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.popFromField(_tableId, _keyTuple, 2, 32);
  }

  /** Update an element of port_speeds at `_index` */
  function updatePort_speeds(bytes32 port_id, uint256 _index, int256 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.updateInField(_tableId, _keyTuple, 2, _index * 32, abi.encodePacked((_element)));
  }

  /** Update an element of port_speeds (using the specified store) at `_index` */
  function updatePort_speeds(IStore _store, bytes32 port_id, uint256 _index, int256 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.updateInField(_tableId, _keyTuple, 2, _index * 32, abi.encodePacked((_element)));
  }

  /** Get port_name */
  function getPort_name(bytes32 port_id) internal view returns (string memory port_name) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 3);
    return (string(_blob));
  }

  /** Get port_name (using the specified store) */
  function getPort_name(IStore _store, bytes32 port_id) internal view returns (string memory port_name) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 3);
    return (string(_blob));
  }

  /** Set port_name */
  function setPort_name(bytes32 port_id, string memory port_name) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.setField(_tableId, _keyTuple, 3, bytes((port_name)));
  }

  /** Set port_name (using the specified store) */
  function setPort_name(IStore _store, bytes32 port_id, string memory port_name) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.setField(_tableId, _keyTuple, 3, bytes((port_name)));
  }

  /** Get the length of port_name */
  function lengthPort_name(bytes32 port_id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    uint256 _byteLength = StoreSwitch.getFieldLength(_tableId, _keyTuple, 3, getSchema());
    return _byteLength / 1;
  }

  /** Get the length of port_name (using the specified store) */
  function lengthPort_name(IStore _store, bytes32 port_id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    uint256 _byteLength = _store.getFieldLength(_tableId, _keyTuple, 3, getSchema());
    return _byteLength / 1;
  }

  /** Get an item of port_name (unchecked, returns invalid data if index overflows) */
  function getItemPort_name(bytes32 port_id, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = StoreSwitch.getFieldSlice(_tableId, _keyTuple, 3, getSchema(), _index * 1, (_index + 1) * 1);
    return (string(_blob));
  }

  /** Get an item of port_name (using the specified store) (unchecked, returns invalid data if index overflows) */
  function getItemPort_name(IStore _store, bytes32 port_id, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = _store.getFieldSlice(_tableId, _keyTuple, 3, getSchema(), _index * 1, (_index + 1) * 1);
    return (string(_blob));
  }

  /** Push a slice to port_name */
  function pushPort_name(bytes32 port_id, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.pushToField(_tableId, _keyTuple, 3, bytes((_slice)));
  }

  /** Push a slice to port_name (using the specified store) */
  function pushPort_name(IStore _store, bytes32 port_id, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.pushToField(_tableId, _keyTuple, 3, bytes((_slice)));
  }

  /** Pop a slice from port_name */
  function popPort_name(bytes32 port_id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.popFromField(_tableId, _keyTuple, 3, 1);
  }

  /** Pop a slice from port_name (using the specified store) */
  function popPort_name(IStore _store, bytes32 port_id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.popFromField(_tableId, _keyTuple, 3, 1);
  }

  /** Update a slice of port_name at `_index` */
  function updatePort_name(bytes32 port_id, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.updateInField(_tableId, _keyTuple, 3, _index * 1, bytes((_slice)));
  }

  /** Update a slice of port_name (using the specified store) at `_index` */
  function updatePort_name(IStore _store, bytes32 port_id, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.updateInField(_tableId, _keyTuple, 3, _index * 1, bytes((_slice)));
  }

  /** Get the full data */
  function get(bytes32 port_id) internal view returns (PortsData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = StoreSwitch.getRecord(_tableId, _keyTuple, getSchema());
    return decode(_blob);
  }

  /** Get the full data (using the specified store) */
  function get(IStore _store, bytes32 port_id) internal view returns (PortsData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    bytes memory _blob = _store.getRecord(_tableId, _keyTuple, getSchema());
    return decode(_blob);
  }

  /** Set the full data using individual values */
  function set(
    bytes32 port_id,
    address port_owner,
    uint256 last_updated,
    int256[5] memory port_speeds,
    string memory port_name
  ) internal {
    bytes memory _data = encode(port_owner, last_updated, port_speeds, port_name);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.setRecord(_tableId, _keyTuple, _data);
  }

  /** Set the full data using individual values (using the specified store) */
  function set(
    IStore _store,
    bytes32 port_id,
    address port_owner,
    uint256 last_updated,
    int256[5] memory port_speeds,
    string memory port_name
  ) internal {
    bytes memory _data = encode(port_owner, last_updated, port_speeds, port_name);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.setRecord(_tableId, _keyTuple, _data);
  }

  /** Set the full data using the data struct */
  function set(bytes32 port_id, PortsData memory _table) internal {
    set(port_id, _table.port_owner, _table.last_updated, _table.port_speeds, _table.port_name);
  }

  /** Set the full data using the data struct (using the specified store) */
  function set(IStore _store, bytes32 port_id, PortsData memory _table) internal {
    set(_store, port_id, _table.port_owner, _table.last_updated, _table.port_speeds, _table.port_name);
  }

  /** Decode the tightly packed blob using this table's schema */
  function decode(bytes memory _blob) internal view returns (PortsData memory _table) {
    // 52 is the total byte length of static data
    PackedCounter _encodedLengths = PackedCounter.wrap(Bytes.slice32(_blob, 52));

    _table.port_owner = (address(Bytes.slice20(_blob, 0)));

    _table.last_updated = (uint256(Bytes.slice32(_blob, 20)));

    // Store trims the blob if dynamic fields are all empty
    if (_blob.length > 52) {
      uint256 _start;
      // skip static data length + dynamic lengths word
      uint256 _end = 84;

      _start = _end;
      _end += _encodedLengths.atIndex(0);
      _table.port_speeds = toStaticArray_int256_5(SliceLib.getSubslice(_blob, _start, _end).decodeArray_int256());

      _start = _end;
      _end += _encodedLengths.atIndex(1);
      _table.port_name = (string(SliceLib.getSubslice(_blob, _start, _end).toBytes()));
    }
  }

  /** Tightly pack full data using this table's schema */
  function encode(
    address port_owner,
    uint256 last_updated,
    int256[5] memory port_speeds,
    string memory port_name
  ) internal view returns (bytes memory) {
    uint40[] memory _counters = new uint40[](2);
    _counters[0] = uint40(port_speeds.length * 32);
    _counters[1] = uint40(bytes(port_name).length);
    PackedCounter _encodedLengths = PackedCounterLib.pack(_counters);

    return
      abi.encodePacked(
        port_owner,
        last_updated,
        _encodedLengths.unwrap(),
        EncodeArray.encode(fromStaticArray_int256_5(port_speeds)),
        bytes((port_name))
      );
  }

  /** Encode keys as a bytes32 array using this table's schema */
  function encodeKeyTuple(bytes32 port_id) internal pure returns (bytes32[] memory _keyTuple) {
    _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));
  }

  /* Delete all data for given keys */
  function deleteRecord(bytes32 port_id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /* Delete all data for given keys (using the specified store) */
  function deleteRecord(IStore _store, bytes32 port_id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((port_id));

    _store.deleteRecord(_tableId, _keyTuple);
  }
}

function toStaticArray_int256_5(int256[] memory _value) pure returns (int256[5] memory _result) {
  // in memory static arrays are just dynamic arrays without the length byte
  assembly {
    _result := add(_value, 0x20)
  }
}

function fromStaticArray_int256_5(int256[5] memory _value) view returns (int256[] memory _result) {
  _result = new int256[](5);
  uint256 fromPointer;
  uint256 toPointer;
  assembly {
    fromPointer := _value
    toPointer := add(_result, 0x20)
  }
  Memory.copy(fromPointer, toPointer, 160);
}
