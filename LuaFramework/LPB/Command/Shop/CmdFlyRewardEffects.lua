FlyRewardType = { Gems = 1, Coin = 2, Lens = 3, PlayerExp = 5, Rocket = 9, VipExp = 10,WinZoneMusic =33, CardFree = 6005,
                  JokerGems = 7001, JokerCoin = 7002, JokerRocket = 7003, TournamentSprintBuff1 = 1051, TournamentSprintBuff2 = 1052}

local Command = {}

local promote_count = 0
local have_vip = false

---@param flyType  : int
---@param callback : function
---@param icon : GameObject
---@param promoteTopView : boolean
function Command.Execute(notifyName, ...)
    local param, flyType, callback, icon, promoteTopView, flyTargetPos = select(1, ...)
    have_vip = false
    local callback_fun = function()
        if callback then
            callback()
        end
        promote_count = math.max(0, promote_count - 1)
        if promoteTopView and promote_count == 0 then
            local coroutine_fun = function()
                coroutine.wait(1)
                if have_vip then
                    while not Command.GetVipSliderComplete() do
                        coroutine.wait(1)
                    end
                end
                have_vip = false
                local currency = GetTopCurrencyInstance()
                if currency and currency.Exit then --这里只是解决了报错问题，
                    currency:Exit()
                end
            end
            coroutine.resume(coroutine.create(coroutine_fun))
        end
    end
    if promoteTopView then
        local currency = GetTopCurrencyInstance()
        if currency and promote_count == 0 then
            promote_count = 1
        end
        promote_count = math.max(promote_count, 0)
        if promote_count == 0 then
            --ViewList.TopConsolePromoteView:Show(nil, nil)
            ViewList.TopConsoleView:Show(nil, nil)
        end
        promote_count = promote_count + 1
    end
    if type(flyType) == "table" then
        log.r("CmdFlyRewardEffects type(flyType) is table, 目前对此类型的支持可能存在问题")
        for key, value in pairs(flyType) do
            Command.ShowView(value, param, callback_fun, icon, flyTargetPos)
        end
    else
        Command.ShowView(flyType, param, callback_fun, icon, flyTargetPos)
    end
end

function Command.ShowView(viewType, param, callback, icon, flyTargetPos)
    local FlyItemView = nil
    local view = nil
    local viewInstance = nil

    if viewType == FlyRewardType.Coin then
        FlyItemView = require "View/FlyRewardEffectsView/FlyCoinEffectsView"
        view = FlyItemView:New()
    elseif viewType == FlyRewardType.Gems then
        FlyItemView = require "View/FlyRewardEffectsView/FlyGemsEffectsView"
        view = FlyItemView:New()
    elseif viewType == FlyRewardType.Lens then
        FlyItemView = require "View/FlyRewardEffectsView/FlyItemEffectsView"
        view = FlyItemView:New()
    elseif viewType == FlyRewardType.VipExp then
        FlyItemView = require "View/FlyRewardEffectsView/FlyVipExpEffectsView"
        view = FlyItemView:New()
        have_vip = true
    elseif viewType == FlyRewardType.Rocket then
        FlyItemView = require "View/FlyRewardEffectsView/FlyRocketEffectsView"
        view = FlyItemView:New()
    elseif viewType == FlyRewardType.PlayerExp then
        FlyItemView = require "View.FlyRewardEffectsView.FlyPlayerExpEffectsView"
        view = FlyItemView:New()
    elseif viewType == FlyRewardType.JokerCoin then
        FlyItemView = require "View/FlyRewardEffectsView/FlyJokerCoinEffectsView"
        view = FlyItemView:New(viewType, flyTargetPos)
    elseif viewType == FlyRewardType.JokerGems then
        FlyItemView = require "View.FlyRewardEffectsView.FlyJokerGemsEffectsView"
        view = FlyItemView:New(viewType, flyTargetPos)
    elseif viewType == FlyRewardType.JokerRocket then
        FlyItemView = require "View/FlyRewardEffectsView/FlyJokerRocketEffectsView"
        view = FlyItemView:New(viewType, flyTargetPos)
    elseif viewType == FlyRewardType.WinZoneMusic then
        FlyItemView = require "View/FlyRewardEffectsView/FlyWinMusicEffectsView"
        view = FlyItemView:New(viewType, flyTargetPos)
    else
        local other = require "View/FlyRewardEffectsView/FlyCommonEffectsView"
        view = other:New(viewType, flyTargetPos)
    end

    viewInstance = view --view:New()
    viewInstance:SetPos(param)
	if flyTargetPos then
		viewInstance:SetTargetPos(flyTargetPos);
	end
    if viewType == FlyRewardType.VipExp then
        log.g("FlyRewardType.VipExp")
        local function cbAndPop()
            callback()
            Event.Brocast(EventName.Event_VipExp_Slider_Pop)
        end
        viewInstance:SetFlyEffectCallBack(cbAndPop)
    elseif viewType == FlyRewardType.Lens then
        local function cbAndPop()
            callback()
            Event.Brocast(EventName.Event_Update_MagnifyLens_Time_On_Function)
        end
        viewInstance:SetFlyEffectCallBack(cbAndPop)
    elseif viewType == FlyRewardType.TournamentSprintBuff1 or viewType == FlyRewardType.TournamentSprintBuff2 then
        local function cbAndPop()
            callback()
            Event.Brocast(EventName.Event_Update_TournamentSprintBuff_Time)
        end
        viewInstance:SetFlyEffectCallBack(cbAndPop)
    else
        viewInstance:SetFlyEffectCallBack(callback)
    end

    --viewInstance:SetFlyRewardType(viewType)
    --- 战斗中从特效池获取，避免反复创建
    if ModelList.BattleModel:IsGameing() and not ModelList.BattleModel:IsShowDetail() then
        --log.r("CmdFlyRewardEffects ModelList.BattleModel:IsGameing()  "..viewInstance.viewName)
        local obj =  Cache.load_pool_or_instance(viewInstance.viewName,nil,false)
        if fun.is_not_null(obj) then
            viewInstance:SkipLoadShow(obj,true)
            fun.set_active(obj,true)
        else
            viewInstance:Show(nil, nil)
        end
    else
        viewInstance:Show(nil, nil)
    end

    if icon and viewInstance.NeedSetIcon then
        viewInstance:SetCommonIcon(icon)
    end
end

--- 顶部Vip滑动条，播放完毕
function Command.GetVipSliderComplete()
    if not ViewList.TopVipSliderView or ViewList.TopVipSliderView:IsOver() then
        return true
    end
    return false
end

return Command