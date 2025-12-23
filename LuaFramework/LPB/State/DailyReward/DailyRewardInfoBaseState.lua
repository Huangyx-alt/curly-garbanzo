
require "Logic/Fsm/BaseFsmState"

local DailyRewardInfoBaseState = Clazz(BaseFsmState,"DailyRewardInfoBaseState")

function DailyRewardInfoBaseState:PlayEnter(fsm)
end

function DailyRewardInfoBaseState:FinishEnter(fsm)
end

function DailyRewardInfoBaseState:GobackClick(fsm)

end

function DailyRewardInfoBaseState:ClaimRewar(fsm,params)
end

function DailyRewardInfoBaseState:CliamRewardRespone(fsm,isExit)

end

function DailyRewardInfoBaseState:WatchVideo(fsm)
end

return DailyRewardInfoBaseState