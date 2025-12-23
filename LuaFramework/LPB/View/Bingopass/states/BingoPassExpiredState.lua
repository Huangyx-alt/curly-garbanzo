local BingoPassBaseState = require "View/Bingopass/states/BingoPassBaseState"
local BingoPassExpiredState = Clazz(BingoPassBaseState,"BingoPassExpiredState")

function BingoPassExpiredState:OnEnter(fsm,previous,...)

end

function BingoPassExpiredState:OnLeave(fsm)
end

function BingoPassExpiredState:Complete(fsm)
    self:ClaimReward(fsm)
end

function BingoPassExpiredState:GemUnlockLevel(fsm,passItem)
    self:ClaimReward(fsm)
end

function BingoPassExpiredState:BingoPassWatchAd(fsm,passItem)
    self:ClaimReward(fsm)
end

function BingoPassExpiredState:Purchase(fsm)
    self:ClaimReward(fsm)
end

function BingoPassExpiredState:PlayExit(fsm)
    self:ClaimReward(fsm)
end

function BingoPassExpiredState:ClaimReward(fsm)
    UIUtil.show_common_popup(984,true,function()
        if fsm then
            ModelList.BingopassModel:TimeExpired_C2S_RequestBingopassDetail()
            self:ChangeState(fsm,"BingoPassExitState")
        end
    end,function()

    end,nil,nil)
end

function BingoPassExpiredState:ClaimAllReward(fsm)
    UIUtil.show_common_popup(984,true,function()
        if fsm then
            ModelList.BingopassModel:TimeExpired_C2S_RequestBingopassDetail()
            self:ChangeState(fsm,"BingoPassExitState")
        end
    end,function()

    end,nil,nil)
end

return BingoPassExpiredState