
CommonState1State = Clazz(BaseCommonState,"CommonState1State")

function CommonState1State:New(name)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    if name then
        o.name = name
    end
    return o
end

function CommonState1State:OnEnter(fsm,previous,...)
    local callback, params = select(1,...)
    if callback then
        callback(params)
    end
end

function CommonState1State:OnLeave(fsm)

end

function CommonState1State:DoCommonState1Action(fsm,gostate,callback,params)
    self:DoAction(fsm,gostate,callback,params)
end