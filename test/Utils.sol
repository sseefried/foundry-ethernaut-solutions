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

  // The address here is for the Goerli Test network
  // See https://goerli.etherscan.io/address/0xD2e5e0102E55a5234379DD796b8c641cd5996Efd
  IEthernaut public constant ethernaut = IEthernaut(0xD2e5e0102E55a5234379DD796b8c641cd5996Efd);

  function createChallenge(Vm vm, address level) external returns (address) {
    vm.recordLogs();
    ethernaut.createLevelInstance{value: msg.value}(ILevel(level));
    Vm.Log[] memory logs = vm.getRecordedLogs();
    for (uint256 i; i < logs.length; i++) {
      Vm.Log memory log = logs[i];
      if (keccak256("LevelInstanceCreatedLog(address,address,address)") == log.topics[0]) {
        return address(uint256(log.topics[2]));
      }
    }
    revert("Unable to create level instance");
  }

  function isSolved(Vm vm, address payable instance, address payable level) external returns (bool) {
    vm.recordLogs();
    ethernaut.submitLevelInstance(instance);
    Vm.Log[] memory logs = vm.getRecordedLogs();
    bool solved = false;
    for (uint256 i; i < logs.length; i++) {
      Vm.Log memory log = logs[i];
      if (keccak256("LevelCompletedLog(address,address,address)") == log.topics[0]) {
        bytes memory thisBytes = abi.encode(log.topics[1]);
        bytes memory instanceBytes = abi.encode(log.topics[2]);
        bytes memory levelBytes = abi.encode(log.topics[3]);

        if (abi.decode(thisBytes,(address)) == address(this) &&
            payable(abi.decode(instanceBytes,(address))) == instance &&
            abi.decode(levelBytes,(address)) == level) {
          solved = true;
        }
      }
    }
    return solved;
  }

}