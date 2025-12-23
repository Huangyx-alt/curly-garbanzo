
local BottomRegularlyAwardBaseState = Clazz(BaseFsmState,"BottomRegularlyAwardBaseState")

function BottomRegularlyAwardBaseState:Change2Mature(fsm)
end

function BottomRegularlyAwardBaseState:Change2Raw(fsm)
end

function BottomRegularlyAwardBaseState:ChangeDisable(fsm)
end

function BottomRegularlyAwardBaseState:CliamRewardRespone(fsm)
    if fsm then
        self:ChangeState(fsm,"BottomRegularlyAwardOriginalState")
        fsm:GetOwner():CheckRemainTime()
    end
end

function BottomRegularlyAwardBaseState:ClickRegularlyAward(fsm)

end

function BottomRegularlyAwardBaseState:CheckAd(fsm)
    
end

function BottomRegularlyAwardBaseState:AdBreakOut(fsm)
end

return BottomRegularlyAwardBaseState