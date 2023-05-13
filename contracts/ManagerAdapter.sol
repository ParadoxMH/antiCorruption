// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./interfaces/IManager.sol";
import "./interfaces/IManagerStorage.sol";

abstract contract ManagerAdapter { //or ManagerWrapper?

    address managerAddress;
    address managerStorageAddress;

    constructor (address _manager, address _managerStorage)  {
        managerAddress = _manager;
        managerStorageAddress = _managerStorage;
    }
    
    // do we need this func? then we'll need to `is Ownable` here
    // function setManagerAddress(address _addr) public onlyOwner {
    //     manager = Manager(_addr);
    // }

    function manager() internal view returns (IManager) {
        return IManager(managerAddress);
    }
    function managerStorage() internal view returns (IManagerStorage) {
        return IManagerStorage(managerStorageAddress);
    }
    
    modifier onlyRole(bytes32 role) {
        _checkRole(role, tx.origin);
        _;
    }

    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!manager().hasRole(role, account)) {
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
}