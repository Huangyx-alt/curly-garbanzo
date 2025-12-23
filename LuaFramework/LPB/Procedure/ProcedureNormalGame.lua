
ProcedureNormalGame = Clazz(BaseProcedure,"ProcedureNormalGame")

local isEnter = false
local isShowReady = false

function ProcedureNormalGame:New()
    local o = {}
    setmetatable(o,{__index = ProcedureNormalGame})
    return o
end

function ProcedureNormalGame:OnEnter(fsm,lastName)
    log.r("ProcedureNormalGame:OnEnter")
    isEnter = true
    ProcedureNormalGame:StartShow()
    --Facade.RegisterCommand(NotifyName.Bingo.ShowBingoView,CmdCommonList.CmdShowBingoView)
    --Facade.SendNotification(NotifyName.Bingo.ShowBingoView,ViewList.GameBingoView)
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView =  fun.find_child(game_ui,"GameBingoView")
    --log.w("Bingo --  InitSceneGame ")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.GameBingoView,gameBingoView )

    --if not ModelList.GuideModel:IsFirstBattle() then
    --    local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --    local getReadyView =  fun.find_child(game_ui,"ReadyView")
    --    Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.ReadyView,getReadyView )
    --    if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --        ViewList.SceneLoadingGameView:FadeOut()
    --    end
    --else
    --    local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --    local getReadyView =  fun.find_child(game_ui,"ReadyView")
    --    fun.set_active(getReadyView.gameObject , false)
    --end
end

function ProcedureNormalGame:ShowReadyView(cb)
    isShowReady = true
    ProcedureNormalGame:StartShow(cb)
end

function ProcedureNormalGame:StartShow(cb)
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView =  fun.find_child(game_ui,"GameBingoView")

        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.GameBingoView,gameBingoView)
        
        if not ModelList.GuideModel:IsFirstBattle() then
            game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
            local getReadyView =  fun.find_child(game_ui,"ReadyView")
            if ModelList.BattleModel.GetBattleSuperMatch() then
                fun.set_active(getReadyView.gameObject , false)
                if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
                    ViewList.SceneLoadingGameView:FadeOut(function()
                        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.ReadyView ,getReadyView, nil, nil, true, {
                            onBattleStart = self.showCompleteCb or cb
                        })
                    end)
                end
            else
                Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.ReadyView ,getReadyView, nil, nil, true, {
                    onBattleStart = self.showCompleteCb or cb
                })
                if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
                    ViewList.SceneLoadingGameView:FadeOut()
                end
            end
        else
            game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
            local getReadyView =  fun.find_child(game_ui,"ReadyView")
            fun.set_active(getReadyView.gameObject , false)
            fun.SafeCall(cb)
        end
        self.showCompleteCb = nil
    else
        self.showCompleteCb = cb
    end
end


function ProcedureNormalGame:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureNormalGame:ProcedureName()
    return "ProcedureNormalGame"
end

function ProcedureNormalGame:GetCurrentSceneName()
    return "NormalGameScene"
end

return ProcedureNormalGame