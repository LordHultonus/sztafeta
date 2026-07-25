// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Sztafeta - an onchain relay baton
/// @notice Anyone can create a baton. Only its current holder can pass it on.
///         Every handoff is stamped onchain, forming a public chain of custody.
contract Sztafeta {
    /// @notice A single handoff: who gave the baton, to whom, and when.
    struct Handoff {
        address from;
        address to;
        uint256 at;
    }

    /// @notice A baton and its current state.
    struct Baton {
        string name;
        address creator;
        address holder;
        uint256 createdAt;
    }

    /// @notice All batons ever created. Position in this list is the baton id.
    Baton[] public batons;

    /// @dev batonId => full ordered list of its handoffs.
    mapping(uint256 => Handoff[]) private handoffs;

    event BatonCreated(uint256 indexed batonId, string name, address indexed creator);
    event BatonPassed(uint256 indexed batonId, address indexed from, address indexed to, uint256 at);

    /// @notice Create a new baton. The creator becomes its first holder.
    /// @return batonId The id of the freshly created baton.
    function createBaton(string calldata name) external returns (uint256 batonId) {
        batonId = batons.length;

        batons.push(
            Baton({name: name, creator: msg.sender, holder: msg.sender, createdAt: block.timestamp})
        );

        emit BatonCreated(batonId, name, msg.sender);
    }

    /// @notice Pass a baton you currently hold to someone else.
    function pass(uint256 batonId, address to) external {
        require(batonId < batons.length, "no such baton");

        Baton storage baton = batons[batonId];

        require(msg.sender == baton.holder, "you do not hold this baton");
        require(to != address(0), "zero address");
        require(to != msg.sender, "cannot pass to yourself");

        baton.holder = to;

        handoffs[batonId].push(Handoff({from: msg.sender, to: to, at: block.timestamp}));

        emit BatonPassed(batonId, msg.sender, to, block.timestamp);
    }

    /// @notice How many batons exist.
    function totalBatons() external view returns (uint256) {
        return batons.length;
    }

    /// @notice How many times a baton has changed hands.
    function chainLength(uint256 batonId) external view returns (uint256) {
        return handoffs[batonId].length;
    }

    /// @notice The full chain of custody of a baton, oldest handoff first.
    function getChain(uint256 batonId) external view returns (Handoff[] memory) {
        return handoffs[batonId];
    }
}
