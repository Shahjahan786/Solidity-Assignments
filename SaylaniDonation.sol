pragma solidity ^0.5.16;

contract SaylaniDonation {
    address payable private owner;
    enum gender {male, female}
  
    mapping(address => Doner) public donerList;
    uint private collectedDonation;
    uint private totalDoners;
    
    constructor () public{
         owner = msg.sender;
    }
    
    struct Doner{
        string name;
        address donnerAddress;
        gender _gender;
       
    }
    
   
    
    function getAddress() public view returns(address){
        return owner;
    }
    
    function getBalance() public view onlyMe returns (uint){
        return owner.balance;
    }
    
    function donate(string memory name,  gender _gender) public payable {
        require(msg.value == 10 ether, "10 ether required");
       
        Doner memory doner = Doner(name,msg.sender,  _gender);
        donerList[msg.sender] = doner;

        owner.transfer(msg.value);
        collectedDonation = collectedDonation + msg.value;
        totalDoners++;
    }
    
    function getCollectedDonation() public view onlyMe returns(uint){
        return collectedDonation;
    }
    
    function getTotalDonners() public view onlyMe returns(uint){
      
        return totalDoners;
    }
    
     function getDonnerDetails(address id) public view onlyMe returns (address,string memory){
        
        return(donerList[id].donnerAddress,donerList[id].name);
    }
    
  
    function close() public onlyMe{ 
        selfdestruct(owner); 
    }
    
     modifier onlyMe(){
        if(msg.sender != owner){
          
        }else{
             _;
        }
        
        
    }
    

}