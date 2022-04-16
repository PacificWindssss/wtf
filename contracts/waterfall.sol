// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
 
import "https://github.com/0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";

contract waterfall {

    address outAccount;
    uint256 amount;
    mapping(address => uint256) private buyerMap;
    struct Buyer {
        address add;
        uint256 sum;
    }
    Buyer[] buyerArr;
    uint256 index = 0;

    constructor(address _outAccount, uint256 _amount) {
        outAccount = _outAccount;
        amount = _amount;
    }

    function transfer(uint256 _amount, address _recommendAdd) external payable {
        address _to = msg.sender;
        require(_amount >= amount, "amt should rather than 0.1BNB!");
        require(msg.value >= amount, "no enough amt!");
        if (buyerMap[_to] == 0) {
            buyerMap[_to] = _amount;
        } else {
            buyerMap[_to] = buyerMap[_to] + _amount;
        }
        
        Buyer storage buyer = buyerArr[index];
        buyer.add = _to;
        buyer.sum = _amount;
        index++;
        if (buyerMap[_recommendAdd] > 0) {
            uint256 amt1 = msg.value * 19 / 20;
            uint256 amt2 = msg.value / 20;
            payable(outAccount).transfer(amt1);
            payable(_recommendAdd).transfer(amt2);
        } else {
            payable(outAccount).transfer(msg.value);
        }
    }

    function isBought(address _address) external view returns (bool) {
        if (buyerMap[_address] > 0) {
            return true;
        } else {
            return false;
        }
    }

    function getBuyerArr() external view returns (Buyer[] memory) {
        return buyerArr;
    }
}
