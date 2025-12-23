--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-03-22 16:45:33
]]

local baseState = require"View.VolcanoMission.State.BaseStateMainView"
local StateMainViewReward = class("StateMainViewReward",baseState)--Clazz(baseState,"StateMainViewReward")

function StateMainViewReward:OnEnter(fsm)
    local model = ModelList.VolcanoMissionModel
    if(model:IsFinalStep())then  

        self.fsm:GetOwner():JumpNextStep(model:GetCurstepCount())

        --Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionRewardView)
    else
        self:ChangeState(self.fsm,"StateMainViewIdle")
    end
end

function StateMainViewReward:OnLeave(fsm)
    self.fsm:GetOwner():UpdateBoxState(true)
end




function StateMainViewReward:OnRewardEnd(fsm)
    Facade.SendNotification(NotifyName.CloseUI,ViewList.VolcanoMissionMainView)  
    ModelList.VolcanoMissionModel:CleanShowBoxTips()
    ModelList.VolcanoMissionModel:C2S_PlayeMatch()
    ModelList.VolcanoMissionModel:SaveLastPrizeTag()
end


function StateMainViewReward:Complete(fsm)
    self.fsm:GetOwner():SetSuccessInfo()
    Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionRewardView)
end

return StateMainViewReward