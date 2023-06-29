// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ChainLinkBoxWizard.sol";

contract FurnitureBox is ChainLinkBoxWizard {
    constructor(uint64 subscriptionId) ChainLinkBoxWizard(subscriptionId) {}

    function getProductName(uint256 id) internal pure override returns (string memory) {
        string[6] memory furnitureNames = [
            "Supreme Luxury Edition",
            "Exquisite Opulence",
            "Luxury Living",
            "Classic Elegance",
            "Affordable Comfort",
            "Simplicity Collection"
        ];

        return furnitureNames[id - 1];
    }
}