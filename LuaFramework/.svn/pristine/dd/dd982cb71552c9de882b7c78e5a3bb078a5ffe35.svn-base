
CommonState4State = Clazz(BaseCommonState,"CommonState4State")

function CommonState4State:New(name)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    if name then
        o.name = name
    end
    return o
end

function CommonState4State:OnEnter(fsm,previous,...)
    local callback, params = select(1,...)
    if callback then
        callback(params)
    end
end

function CommonState4State:OnLeave(fsm)

end

function CommonState4State:DoCommonState4Action(fsm,gostate,callback,params)
    self:DoAction(fsm,gostate,callback,params)
end