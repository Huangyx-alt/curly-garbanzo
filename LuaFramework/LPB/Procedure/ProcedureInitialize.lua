
ProcedureInitialize = Clazz(BaseProcedure,"ProcedureInitialize")

function ProcedureInitialize:New()
    local o = {}
    setmetatable(o,{__index = ProcedureInitialize})
    return o
end

function ProcedureInitialize:OnEnter(fsm,lastName)
    --暂时屏蔽SDK by LwangZg
   --[[require("Logic/SDK") 
    if SDK ~= nil then
        SDK.event_first_open()
    end ]]
end

function ProcedureInitialize:OnLeave(fsm)
    
end