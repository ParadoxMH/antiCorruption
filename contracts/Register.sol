// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Manager.sol";

contract Register is Manager {

    mapping(address => bool) whitelistedDonators;

    function whitelistDonator(address _donator) public onlyRole(MANAGER_ROLE) {
        require(hasRole(DONATOR_ROLE, _donator), 'Only Donator address can be whitelisted.');
        whitelistedDonators[_donator] = true;
    }

    function whitelistDonators(address[] calldata _donators) external onlyRole(MANAGER_ROLE) {
        for (uint i = 0; i < _donators.length; i++) {
            whitelistDonator(_donators[i]);
        }
    }
}