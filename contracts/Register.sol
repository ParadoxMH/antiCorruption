// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./ManagerAdapter.sol";

contract Register is Ownable, ManagerAdapter {

    mapping(address => bool) public whitelistedDonators;

    constructor(address _manager) ManagerAdapter(_manager) payable { 
    }


    function whitelistDonator(address _donator) public onlyRole(manager().MANAGER_ROLE()) {
        require(_donator != address(0), "Invalid address provided");
        require(!whitelistedDonators[_donator], "Address already whitelisted");
        require(manager().hasRole(manager().DONATOR_ROLE(), _donator), 'Only Donator address can be whitelisted.');
        whitelistedDonators[_donator] = true;
    }

    function whitelistDonators(address[] calldata _donators) external onlyRole(manager().MANAGER_ROLE()) {
        for (uint i = 0; i < _donators.length; i++) {
            whitelistDonator(_donators[i]);
        }
    }
}