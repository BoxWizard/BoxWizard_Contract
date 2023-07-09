// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract RandomBox {
    address public owner;
    uint256 public boxGrade; // Box 등급
    uint256 public boxNumber = 0; // 당첨 상품 Number

    mapping(uint256 => string[]) private boxItemNames;

    constructor(uint16 _grade, address _owner) {
        require(_grade > 0 && _grade <= 6, "Invalid box grade");

        owner = _owner;
        boxGrade = _grade;

        initializeBoxItemNames();
    }

    function initializeBoxItemNames() private {
        boxItemNames[1] = [
            "[LG] Complete Home Appliance Set Package (Master)",
            "[Samsung] Complete Home Appliance Set Package (Master)",
            "[LG] Signature Ice Water Dispenser Refrigerator J842ND79",
            "[Samsung] Neo QLED 8K 189cm Infinite Screen KQ75QNB900FXKR + 3.1.2 Channel Soundbar Q600B HW-Q600B/KR",
            "[LG] OLED evo TV (Stand Type) OLED83C3KNA"
        ];
        boxItemNames[2] = [
            "[Zacomo] Bellas 6-Person Corner Functional Vichyino Full Natural Fabric Leather Sofa (Full Leather) + 2 Headrests",
            "[Samsung] Samsung MX Package (Master) (Random Color)",
            "[Simmons] Beautyrest Edison California King",
            "[LG] Clothing Care Package (Master) (Random Color)",
            "[MUUTO] Muuto Outline Refine Leather 2 Seater Cognac Sofa",
            "[TECHNOGYM] Technogym Ride (TECHNOGYM RIDE)"
        ];
        boxItemNames[3] = [
            "[Samsung] Design TV The Serif KQ65LSB01AFXKR",
            "[Samsung] Air Conditioner Q9000 Clean",
            "[Apple] Apple Studio Display (Standard Glass - Adjustable Stand)",
            "[Apple] Apple iMac 24 M1 (8-core CPU, 8-core GPU, 256GB SSD) (Random Color)",
            "HumanScale Freedom Headrest Fabric Chair",
            "[Samsung] Galaxy Book 3 360 33.7cm NT730QFT-A51A 256GB (Random Color)"
        ];
        boxItemNames[4] = [
            "Coco Jelly Snowman Circulator TS-17-E",
            "Kipel Baro Plating IH Frypan 5PCS(B)",
            "Shepherd Chaleur Bread Maker JSK-22013",
            "Cat Collection Air Factory Air Purifier",
            "Bastian Blenzz A2 Air Fryer 7.7L Gold & Black",
            "Lotte Stainless Multi Pressure Cooker 6L LT-EPC1"
        ];
        boxItemNames[5] = [
            "Fontiac Test Metal Carry-on Luggage for Travel, 20 inches",
            "Elle Mienne 2-Person Tableware Set, 27-piece Home Set",
            "Painamil Wireless One-Touch Electric Grinder + Additional Pods 2pcs",
            "Lien Cook Nordic Plus IH Pot Set, 4 Types (16cm Soup Pot, 20cm Stew Pot, 24cm Casserole, 24cm Stockpot)",
            "Silverstar OIC End Grain Camphor Wood Cutting Board, Square",
            "Murray Owl Bluetooth Wireless Dual Microphone Karaoke S-Bird + Party Mirror Ball Gift"
        ];
        boxItemNames[6] = [
            "Neebot QoBox Total Care Sterilizer JSK-21087",
            "Hankyeonghee Steam Cleaner HESM-D1300WT",
            "NordiCook Black Swan Air Fryer 9L NRAF-9000B",
            "Neebot Smart Cube Ultrasonic Cleaner JSK-20019",
            "Jennifer Room WhiteOn Steam Oven Toaster JR-OT9650WH",
            "Shepherd Comfortable Wireless Neck and Shoulder Massager"
        ];
    }

    function openBox() public onlyOwner returns (uint256) {
        require(boxNumber == 0, "You used a box");

        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender)));
        uint256 index = (randomNumber % boxItemNames[boxGrade].length) + 1;

        boxNumber = index;
        return index;
    }

    function getBoxName() public view returns (string memory) {
        require(boxGrade != 0, "This is the wrong box");
        require(boxNumber != 0, "This is an unopened box");

        return boxItemNames[boxGrade][boxNumber - 1];
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Sender is not owner");
        _;
    }
}
