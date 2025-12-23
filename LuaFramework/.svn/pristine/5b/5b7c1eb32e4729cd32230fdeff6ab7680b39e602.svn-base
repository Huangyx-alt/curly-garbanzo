--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-03-22 16:45:33
]]

local baseState = require"View.VolcanoMission.State.BaseStateMainView"
local StateMainViewIdle = class("StateMainViewIdle",baseState)--Clazz(baseState,"StateMainViewIdle")
local debug = true 
function StateMainViewIdle:OnEnter(fsm)
    self.fsm:GetOwner():SetScrollTouch(true)
    self.fsm:GetOwner():StopBoxShade()
    local model = ModelList.VolcanoMissionModel
    if(debug)then 
        self:start_x_update()
    end  
    if(model:IsFaild())then 
        self:ChangeState(self.fsm,"StateMainViewRevive") 
        return 
    end 
    if(model:IsLastPrize())then 
        self.fsm:GetOwner():ShowTopInfo()
        model:CleanLastPrizeTag()
        return 
    end 
end

 local cout = 10
function StateMainViewIdle:on_x_update()
        cout = cout - 1 
        if(cout <=0)then 
            cout = 10
            local model = ModelList.VolcanoMissionModel
            
            local isChange ,sourceValue ,newValue = model:IsRoundDataChange()
            if(isChange)then 
                self:ChangeState(self.fsm,"StateMainViewUpdateRound") 
                return 
            end

        end

end

function StateMainViewIdle:OnShowBoxTips(fsm)
 
    local model = ModelList.VolcanoMissionModel
    if(model:isCurStepHasReward() and model:HasBoxBuffer())then   
        self:ChangeState(self.fsm,"StateMainViewOpenBox")  
    else
        Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionTipsView)
       
    end
end

-- function StateMainViewIdle:OnTrigetBuffer(fsm)
 
--     local model = ModelList.VolcanoMissionModel
--     if(model:isCurStepHasReward() and model:HasBoxBuffer())then   
--         self:ChangeState(self.fsm,"StateMainViewOpenBox")  
--     else
--         Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionTipsView)
       
--     end
-- end


function StateMainViewIdle:OnLeave(fsm)
    Facade.SendNotification(NotifyName.CloseUI,ViewList.VolcanoMissionTipsView)
end


function StateMainViewIdle:OnShowGift(fsm)
    -- Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionGiftPackView)
    ModelList.GiftPackModel:ShowVolcanoMissionPack()
end


function StateMainViewIdle:OnCloseGift(fsm)
    local model = ModelList.VolcanoMissionModel
    if(model:isCurStepHasReward() and model:HasBoxBuffer())then  
        model:Login_C2S_UpdateMissionData()
        self:ChangeState(self.fsm,"StateMainViewOpenBox")  
        return  
    end 
end


function StateMainViewIdle:OnShowHelp(fsm)
    Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionHelpView) 
end


function StateMainViewIdle:OnCloseSelf(fsm)
    Facade.SendNotification(NotifyName.CloseUI,ViewList.VolcanoMissionMainView)
end
return StateMainViewIdle