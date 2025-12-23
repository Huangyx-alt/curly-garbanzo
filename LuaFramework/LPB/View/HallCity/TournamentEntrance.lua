local TournamentEntrance = {}

local cacheTier = nil

local isOpen = nil

local trophy = nil
local lock= nil

local hasJoin = false
local defaultTitle = nil
local nextRoundTime = nil
local nextRountCountDown = nil

local tournamentBuffBg = nil
local tournamentBuffTime = nil
local buffRemainCountDown = nil


function TournamentEntrance:OnEnable(params)
    -- local tier,difficulty = ModelList.TournamentModel:GetTiers()
    -- log.log("周榜优化 等级参数 OnEnable " , tier,difficulty)
    Event.AddListener(EventName.Event_Update_TournamentSprintBuff_Time, self.CheckJoinAndBuff, self)
    trophy = fun.get_component(params[1].transform,fun.IMAGE)
    lock = params[2]
    defaultTitle = params[3]
    nextRoundTime = params[4]
    tournamentBuffBg = params[5]
    tournamentBuffTime = params[6]

    if ModelList.TournamentModel:IsActivityAvailable() then
        self:ShowInfo()
    end
end

function TournamentEntrance:ShowInfo()
    local tier,difficulty = ModelList.TournamentModel:GetTiers()
    if cacheTier ~= tier then
        cacheTier = tier
        local trophyName = fun.GetCurrTournamentActivityImg(tier)
        Cache.load_sprite(AssetList["trophyName"],trophyName,function(sprite)
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

function TournamentEntrance:CheckLevelOpen()
    if not isOpen then
        local openLevel = ModelList.TournamentModel:GetUnlockTournamentLv()
        local myLevel = ModelList.PlayerInfoModel:GetLevel()
        isOpen = myLevel >= openLevel
        if isOpen then
            fun.set_active(lock,false)
            Util.SetImageColorGray(trophy.gameObject,false)
        end
    end
end

function TournamentEntrance:CheckJoin()
    if isOpen then
        hasJoin = ModelList.TournamentModel.CheckJoinTournament()
        
    end

    if not hasJoin then
        if ModelList.TournamentModel:HasSprintBuff() then
            fun.set_active(defaultTitle, false)
        else
            fun.set_active(defaultTitle, true)
        end
        fun.set_active(nextRoundTime , false)
    else
        
        fun.set_active(defaultTitle , false)
        if ModelList.TournamentModel:HasSprintBuff() then
            fun.set_active(nextRoundTime , false)
        else
            fun.set_active(nextRoundTime , true)
        end
        local nextRountTime = ModelList.TournamentModel:GetRemainTime()

        if nextRountCountDown == nil then
            nextRountCountDown = RemainTimeCountDown:New()
        end
        --这个倒计时 是活动结束倒计时
        nextRountCountDown:StartCountDown(CountDownType.cdt2,nextRountTime,nextRoundTime,function()
            Event.Brocast(NotifyName.Tournament.TournamentNextOpenTimeCountDownEnd)
        end)
    end
end

function TournamentEntrance:CheckBuff()
    if ModelList.TournamentModel:HasSprintBuff() then
        fun.set_active(tournamentBuffBg, true)
    else
        fun.set_active(tournamentBuffBg, false)
    end
    local buffRemainTime = ModelList.TournamentModel:GetSprintBuffRemainTime()
    if buffRemainTime > 0 then
        buffRemainCountDown = buffRemainCountDown or RemainTimeCountDown:New()
        buffRemainCountDown:StartCountDown(CountDownType.cdt2, buffRemainTime, tournamentBuffTime,
            function()
                self:CheckJoin()
                self:CheckBuff()
            end
        )
    end
end

function TournamentEntrance:CheckJoinAndBuff()
    self:CheckJoin()
    self:CheckBuff()
end

function TournamentEntrance:IsOpen()
    return isOpen
end

function TournamentEntrance:OnDisable()
    Event.RemoveListener(EventName.Event_Update_TournamentSprintBuff_Time, self.CheckJoinAndBuff, self)
end

function TournamentEntrance:OnDestroy()
    defaultTitle = nil
    lock = nil
    trophy = nil
    nextRoundTime = nil
    self:InitData()
end

function TournamentEntrance:InitData()
    cacheTier = nil
    isOpen = nil
    hasJoin = false
    if nextRountCountDown then
        nextRountCountDown:StopCountDown()
        nextRountCountDown = nil
    end

    if buffRemainCountDown then
        buffRemainCountDown:StopCountDown()
        buffRemainCountDown = nil
    end
end

return TournamentEntrance