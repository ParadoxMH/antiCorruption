// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Project.sol";

contract RegisterStorage {
    
    mapping(address => bool) public whitelistedDonators;
    Project[] public projects;
}