--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-03-22 16:45:33
]]

local baseState = require"View.VolcanoMission.State.BaseStateMainView"
local StateMainViewUpdateCollect = class("StateMainViewUpdateCollect",baseState) 

function StateMainViewUpdateCollect:OnEnter(fsm)
    log.e("StateMainViewUpdateCollect:OnEnter")
    local model = ModelList.VolcanoMissionModel
    local isChange ,sourceValue ,newValue ,count= model:IsCollectChange()
    self.fsm:GetOwner():SetScrollTouch(false)
      if(isChange)then
        self.fsm:GetOwner():UpdateNewProgress(sourceValue,newValue,count,self:IsFull())
    else
        self:GotoNextState() 
    end
end


function StateMainViewUpdateCollect:IsFull()
    
    local model = ModelList.VolcanoMissionModel 
    return model:IsFinalStep()==false and  model:IsLevelUp() or model:IsFinalStep()
end

function StateMainViewUpdateCollect:GotoNextState(fsm)
    local model = ModelList.VolcanoMissionModel
    if(model:IsFaild())then 
        self:ChangeState(self.fsm,"StateMainViewFaild")
        return
    end


   
    if(model:IsLevelUp())then 
        self:ChangeState(self.fsm,"StateMainViewPlayerLevelUp")
        return 
    end  
    if(model:IsFinalStep())then  
        self:ChangeState(self.fsm,"StateMainViewReward")
        return 
    end

    --不走以上流程，则要更新数据
    model:UpdateData()--将数据覆盖
    self:ChangeState(self.fsm,"StateMainViewIdle")
end

function StateMainViewUpdateCollect:OnLeave(fsm)
    self.fsm:GetOwner():SetScrollTouch(true)
end



function StateMainViewUpdateCollect:Complete(fsm)
    self:GotoNextState()
end
return StateMainViewUpdateCollect