// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";


interface ILevel {
  function createInstance(address _player) external payable returns (address);
  function validateInstance(address payable _instance, address _player) external returns (bool);
}

interface IEthernaut {

  // mapping(address => bool) registeredLevels;

  function registerLevel(ILevel _level) external;

  struct EmittedInstanceData {
    address player;
    ILevel level;
    bool completed;
  }

  // mapping(address => EmittedInstanceData) emittedInstances;

  event LevelInstanceCreatedLog(address indexed player, address instance);
  event LevelCompletedLog(address indexed player, ILevel level);

  function createLevelInstance(ILevel _level) external payable;
  function submitLevelInstance(address payable _instance) external;
}

library LevelUtils  {

  IEthernaut public constant ethernaut = IEthernaut(0xD991431D8b033ddCb84dAD257f4821E9d5b38C33);

  function createChallenge(Vm vm, address level) external returns (address) {
    vm.recordLogs();
    ethernaut.createLevelInstance{value: msg.value}(ILevel(level));
    Vm.Log[] memory logs = vm.getRecordedLogs();
    for (uint256 i; i < logs.length; i++) {
      Vm.Log memory log = logs[i];
      if (keccak256("LevelInstanceCreatedLog(address,address)") == log.topics[0]) {
        return abi.decode(log.data, (address));
      }
    }
    return address(0); // failed
  }

  function isSolved(Vm vm, address payable instance, address payable level) external returns (bool) {
    vm.recordLogs();
    ethernaut.submitLevelInstance(instance);
    Vm.Log[] memory logs = vm.getRecordedLogs();
    bool solved = false;
    for (uint256 i; i < logs.length; i++) {
      Vm.Log memory log = logs[i];
      if (keccak256("LevelCompletedLog(address,address)") == log.topics[0]) {
        bytes memory instanceBytes = abi.encodePacked(log.topics[1]);
        if (abi.decode(instanceBytes,(address)) == address(this) &&
            abi.decode(log.data,(address)) == level) {
          solved = true;
        }
      }
    }
    return solved;
  }

}