// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Manager.sol";
import "./ManagerAdapter.sol";

contract Project is ERC1155, Ownable, ManagerAdapter {

    mapping(address => bool) whitelistedVendors;
    mapping(address => bool) whitelistedViewers;
    mapping(uint => string) private _uris;  //unique uri for each new nft
    uint private mintCount = 0;

    constructor(address _manager, address _managerStorage) 
        ManagerAdapter(_manager, _managerStorage) 
        ERC1155("") {
    }
    
    function addAtachment(string memory _uri) public //onlyOwner
    {
        _mint(address(this), mintCount++, 1, "");
        setTokenUri(mintCount++, _uri);
    }
    
    function setTokenUri(uint _tokenId, string memory _uri) private {
        require(bytes(_uris[_tokenId]).length == 0, "Cannot set uri twice.");
        _uris[_tokenId] = _uri;
    }
    
    function uri(uint256 _tokenId) override public view returns (string memory) {
        return _uris[_tokenId];
    }


    function whitelistVendors(address[] calldata _vendors) external onlyRole(managerStorage().MANAGER_ROLE()) {
        for (uint i = 0; i < _vendors.length; i++) {
            whitelistVendor(_vendors[i]);
        } 
    }

    function whitelistViewers(address[] calldata _viewers) external onlyRole(managerStorage().MANAGER_ROLE()) {
        for (uint i = 0; i < _viewers.length; i++) {
            whitelistViewer(_viewers[i]);
        }
    }

    function whitelistViewer(address _viewer) internal {
        require(_viewer != address(0), "Invalid address provided");
        require(!whitelistedViewers[_viewer], "Address already whitelisted");
        require(manager().hasRole(managerStorage().VIEWER_ROLE(), _viewer), 'Only Viewer address can be whitelisted.');
        whitelistedViewers[_viewer] = true;
    }
    
    function whitelistVendor(address _vendor) internal {
        require(_vendor != address(0), "Invalid address provided");
        require(!whitelistedVendors[_vendor], "Address already whitelisted");
        require(manager().hasRole(managerStorage().VENDOR_ROLE(), _vendor), 'Only Vendor address can be whitelisted.');
        whitelistedVendors[_vendor] = true;
    }
}