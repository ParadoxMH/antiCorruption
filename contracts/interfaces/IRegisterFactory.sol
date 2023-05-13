// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9;

interface IRegisterFactory {
    function createRegister(address managerAddr, address managerStorage) external payable returns (address);
}