pragma solidity ^0.8.0;

// SPDX-License-Identifier: AGPL-3.0-only

contract SimpleBank {
   
   uint numcustomers ;  
   mapping(address => uint) balance ;

   constructor()  {
      numcustomers = 0 ; 
   }

    function deposit() public payable  {
       if (msg.value > 0) {
           if (balance[msg.sender] == 0) {
               numcustomers = numcustomers + 1 ;  
           }
           balance[msg.sender]  += msg.value ; 
       }
    }
   

   
   function withdraw(uint amount) public  returns (bool) {
       bool rc ; 
       address payable x ; 
       
        rc = false ; 
        x = payable(msg.sender) ;  
        if (balance[msg.sender] >= amount ) {
            balance[msg.sender] = balance[msg.sender] - amount ; 
            rc = x.send(amount) ; 
            if (balance[msg.sender] == 0)  {
                numcustomers = numcustomers - 1 ; 
            }
        }
        return(rc) ; 
   }
   
   function mybalance() public  view returns (uint) {
        return(balance[msg.sender]) ; 
   } 
   
   function numberofcustomers() public  view returns (uint) {
        return(numcustomers) ; 
   }
    
}


