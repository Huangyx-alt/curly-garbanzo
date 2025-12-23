local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"
require "View/CommonView/RemainTimeCountDown"
local FunctionIconPigBankView = FunctionIconBaseView:New()
local this = FunctionIconPigBankView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_icon",
    "text_countdown",   --倒计时
    "lpMax",            --最大
    "tipPanel",         --提示面板
    "PigpriceText",
    "PigTextMax",
    "eleTextMax",
    "elepriceText"
}

function FunctionIconPigBankView:New()
    local o = {}
    self.__index = self
    o.remainTimeCountDown = RemainTimeCountDown:New()
    setmetatable(o,self)
    return o
end

function FunctionIconPigBankView:Awake()
    self:on_init()
end

function FunctionIconPigBankView:OnEnable()
    self:RegisterRedDotNode()
    self:RegisterEvent()

end

function FunctionIconPigBankView:OnDisable()
    self.remainTimeCountDown:StopCountDown()
    self:RemoveEvent()
    self:UnRegisterRedDotNode()
end

function FunctionIconPigBankView:RegisterRedDotNode()
  --  RedDotManager:RegisterNode(RedDotEvent.bingopass_reddot_event,"function_bingopass",self.img_reddot)
end

function FunctionIconPigBankView:UnRegisterRedDotNode()
    -- RedDotManager:UnRegisterNode(RedDotEvent.bingopass_reddot_event,"function_bingopass")
end

function FunctionIconPigBankView:on_btn_icon_click()
    --ModelList.BingopassModel:C2S_RequestBingopassDetail()
end

function FunctionIconPigBankView:IsFunctionOpen()
    -- local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    -- local needLevel = Csv.GetLevelOpenByType(10,0)
    return true --nowLevel >= needLevel
end

--是否过期
function FunctionIconPigBankView:IsExpired()
    return true
     
end

function FunctionIconPigBankView:RegisterEvent()
  --  Event.AddListener(EventName.Event_BingoPass_UpdateLevel,self.OnCityResourceChange,self)
end

function FunctionIconPigBankView:RemoveEvent()
 --   Event.RemoveListener(EventName.Event_BingoPass_UpdateLevel,self.OnCityResourceChange,self)
end

function FunctionIconPigBankView:RefreshRedDot()
  --  RedDotManager:Refresh(RedDotEvent.bingopass_reddot_event)
end

function FunctionIconPigBankView:OnCityResourceChange()

end


return this