MiniGame01PlayState = Clazz(MiniGame01BaseState,"MiniGame01PlayState")

function MiniGame01PlayState:OnEnter(fsm,previous,...)
    local params,params2 = select(1,...)
    if params then
        fsm:GetOwner():OpenBox(params)
    end
    if params2 then
        self.Timer = Invoke(function()
            self:OpenBoxSequenceFinish(fsm)
        end,5)
    end
end

function MiniGame01PlayState:OnLeave(fsm)
    self:ServerRespone()
end

function MiniGame01PlayState:ServerRespone()
    if self.Timer then
        self.Timer:Stop()
        self.Timer = nil
    end
end

function MiniGame01PlayState:OnSubmitLayerResphone(fsm,data)
    if fsm then
        fsm:GetOwner():DoOpenBoxAction(data)
    end
end

function MiniGame01PlayState:ExpelThiefResult(fsm,params)
    if fsm then
        fsm:GetOwner():ExpelThiefResult(params)
    end
end

function MiniGame01PlayState:ExitOrRestartMiniGame(fsm)
    if fsm then
        fsm:GetOwner():OnExitOrRestartMiniGame()
    end
end

function MiniGame01PlayState:OpenBoxSequenceFinish(fsm)
    if fsm then
        self:ChangeState(fsm,"MiniGame01OriginalState")
    end
end

function MiniGame01PlayState:DoAction2Stiff(fsm,params)
    if fsm then
        self:ChangeState(fsm,"MiniGame01StiffState",params)
    end
end

function MiniGame01PlayState:DoAction2StiffPlay(fsm,params,params2)
    if fsm then
        self:ChangeState(fsm,"MiniGame01StiffState",params,params2)
    end
end