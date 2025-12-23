local BaseSwitchCardLogic = require("Combat.BattleLogic.Base.BaseLogicSwitchCard")

local BisonLogicSwitchCard = BaseSwitchCardLogic:New("BisonLogicSwitchCard")
local this = BisonLogicSwitchCard
this.moduleName = "BisonLogicSwitchCard"

function BisonLogicSwitchCard:InitLogic()
    self.__index:InitLogic()
    self.PageOneCardIds = { 1, 2 }
    self.BackTwoCardIds = { 3, 4 }
end

--- �л�����
function BisonLogicSwitchCard:StartSwitchCard()
    if self.isSwitching then
        return
    end
    self.isSwitching = true
    self.curr_show_card_index = self.curr_show_card_index + 1
    if self.curr_show_card_index >= 3 then
        self.curr_show_card_index = 1
    end
    self:RemoveHideJackpotCardBackground()
    Event.Brocast(EventName.Event_Switch_Card, self.curr_show_card_index)
end

function BisonLogicSwitchCard:IsShowing(cardId)
    if ModelList.BattleModel:IsRocket() then
        return true
    end
    if not self.curr_show_card or #self.curr_show_card == 0 then
        return true
    end
    if self.curr_show_card[self.curr_show_card_index] then
        for i = 1, #self.curr_show_card[self.curr_show_card_index] do
            if self.curr_show_card[self.curr_show_card_index][i] == cardId then
                return true
            end
        end
    end
    return false
end

--- �л�����
function BisonLogicSwitchCard:EnterDoubleJackpotChangeCard()
    if self.isSwitching then
        log.r("�����л����ƣ���Ӧ�ô���˫jackpot�п�")
    end
    self.isSwitching = true
    self.doubleJackpotChange = LuaTimer:SetDelayLoopFunction(0.01, 0.01, -1, function()
        BattleEffectPool.FollowTargetObj()
        BattleEffectCache.FollowTargetObj()
    end, nil, nil, LuaTimer.TimerType.Battle)
end

function BisonLogicSwitchCard:ExitDoubleJackpotChangeCard()
    if self.doubleJackpotChange then
        LuaTimer:Remove(self.doubleJackpotChange)
        self.doubleJackpotChange = nil
    end
    Event.Brocast(EventName.Event_Switch_Card_Check_Jokepot_Pos)
    Event.Brocast(EventName.Event_Switch_Card, self.curr_show_card_index)
    self.isSwitching = false
end

--- ��Jackpot�Ŀ����Զ��ƶ�������
function BisonLogicSwitchCard:StartHideJackpotCardBackground(currCardId, otherJackpotId)
    self.loopMoveCard = LuaTimer:SetDelayLoopFunction(5, 0.3, -1, function()
        if ModelList.BisonModel:IsGameOver() then
            self:RemoveHideJackpotCardBackground()
            return
        end

        if BattleEffectCache:CheckCardHideAllEffect(currCardId) then
            self:RemoveHideJackpotCardBackground()
            local moveCardId = 0
            local currIndex = 0
            local moveIndex = 0
            if self.curr_show_card_index == 1 then
                if not fun.is_include(otherJackpotId, self.BackTwoCardIds) then
                    local temp = otherJackpotId
                    otherJackpotId = currCardId
                    currCardId = temp
                end
                for i = 1, #self.BackTwoCardIds do
                    if self.BackTwoCardIds[i] ~= otherJackpotId then
                        moveCardId = self.BackTwoCardIds[i]
                        moveIndex = i
                        break
                    end
                end
                for i = 1, #self.PageOneCardIds do
                    if self.PageOneCardIds[i] == currCardId then
                        self.PageOneCardIds[i] = moveCardId
                        currIndex = i
                    end
                end
                for i = 1, #self.BackTwoCardIds do
                    if self.BackTwoCardIds[i] ~= otherJackpotId then
                        self.BackTwoCardIds[i] = currCardId
                    end
                end
            else
                if not fun.is_include(otherJackpotId, self.PageOneCardIds) then
                    local temp = otherJackpotId
                    otherJackpotId = currCardId
                    currCardId = temp
                end
                for i = 1, #self.PageOneCardIds do
                    if self.PageOneCardIds[i] ~= otherJackpotId then
                        moveCardId = self.PageOneCardIds[i]
                        moveIndex = i
                        break
                    end
                end
                for i = 1, #self.BackTwoCardIds do
                    if self.BackTwoCardIds[i] == currCardId then
                        self.BackTwoCardIds[i] = moveCardId
                        currIndex = i
                    end
                end
                for i = 1, #self.PageOneCardIds do
                    if self.PageOneCardIds[i] ~= otherJackpotId then
                        self.PageOneCardIds[i] = currCardId
                    end
                end
            end
            --self:HideJackpotCardBackground(currCardId,moveCardId,currIndex,moveIndex)
            Event.Brocast(EventName.Event_Move_Jackpot_Card_Background, currCardId, moveCardId, currIndex, moveIndex)
            Event.Brocast(EventName.Event_Switch_Card_Double_Jackpot_Sort, currCardId, moveCardId, currIndex, moveIndex)
            self:SyncPage()
        end
    end, nil, nil, LuaTimer.TimerType.Battle)
end

---
function BisonLogicSwitchCard:RemoveHideJackpotCardBackground()
    if self.loopMoveCard then
        LuaTimer:Remove(self.loopMoveCard)
        self.loopMoveCard = nil
    end
end

function BisonLogicSwitchCard:OnDisable()
    self:RemoveHideJackpotCardBackground()
end

function BisonLogicSwitchCard:GetsCurrCardOrder()
    local next_card_index = self.curr_show_card_index + 1
    if next_card_index >= 3 then
        next_card_index = 1
    end

    if next_card_index == 1 then
        return 1
    else
        return self.back_card_stard_index
    end
end

return this