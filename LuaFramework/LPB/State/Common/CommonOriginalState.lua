
CommonOriginalState = Clazz(BaseCommonState,"CommonOriginalState")

function CommonOriginalState:New(name)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    if name then
        o.name = name
    end
    return o
end

function CommonOriginalState:OnEnter(fsm,previous,...)
    local callback, params = select(1,...)
    if callback then
        callback(params)
    end
end

function CommonOriginalState:OnLeave(fsm)

end

function CommonOriginalState:DoOriginalAction(fsm,gostate,callback,params)
    self:DoAction(fsm,gostate,callback,params)
end