// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Project {

    mapping(address => bool) whitelistedVendors;
    mapping(address => bool) whitelistedViewers;

    function whitelistVendor(address _vendor) public onlyRole(MANAGER_ROLE) {
        require(hasRole(VENDOR_ROLE, _vendor), 'Only Vendor address can be whitelisted.');
        whitelistedDonators[_vendor] = true;
    }

    function whitelistVendors(address[] calldata _vendors) external onlyRole(MANAGER_ROLE) {
        for (uint i = 0; i < _vendors.length; i++) {
            whitelistVendor(_vendors[i]);
        }
    }

    function whitelistViewer(address _viewer) public onlyRole(MANAGER_ROLE) {
        require(hasRole(VIEWER_ROLE, _viewer), 'Only Viewer address can be whitelisted.');
        whitelistedDonators[_viewer] = true;
    }

    function whitelistViewers(address[] calldata _viewers) external onlyRole(MANAGER_ROLE) {
        for (uint i = 0; i < _viewers.length; i++) {
            whitelistViewer(_viewers[i]);
        }
    }
}