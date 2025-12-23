local BaseJackpotConsoleState =  require "State/JackpotConsole/BaseJackpotConsoleState"
local JackpotMaxBetRateState = Clazz(BaseJackpotConsoleState,"JackpotMaxBetRateState")

function JackpotMaxBetRateState:OnEnter(fsm)
    fsm:GetOwner():SetMaxBetRateJackpot()
end

function JackpotMaxBetRateState:OnLeave(fsm)

end

function JackpotMaxBetRateState:BetRateChangeCheckJackpot(fsm)
    if fsm then
        self:ChangeState(fsm,"JackpotSmallBetRateState")
    end
end
return  JackpotMaxBetRateState