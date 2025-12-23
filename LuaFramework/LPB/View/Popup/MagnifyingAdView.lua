----放大镜广告
---
---
---特殊玩法里面得Item
local MagnifyingAdAdState = require "State/MagnifyingAdView/MagnifyingAdAdState"
local MagnifyingAdWaitCdState = require "State/MagnifyingAdView/MagnifyingAdWaitCdState"
local MagnifyingAdVipState = require "State/MagnifyingAdView/MagnifyingAdVipState"

local MagnifyingAdView =BaseView:New("MagnifyingAdView")

local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_PU_MAGNIFY)

local this = MagnifyingAdView

this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_puad",
    "vipStyle",
    "adStyle",
    "waitCd",
    "vip_txt_dec",
    "vip_txt_price",
    "vip_text_count",
    "ad_txt_ime",
    "cd_txt_time",
    "Anima",   --动画
    "btn_Buy",
    "txt_vipCdTime",
    "vipwaitCd"
}

function MagnifyingAdView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end


function MagnifyingAdView:Awake()
    self:on_init()
end

function MagnifyingAdView:OnEnable()
    self:BuildFsm()
    Facade.RegisterView(this)
    this.Pos = self.go.transform.position
    this.Pos.x =  this.Pos.x + 0.2

end

function MagnifyingAdView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("MagnifyingAdView",self,{
        MagnifyingAdVipState:New(),
        MagnifyingAdAdState:New(),
        MagnifyingAdWaitCdState:New(),
    })
    
    self:changeState()
end

-- 选择使用状态
function MagnifyingAdView:changeState()
    local data = Csv.GetData("advertise",14,"user_type")
    local showAd = false 
    local myLabel = ModelList.PlayerInfoModel:GetUserType()
    myLabel = myLabel or 0

    if data ~=nil then 
        for _,v in pairs(data) do 
            if myLabel == v then 
                showAd = true 
            end 
        end 
    end 
    
    if _watchADUtility:IsAbleWatchAd() ==false then
        showAd =false
    end 

  --  showAd = false  -- 测试专用

    if showAd then 
        --如果有cd，并且cd时间大0 ，就显示cd 
        local nowTime =  ModelList.PlayerInfoModel.get_cur_server_time()
        local cdTime =  ModelList.AdModel:GetMagnifyingTime("MagnifyingTime")
        local interval = Csv.GetData("advertise",14,"frequency_cd")
        
        if nowTime - cdTime > interval then 
            self._fsm:StartFsm("MagnifyingAdAdState")
        else 
            self._fsm:StartFsm("MagnifyingAdWaitCdState") --Magnifying 等待广告时间
        end 
    else 
        self._fsm:StartFsm("MagnifyingAdVipState")
    end 

   
end

--购买礼包状态
function MagnifyingAdView:OnVipState() 
    self.Anima:Play("vipidle")
    --初始化价格
    local data = Csv.GetData("grocery",1)
    
    if data then 
        self.vip_txt_price.text = "$".. data.price
        self.vip_text_count.text = data.item[2][2] or "0"
        self.vip_txt_dec.text = #data.item >=2 and math.ceil(data.item[1][2]/60).."Mins"  or "3s" --时间
    end 

end 

--可看广告
function MagnifyingAdView:OnAdState() 
    self.Anima:Play("adidle")

    --广告的时间读取？
    local data = Csv.GetData("advertise",14,"reward_description")

    if data and type(data) == "table" and #data >0 and #data[1]>=2 then 
        
        self.ad_txt_ime.text = data[1][2] or "s"
    end 
end 

--等待广告时间
function MagnifyingAdView:OnWaitCdState() 
    self.Anima:Play("cdidle")

    --wait时间
    self.cd_txt_time.text = ""
    this.cdTime =0
    --开启定时器
    local nowTime =  ModelList.PlayerInfoModel.get_cur_server_time()
    local cdTime =  ModelList.AdModel:GetMagnifyingTime("MagnifyingTime")
    local interval = Csv.GetData("advertise",14,"frequency_cd")

    if nowTime - cdTime > interval then 
        self._fsm:ChangeState("MagnifyingAdAdState")
    else 
        this.cdTime = interval-(nowTime - cdTime)

        if  this.cdTime >0 then 
            this.TimeLoop = LuaTimer:SetDelayLoopFunction(0, 1,(interval-(nowTime - cdTime)), function()
                self.cd_txt_time.text = this.cdTime.."S"
                this.cdTime = this.cdTime - 1 
            end,function ()
              
                self.cd_txt_time.text = "0S"

                self._fsm:ChangeState("MagnifyingAdAdState")
           
            end,nil,LuaTimer.TimerType.UI)
        else 
            self._fsm:ChangeState("MagnifyingAdAdState")
        end 
       
    end 
