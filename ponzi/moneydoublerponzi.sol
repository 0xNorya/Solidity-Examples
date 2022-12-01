// SPDX-License-Identifier: UNLICENSED

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

pragma solidity 0.8.12;


contract Auto2x is Ownable{
    using Strings for uint256;
    

    event Deposited(address indexed payee, uint256 weiAmount);
    uint Payingindex;
    uint index;
    address payable[] addresses;
    uint[] deposit;
    // mapping (address => uint) values;
    uint256 _Max;
    address payable devWallet;
    // address payable buyBack;
    uint256 _Thresh;
    uint256 _Tax;
    // uint256 _bTax;

    constructor(uint256 __Max, address payable _devWallet, uint256 __Thresh, uint256 __Tax) { 
      _Max = __Max * 10000000000000000;
      devWallet = _devWallet;
    //   buyBack = _buyBack;
      _Thresh = __Thresh * 10000000000000000;
      _Tax = __Tax;
    //   _bTax = __bTax;
   }

    
    receive () external payable {

        require(msg.value <= _Max);
        // values[msg.sender] = msg.value;
        devWallet.transfer(msg.value/_Tax);
        // buyBack.transfer(msg.value/_bTax);
        addresses.push(payable(msg.sender));
        deposit.push(msg.value);
        index = index+1;
        sendIndex();
        
        if(address(this).balance >= _Thresh && address(this).balance >= deposit[Payingindex]*2){
        addresses[Payingindex].transfer(deposit[Payingindex]*2);
        Payingindex = Payingindex +1;
    }
        else{}
    }
    

    function buyIn(uint256 _amount) external payable {

        uint256 amount = _amount * 10000000000000000;
        require(msg.value <= _Max);
        require(msg.value >= amount);
        devWallet.transfer(msg.value/_Tax);
        // buyBack.transfer(msg.value/_bTax);
        addresses.push(payable(msg.sender));
        deposit.push(msg.value);
        index = index+1;
        sendIndex();
    }
    
    function distribute() public onlyOwner {
        
        if(address(this).balance >= _Thresh && address(this).balance >= deposit[Payingindex]*2){
        addresses[Payingindex].transfer(deposit[Payingindex]*2);
        Payingindex +1;
    }
        else{}
    }

    function sendIndex() public payable {
        bytes memory sendPosition = abi.encode(index);
        (bool success,) = address(msg.sender).call(sendPosition);
        require(success);
    }

    //Setters
    function setMax(uint256 newMax) public onlyOwner {
        _Max = newMax * 10000000000000000;
    }

    function setTax(uint256 newTax) public onlyOwner {
        _Tax = newTax;
    }
    // function setbTax(uint256 newbTax) public onlyOwner {
    //     _bTax = newbTax;
    // }

    function setDev(address payable newDev) public onlyOwner {
        devWallet = newDev;
    }
    // function setBuy(address payable newBuy) public onlyOwner {
    //     buyBack = newBuy;
    // }

    function setThresh(uint256 newThresh) public onlyOwner {
        _Thresh = newThresh * 10000000000000000;
    }

    //Getters
    function getThresh() public view returns (uint256) {
        return (_Thresh/10000000000000000);
    }
    
    function getMax() public view returns (uint256) {
        return (_Max/10000000000000000);
    }

    function getTax() public view returns (uint256) {
        return (_Tax);
    }

    // function getbTax() public view returns (uint256) {
    //     return (_bTax);
    // }

    function getDev() public view returns (address) {
        return (devWallet);
    }
    // function getBuy() public view returns (address) {
    //     return (buyBack);
    // }

    function getpayIndex() public view returns (uint256) {
        return (Payingindex);
    }

    function getIndex() public view returns (uint256) {
        return (index);
    }

    function getSpot(uint256 _index) public view returns (uint256) {
        uint256 yourSpot = _index - Payingindex;
        return (yourSpot);
    }
    
    function getBalance() public view returns (uint256) {      
        return address(this).balance;
    }

    // function kill(uint256 _amount) public payable onlyOwner {
    //     uint256 balance = address(this).balance - _amount;
    //     require(balance > 0);
    //     (bool success, ) = payable(msg.sender).call{value: balance}("");
    //     require(success);
    // }
}