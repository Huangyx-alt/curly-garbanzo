-----在小象界面的状态

require "Logic/Fsm/BaseFsmState"
BankEleState = Clazz(BaseFsmState,"BankEleState")

function BankEleState:InitState()
end

function BankEleState:OnEnter(fsm)
    fsm:GetOwner():OnEleSate()
end

function BankEleState:EnterFinish(fsm)
    
end

--收集小象奖励
function BankEleState:CollectReward(fsm)
    if  fsm then
        fsm:GetOwner():OnEleCollectReward()
    end 
  
end