
local RouletteFree = require "View/Roulette/RouletteFree"
local RouletteFee = require "View/Roulette/RouletteFee"

local RouletteView = BaseView:New("SpinRewardView","RouletteAtlas")
local this = RouletteView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local childView = nil
this.isCleanRes = true
this.auto_bind_ui_items = {
    "spinOrdinary",
    "spinFee",
    "anima",
}

function RouletteView:Awake(obj)
    self:on_init()
end

function RouletteView:OnEnable(params)
    Facade.RegisterView(self)
    local isFee = ModelList.RouletteModel:IsFeeAvailable(true)
    if isFee then
        self:SetFeeStyle()
    else
        self:SetFreeStyle()
    end
end

function RouletteView:OnDisable()
    Facade.RemoveView(self)
    ModelList.RouletteModel:ResetRouletteInfo()
    Event.Brocast(EventName.Event_popup_roulette_finish)
    childView = nil
end

function RouletteView:SetFreeStyle()
    fun.set_active(self.spinOrdinary.transform,true)
    fun.set_active(self.spinFee.transform,false)
    childView = RouletteFree:New("RouletteFree")
    childView:SkipLoadShow(self.spinOrdinary,true,nil,{super = self,isFromFree = false})
end

function RouletteView:SetFeeStyle(isFromFree)

    if fun.get_active_self(self.spinFee.transform) then 
        return
    end 

    fun.set_active(self.spinFee.transform,true)
    childView = RouletteFee:New("RouletteFee")
    childView:SkipLoadShow(self.spinFee,true,nil,{super = self,isFromFree = isFromFree})
end

function RouletteView:PlayFreeEnter(callback)
    AnimatorPlayHelper.Play(self.anima,{"free_in","SpinRewardfreeenter"},false,function()
        if callback then
            callback()
        end
    end)
end

function RouletteView:PlayVipEnter(callback)
    AnimatorPlayHelper.Play(self.anima,{"VIP_in","SpinRewardVIPin"},false,function()
        if callback then
            callback()
        end
    end)
end

function RouletteView:PlayChange2Vip(callback)
    AnimatorPlayHelper.Play(self.anima,{"vip_enter","SpinRewardVIPenter"},false,function()
        fun.set_active(self.spinOrdinary.transform,false)
        if callback then
            callback()
        end
    end)
end

function RouletteView:PlayVipExit(callback)
    if childView then
        childView:PlayButtonExit()
    end
    UISound.play("turntable_upgrade")
    AnimatorPlayHelper.Play(self.anima,{"VIP_end","SpinRewardVIPend"},false,function()
        if callback then
            callback()
        end
    end)
end

function RouletteView:PlayFreeSpin()
    AnimatorPlayHelper.Play(self.anima,{"free_spin","SpinRewardfreespin"},false,function()
        
    end)
end

function RouletteView:PlayFreeShowReward()
    AnimatorPlayHelper.Play(self.anima,{"free_win","SpinRewardfreewin"},false,function()
        UISound.play("turntable_win")
    end)
end

function RouletteView:PlayFeeSpin()
    AnimatorPlayHelper.Play(self.anima,{"VIP_spin","SpinRewardVIPspin"},false,function()
       
    end)
end

function RouletteView:PlayFeeShowReward()
    AnimatorPlayHelper.Play(self.anima,{"VIP_win","SpinRewardVIPwin"},false,function()

    end)
end

function RouletteView:PlayRouletteIdle()
    if fun.get_active_self(self.spinFee.transform) then -- 付费转盘，断线重连发生异常退出
        Facade.SendNotification(NotifyName.Roulette.ExitRoulette,true)
        return
    end 
    AnimatorPlayHelper.Play(self.anima,{"free_idle","SpinRewardfreeidle"},false,function()

    end)
end

function RouletteView:PlayChange2FeeStyle()
    AnimatorPlayHelper.Play(self.anima,{"VIP_idle","SpinRewardVIPidle"},false,function()

    end)
end

return this