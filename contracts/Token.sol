// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract lottery {
    address public manager;
    address payable[] public players;

    constructor() {
        manager = msg.sender;
    }

    modifier Owner() {
        require(msg.sender == manager, "Not Manager");
        _;
    }

    function enter() payable external {
        require(msg.value == 1 ether);
        players.push(payable(msg.sender));
    }

    function getBalance() public view Owner returns (uint256) {
        return address(this).balance;
    }

    function getPlayer() external view returns (address payable[] memory) {
        return  players; 
    }


    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.prevrandao,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }

    function pickWiner() public Owner {
        require(players.length >= 0);
        uint256 r = random();
        address payable winner;

        uint256 index = r % players.length;

        winner = players[index];

        winner.transfer(getBalance());

        players = new address payable[](0);
        
    }
}
