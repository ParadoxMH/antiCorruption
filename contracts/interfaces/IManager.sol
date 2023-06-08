// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9;

interface IManager {
    function addManagers(address[] memory accounts) external;
    function removeManager(address account) external;
    function addDonators(address[] memory accounts) external;
    function removeDonator(address account) external;
    function addVendors(address[] memory accounts) external;
    function removeVendor(address account) external;
    function addViewers(address[] memory accounts) external;
    function removeViewer(address account) external;
    function createRegister(address[] calldata managers, address[] calldata vendors, address[] calldata donators, address[] calldata viewiers) external payable;
    function hasRole(bytes32 role, address account) external view returns (bool);
}