local HallofFameEntrance = {}

local cacheTier = nil
local isOpen = nil
local trophy = nil
local lock = nil
local hasJoin = false
local defaultTitle = nil
local nextRoundTime = nil
local nextRountCountDown = nil
local tournamentBuffBg = nil
local tournamentBuffTime = nil

function HallofFameEntrance:OnEnable(params)
    trophy = fun.get_component(params[1].transform, fun.IMAGE)
    lock = params[2]
    defaultTitle = params[3]
    nextRoundTime = params[4]
    tournamentBuffBg = params[5]
    tournamentBuffTime = params[6]
    
    if ModelList.HallofFameModel:IsActivityAvailable() then
        self:ShowInfo()
    end
end

function HallofFameEntrance:ShowInfo()
    local tier, difficulty = ModelList.HallofFameModel:GetTiers()
    if cacheTier ~= tier then
        cacheTier = tier
        local trophyName = fun.GetCurrTournamentActivityImg(tier)
        Cache.load_sprite(AssetList["trophyName"], trophyName, function(sprite)
            if sprite then
                if fun.is_not_null(trophy) then
                    trophy.sprite = sprite
                end
            end
        end)
    end
    self:CheckLevelOpen()
    self:CheckJoin()
    self:CheckBuff()
end

function HallofFameEntrance:CheckLevelOpen()
    if not isOpen then
        local openLevel = ModelList.HallofFameModel:GetUnlockLv()
        local myLevel = ModelList.PlayerInfoModel:GetLevel()
        isOpen = myLevel >= openLevel
        if isOpen then
            fun.set_active(lock, false)
            Util.SetImageColorGray(trophy.gameObject, false)
        end
    end
end

function HallofFameEntrance:CheckJoin()
    if isOpen then
        hasJoin = ModelList.HallofFameModel.CheckJoin()
    end

    if not hasJoin then
        fun.set_active(defaultTitle, true)
        fun.set_active(nextRoundTime, false)
    else
        fun.set_active(defaultTitle, false)
        fun.set_active(nextRoundTime, true)

        local nextRountTime = ModelList.HallofFameModel:GetRemainTime()
        if nextRountCountDown == nil then
            nextRountCountDown = RemainTimeCountDown:New()
        end
        --这个倒计时 是活动结束倒计时
        nextRountCountDown:StartCountDown(CountDownType.cdt2, nextRountTime, nextRoundTime, function()
            Event.Brocast(NotifyName.HallofFame.FameNextOpenTimeCountDownEnd)
        end)
    end
end

function HallofFameEntrance:CheckBuff()
    fun.set_active(tournamentBuffBg, false)
end

function HallofFameEntrance:IsOpen()
    return isOpen
end

function HallofFameEntrance:OnDisable()

end

function HallofFameEntrance:OnDestroy()
    defaultTitle = nil
    lock = nil
    trophy = nil
    nextRoundTime = nil
    self:InitData()
end

function HallofFameEntrance:InitData()
    cacheTier = nil
    isOpen = nil
    hasJoin = false
    if nextRountCountDown then
        nextRountCountDown:StopCountDown()
        nextRountCountDown = nil
    end
end

return HallofFameEntrance