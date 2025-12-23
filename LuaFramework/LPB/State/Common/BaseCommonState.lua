
BaseCommonState = Clazz(BaseFsmState,"BaseCommonState")

function BaseCommonState:DoAction(fsm,gostate,callback,params)
    if fsm and gostate then
        self:ChangeState(fsm,gostate,callback,params)
    elseif callback then
        callback(params)
    end
end

function BaseCommonState:DoOriginalAction(fsm,gostate,callback,params)
end

function BaseCommonState:DoCommonState1Action(fsm,gostate,callback,params)
end

function BaseCommonState:DoCommonState2Action(fsm,gostate,callback,params)
end

function BaseCommonState:DoCommonState3Action(fsm,gostate,callback,params)
end

function BaseCommonState:DoCommonState4Action(fsm,gostate,callback,params)
end

function BaseCommonState:DoCommonState5Action(fsm,gostate,callback,params)
end