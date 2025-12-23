
PiggySlotsGameWaitChoosePaySpinOrTakeAwayState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameWaitChoosePaySpinOrTakeAwayState")
local ChooseType = 
{
    Wait = 1,
    ExitGame = 2,
    PaySpin = 3,
    TakeAway = 4
}
function PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:OnEnter(fsm)
    self.chooseState = ChooseType.Wait
    fsm:GetOwner():ChooseTakeOrPaySpinUpdateUI(false)
    self.isFinishState = false
end

function PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:OnLeave(fsm)
    self.isFinishState = true
    self:ClearResetButton()
end

function PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:DoPayFailGetExtraSpin(fsm)
    self:ClearResetButton()
    fsm:GetOwner():PayGetSpinFailUpdateUI()
    self.chooseState = ChooseType.Wait
    fsm:GetOwner():ChooseTakeOrPaySpinUpdateUI(false)
end

function PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:ResetChooseType(fsm)
    self.chooseState = ChooseType.Wait
    self:ClearResetButton()
    fsm:GetOwner():ChooseTakeOrPaySpinUpdateUI(false)
end

function PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:DoTakeAway(fsm)
    log.log("changestate 1 点击走过这里 PiggySlotsGameWaitChoosePaySpinOrTakeAwayState" )
    if self.chooseState ~= ChooseType.Wait then
        log.log("状态唯一 DoTakeAway" )
        return
    end
    UISound.play("piggyslotbuttonclick")
    fsm:GetOwner():ChooseTakeOrPaySpinUpdateUI(true)
    self.chooseState = ChooseType.TakeAway
    self:ChangeState(fsm,"PiggySlotsGameFinishOneBingoCardState" , false)
end

function PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:DoBuyExtraUseSpin(fsm)
    if self.chooseState ~= ChooseType.Wait then
        log.log("状态唯一 DoBuyExtraUseSpin" )
        return
    end
    UISound.play("piggyslotbuttonclick")
    self.chooseState = ChooseType.PaySpin
    fsm:GetOwner():ChooseTakeOrPaySpinUpdateUI(true)
    if fsm then
        self:CreatResetButton(fsm)
        fsm:GetOwner():OnBuyExtraSpin()
    end
end

function PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:ReqSpinSuccess(fsm)
    self:ClearResetButton()
    if fsm then
        fsm:GetCurState():ChangeState(fsm,"PiggySlotsGameSpinState", "PiggySlotsGameWaitChoosePaySpinOrTakeAwayState")
    end
end

function PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:Goback(fsm)
    if self.chooseState ~= ChooseType.Wait then
        log.log("状态唯一 Goback" )
        return
    end
    fsm:GetOwner():ChooseTakeOrPaySpinUpdateUI(true)
    self.chooseState = ChooseType.ExitGame

    UIUtil.show_common_popup(191164,false,function()
        if fsm then

            self:ChangeState(fsm,"PiggySlotsGameFinishOneBingoCardState" , true)
        end
    end,function()
        self.chooseState = ChooseType.Wait
        fsm:GetOwner():ChooseTakeOrPaySpinUpdateUI(false)
        self:ClearResetButton()
    end)
    
end

function PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:DoError(fsm,code)
    log.log("PiggySlotsGameWaitChoosePaySpinOrTakeAwayState code" , code)
    if code == -99 or code == RET.RET_SESSION_INVALID then
        --断网处理
        local tip = Csv.GetDescription(191169)
        UIUtil.show_common_popup_with_options(
            {
                okType = 3,
                contentText = tip,
                sureCb = function()
                    log.log("状态完成判断 PiggySlotsGameWaitChoosePaySpinOrTakeAwayState" , self.isFinishState)
                    if self.isFinishState then
                        --状态完成了
                    else
                        fsm:GetOwner():ReqPiggySlotsSpin()
                        fsm:GetOwner():FreeSpinUpdateUI(true)
                        self:CreatResetButton(fsm)
                    end
                end,
            }
        )
    else
        --其他问题处理
        self:ChangeState(fsm,"PiggySlotsGameErrorTipExitState")
    end
end

function PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:CreatResetButton(fsm)
    self:ClearResetButton()
    self.timeResetButton = LuaTimer:SetDelayFunction(10, function()
        fsm:GetOwner():ChooseTakeOrPaySpinUpdateUI(false)
    end)
end

function PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:ClearResetButton()
    log.log("清除效果了 PiggySlotsGameWaitChoosePaySpinOrTakeAwayState")
    if self.timeResetButton then
        LuaTimer:Remove(self.timeResetButton)
        self.timeResetButton = nil
    end
end


