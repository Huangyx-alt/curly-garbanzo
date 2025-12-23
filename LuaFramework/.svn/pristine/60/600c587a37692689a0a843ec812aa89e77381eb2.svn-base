--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-03-22 16:45:33
]]

local baseState = require"View.VolcanoMission.State.BaseStateMainView"
local StateMainViewInit = class("StateMainViewInit",baseState)

function StateMainViewInit:OnEnter(fsm)
 
    self.fsm:GetOwner():InitMap()
    self.fsm:GetOwner():InitTopPanelInfo()
    self.fsm:GetOwner():InitBottomPanel()
 
    self.fsm:GetOwner():MoveToStepPos()
    
    
    local model = ModelList.VolcanoMissionModel
    if(model:IsDataChange())then 
        model:InitLevelUpdate()   --初始化动画数据
        self.fsm:GetOwner():InitHead()  --根据数据生成失败npc
        self:ChangeState(self.fsm,"StateMainViewUpdateRound")
    else 

        self.fsm:GetOwner():InitHead()
        if(model:IsFaild())then 
            self:ChangeState(self.fsm,"StateMainViewFaild")
            return 
        end

        if(model:IsFinalStep())then  
            self:ChangeState(self.fsm,"StateMainViewReward")
            return 
        end
        -- self:ChangeState(self.fsm,"StateMainViewOpenBox") 
        --debug 
        self:ChangeState(self.fsm,"StateMainViewIdle")
    end
    
end

 

return StateMainViewInit