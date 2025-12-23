--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-03-22 16:45:33
]]

local baseState = require"View.VolcanoMission.State.BaseStateMainView"
local StateMainViewRevive = class("StateMainViewRevive",baseState)--Clazz(baseState,"StateMainViewRevive")

function StateMainViewRevive:OnEnter(fsm) 
    local model = ModelList.VolcanoMissionModel  
    local canRevive = model:CanRelive()
    local cfg = model:GetReliveCfg() 
    self.usePropSuccess = false 
    self.isUpdate = false 
    self.isGiveUp = false 
    if(cfg==nil or canRevive==false )then  
       self:OnGiveUP()
    else
        Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionRevivalView) 
    end

end


function StateMainViewRevive:OnGiveUP(fsm)


    if( self.isGiveUp)then 
        return 
    end
    self.isGiveUp = true 
    local showTime = 2
    self.fsm:GetOwner():run_coroutine(function()
        UISound.play("missionout")
        self.fsm:GetOwner():SetTopVisiable(true) 
        self.fsm:GetOwner():SetFaildInfo() 
        self.fsm:GetOwner():ShowContinueClcik()
        --coroutine.wait(showTime)
        --Facade.SendNotification(NotifyName.CloseUI,ViewList.VolcanoMissionMainView)
        --ModelList.VolcanoMissionModel:C2S_PlayeMatch()
    end) 
   
 
end


function StateMainViewRevive:OnReviveSuccess(fsm)

        self.usePropSuccess = true 
        self:start_x_update()
end


function StateMainViewRevive:OnUpdateData(fsm)
    self.isUpdate = true 
    local model = ModelList.VolcanoMissionModel
    model:UpdateData()--将数据覆盖
end


function StateMainViewRevive:on_x_update()
    if(self.isUpdate  and self.usePropSuccess )then 
        self.isUpdate = false 
        self.usePropSuccess = false 
        self:stop_x_update()
        self:Complete()
    end
end


function StateMainViewRevive:Complete(fsm)
    local model = ModelList.VolcanoMissionModel

    if(model:IsFaild())then 
        --close self
        --self.fsm:GetOwner():Close()
        -- Facade.SendNotification(NotifyName.ShowUI, ViewList.VolcanoMissionStartView) 
        --ModelList.VolcanoMissionModel:C2S_PlayeMatch()
        self.fsm:GetOwner():ShowContinueClcik()
    else
        UISound.play("missionrevival")
        --刷新数据 
        self.fsm:GetOwner():InitMap()
        self.fsm:GetOwner():InitTopPanelInfo()
        self.fsm:GetOwner():InitBottomPanel()
        self.fsm:GetOwner():InitHead()
        self.fsm:GetOwner():MoveToStepPos() 
        self.fsm:GetOwner():PlayOwnerRevival()  --播放复活动画
        self:ChangeState(self.fsm,"StateMainViewIdle")
    end
end





return StateMainViewRevive