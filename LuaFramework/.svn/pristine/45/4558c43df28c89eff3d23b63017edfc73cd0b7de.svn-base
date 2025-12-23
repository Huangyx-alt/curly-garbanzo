
MiniGame01Stiffparams = {keepPlaying = 1,free2keep = 2,
giveUpExpelThief = 3,claimJackpotReward = 4,
enterGameShowClaimTopReward = 5,openBoxShowClaimTopReward = 6,
EnterGameShowStolenByThief = 7,openBoxShowStolenByThief = 8,
openBoxShowJackpot = 9,enterGameShowJackpot = 10,
collectAndQuit = 11,stayWinMore = 12,
confireCollectAndQuit = 13,exitPlayHelper = 14,
dodgeExit = 15,hatBoost = 16,hatBoostPurchse = 17}

MiniGame01StiffState = Clazz(MiniGame01BaseState,"MiniGame01StiffState")

local previous_state_name = nil

function MiniGame01StiffState:OnEnter(fsm,previous,...)
    previous_state_name = previous
    local params1,params2,params3 = select(1,...)
    self:CallOwner(fsm,params1,params2)
    if params3 then
        self.Timer = Invoke(function()
            self:StiffOver(fsm)
        end,5)
    end
end

function MiniGame01StiffState:CallOwner(fsm,params,params2)
    if params == MiniGame01Stiffparams.keepPlaying then
        fsm:GetOwner():DoKeepPlaying()
    elseif params == MiniGame01Stiffparams.free2keep then
        fsm:GetOwner():DoFree2KeepPlaying()
    elseif params == MiniGame01Stiffparams.giveUpExpelThief then
        fsm:GetOwner():DoGiveUpExpelThief()
    elseif params == MiniGame01Stiffparams.claimJackpotReward then
        fsm:GetOwner():OnClaimJackpotReward()
    elseif params == MiniGame01Stiffparams.enterGameShowClaimTopReward then
        fsm:GetOwner():OnEnterGameShowClaimTopReward(params2)
    elseif params == MiniGame01Stiffparams.openBoxShowClaimTopReward then
        fsm:GetOwner():OnOpenBoxShowClaimTopReward()
    elseif params == MiniGame01Stiffparams.EnterGameShowStolenByThief then
        fsm:GetOwner():OnEnterGameShowStolenByThief()
    elseif params == MiniGame01Stiffparams.openBoxShowStolenByThief then
        fsm:GetOwner():OnOpenBoxShowStolenByThief()
    elseif params == MiniGame01Stiffparams.openBoxShowJackpot then
        fsm:GetOwner():OnOpenBoxShowJackpot()
    elseif params == MiniGame01Stiffparams.enterGameShowJackpot then
        fsm:GetOwner():OnEnterGameShowJackpot()
    elseif params == MiniGame01Stiffparams.collectAndQuit then
        fsm:GetOwner():OnCollectAndQuit()
    elseif params == MiniGame01Stiffparams.stayWinMore then
        fsm:GetOwner():OnStayWinMore()
    elseif params == MiniGame01Stiffparams.confireCollectAndQuit then
        fsm:GetOwner():OnConfireCollectAndQuit()
    elseif params == MiniGame01Stiffparams.exitPlayHelper then
        fsm:GetOwner():OnExitPlayHelper()
    elseif params == MiniGame01Stiffparams.dodgeExit then
        fsm:GetOwner():OnDodgeExit()
    elseif params == MiniGame01Stiffparams.hatBoost then
        fsm:GetOwner():OnHatBoostExit()
    elseif params == MiniGame01Stiffparams.hatBoostPurchse then
        fsm:GetOwner():OnHatBoostPurchse(params2)
    end
end

function MiniGame01StiffState:OnLeave(fsm,previous,...)
    previous_state_name = nil
    self:ServerRespone()
end

function MiniGame01StiffState:ServerRespone()
    if self.Timer then
        self.Timer:Stop()
        self.Timer = nil
    end
end

function MiniGame01StiffState:StiffOver(fsm)
    if fsm then
        self:ChangeState(fsm,"MiniGame01OriginalState")
    end
end

function MiniGame01StiffState:OnSubmitLayerResphone(fsm,data)
    if fsm then
        fsm:GetOwner():OnSubmitLayerResphoneNotify(data)
    end
end

function MiniGame01StiffState:ExpelThiefResult(fsm,params)
    if fsm then
        fsm:GetOwner():ExpelThiefResult(params)
    end
end

function MiniGame01StiffState:ExitOrRestartMiniGame(fsm)
    if fsm then
        fsm:GetOwner():OnExitOrRestartMiniGame()
    end
end

function MiniGame01StiffState:OpenBoxSequenceFinish(fsm)
    if fsm then
        self:ChangeState(fsm,"MiniGame01OriginalState")
    end
end

function MiniGame01StiffState:DoAction2StiffStiff(fsm,params,params2)
    if fsm then
        self:CallOwner(fsm,params,params2)
    end
end

function MiniGame01StiffState:DoAction2StiffPlay(fsm,params,params2)
    if fsm then
        self:CallOwner(fsm,params,params2)
    end
end