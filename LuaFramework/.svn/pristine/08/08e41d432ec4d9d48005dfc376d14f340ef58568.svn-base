
CommonState6State = Clazz(BaseCommonState,"CommonState6State")

function CommonState6State:New(name)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    if name then
        o.name = name
    end
    return o
end

function CommonState6State:OnEnter(fsm,previous,...)
    local callback, params = select(1,...)
    if callback then
        callback(params)
    end
end

function CommonState6State:OnLeave(fsm)

end

function CommonState6State:DoCommonState6Action(fsm,gostate,callback,params)
    self:DoAction(fsm,gostate,callback,params)
end