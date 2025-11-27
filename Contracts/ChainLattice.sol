// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ChainLattice - A basic blockchain project template
/// @author
/// @notice This is a starter Solidity contract for the ChainLattice project
/// @dev Extend this contract with your project-specific logic

contract ChainLattice {
    address public owner;

    // Basic data structure for lattice-like nodes
    struct Node {
        uint256 id;
        string data;
        uint256 parentId; // could be used to link nodes
        bool exists;
    }

    mapping(uint256 => Node) public nodes;
    uint256 public nodeCount;

    // Events
    event NodeCreated(uint256 indexed id, string data, uint256 parentId);
    event NodeUpdated(uint256 indexed id, string data);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier nodeExists(uint256 _id) {
        require(nodes[_id].exists, "Node does not exist");
        _;
    }

    constructor() {
        owner = msg.sender;
        nodeCount = 0;
    }

    /// @notice Create a new node in the lattice
    /// @param _data The data for the node
    /// @param _parentId The parent node ID (0 if root)
    function createNode(string memory _data, uint256 _parentId) public onlyOwner {
        nodeCount++;
        nodes[nodeCount] = Node(nodeCount, _data, _parentId, true);
        emit NodeCreated(nodeCount, _data, _parentId);
    }

    /// @notice Update the data of an existing node
    /// @param _id The node ID to update
    /// @param _data New data string
    function updateNode(uint256 _id, string memory _data) public onlyOwner nodeExists(_id) {
        nodes[_id].data = _data;
        emit NodeUpdated(_id, _data);
    }

    /// @notice Get information about a node
    /// @param _id The node ID
    /// @return Node struct
    function getNode(uint256 _id) public view nodeExists(_id) returns (Node memory) {
        return nodes[_id];
    }
}
