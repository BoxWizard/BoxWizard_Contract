// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import './Token.sol';
import { RandomBox } from "./RandomBox.sol";

contract CreateRandomBox {
    // Token token;

    struct RandomBoxInfo {
        address msgSender;
        RandomBox randomBoxAddress;
    }

    RandomBoxInfo[] public randomBoxInfoArray;

    function getRandomBox() public {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender)));
        uint256 index = (randomNumber % 1000000) + 1; // random number 1 ~ 1,000,000

        uint16 boxGrade;
        address owner = msg.sender;

        if (index <= 9) {                // 1 -> 0.0001%
            boxGrade = 1;
        } else if (index <= 1000) {
            boxGrade = 2;
        } else if (index <= 20000) {
            boxGrade = 3;
        } else if (index <= 100000) {
            boxGrade = 4;
        } else if (index <= 500000) {
            boxGrade = 5;
        } else {
            boxGrade = 6;
        }

        require(boxGrade != 0, "This is the wrong box!");
        RandomBox newRandomBox = new RandomBox(boxGrade, owner);
        randomBoxInfoArray.push(RandomBoxInfo(owner, newRandomBox));
    }

    function getMyRandomBox(address _myAddress) view public returns(RandomBox[] memory) {
        uint256 j = 0;
        uint256 k = 0;

        for (uint256 i = 0; i < randomBoxInfoArray.length; i++){
            if(randomBoxInfoArray[i].msgSender == _myAddress){
                j++;
            }
        }

        RandomBox[] memory myRandomBox = new RandomBox[](j);
        for (uint256 i = 0; i < randomBoxInfoArray.length; i++){
            if(randomBoxInfoArray[i].msgSender == _myAddress){
                myRandomBox[k] = randomBoxInfoArray[i].randomBoxAddress;
                k++;
            }
        }

        return myRandomBox;
    }
}
