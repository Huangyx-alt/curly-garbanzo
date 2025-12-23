MiniGame01OriginalState = Clazz(MiniGame01BaseState,"MiniGame01OriginalState")

function MiniGame01OriginalState:OnEnter(fsm,previous,...)
    
end

function MiniGame01OriginalState:OnLeave(fsm)
    
end

function MiniGame01OriginalState:Change2Enter(fsm)
    if fsm then
        self:ChangeState(fsm,"MiniGame01EnterState")
    end
end

function MiniGame01OriginalState:CheckEncounterThief(fsm)
    if fsm then
        return true
    end
end

function MiniGame01OriginalState:StartPlay(fsm,params)
    if fsm then
        self:ChangeState(fsm,"MiniGame01PlayState",params,true)
    end
end

function MiniGame01OriginalState:ExitOrRestartMiniGame(fsm)
    if fsm then
        fsm:GetOwner():OnExitOrRestartMiniGame()
    end
end

function MiniGame01OriginalState:DoAction2StiffStiff(fsm,params,params2,params3)
    if fsm then
        self:ChangeState(fsm,"MiniGame01StiffState",params,params2,params3)
    end
end

function MiniGame01OriginalState:DoAction2Stiff(fsm,params,params2,params3)
    if fsm then
        self:ChangeState(fsm,"MiniGame01StiffState",params,params2,params3)
    end
end