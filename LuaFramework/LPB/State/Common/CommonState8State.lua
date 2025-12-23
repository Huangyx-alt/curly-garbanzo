
CommonState8State = Clazz(BaseCommonState,"CommonState8State")

function CommonState8State:New(name)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    if name then
        o.name = name
    end
    return o
end

function CommonState8State:OnEnter(fsm,previous,...)
    local callback, params = select(1,...)
    if callback then
        callback(params)
    end
end

function CommonState8State:OnLeave(fsm)

end

function CommonState8State:DoCommonState8Action(fsm,gostate,callback,params)
    self:DoAction(fsm,gostate,callback,params)
end