end 

function MagnifyingAdView:StopCountdown()
    if this.TimeLoop then
        LuaTimer:Remove(this.TimeLoop)
        this.TimeLoop = nil
    end
    
    if this.TimeLoop2 then 
        LuaTimer:Remove(this.TimeLoop2)
        this.TimeLoop2 = nil
    end 
end

--直接看广告
function MagnifyingAdView:OnBtnAdClick() 
   --看广告领取
    if _watchADUtility:IsAbleWatchAd() then
        _watchADUtility:WatchVideo(self,self.WatchAdCallback,"MagnifyingAd") 
    else
        self._fsm:ChangeState("MagnifyingAdVipState")
    end 
end 

--等待广告时间 点击
function MagnifyingAdView:OnBtnWaitCdClick() 
   --不做处理

end 

--VIP 直接购买
function MagnifyingAdView:OnBtnVipClick()
    --不做处理
    self._fsm:GetCurState():OnBtnVipBuyClick(self._fsm)
end 

--点击事件
function MagnifyingAdView:on_btn_puad_click()
    self._fsm:GetCurState():OnBtnClick(self._fsm)
end

--是否可以看广告
function MagnifyingAdView:IsAbleWatchAd()
    return _watchADUtility:IsAbleWatchAd()
end


function MagnifyingAdView:WatchAdCallback(isBreak)
    if isBreak then
        --清掉cdtime
        ModelList.AdModel:SetMagnifyingTime("MagnifyingTime",0)
    else
       --记录cd
       --转为cdtime 的模式
       Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,this.Pos,Resource.hintTime,function()
            local nowTime = ModelList.PlayerInfoModel.get_cur_server_time()
            ModelList.AdModel:SetMagnifyingTime("MagnifyingTime",nowTime)

            if _watchADUtility:IsAbleWatchAdCount() then 
               
                self._fsm:ChangeState("MagnifyingAdWaitCdState")
            else 
                self._fsm:ChangeState("MagnifyingAdVipState")
            end 

            Event.Brocast(EventName.Event_currency_change)
       end)


    end
end


function MagnifyingAdView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function MagnifyingAdView:on_btn_Buy_click()
    self._fsm:GetCurState():OnBtnVipBuyClick(self._fsm)
end

--富哥买礼包
function MagnifyingAdView:OnVipBuyClick()
    ModelList.MainShopModel.C2S_RequestBuyGrocery(1)  --固定id =1 
   
end

function MagnifyingAdView:OnDisable()
    this:StopCountdown()
    Facade.RemoveView(this)
end

function MagnifyingAdView:OnSuccessBuy(id)
    if not id or id ~= 1 then 
        return 
    end 
    local data = Csv.GetData("grocery",1,"item")
    
    if data then 
        for _,v in pairs(data) do 
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,this.Pos,v[1],function()
                ---切换到
                Event.Brocast(EventName.Event_currency_change)
            end)
        end 
    end 
    self:OnGroceryInfoUpdate()
end

function MagnifyingAdView:OnGroceryInfoUpdate()
    local cd =   Csv.GetData("grocery",1,"buy_cd")
    
    if cd and  cd >0 then 
        this.cdTime = cd
        this.TimeLoop2 = LuaTimer:SetDelayLoopFunction(0, 1,cd, function()
            fun.set_active(self.vipwaitCd,true)
            self.txt_vipCdTime.text = this.cdTime.."S"
            this.cdTime = this.cdTime - 1 
        end,function ()
            fun.set_active(self.vipwaitCd,false)
            self.txt_vipCdTime.text = "0S"
        end,nil,LuaTimer.TimerType.UI)
    end 
end

--转为vip 状态
function MagnifyingAdView:OnGroceryInfoUpdate()
    self._fsm:StartFsm("MagnifyingAdVipState")
end

this.NotifyList = {
  --  {notifyName = NotifyName.Grocery.GroceryBuySuccess,func = this.OnSuccessBuy},
    {notifyName = NotifyName.Grocery.GroceryInfoUpdate,func = this.OnGroceryInfoUpdate},
}

return this