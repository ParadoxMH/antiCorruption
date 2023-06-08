// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Project.sol";

contract ManagerStorage is IManagerStorage{
    
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant DONATOR_ROLE = keccak256("DONATOR_ROLE");
    bytes32 public constant VENDOR_ROLE = keccak256("VENDOR_ROLE");
    bytes32 public constant VIEWER_ROLE = keccak256("VIEWER_ROLE");

    address[] public registers;

    function addRegister(address register) external {
        registers.push(address(register));
    }
}