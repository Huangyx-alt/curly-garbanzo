--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-03-22 16:45:33
]]

local baseState = require"View.VolcanoMission.State.BaseStateMainView"
local StateMainViewUpdateRound = class("StateMainViewUpdateRound",baseState)--Clazz(baseState,"StateMainViewUpdateRound")

function StateMainViewUpdateRound:OnEnter(fsm)
    
    local model = ModelList.VolcanoMissionModel
    local isChange ,sourceValue ,newValue = model:IsRoundDataChange()
    if(isChange)then 
        self.fsm:GetOwner():UpdateNewRound(sourceValue,newValue)
    else
        self:ChangeState(self.fsm,"StateMainViewUpdateCollect")
    end

end

function StateMainViewUpdateRound:OnLeave(fsm)

end

function StateMainViewUpdateRound:Complete(fsm) 
    self:ChangeState(self.fsm,"StateMainViewUpdateCollect") 
end
return StateMainViewUpdateRound