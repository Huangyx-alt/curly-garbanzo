
PiggySlotsGameWaitDoFreeSpinState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameWaitDoFreeSpinState")

function PiggySlotsGameWaitDoFreeSpinState:OnEnter(fsm)
    self.isFinishState = false
    fsm:GetOwner():FreeSpinUpdateUI(false)
end

function PiggySlotsGameWaitDoFreeSpinState:OnLeave(fsm)
    self.isFinishState = true
    self:ClearResetButton()
end

function PiggySlotsGameWaitDoFreeSpinState:DoClickSpinRoll(fsm)
    UISound.play("piggyslotbuttonclick")
    if ModelList.PiggySloltsGameModel.CheckIsTest() then
        ModelList.PiggySloltsGameModel.SetTestSpinData()    
    else
        if fsm then
            fsm:GetOwner():ReqPiggySlotsSpin()
    		fsm:GetOwner():FreeSpinUpdateUI(true)
            self:CreatResetButton(fsm)
        end
    end
end

function PiggySlotsGameWaitDoFreeSpinState:ReqSpinSuccess(fsm)
    self.isFinishState = true
    self:ClearResetButton()
    fsm:GetOwner():FreeSpinUpdateUI(true)
    if fsm then
        fsm:GetCurState():ChangeState(fsm,"PiggySlotsGameSpinState", "PiggySlotsGameWaitDoFreeSpinState")
    end
end

function PiggySlotsGameWaitDoFreeSpinState:CreatResetButton(fsm)
    self:ClearResetButton()
    self.timeResetButton = LuaTimer:SetDelayFunction(10, function()
        fsm:GetOwner():FreeSpinUpdateUI(false)
    end)
end

function PiggySlotsGameWaitDoFreeSpinState:ClearResetButton()
    log.log("清除效果了")
    if self.timeResetButton then
        LuaTimer:Remove(self.timeResetButton)
        self.timeResetButton = nil
    end
end

function PiggySlotsGameWaitDoFreeSpinState:DoError(fsm,code)
    log.log("PiggySlotsGameWaitDoFreeSpinState code" , code)
    if code == -99 or code == RET.RET_SESSION_INVALID then
        --断网处理
        local tip = Csv.GetDescription(191169)
        UIUtil.show_common_popup_with_options(
            {
                okType = 3,
                contentText = tip,
                sureCb = function()
                    log.log("状态完成判断" , self.isFinishState)
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
