// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./ManagerAdapter.sol";
import "./Project.sol";
import "./RegisterStorage.sol";

contract Register is RegisterStorage, Ownable, ManagerAdapter { 

    constructor(address _manager, address _managerStorage) ManagerAdapter(_manager, _managerStorage) payable {
    }

    function whitelistDonator(address _donator) public onlyRole(managerStorage().MANAGER_ROLE()) {
        require(_donator != address(0), "Invalid address provided");
        require(!whitelistedDonators[_donator], "Address already whitelisted");
        require(manager().hasRole(managerStorage().DONATOR_ROLE(), _donator), "Only Donator address can be whitelisted.");
        whitelistedDonators[_donator] = true;
    }

    function whitelistDonators(address[] calldata _donators) external onlyRole(managerStorage().MANAGER_ROLE()) {
        for (uint i = 0; i < _donators.length; i++) {
            whitelistDonator(_donators[i]);
        }
    }
    
    //must be DEFAULT_ADMIN_ROLE but how to access it?
    function createProject() public payable onlyRole(managerStorage().MANAGER_ROLE()) 
    {
        Project project = new Project(address(this), managerStorageAddress);
        projects.push(project);
    }
}