
contract Project {

    struct Asset {
        address owner;
        string metadataURI;
        uint256 timestamp;
    }

    mapping(bytes32 => Asset) private assets;
    bytes32[] private assetList;

    event AssetRegistered(bytes32 indexed assetId, address indexed owner, string metadataURI, uint256 timestamp);
    event OwnershipTransferred(bytes32 indexed assetId, address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Automatically registers a new asset.
     * The asset ID is auto-generated from the sender address and timestamp.
     * @param metadataURI Optional metadata URI; can be an empty string.
     */
    function registerAsset(string calldata metadataURI) external {
        bytes32 assetId = keccak256(abi.encodePacked(msg.sender, block.timestamp, block.number));

        require(assets[assetId].timestamp == 0, "Asset already exists");

        string memory finalURI = bytes(metadataURI).length > 0
            ? metadataURI
            : string(abi.encodePacked("chainlattice://auto/", toHexString(assetId)));

        assets[assetId] = Asset(msg.sender, finalURI, block.timestamp);
        assetList.push(assetId);

        emit AssetRegistered(assetId, msg.sender, finalURI, block.timestamp);
    }

    /**
     * @dev Transfers ownership of an asset to a new address.
     * @param assetId ID of the asset to transfer.
     * @param newOwner Address of the new owner.
     */
    function transferOwnership(bytes32 assetId, address newOwner) external {
        require(assets[assetId].timestamp != 0, "Asset not found");
        require(assets[assetId].owner == msg.sender, "Only owner can transfer");

        address previousOwner = assets[assetId].owner;
        assets[assetId].owner = newOwner;

        emit OwnershipTransferred(assetId, previousOwner, newOwner);
    }

    /**
     * @dev Fetch details of an asset by ID.
     * @param assetId Asset hash to query.
     * @return owner Owner address.
     * @return metadataURI Metadata link.
     * @return timestamp Registration timestamp.
     */
    function getAsset(bytes32 assetId)
        external
        view
        returns (address owner, string memory metadataURI, uint256 timestamp)
    {
        Asset memory asset = assets[assetId];
        require(asset.timestamp != 0, "Asset not found");
        return (asset.owner, asset.metadataURI, asset.timestamp);
    }

    /**
     * @dev Returns the total number of registered assets.
     */
    function getTotalAssets() external view returns (uint256) {
        return assetList.length;
    }

    /**
     * @dev Converts bytes32 to a hexadecimal string (for auto-generated URI).
     */
    function toHexString(bytes32 data) internal pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes memory str = new bytes(64);
        for (uint256 i = 0; i < 32; i++) {
            str[i * 2] = hexChars[uint8(data[i] >> 4)];
            str[1 + i * 2] = hexChars[uint8(data[i] & 0x0f)];
        }
        return string(str);
    }
}
// 
Updated on 2025-11-19
// 
