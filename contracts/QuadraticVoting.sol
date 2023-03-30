pragma solidity ^0.8.0;

interface IToken {
    function balanceOf(address account) external view returns (uint256);
}

contract QuadraticVoting {
    struct Vote {
        uint256 weight;
        bool voted;
    }

    IToken public token;
    mapping(address => Vote) public votes;
    uint256 public totalVotes;

    event Voted(address indexed voter, uint256 weight);

    constructor(address tokenAddress) {
        token = IToken(tokenAddress);
    }

    function vote(uint256 weight) public {
        require(weight > 0, "Weight must be greater than zero");
        require(votes[msg.sender].weight + weight <= token.balanceOf(msg.sender), "Insufficient token balance");

        votes[msg.sender].weight += weight;
        if (!votes[msg.sender].voted) {
            votes[msg.sender].voted = true;
        }

        totalVotes += weight;

        emit Voted(msg.sender, weight);
    }

    function getVoteWeight(address voter) public view returns (uint256) {
        return votes[voter].weight;
    }

    function getRemainingVoteWeight(address voter) public view returns (uint256) {
        uint256 balance = token.balanceOf(voter);
        uint256 usedWeight = votes[voter].weight;
        return balance > usedWeight ? balance - usedWeight : 0;
    }

    function getVoteCount() public view returns (uint256) {
        return totalVotes;
    }

    function getQuadraticVoteCount() public view returns (uint256) {
        uint256 sumOfSquares = 0;

        for (uint256 i = 0; i < totalVotes; i++) {
            address voter = address(uint160(i));
            uint256 weight = getVoteWeight(voter);
            sumOfSquares += weight * weight;
        }

        return sumOfSquares;
    }

    function getQuadraticVoteWeight(address voter) public view returns (uint256) {
        uint256 weight = getVoteWeight(voter);
        uint256 quadraticWeight = weight * weight;

        uint256 quadraticVoteCount = getQuadraticVoteCount();
        uint256 quadraticWeightedVoteCount = quadraticVoteCount + quadraticWeight;

        uint256 proportionalWeight = quadraticWeightedVoteCount != 0 ?
            (quadraticWeight * totalVotes) / quadraticWeightedVoteCount :
            0;

        return proportionalWeight;
    }
}