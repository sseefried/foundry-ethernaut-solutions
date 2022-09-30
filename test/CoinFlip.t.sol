// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "forge-std/Test.sol";
import "./Utils.sol";
import "../src/CoinFlip.sol";

contract CoinflipSolution is Test {
    using LevelUtils for Vm;

    CoinFlip public coinflip;
    address payable level = 0x4dF32584890A0026e56f7535d0f2C6486753624f;

    function setUp() public {
       vm.deal(address(this), 1 ether);
       coinflip = CoinFlip(vm.createChallenge(level));
       vm.label(address(coinflip), "CoinFlip Instance");
    }

    function testIsSolved() public {
        // Write your solution here

        // Remember to use "vm.roll(block.number + 1)" to simulate mining of block

        assertTrue(vm.isSolved(payable(address(coinflip)), level), "Level not solved");
    }

}
