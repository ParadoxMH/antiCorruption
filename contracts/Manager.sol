// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Manager is ERC165, AccessControl {
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant DONATOR_ROLE = keccak256("DONATOR_ROLE");
    bytes32 public constant VENDOR_ROLE = keccak256("VENDOR_ROLE");
    bytes32 public constant VIEWER_ROLE = keccak256("VIEWER_ROLE");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleAdmin(DONATOR_ROLE, MANAGER_ROLE);
        _setRoleAdmin(VENDOR_ROLE, MANAGER_ROLE);
        _setRoleAdmin(VIEWER_ROLE, MANAGER_ROLE);
    }

    //do we readlly need this? As both ERC165 and AccessControl implements it.
    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC165) returns (bool) {
        return interfaceId == type(IERC165).interfaceId || interfaceId == type(IAccessControl).interfaceId;
    }

    /// @dev Restricted to members of the admin role.
    modifier onlyAdmin()
    {
        require(isAdmin(msg.sender), "Restricted to admins.");
        _;
    }
    /// @dev Restricted to members of the manager role.
    modifier onlyManager()
    {
        require(isManager(msg.sender), "Restricted to managers.");
        _;
    }

    /// @dev Return `true` if the account belongs to the admin role.
    function isAdmin(address account) public virtual view returns (bool)
    {
        return hasRole(DEFAULT_ADMIN_ROLE, account);
    }
    /// @dev Return `true` if the account belongs to the manager role.
    function isManager(address account) public virtual view returns (bool)
    {
        return hasRole(MANAGER_ROLE, account);
    }
    /// @dev Return `true` if the account belongs to the donator role.
    function isDonator(address account) public virtual view returns (bool)
    {
        return hasRole(DONATOR_ROLE, account);
    }
    /// @dev Return `true` if the account belongs to the vendor role.
    function isVendor(address account) public virtual view returns (bool)
    {
        return hasRole(VENDOR_ROLE, account);
    }
    /// @dev Return `true` if the account belongs to the viewer role.
    function isViewer(address account) public virtual view returns (bool)
    {
        return hasRole(VIEWER_ROLE, account);
    }

    /// @dev Add an account to the manager role. Restricted to admins.
    function addManager(address account) public virtual onlyAdmin
    {
        grantRole(MANAGER_ROLE, account);
    }
    /// @dev Remove an account from the manager role. Restricted to admins.
    function removeManager(address account) public virtual onlyAdmin
    {
        revokeRole(MANAGER_ROLE, account);
    }
    
    /// @dev Add an account to the Donator role. Restricted to managers.
    function addDonator(address account) public virtual onlyManager
    {
        grantRole(DONATOR_ROLE, account);
    }
    /// @dev Remove an account from the Donator role. Restricted to managers.
    function removeDonator(address account) public virtual onlyManager
    {
        revokeRole(DONATOR_ROLE, account);
    }
    
    /// @dev Add an account to the Vendor role. Restricted to managers.
    function addVendor(address account) public virtual onlyManager
    {
        grantRole(VENDOR_ROLE, account);
    }
    /// @dev Remove an account from the Vendor role. Restricted to managers.
    function removeVendor(address account) public virtual onlyManager
    {
        revokeRole(VENDOR_ROLE, account);
    }
    
    /// @dev Add an account to the Viewer role. Restricted to managers.
    function addViewer(address account) public virtual onlyManager
    {
        grantRole(VIEWER_ROLE, account);
    }
    /// @dev Remove an account from the Viewer role. Restricted to managers.
    function removeViewer(address account) public virtual onlyManager
    {
        revokeRole(VIEWER_ROLE, account);
    }
}