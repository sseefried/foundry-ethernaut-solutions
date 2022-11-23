// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "forge-std/Test.sol";
import "./Utils.sol";
import "../src/CoinFlip.sol";

interface IHelloEthernaut {
    function password() external returns (string memory);
    function authenticate(string calldata passkey) external;
}

contract HelloEthernautSolution is Test {
    using LevelUtils for Vm;

    address payable level = 0xBA97454449c10a0F04297022646E7750b8954EE8;
    IHelloEthernaut helloEthernaut;

    function setUp() public {
       vm.deal(address(this), 1 ether);
       helloEthernaut = IHelloEthernaut(vm.createChallenge(level));
       vm.label(address(helloEthernaut), "HelloEthernaut");
    }

    function testIsSolved() public {
        helloEthernaut.authenticate(helloEthernaut.password());


        // This must be at the end of of all tests to see if level has been solved
        require(vm.isSolved(payable(address(helloEthernaut)), level), "Level not solved");
    }

}
