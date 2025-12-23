
CommonState2State = Clazz(BaseCommonState,"CommonState2State")

function CommonState2State:New(name)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    if name then
        o.name = name
    end
    return o
end

function CommonState2State:OnEnter(fsm,previous,...)
    local callback, params = select(1,...)
    if callback then
        callback(params)
    end
end

function CommonState2State:OnLeave(fsm)

end

function CommonState2State:DoCommonState2Action(fsm,gostate,callback,params)
    self:DoAction(fsm,gostate,callback,params)
end