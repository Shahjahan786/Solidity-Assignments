pragma solidity ^0.8.0;

contract Bank {
    
    mapping(address => Account) accountBalances;
    address payable public  owner;
    uint private count;
    
  
    
    enum status {opened, closed, suspended, dormant}
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
        
  
    struct Account{
        uint balance;
        address actAddress;
        status _status;
    }
    
    constructor() payable{
        require(msg.value >= 50 ether, "Insufficient initial deposit to open bank, must be at least 50 ethers");
        owner = payable(msg.sender);
     
    }
    
    function closeBank() public onlyOwner {
      selfdestruct(owner);
    }
    
    function openAccount() public payable {
        require(msg.value >= 1 ether, "Insufficient initial deposit, must be at least 1 ether");
        require(accountBalances[msg.sender].actAddress == address(0x0), "Already account holder");
        uint amount = msg.value;
        if(count < 5){
            amount = amount + 1 ether;
        } 
        
        Account memory account = Account(amount, msg.sender, status.opened);
        accountBalances[msg.sender] = account;
        
        count++;
    }
    
    function closeAccount() public  {
         require(accountBalances[msg.sender].actAddress != address(0x0), "Account does not exist");
        payable(msg.sender).transfer(accountBalances[msg.sender].balance);
        accountBalances[msg.sender].balance = 0;
        accountBalances[msg.sender]._status = status.closed;
    }
    
    function deposit() public payable  {
        require(msg.value >= 1 ether, "Insufficient deposit amount , must be at least 1 ether");
        require(accountBalances[msg.sender].actAddress != address(0x0), "Account does not exist");
        accountBalances[msg.sender].balance += msg.value;
    }
    
    function deposit(address receiver) public payable  {
        require(msg.value >= 1 ether, "Insufficient deposit amount , must be at least 1 ether");
        require(accountBalances[receiver].actAddress != address(0x0), "Account does not exist");
        accountBalances[receiver].balance += msg.value;
    }
    
    function withdraw(uint withdrawAmount) public  {
        require(withdrawAmount >= 1 ether, "Insufficient withdraw amount , must be at least 1 ether");
        require(accountBalances[msg.sender].actAddress != address(0x0), "Account does not exist");
        require(withdrawAmount <= accountBalances[msg.sender].balance, "Insufficient balance");
        
        accountBalances[msg.sender].balance -= withdrawAmount;
        payable(msg.sender).transfer(withdrawAmount);
        
    }
    
    function getBalance() view public  returns(uint)  {
        return accountBalances[msg.sender].balance;
    }
    
    function depositsBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    

    
}
