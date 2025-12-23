local MailBaseState = require "State/MailView/MailBaseState"
local MailIdleState = Clazz(MailBaseState,"MailIdleState")

function MailIdleState:InitState()
end


function MailIdleState:OnEnter(fsm)
    if fsm then 
        fsm:GetOwner():OnHaveMail()
    end 
end

function MailIdleState:EnterFinish(fsm)
    
end


function MailIdleState:OnLeave(fsm)
    
end

return MailIdleState