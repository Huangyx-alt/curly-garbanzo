--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-03-22 16:45:33
]]


local baseState = require"View.VolcanoMission.State.BaseStateMainView"
local StateMainViewFaild =  class("StateMainViewFaild",baseState)--Clazz(baseState,"StateMainViewFaild")

function StateMainViewFaild:OnEnter(fsm)


    self.fsm:GetOwner():register_timer(0.1,function()
        --如果进地图时，触发 不间隔取的目标地址会有问题，这里间隔一下
        local model = ModelList.VolcanoMissionModel
        --local nextStep = model:GetCurStepId()+1
        self.fsm:GetOwner():JumpFaild()
    end)
end

function StateMainViewFaild:OnLeave(fsm)
    
end

function StateMainViewFaild:Complete(fsm)
    self:ChangeState(self.fsm,"StateMainViewRevive")
end

return StateMainViewFaild


