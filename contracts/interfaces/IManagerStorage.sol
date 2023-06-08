// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9;

interface IManagerStorage {
    function MANAGER_ROLE() external returns (bytes32);
    function DONATOR_ROLE() external returns (bytes32);
    function VENDOR_ROLE() external returns (bytes32);
    function VIEWER_ROLE() external returns (bytes32);

    function addRegister(address register) external;
}