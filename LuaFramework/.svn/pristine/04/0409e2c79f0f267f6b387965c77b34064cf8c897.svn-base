
CommonState7State = Clazz(BaseCommonState,"CommonState7State")

function CommonState7State:New(name)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    if name then
        o.name = name
    end
    return o
end

function CommonState7State:OnEnter(fsm,previous,...)
    local callback, params = select(1,...)
    if callback then
        callback(params)
    end
end

function CommonState7State:OnLeave(fsm)

end

function CommonState7State:DoCommonState7Action(fsm,gostate,callback,params)
    self:DoAction(fsm,gostate,callback,params)
end