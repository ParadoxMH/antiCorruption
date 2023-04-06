// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Manager.sol";

contract Project is Ownable, ManagerAdapter {

    mapping(address => bool) whitelistedVendors;
    mapping(address => bool) whitelistedViewers;

    constructor(address _manager) ManagerAdapter(_manager) {
    }

    function whitelistVendor(address _vendor) public onlyRole(manager().MANAGER_ROLE()) {
        require(_vendor != address(0), "Invalid address provided");
        require(!whitelistedVendors[_vendor], "Address already whitelisted");
        require(manager().hasRole(manager().VENDOR_ROLE(), _vendor), 'Only Vendor address can be whitelisted.');
        whitelistedVendors[_vendor] = true;
    }

    function whitelistVendors(address[] calldata _vendors) external onlyRole(manager().MANAGER_ROLE()) {
        for (uint i = 0; i < _vendors.length; i++) {
            whitelistVendor(_vendors[i]);
        }
    }

    function whitelistViewer(address _viewer) public onlyRole(manager().MANAGER_ROLE()) {
        require(_viewer != address(0), "Invalid address provided");
        require(!whitelistedViewers[_viewer], "Address already whitelisted");
        require(manager.hasRole(manager().VIEWER_ROLE(), _viewer), 'Only Viewer address can be whitelisted.');
        whitelistedViewers[_viewer] = true;
    }

    function whitelistViewers(address[] calldata _viewers) external onlyRole(manager().MANAGER_ROLE()) {
        for (uint i = 0; i < _viewers.length; i++) {
            whitelistViewer(_viewers[i]);
        }
    }
}