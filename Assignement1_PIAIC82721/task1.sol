pragma solidity ^0.5.16;

contract StudentRegistration {
    address payable private myAddress = 0xf2e891d063F76A3eE2357B1Bf78dd555d4dc35EB;
    
    enum gender {male, female}
    enum category {online, onsite}
    
    mapping(address => Student) public studentList;
    uint private collectedFee;
    uint private totalRegisterdStudents;
    
    struct Student{
        string name;
        address sdtAddress;
        bool hasBSDegree;
        gender _gender;
        category _category;
    }
    
    function setAddress(address payable add) public{
        myAddress = add;
    }
    
    function getAddress() public view returns(address){
        return myAddress;
    }
    
    function getBalance() public view returns (uint){
        return myAddress.balance;
    }
    
    function pay(string memory name, bool hasBSDegree, gender _gender, category _category) public payable {
        require(msg.value == 2 ether, "2 ether required for registration");
        require(studentList[msg.sender].sdtAddress == address(0x0), "Already enrolled");
        Student memory std = Student(name,msg.sender, hasBSDegree, _gender, _category);
        studentList[msg.sender] = std;

        myAddress.transfer(msg.value);
        collectedFee = collectedFee + msg.value;
        totalRegisterdStudents++;
    }
    
    function getCollectedFee() public view returns(uint){
        /*Returns collected fee by students*/
        return collectedFee;
    }
    
    function getTotalRegisterdStudents() public view returns(uint){
        /*Returns count of students*/
        return totalRegisterdStudents;
    }
    
     function getStudentDetails(address studentId) public view returns (address,string memory,bool,gender,category){
        
        /*Returns student details as per ID*/
        return(studentList[studentId].sdtAddress,studentList[studentId].name,studentList[studentId].hasBSDegree,studentList[studentId]._gender,studentList[studentId]._category);
    }

}