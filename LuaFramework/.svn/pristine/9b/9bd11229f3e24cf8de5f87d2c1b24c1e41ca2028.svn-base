--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-03-22 16:45:33
]]

local baseState = require"View.VolcanoMission.State.BaseStateMainView"
local StateMainViewOpenBox = class("StateMainViewOpenBox",baseState)--Clazz(baseState,"StateMainViewOpenBox")

function StateMainViewOpenBox:OnEnter(fsm)
    self.isUpdate = false 
    self.isRecBuffer  = false 
    self.isRewardEnd = false 
    local model = ModelList.VolcanoMissionModel
    if(model:isCurStepHasReward())then   
        if(model:HasBoxBuffer())then  
            self:start_x_update()
            model:Login_C2S_UpdateMissionData()
            self.isRecBuffer = true 
            Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionOpenBoxView)
            return 
        end
        -- if(true)then  
        if(model:IsShowBoxTips())then  
            Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionTipsView)
            return 
        end
        self.buyPropSuccess = false 
        self:ChangeState(self.fsm,"StateMainViewReward")
    else
        self:ChangeState(self.fsm,"StateMainViewReward")
    end
end

--[[
    @desc: 购买礼包过程
    author:{author}
    time:2024-04-09 16:52:26
    --@fsm: 
    @return:
]]
function StateMainViewOpenBox:OnTrigetBuffer(fsm)
    local model = ModelList.VolcanoMissionModel 
    self.isRecBuffer = true 
    model:Login_C2S_UpdateMissionData()
    self:start_x_update()
    if(model:HasBoxBuffer() and model:isCurStepHasReward())then  
        Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionOpenBoxView)
        return 
    else 
       
    end 
   
end



function StateMainViewOpenBox:OnRewardEnd(fsm)
    self.isRewardEnd = true 
    if(self.isRecBuffer )then 
      
    else
        local model = ModelList.VolcanoMissionModel
        model:SetCurBoxPos()
        self:ChangeState(self.fsm,"StateMainViewReward")
    end
end


-- function StateMainViewOpenBox:OnBuyBuffer(fsm)
--     self.buyPropSuccess = true 
--     self:start_x_update()
-- end

function StateMainViewOpenBox:OnUpdateData(fsm)
    self.isUpdate = true 
    local model = ModelList.VolcanoMissionModel
    model:UpdateData()--将数据覆盖
    model:SetCurBoxPos()
end

function StateMainViewOpenBox:on_x_update()
    if(self.isUpdate and self.isRewardEnd )then 
        self.isUpdate = false 
        self:stop_x_update()
        self:Complete()
        self:ChangeState(self.fsm,"StateMainViewReward")
    end
end





function StateMainViewOpenBox:OnCloseGift(fsm)
    local model = ModelList.VolcanoMissionModel
    if(model:isCurStepHasReward() and model:HasBoxBuffer())then  
        Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionOpenBoxView)
        return 
    else
        self:ChangeState(self.fsm,"StateMainViewReward")
    end 
end

function StateMainViewOpenBox:Complete(fsm)
    
end



return StateMainViewOpenBox