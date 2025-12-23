
PiggySlotsGameCheckNextCardState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameCheckNextCardState")

function PiggySlotsGameCheckNextCardState:ReqUseTicketContinueGame(fsm)
    local piggySlotsGameId = ModelList.MiniGameModel:GetMiniGameId(BingoBangEntry.miniGameType.PiggySlots)
    ModelList.PiggySloltsGameModel.SetReqPiggyState(true)
    ModelList.MiniGameModel:RaqUseMiniGameTick(piggySlotsGameId,nil)
end

function PiggySlotsGameCheckNextCardState:OnEnter(fsm)
    self.isFinishState = false
    local ticketNum = ModelList.MiniGameModel:GetMiniGameTicketNum(BingoBangEntry.miniGameType.PiggySlots)
    if ticketNum > 0 then
        fsm:GetOwner():ShowUseNextTicketUpdateUI()
        --ModelList.PiggySloltsGameModel.ReqPiggyInfo()
    else
        log.log("游戏结束了")
        if fsm then
            fsm:GetOwner():ShowViewEnd()
        end
    end
end

function PiggySlotsGameCheckNextCardState:OnLeave(fsm)
    self.isFinishState = true
end

function PiggySlotsGameCheckNextCardState:DoFinishReqNextCard(fsm)
    self.isFinishState = true
    if fsm then
        fsm:GetOwner():AnimFreeButton()
        fsm:GetOwner():NewCarcInitElement()
        fsm:GetOwner():InitView()
        self:ChangeState(fsm,"PiggySlotsGameTableInitState",true)
    end
end

function PiggySlotsGameCheckNextCardState:DoError(fsm,code)
    log.log("PiggySlotsGameCheckNextCardState code" , code)
    if code == -99 or code == RET.RET_SESSION_INVALID then
        local tip = Csv.GetDescription(191169)
        UIUtil.show_common_popup_with_options(
            {
                okType = 3,
                contentText = tip,
                sureCb = function()
                    log.log("状态完成判断 PiggySlotsGameCheckNextCardState" , self.isFinishState)
                    if self.isFinishState then
                        --状态完成了
                    else
                        ModelList.PiggySloltsGameModel.ReqPiggyInfo()
                    end
                end,
            }
        )
    else
        self:ChangeState(fsm,"PiggySlotsGameErrorTipExitState")
    end
end


function PiggySlotsGameCheckNextCardState:Goback(fsm)
    if fsm then
        self:ChangeState(fsm,"PiggySlotsGameChooseExitState" , true)
    end
    --
    --UIUtil.show_common_popup(191164,false,function()
    --    if fsm then
    --        self:ChangeState(fsm,"PiggySlotsGameChooseExitState" , true)
    --    end
    --end,function()
    --    fsm:GetOwner():ChooseTakeOrPaySpinUpdateUI(false)
    --    self:ClearResetButton()
    --end)

end

