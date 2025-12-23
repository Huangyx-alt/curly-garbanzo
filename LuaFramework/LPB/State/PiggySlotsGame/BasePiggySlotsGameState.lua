
BasePiggySlotsGameState = Clazz(BaseFsmState,"BasePiggySlotsGameState")

function BasePiggySlotsGameState:DoEnter(fsm)
end

function BasePiggySlotsGameState:OnLeave(fsm)
end

function BasePiggySlotsGameState:DoBtnClick(fsm)
end

function BasePiggySlotsGameState:DoClickSpinRoll(fsm)
end

function BasePiggySlotsGameState:DoStopRoll(fsm)
end

function BasePiggySlotsGameState:DoFinishSpin(fsm)
end

function BasePiggySlotsGameState:DoClickExit(fsm)
end

function BasePiggySlotsGameState:DoPaySuccessGetExtraSpin(fsm)
end

function BasePiggySlotsGameState:DoPayFailGetExtraSpin(fsm)
end

function BasePiggySlotsGameState:DoBuyExtraUseSpin(fsm)
end

function BasePiggySlotsGameState:DoOneBingoCardReward(fsm)
end

function BasePiggySlotsGameState:DoTakeAway(fsm)
end

function BasePiggySlotsGameState:DoFinishGameInit(fsm)
end

function BasePiggySlotsGameState:ReqSpinSuccess(fsm)
end

function BasePiggySlotsGameState:DoError(fsm,code)
end

function BasePiggySlotsGameState:DoBigPiggyWheel(fsm)
end

function BasePiggySlotsGameState:DoCollectBreakRewardFinish(fsm)
end

function BasePiggySlotsGameState:DoSpinPiggyWheel(fsm)
end

function BasePiggySlotsGameState:DoEnterNextCard()
end

function BasePiggySlotsGameState:DoFinishReqNextCard()
end

function BasePiggySlotsGameState:Goback()
end

function BasePiggySlotsGameState:ResetChooseType()
end

function BasePiggySlotsGameState:ReqUseTicketContinueGame()
end