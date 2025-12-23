local BaseJackpotConsoleState =  require "State/JackpotConsole/BaseJackpotConsoleState"
local JackpotSmallBetRateState = Clazz(BaseJackpotConsoleState,"JackpotSmallBetRateState")

function JackpotSmallBetRateState:OnEnter(fsm)
    fsm:GetOwner():SetSmallBetRateJackpot()
end

function JackpotSmallBetRateState:OnLeave(fsm)

end

function JackpotSmallBetRateState:BetRateChangeCheckJackpot(fsm)
    if (ModelList.CityModel:IsMaxBetRate()) and fsm then
        self:ChangeState(fsm,"JackpotMaxBetRateState")
    else 
        fsm:GetOwner():SetSmallBetRateJackpot()
    end
end

return JackpotSmallBetRateState