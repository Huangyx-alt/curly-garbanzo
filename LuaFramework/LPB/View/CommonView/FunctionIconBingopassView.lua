local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"
require "View/CommonView/RemainTimeCountDown"
local FunctionIconBingopassView = FunctionIconBaseView:New()
local this = FunctionIconBingopassView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_task",
    "slider_text",
    "img_reddot",
    "anima",
    "text_countdown",
    "text_day",
    "lpMax",
    "FunctionShowTipView"
}

this.shwoTipTime = -5

function FunctionIconBingopassView:New()
    local o = {}
    self.__index = self
    o.remainTimeCountDown = RemainTimeCountDown:New()
    setmetatable(o,self)
    return o
end

function FunctionIconBingopassView:Awake()
    self:on_init()
end

function FunctionIconBingopassView:OnEnable()
    self:RegisterRedDotNode()
    self:RegisterEvent()
    fun.set_active(self.text_day,false)
    self:refreshSlider()
end

function FunctionIconBingopassView:OnDisable()
    self.remainTimeCountDown:StopCountDown()
    self:RemoveEvent()
    self:UnRegisterRedDotNode()
end

function FunctionIconBingopassView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.bingopass_reddot_event,"function_bingopass",self.img_reddot)
end

function FunctionIconBingopassView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.bingopass_reddot_event,"function_bingopass")
end

function FunctionIconBingopassView:on_btn_task_click()
    ModelList.BingopassModel:C2S_RequestBingopassDetail()
end

function FunctionIconBingopassView:IsFunctionOpen()
    -- local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    -- local needLevel = Csv.GetLevelOpenByType(10,0)
    -- return nowLevel >= needLevel

    return ModelList.BingopassModel:IsSeasonOpen()
end

--是否过期
function FunctionIconBingopassView:IsExpired()
    local flag = false 
    local level  = ModelList.BingopassModel:GetLevel()
    local level_max = Csv.GetData("season_pass",level,"level_max")
    if level_max == 1 then 
        flag =  ModelList.BingopassModel:IsGetAllPayReceived(level)
    end
    flag = flag or (ModelList.BingopassModel:GetRemainTime() <= 1)
    return not (ModelList.BingopassModel:IsBingoPassActivate() or flag)
end

function FunctionIconBingopassView:refreshSlider()
    self:SetProgress()
   
    if self.remainTimeCountDown:IsWorking() then
        self.remainTimeCountDown:UpdateRemainTime(ModelList.BingopassModel:GetRemainTime())
    else
        local des_text = Csv.GetData("description",30107,"description")
        local refer = fun.get_component(self.FunctionShowTipView, fun.REFER)
        refer:Get("text_tip").text = des_text
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown:StartCountDown(CountDownType.cdt2,ModelList.BingopassModel:GetRemainTime(),self.text_countdown,function()
            -- self:Hide()
            ModelList.BingopassModel:TimeExpired_C2S_RequestBingopassDetail()
            Facade.SendNotification(NotifyName.CloseUI,ViewList.FunctionShowTipView)
          end,function()
            local dealTime =  ModelList.BingopassModel:GetRemainTime()
            local saleflag = ModelList.BingopassModel:IsSaleTime()
            if self.text_day.gameObject.activeSelf == false then 
                if dealTime < 86400 then 
                    fun.set_active(self.text_day,true)
                end 
            end 

            --计算折扣时间
            if saleflag then 
                if this.shwoTipTime >-5 then 
                    this.shwoTipTime =this.shwoTipTime -1
                    if this.shwoTipTime<0 then 
                        fun.set_active(self.FunctionShowTipView,false)
                    end 
                else 
                    self:Showtip()
                end 
            end
      
          end)
    end
end 

function FunctionIconBingopassView:RegisterEvent()
    Event.AddListener(EventName.Event_BingoPass_ErrorActivity, self.PassDataError, self)
    Event.AddListener(EventName.Event_BingoPass_UpdateActivity, self.refreshSlider, self)
    Event.AddListener(EventName.Event_BingoPass_UpdateLevel,self.OnCityResourceChange,self)
end

function FunctionIconBingopassView:RemoveEvent()
    Event.RemoveListener(EventName.Event_BingoPass_ErrorActivity, self.PassDataError, self)
    Event.RemoveListener(EventName.Event_BingoPass_UpdateActivity, self.refreshSlider, self)
    Event.RemoveListener(EventName.Event_BingoPass_UpdateLevel,self.OnCityResourceChange,self)
end

function FunctionIconBingopassView:PassDataError()
    log.log("数据有误 关闭图标")
    self:Hide()
end

function FunctionIconBingopassView:SetProgress()
    local level  = ModelList.BingopassModel:GetLevel()
    local totalexp  = Csv.GetData("season_pass",level + 1,"exp")--从0级开始的
    local level_max = Csv.GetData("season_pass",level,"level_max")
end

function FunctionIconBingopassView:RefreshRedDot()
    RedDotManager:Refresh(RedDotEvent.bingopass_reddot_event)
end

function FunctionIconBingopassView:OnCityResourceChange()
    log.w("FunctionIconBingopassView =>OnCityResourceChange")

    self:SetProgress()
    self:RefreshRedDot()
end

function FunctionIconBingopassView:Showtip()
   
    
    fun.set_active(self.FunctionShowTipView,true)
    this.shwoTipTime = 5
end 


return this