local WinZoneEntrance = {}
local DownloadUtility = require "View/CommonView/DownloadUtility"
local _DownloadUtility = DownloadUtility:New()

function WinZoneEntrance:OnEnable(btn)
    self.btn = btn
    self.refer = fun.get_component(btn.gameObject, fun.REFER)
    self.text_timer = self.refer:Get("text_timer")
    self.img_claim = self.refer:Get("img_claim")
    self.buffer_img = self.refer:Get("buffer_img")
    
    self:CheckOpen()
    self:CheckBuff()

    Event.AddListener(EventName.Event_WinZone_Item_Buff, self.CheckBuff, self)
end

function WinZoneEntrance:OnDisable()
    Event.RemoveListener(EventName.Event_WinZone_Item_Buff, self.CheckBuff, self)
end

function WinZoneEntrance:OnDestroy()
    if self.openTimer then
        self.openTimer:StopCountDown()
        self.openTimer = nil
    end
end

function WinZoneEntrance:CheckOpen()
    --local isOpen = ModelList.HallofFameModel:IsActivityAvailable()
    --fun.set_active(self.img_claim, isOpen)
    fun.set_active(self.text_timer, false)
    
    --if not isOpen and not self.openTimer then
    --    local remainOpenTime = ModelList.HallofFameModel:GetTimeToNextOpen()
    --    self.openTimer = RemainTimeCountDown:New()
    --    self.openTimer:StartCountDown(CountDownType.cdt2, remainOpenTime, self.text_timer, function()
    --        self:CheckOpen()
    --        self:CheckBuff()
    --    end)
    --end
end

function WinZoneEntrance:CheckBuff()
    local isOpen = ModelList.HallofFameModel:IsActivityAvailable()
    local remainBuffTime = ModelList.WinZoneModel:GetDoubleBuffRemainTime()
    fun.set_active(self.buffer_img, isOpen and remainBuffTime > 0)
end

function WinZoneEntrance:OnClick()
    if not CmdCommonList.CmdEnterCityPopupOrder.IsFinish() then
        return
    end
    if not _DownloadUtility:NewNode(14, self.btn) then
        return
    end
    if not CityHomeScene:CanClickIcon() then
        return
    end

    --local isOpen = ModelList.HallofFameModel:IsActivityAvailable()
    --if not isOpen then
    --    local remainOpenTime = ModelList.HallofFameModel:GetTimeToNextOpen()
    --    if remainOpenTime > 0 then
    --        local formatText = self:GetFormatTime(remainOpenTime)
    --        UIUtil.show_common_popup(1933, true, nil, nil, formatText)
    --        return
    --    else
    --        return
    --    end
    --end
    
    if not ModelList.WinZoneModel:IsVipLevelEnough() then
        UIUtil.show_common_popup(8039, true)
    elseif not ModelList.WinZoneModel:IsPlayerLevelEnough() then
        UIUtil.show_common_popup(8038, true)
    else
        if ModelList.WinZoneModel.CheckHasRewardAndCannotRelive() then
            return
        end
        ModelList.BattleModel.RequireModuleLua("WinZone")
        ---检查winzone是否正在进行中
        if self:Check_WinZone_Need_Open() then
            local winzoneView = require("View/WinZone/WinZoneInPropgressView")
            Facade.SendNotification(NotifyName.ShowUI, winzoneView:New())
            return
        end
        local winzoneView = require("View/WinZone/WinZoneHelperView")
        Facade.SendNotification(NotifyName.ShowUI, winzoneView:New())
    end
    SDK.BI_Event_Tracker("click_victorybeats", { vip_level = ModelList.PlayerInfoModel:GetVIP() })
end

function WinZoneEntrance:Check_WinZone_Need_Open()
    if ModelList.WinZoneModel:IsActivityValid() and ModelList.WinZoneModel:ShouldGotoGameHall() then
        return true
    end
    return false
end

function WinZoneEntrance:GetFormatTime(time)
    local formatText
    
    local t = math.floor(time/60/60/24/30)
    if t > 0 then
        formatText = string.format("%smonth",t)
    else
        t = time/60/60/24
        if t > 1 then
            local t2 = math.floor(time/60/60%24)
            formatText = string.format("%sd:%sh",math.floor(t),t2)
        else
            t = math.floor(time/60/60)
            if t > 0 then
                local t2 = math.floor(time/60%60)
                formatText = string.format("%sh:%sm",t,t2)
            else
                formatText = string.format("%02d:%02d",math.floor(time/60),math.floor(time%60))
            end
        end
    end
    
    return formatText
end

return WinZoneEntrance