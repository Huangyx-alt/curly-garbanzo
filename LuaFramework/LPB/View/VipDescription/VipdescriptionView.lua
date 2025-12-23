VipdescriptionView = BaseView:New('VipdescriptionView',"VipAtlas");

local sliderView =  require("View.VipDescription.VipDescriptionSliderItem")

local this = VipdescriptionView;
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.auto_bind_ui_items = {
    "vipIcon11",
    "vipIcon12",
    "vipIcon21",
    "vipIcon22",
    "vipIcon31",
    "vipIcon32",
    "btn_collect",
    "clone",
    "anima",
    "vipSliderView",
    "VipMax",
    "tipView",
    "text_tip",
    "btn_bg",
}
local MaxVipLv = 0
local CurrVipLv = 0
local benefitRow ={}

function VipdescriptionView.Awake(obj)
    --this.update_x_enabled = true
    this:on_init()
end

function VipdescriptionView.OnEnable()
    MaxVipLv = #Csv.vip
    CurrVipLv = ModelList.PlayerInfoModel:GetVIP()
    --this:SetVipInfo()
    this:SetBenefitsTitle()
    this:SetBenefits()
    --local sliderViewIns = sliderView:New()
    sliderView:SkipLoadShow(this.vipSliderView)
    --sliderView:Init(this.vipSliderView)
    sliderView:SetVipInfo(this.SetMaxVipDes)
end

function VipdescriptionView.SetMaxVipDes()
    fun.set_active(this.VipMax,true)
end


function VipdescriptionView:SetVipInfo()
    CurrVipLv = ModelList.PlayerInfoModel:GetVIP()
    --local vipPts = ModelList.PlayerInfoModel:GetVipPts()
    --
    --local vipInfo = Csv.GetData("vip",CurrVipLv)
    --this:SetVipIcon(CurrVipLv,this.currVipIcon,this.currVipLevel)
    --if CurrVipLv < MaxVipLv then
    --    this:SetVipIcon(CurrVipLv+1,this.nextVipIcon,this.nextVipLevel)
    --     local progress = vipPts/vipInfo.exp
    --    this.Slider.value = progress
    --    this.sliderText.text =  fun.format_percent(progress)
    --else
    --    this.Slider.value = 1
    --    this.sliderText.text = "MAX"
    --    this:SetVipIcon(CurrVipLv,this.nextVipIcon,this.nextVipLevel)
    --end
end

function VipdescriptionView:SetBenefitsTitle()
    benefitRow = {}
    if CurrVipLv< MaxVipLv-1 then
        benefitRow = {CurrVipLv,CurrVipLv+1,CurrVipLv+2}
    elseif CurrVipLv  == MaxVipLv then
        benefitRow = {CurrVipLv,-1,-1}
    else
        benefitRow = {CurrVipLv,MaxVipLv,-1}
    end
    for i = 1, 3 do
        if benefitRow[i] ~= -1 then
            local vipInfo = Csv.GetData("vip", benefitRow[i])
            this["vipIcon" .. i .. "2"].sprite = AtlasManager:GetSpriteByName("VipAtlas", "VipNub" .. benefitRow[i])
            this["vipIcon" .. i .. "1"].sprite = AtlasManager:GetSpriteByName("VipAtlas", vipInfo.icon)
        else
            fun.set_active(this["vipIcon"..i.."1"].gameObject,false)
            fun.set_active(this["vipIcon"..i.."2"].gameObject,false)
        end
    end
end


function VipdescriptionView:SetBenefits()
    local VipDescriptionItem = require("View.VipDescription.VipDescriptionItem")
    for key,value in pairs(Csv.vip_description) do
        local item = VipDescriptionItem.New()
        local cc = fun.get_instance(this["clone"],this.clone.transform.parent)
        fun.set_active(cc,true)
        item:Init(cc, this)
        item:SetData(value,benefitRow)
    end
    fun.set_recttransform_native_height(this.clone.transform.parent,100*#Csv.vip_description)
end

--function VipdescriptionView:on_x_update()
--end

function VipdescriptionView.OnDisable()
    --Facade.RemoveView(this)
end


function VipdescriptionView.OnDestroy()
    this:Destroy()
end



function VipdescriptionView:on_btn_collect_click()
    this.anima:Play("out")
    LuaTimer:SetDelayFunction(0.5,function()
        Facade.SendNotification(NotifyName.CloseUI, ViewList.VipdescriptionView)
    end,nil,LuaTimer.TimerType.UI)
end

function VipdescriptionView:on_btn_bg_click()
    fun.set_active(this.tipView,false)
end


function VipdescriptionView:ShowHelpInfo(icon,descriptionId)
    if this.tipView then
        fun.set_same_position_with(this.tipView,icon)
        this.text_tip.text = Csv.GetData("description",descriptionId,"description")
        fun.set_active(this.tipView,true)
    end
end

return this




