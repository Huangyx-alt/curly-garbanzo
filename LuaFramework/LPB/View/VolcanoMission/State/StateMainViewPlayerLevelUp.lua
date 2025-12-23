--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-03-22 16:45:33
]]

local baseState = require"View.VolcanoMission.State.BaseStateMainView"
local StateMainViewPlayerLevelUp = class("StateMainViewPlayerLevelUp",baseState)Clazz(baseState,"StateMainViewPlayerLevelUp")




function StateMainViewPlayerLevelUp:OnEnter(fsm)
    local model = ModelList.VolcanoMissionModel
    self.nextStep = model:GetLevelUpTarget()
    self.fsm:GetOwner():JumpNextStep(self.nextStep)
end


 


function StateMainViewPlayerLevelUp:OnLeave(fsm)


end

function StateMainViewPlayerLevelUp:Complete(fsm)
    ModelList.VolcanoMissionModel:RefreshLevelUpdate(self.nextStep)
    if ModelList.VolcanoMissionModel:IsLevelUp() then
        --local model = ModelList.VolcanoMissionModel
        --model:UpdateData()--将数据覆盖
        self:ChangeState(self.fsm,"StateMainViewUpdateCollect")
    else
        local model = ModelList.VolcanoMissionModel
        model:UpdateData()--将数据覆盖
        self:ChangeState(self.fsm,"StateMainViewOpenBox")
    end
end
return StateMainViewPlayerLevelUp