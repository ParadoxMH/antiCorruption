// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Register.sol";
import "./interfaces/IManager.sol";

contract Manager is ERC165, AccessControl, IManager {
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant DONATOR_ROLE = keccak256("DONATOR_ROLE");
    bytes32 public constant VENDOR_ROLE = keccak256("VENDOR_ROLE");
    bytes32 public constant VIEWER_ROLE = keccak256("VIEWER_ROLE");

    Register[] public registers;

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        addManager(msg.sender);
        _setRoleAdmin(DONATOR_ROLE, MANAGER_ROLE);
        _setRoleAdmin(VENDOR_ROLE, MANAGER_ROLE);
        _setRoleAdmin(VIEWER_ROLE, MANAGER_ROLE);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC165) returns (bool) {
        return ERC165.supportsInterface(interfaceId) || AccessControl.supportsInterface(interfaceId) || interfaceId == type(IManager).interfaceId;
    }
    
    function hasRole(bytes32 role, address account) public view override(AccessControl, IManager) returns (bool) {
        return AccessControl.hasRole(role, account);
    }

    /// @dev Add an account to the manager role. Restricted to admins.
    function addManager(address account) public virtual onlyRole(DEFAULT_ADMIN_ROLE)
    {
        grantRole(MANAGER_ROLE, account);
    }
    /// @dev Remove an account from the manager role. Restricted to admins.
    function removeManager(address account) public virtual onlyRole(DEFAULT_ADMIN_ROLE)
    {
        revokeRole(MANAGER_ROLE, account);
    }
    
    /// @dev Add an account to the Donator role. Restricted to managers.
    function addDonator(address account) public virtual onlyRole(MANAGER_ROLE)
    {
        grantRole(DONATOR_ROLE, account);
    }
    /// @dev Remove an account from the Donator role. Restricted to managers.
    function removeDonator(address account) public virtual onlyRole(MANAGER_ROLE)
    {
        revokeRole(DONATOR_ROLE, account);
    }
    
    /// @dev Add an account to the Vendor role. Restricted to managers.
    function addVendor(address account) public virtual onlyRole(MANAGER_ROLE)
    {
        grantRole(VENDOR_ROLE, account);
    }
    /// @dev Remove an account from the Vendor role. Restricted to managers.
    function removeVendor(address account) public virtual onlyRole(MANAGER_ROLE)
    {
        revokeRole(VENDOR_ROLE, account);
    }
    
    /// @dev Add an account to the Viewer role. Restricted to managers.
    function addViewer(address account) public virtual onlyRole(MANAGER_ROLE)
    {
        grantRole(VIEWER_ROLE, account);
    }
    /// @dev Remove an account from the Viewer role. Restricted to managers.
    function removeViewer(address account) public virtual onlyRole(MANAGER_ROLE)
    {
        revokeRole(VIEWER_ROLE, account);
    }
    
    function createRegister(address[] calldata managers, address[] calldata vendors, address[] calldata donators, address[] calldata viewiers) public payable onlyRole(DEFAULT_ADMIN_ROLE)
    {
        Register register = new Register{value: 111}(address(this));
        registers.push(register);

        if(managers.length > 0){
            for (uint i = 0; i < managers.length; i++) {
                addManager(managers[i]);
            }   
        }
        if(managers.length > 0){
            for (uint i = 0; i < vendors.length; i++) {
                addVendor(vendors[i]);
            }
        }
        if(managers.length > 0){ 
            for (uint i = 0; i < donators.length; i++) {
                addDonator(donators[i]);
            }
        }
        if(managers.length > 0){
            for (uint i = 0; i < viewiers.length; i++) {
                addViewer(viewiers[i]);
            } 
        }
    }
}