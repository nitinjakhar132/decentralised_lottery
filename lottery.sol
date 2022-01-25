// SPDX-License-Identifier: MIT

pragma solidity >0.6.0 <0.8.11;

contract decentralized_Lottery {
    address public owner;
    address payable[] public players;
    uint public lottery_Id;
    uint public age;
    mapping (uint => address payable) public lottery_History;

    constructor() {
        owner = msg.sender;
        lottery_Id = 1;
    }
    function age_input(uint user_age) public {
        age = user_age;
    }

    function getWinnerByLottery(uint lottery) public view returns (address payable) {
        return lottery_History[lottery];
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function enter() public payable {
        require(age >= 18);
        require(msg.value > 0.09 ether);

        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyowner {
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);

        lottery_History[lottery_Id] = players[index];
        lottery_Id++;
        
        players = new address payable[](0);
    }

    modifier onlyowner() {
      require(msg.sender == owner);
      _;
    }
}