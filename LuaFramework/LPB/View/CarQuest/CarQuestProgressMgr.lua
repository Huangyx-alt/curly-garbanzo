local Const = require "View/CarQuest/CarQuestConst"
local CarQuestProgressMgr = {}
local useDirectSwithSpeed = true

function CarQuestProgressMgr:Init(view, root, rankData)
    self.view = view
    self.root = root
    self.rankData = rankData
    local ref = fun.get_component(root, fun.REFER)
    local progressRect = ref:Get("progressRect")
    self.progressBarLength = progressRect.sizeDelta.y
    
    self.zebraStripes = ref:Get("imgZebraStripes")
    fun.set_active(self.zebraStripes, false)
    
    self.progressBarList = {}
    self:InitProgress()
    self:UpdateHierarchy()
end

function CarQuestProgressMgr:InitProgress()
    local ref = fun.get_component(self.root, fun.REFER)
    local progressRect = ref:Get("progressRect")
    local size = progressRect.sizeDelta
    local raceConfig = self.view:GetRaceConfig()
    local endFuel = raceConfig[#raceConfig][3]

    for i = 1, Const.CarCount do 
        local startProgress = self.rankData[i].lastScore / endFuel
        local endProgress = self.rankData[i].score / endFuel
        if startProgress > 1 then
            startProgress = 1
        end
        if endProgress > 1 then
            endProgress = 1
        end
        local player = ref:Get("player" .. i)
        local startPos = size.y * startProgress
        local params = {}
        params.idx = i
        params.bar = player
        params.startFuel = self.rankData[i].lastScore
        params.endFuel = self.rankData[i].score
        params.startProgress = startProgress
        params.endProgress = endProgress
        params.startPos = startPos
        params.endPos = size.y * endProgress
        params.moveDistance = params.endPos - params.startPos

        table.insert(self.progressBarList, params)
    end
    log.log("CarQuestProgressMgr:InitProgress before sort", self.progressBarList)
    self:Sort()
    log.log("CarQuestProgressMgr:InitProgress after sort", self.progressBarList)
end

function CarQuestProgressMgr:Sort()
    table.sort(self.progressBarList, function(a, b)
        if a.endPos > b.endPos then
            return true
        end
    end)
end

function CarQuestProgressMgr:UpdateHierarchy()    
    for i = 1, Const.CarCount do
        local params = self.progressBarList[i]
        if params.idx == Const.MyTrackNum then
            fun.SetAsLastSibling(params.bar)
        else
            fun.SetAsFirstSibling(params.bar)
        end
    end
end

function CarQuestProgressMgr:StartIncrease()
    for i = 1, Const.CarCount do
        local params = self.progressBarList[i]
        Anim.do_smooth_float_update(0, 1, self.carMovingTime, function(num)
			fun.set_rect_anchored_position(params.bar, 0, params.startPos + num * params.moveDistance)
		end,function()
			fun.set_rect_anchored_position(params.bar, 0, params.endPos)
            self:UpdateHierarchy()
		end)
    end
end

function CarQuestProgressMgr:ShowStartProgress()
    for i = 1, Const.CarCount do
        local params = self.progressBarList[i]
        fun.set_rect_anchored_position(params.bar, 0, params.startPos)
    end
end

function CarQuestProgressMgr:ShowEndProgress()
    for i = 1, Const.CarCount do
        local params = self.progressBarList[i]
        fun.set_rect_anchored_position(params.bar, 0, params.endPos)
    end
    self:UpdateHierarchy()
end

function CarQuestProgressMgr:Update(deltaTime)
    self:Move(deltaTime)
end

function CarQuestProgressMgr:Move(deltaTime)
end

function CarQuestProgressMgr:SetCarMovingTime(movingTime)
    self.carMovingTime = movingTime
end

return CarQuestProgressMgr