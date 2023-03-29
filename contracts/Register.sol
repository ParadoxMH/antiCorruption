// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Manager.sol";

contract Register is Ownable {

    mapping(address => bool) public whitelistedDonators;
    Manager manager;

    constructor(address _manager) {
        manager = Manager(_manager);
    }

    function setManagerAddress(address _addr) public onlyOwner {
        manager = Manager(_addr);
    }

    modifier onlyRole(bytes32 role) {
        _checkRole(role, msg.sender);
        _;
    }

    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!manager.hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        Strings.toHexString(account),
                        " is missing role ",
                        Strings.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }

    function whitelistDonator(address _donator) public onlyRole(manager.MANAGER_ROLE()) {
        require(_donator != address(0), "Invalid address provided");
        require(!whitelistedDonators[_donator], "Address already whitelisted");
        require(manager.hasRole(manager.DONATOR_ROLE(), _donator), 'Only Donator address can be whitelisted.');
        whitelistedDonators[_donator] = true;
    }

    function whitelistDonators(address[] calldata _donators) external onlyRole(manager.MANAGER_ROLE()) {
        for (uint i = 0; i < _donators.length; i++) {
            whitelistDonator(_donators[i]);
        }
    }
}