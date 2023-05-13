// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Register.sol";
import "./interfaces/IManager.sol";
import "./interfaces/IManagerStorage.sol";
import "./interfaces/IRegisterFactory.sol";
import "./ManagerStorage.sol"; 

contract Manager is ERC165, AccessControl, IManager {

    IManagerStorage managerStorage;
    IRegisterFactory registerFactory;

    constructor(address _managerStorage, address _registerFactory) { 
        managerStorage = IManagerStorage(_managerStorage);
        registerFactory = IRegisterFactory(_registerFactory);

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleAdmin(managerStorage.DONATOR_ROLE(), managerStorage.MANAGER_ROLE());
        _setRoleAdmin(managerStorage.VENDOR_ROLE(), managerStorage.MANAGER_ROLE());
        _setRoleAdmin(managerStorage.VIEWER_ROLE(), managerStorage.MANAGER_ROLE());
        
        grantRole(managerStorage.MANAGER_ROLE(), msg.sender);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC165) returns (bool) {
        return ERC165.supportsInterface(interfaceId) || AccessControl.supportsInterface(interfaceId) || interfaceId == type(IManager).interfaceId;
    }
    
    function hasRole(bytes32 role, address account) public view override(AccessControl, IManager) returns (bool) {
        return AccessControl.hasRole(role, account);
    }

    function grantRoleToAccounts(bytes32 role, address[] memory accounts) private
    {
        for (uint i = 0; i < accounts.length; i++) {
            grantRole(role, accounts[i]);
        }
    }

    /// @dev Add an account to the manager role. Restricted to admins.
    function addManagers(address[] memory accounts) public virtual onlyRole(DEFAULT_ADMIN_ROLE)
    {
        grantRoleToAccounts(managerStorage.MANAGER_ROLE(), accounts);
    }
    /// @dev Remove an account from the manager role. Restricted to admins.
    function removeManager(address account) public virtual onlyRole(DEFAULT_ADMIN_ROLE)
    {
        revokeRole(managerStorage.MANAGER_ROLE(), account);
    }
    
    /// @dev Add an account to the Donator role. Restricted to managers.
    function addDonators(address[] memory accounts) public virtual onlyRole(managerStorage.MANAGER_ROLE())
    {
        grantRoleToAccounts(managerStorage.DONATOR_ROLE(), accounts);
    }
    /// @dev Remove an account from the Donator role. Restricted to managers.
    function removeDonator(address account) public virtual onlyRole(managerStorage.MANAGER_ROLE())
    {
        revokeRole(managerStorage.DONATOR_ROLE(), account);
    }
    
    /// @dev Add an account to the Vendor role. Restricted to managers.
    function addVendors(address[] memory accounts) public virtual onlyRole(managerStorage.MANAGER_ROLE())
    {
        grantRoleToAccounts(managerStorage.VENDOR_ROLE(), accounts);
    }
    /// @dev Remove an account from the Vendor role. Restricted to managers.
    function removeVendor(address account) public virtual onlyRole(managerStorage.MANAGER_ROLE())
    {
        revokeRole(managerStorage.VENDOR_ROLE(), account);
    }
    
    /// @dev Add an account to the Viewer role. Restricted to managers.
    function addViewers(address[] memory accounts) public virtual onlyRole(managerStorage.MANAGER_ROLE())
    {
        grantRoleToAccounts(managerStorage.VIEWER_ROLE(), accounts);
    }
    /// @dev Remove an account from the Viewer role. Restricted to managers.
    function removeViewer(address account) public virtual onlyRole(managerStorage.MANAGER_ROLE())
    {
        revokeRole(managerStorage.VIEWER_ROLE(), account);
    }

    function createRegister(address[] calldata managers, address[] calldata vendors, address[] calldata donators, address[] calldata viewiers) external payable {
        address register = registerFactory.createRegister{value: 111}(address(this), address(managerStorage));

        managerStorage.addRegister(register);
        addManagers(managers);
        addVendors(vendors);
        addDonators(donators);
        addViewers(viewiers);
    }
}