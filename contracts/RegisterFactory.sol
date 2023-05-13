// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Register.sol";
import "./interfaces/IRegisterFactory.sol";
import "hardhat/console.sol";

contract RegisterFactory is IRegisterFactory {

    function createRegister(address managerAddr, address managerStorage) external payable returns (address) {
        Register register = new Register{value: 111}(managerAddr, managerStorage); 
        
        return address(register);
    }
}