local MailBaseState = require "State/MailView/MailBaseState"
local MailNoCountState = Clazz(MailBaseState,"MailNoCountState")

function MailNoCountState:OnEnter(fsm)
    if fsm then 
        fsm:GetOwner():OnNotMail()
    end 
end

function MailNoCountState:EnterFinish(fsm)
    
end


function MailNoCountState:OnLeave(fsm)
    
end
return MailNoCountState