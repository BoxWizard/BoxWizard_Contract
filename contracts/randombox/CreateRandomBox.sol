// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Token.sol";
import "./RandomBox.sol";

contract CreateRandomBox {
    struct RandomBoxInfo {
        address owner;
        RandomBox randomBox;
    }

    mapping(address => RandomBoxInfo[]) private randomBoxInfoMap;

    // 랜덤 박스를 생성합니다.
    function getRandomBox() public {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender)));
        uint256 index = (randomNumber % 1000000) + 1; // 1 ~ 1,000,000

        uint16 boxGrade;
        address owner = msg.sender;

        if (index <= 9) {
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
        randomBoxInfoMap[owner].push(RandomBoxInfo(owner, newRandomBox));
    }

    // 특정 주소에 대한 랜덤 박스 정보를 조회합니다.
    function getMyRandomBox(address _myAddress) public view returns (RandomBox[] memory) {
        uint256 boxCount = randomBoxInfoMap[_myAddress].length;

        RandomBox[] memory myRandomBox = new RandomBox[](boxCount);
        for (uint256 i = 0; i < boxCount; i++) {
            myRandomBox[i] = randomBoxInfoMap[_myAddress][i].randomBox;
        }

        return myRandomBox;
    }
}
