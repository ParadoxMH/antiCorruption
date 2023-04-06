// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9;

interface IManager {
    function MANAGER_ROLE() external returns (bytes32);
    function DONATOR_ROLE() external returns (bytes32);
    function VENDOR_ROLE() external returns (bytes32);
    function VIEWER_ROLE() external returns (bytes32);

    function addManager(address account) external;
    function removeManager(address account) external;
    function addDonator(address account) external;
    function removeDonator(address account) external;
    function addVendor(address account) external;
    function removeVendor(address account) external;
    function addViewer(address account) external;
    function removeViewer(address account) external;
    function createRegister(address[] calldata managers, address[] calldata vendors, 
        address[] calldata donators, address[] calldata viewiers) external payable;
    function hasRole(bytes32 role, address account) external view returns (bool);
}