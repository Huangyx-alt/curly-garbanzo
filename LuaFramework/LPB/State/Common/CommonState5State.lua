
CommonState5State = Clazz(BaseCommonState,"CommonState5State")

function CommonState5State:New(name)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    if name then
        o.name = name
    end
    return o
end

function CommonState5State:OnEnter(fsm,previous,...)
    local callback, params = select(1,...)
    if callback then
        callback(params)
    end
end

function CommonState5State:OnLeave(fsm)

end

function CommonState5State:DoCommonState5Action(fsm,gostate,callback,params)
    self:DoAction(fsm,gostate,callback,params)
end