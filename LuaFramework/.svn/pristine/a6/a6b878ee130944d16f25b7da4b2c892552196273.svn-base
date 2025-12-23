
CommonState3State = Clazz(BaseCommonState,"CommonState3State")

function CommonState3State:New(name)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    if name then
        o.name = name
    end
    return o
end

function CommonState3State:OnEnter(fsm,previous,...)
    local callback, params = select(1,...)
    if callback then
        callback(params)
    end
end

function CommonState3State:OnLeave(fsm)

end

function CommonState3State:DoCommonState3Action(fsm,gostate,callback,params)
    self:DoAction(fsm,gostate,callback,params)
end