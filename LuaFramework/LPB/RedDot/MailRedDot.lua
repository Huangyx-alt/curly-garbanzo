local BaseRedDot = require("RedDot/BaseRedDot")

local MailRedDot = Clazz(BaseRedDot,"MailRedDot")
local this = MailRedDot


function MailRedDot:Check(node,param)
    if node then 
        local flag =  ModelList.MailModel.haveReaDot()
       -- fun.set_active(node,flag)
        MailRedDot:SetSingleNodeActive(node,flag)
    end 
end

function MailRedDot:Refresh(nodeList,param)
    for key, value in pairs(nodeList) do
        MailRedDot:Check(value,param)
    end
  
end

return this