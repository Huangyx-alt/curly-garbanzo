--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]


local BasePassIconView = class("BasePassIconView",BaseViewEx)
local this = BasePassIconView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

function BasePassIconView:ctor(id,isHallIcon,parentName)
    self.id = id 
    self.isHallIcon = isHallIcon or false 
    self.parentName = parentName or "iconview"
end
 
local this = BasePassIconView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "btn_icon",
    "img_reddot",
    "anima",
    "text_countdown",
    "text_progress", 
    "img_double",
}

require "View/CommonView/RemainTimeCountDown"
local remainTimeCountDown = RemainTimeCountDown:New()
function BasePassIconView:GetModel()
    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(self.id)
    return model 
end

function BasePassIconView:SetCoutDown(time)
    remainTimeCountDown:StartCountDown(CountDownType.cdt2,time,self.text_countdown,function()
         --TODO
    end)
end


function BasePassIconView:SetProgress()
    
        local curr,target =ModelList.GameActivityPassModel.GetIconProgress()
        self.text_progress.text = string.format("%s/%s",curr,target)
     
end

function BasePassIconView:DisableClickEvent()
    self.isClick = false 
end

function BasePassIconView:Awake()
    self:on_init()
end

function BasePassIconView:OnEnable()
     self:RegisterRedDotNode()
     self:RegisterEvent()
     
     self:SetRewardPos()
     self:UpdateDoubleBuffState()
end

function BasePassIconView:GetBuffId()
    return 0
end

function BasePassIconView:UpdateDoubleBuffState()
    log.log("BasePassIconView:UpdateDoubleBuffState 1")
    if fun.is_null(self.img_double) then
        return
    end

    fun.set_active(self.img_double, false)
    local buffId = self:GetBuffId()
    log.log("BasePassIconView:UpdateDoubleBuffState 2", buffId)
    if not buffId or buffId == 0 then
        return
    end

    local expireTime = ModelList.ItemModel:GetItemNumById(buffId)
    local curTime = ModelList.PlayerInfoModel.get_cur_server_time()
    local remainTime = math.max(0, expireTime - curTime)
    fun.set_active(self.img_double, remainTime > 0)
    self:SetBuffLeftTime(remainTime)

    log.log("BasePassIconView:UpdateDoubleBuffState 3", remainTime, expireTime, curTime)
end

function BasePassIconView:SetBuffLeftTime(remainTime)
    self.buffLeftTime = remainTime
    self:ClearBuffLoopTimer()
    if self.buffLeftTime > 0 then
        self.buffLoopTimer = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            --[[
            if self.left_time_txt then
                self.left_time_txt.text = fun.SecondToStrFormat(self.buffLeftTime)
            end
            --]]

            self.buffLeftTime = self.buffLeftTime - 1
            if self.buffLeftTime <= 0 then
                self:UpdateDoubleBuffState()
            end
        end, nil, nil, LuaTimer.TimerType.UI)
    end
end

function BasePassIconView:ClearBuffLoopTimer()
    if self.buffLoopTimer  then
        LuaTimer:Remove(self.buffLoopTimer)
        self.buffLoopTimer = nil
    end
end


function BasePassIconView:SetRewardPos() 
    if(not self.isHallIcon)then 
       ModelList.GameActivityPassModel.SetIconPos(self:GetPos(),false)
    end
end
function BasePassIconView:CleanRewardPos() 
    if(not self.isHallIcon)then 
       ModelList.GameActivityPassModel.SetIconPos(nil,false)
    end
end


function BasePassIconView:OnDisable()
    self:UnRegisterRedDotNode()
    self:UnRegisterEvent() 
    self:CleanRewardPos()
    self:ClearBuffLoopTimer()
end


function BasePassIconView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.game_pass_reddot_event,"game_pass_icon"..self.parentName,self.img_reddot)
end

function BasePassIconView:UnRegisterRedDotNode() 
    RedDotManager:RegisterNode(RedDotEvent.game_pass_reddot_event,"game_pass_icon"..self.parentName,self.img_reddot)
end

function BasePassIconView:RegisterEvent()
    Facade.RegisterViewEnhance(self)
    Event.AddListener(EventName.Event_items_change, self.OnItemsChange, self)
end

function BasePassIconView:OnItemsChange(params)
    --Event.Brocast(EventName.Event_items_change,{items = value, type = key})
    if not params then
        return
    end

    if params.type == 31 then --ITEMS_TYPE.ITEMS_TYPE_SPECIAL_GAME_BUFF
        self:UpdateDoubleBuffState()
    end
end

function BasePassIconView:UnRegisterEvent()
    Facade.RemoveViewEnhance(self)
    Event.RemoveListener(EventName.Event_items_change, self.OnItemsChange, self)
end
 

function BasePassIconView:GetPos()
    return fun.get_gameobject_pos(self.go,false)
end


function BasePassIconView:on_btn_icon_click()
    if(self.isClick==false)then 
        return 
    end

    if not CmdCommonList.CmdEnterCityPopupOrder.IsFinish() then
        return 
    end  
     --Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassView")
    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassTaskView")
end

this.NotifyEnhanceList = {
    {notifyName = NotifyName.GamePlayShortPassView.UpdateExpInfo, func = this.SetProgress},
    
}



return this 