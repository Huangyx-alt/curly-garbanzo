-----在小猪界面的状态

require "Logic/Fsm/BaseFsmState"
BankPigState = Clazz(BaseFsmState,"BankPigState")

function BankPigState:InitState()
end

function BankPigState:OnEnter(fsm)
    fsm:GetOwner():OnEleSate()
end

function BankPigState:EnterFinish(fsm)
    
end 

--收集小猪奖励
function BankPigState:CollectReward(fsm)
    if fsm then 
        fsm:GetOwner():OnPigCollectReward()
    end 
end