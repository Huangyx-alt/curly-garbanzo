local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")

local ChristmasSynthesisLogicCard = BaseLogicCard:New("ChristmasSynthesisLogicCard")
local this = ChristmasSynthesisLogicCard
this.moduleName = "ChristmasSynthesisLogicCard"

local bowlTable = {}
--- 禁止点击卡牌
local forbidClickTable = {}
local maxCount = nil

function ChristmasSynthesisLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    forbidClickTable = { 0, 0, 0, 0, 0 }
    self:BaseInit()
end

function ChristmasSynthesisLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        bowlTable[i] = { 0, 0, 0, 0, 1 }
    end

    maxCount = {}
    for i = 1, 5 do
        maxCount[i] = Csv.GetCollectiveMaxCount(i)
    end
end

function ChristmasSynthesisLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

function ChristmasSynthesisLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

--- 增加酒水数量
function ChristmasSynthesisLogicCard:AddLogicBowlDrink(cardId, width, height)
    cardId = tonumber(cardId)


    bowlTable[cardId] = width * height
    if not ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):GetForbid() and width * height >= 25 then
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):SetForbid()
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):BeJackpot()
        --self:StatisticsRocketBingo()
        this:CheckDoubleJackpotHandle(cardId)
        this:CheckAllCardJackpotHandle(cardId)
    end
end

function ChristmasSynthesisLogicCard:IsOtherSideHaveOneJackpot(currCardId)
    local otherJackpotId = 0
    if self.model:GetCardCount() == 4 then
        local forbidCount = 0
        for i = 1, 4 do
            if self.model:GetRoundData(i):GetForbid() then
                forbidCount = forbidCount + 1
                if i ~= currCardId then
                    otherJackpotId = i
                end
            end
        end
        if forbidCount == 2 and not (currCardId <= 2 and otherJackpotId <= 2)
            and not (currCardId >= 3 and otherJackpotId >= 3) then
            return otherJackpotId
        else
            return 0
        end
    else
        return 0
    end
end


function ChristmasSynthesisLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function ChristmasSynthesisLogicCard:CheckAllCardJackpotHandle(currCardId)
    --- 这里补充，假如第一次小火箭触发了全部jackpot，就忽略下一次小火箭
    if ModelList.BattleModel:IsRocket() then return end
    if self:IsAllJackpot() then
        if ModelList.BattleModel:IsGameing() then
            ModelList.BattleModel:GetCurrModel():SetReadyState(2)
            self:WaitUploadSettleData()
        end
    end
end

--- 4卡游戏时，若有两张卡达成jackpot，则移动2张达成jackpot的卡片，到3、4卡的位置
function ChristmasSynthesisLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then return end
    local otherJackpotId = self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId, otherJackpotId)
    end
end

--- 取消两个Jackpot的卡牌后移
function ChristmasSynthesisLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end


return this
