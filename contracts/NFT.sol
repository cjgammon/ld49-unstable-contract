// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract OldGuys is ERC721, Ownable {
  using Counters for Counters.Counter;
  using Strings for uint256;

  Counters.Counter private _tokenIds;

  // The registry
  mapping (uint256 => string) private _tokenURIs;
  mapping (address => bool) private _permissions;

  constructor() ERC721("OldGuys", "OGUY") {
    _permissions[owner()]=true;
    emit PermissionGranted(owner());
  }

  // Custom access modifiers

  modifier permittedOnly {
    if (!_permissions[msg.sender]) {
      return;
    }
    _;
  }

 // Events
 event PermissionGranted(address _addr);
 event PermissionRemoved(address _addr);

  function _setTokenURI(uint256 tokenId, string memory _tokenURI)
    internal
    virtual
  {
    _tokenURIs[tokenId] = _tokenURI;
  }

  function tokenURI(uint256 tokenId) 
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
    string memory _tokenURI = _tokenURIs[tokenId];
    return _tokenURI;
  }

// Does the caller have write permission?
  function hasPermission(address addr) public view returns(bool) {
     if (_permissions[addr])
        return true;
     else
        return false;
  } // hasPermission

  // Remove an address from the list of those with write permission
  function removePermission(address addr) external onlyOwner {
    if (!this.hasPermission(addr))
      return;
    delete _permissions[addr];
    emit PermissionRemoved(addr);
  } // removePermission


  // Add an address to the list of those with write permission
  function grantPermission(address addr) external onlyOwner {
    if (this.hasPermission(addr))
      return;
    _permissions[addr] = true;
    emit PermissionGranted(addr);
  } // grantPermission


// Minting
  function mint(address recipient, string memory uri)
    external permittedOnly
    returns (uint256 itemId)
  {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _mint(recipient, newItemId);
    _setTokenURI(newItemId, uri);
    return newItemId;
  }

  function mintMultiple(address[] memory recipient, string[] memory uri) 
    external permittedOnly 
    returns (bool success) 
  {
    for (uint i = 0; i < recipient.length; i++) {
      _tokenIds.increment();
      uint256 newItemId = _tokenIds.current();
      _mint(recipient[i], newItemId);
      _setTokenURI(newItemId, uri[i]);
    }
    return true;
  }
}