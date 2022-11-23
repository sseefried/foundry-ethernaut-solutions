// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./Utils.sol";
import "../src/Fallback.sol";

contract CoinflipSolution is Test {
    using LevelUtils for Vm;

    Fallback public challenge;
    // Get the level address from the web console
    address payable level = payable(0x80934BE6B8B872B364b470Ca30EaAd8AEAC4f63F);

    function setUp() public {
       vm.deal(address(this), 1 ether);
       challenge = Fallback(vm.createChallenge(level));
       vm.label(address(challenge), "Challenge Instance");
    }

    function testIsSolved() public {
        // Write your solution here

        require(vm.isSolved(payable(address(challenge)), level), "Level not solved");
    }

}
