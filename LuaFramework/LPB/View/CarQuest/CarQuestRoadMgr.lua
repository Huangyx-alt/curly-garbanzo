local Const = require "View/CarQuest/CarQuestConst"
local CarQuestRoadUnit = require "View/CarQuest/CarQuestRoadUnit"
local CarQuestRoadMgr = {}
local useDirectSwithSpeed = true

function CarQuestRoadMgr:Init(view)
    self.view = view
    self.roadUnitList = {}
    self.speed = 0
    self.unitIndxOffset = 0
    self.curUnitIdx = 0
end

function CarQuestRoadMgr:CreateRoad(prefab, rootNode)
    for i = 1, Const.RoadUnitCount do
        local item = self:CreateRoadItem(prefab, i)
        local obj = item.go
        if obj then
            obj.transform:SetParent(rootNode.transform)
            obj.transform.localScale = Vector3.one
            fun.set_rect_anchored_position(obj, 0, Const.RoadUnitLength * (i - 1))
            fun.set_active(obj, true)

            table.insert(self.roadUnitList, item)
        end
    end

    self.curUnitIdx = self.unitIndxOffset + Const.RoadUnitCount
end

function CarQuestRoadMgr:CreateRoadItem(prefab, index)
    local itemGo = fun.get_instance(prefab)
    local data = {index = index, view = self.view}
    local item = CarQuestRoadUnit:New()
    item:SetData(data)
    item:SkipLoadShow(itemGo)
    -- fun.set_parent(itemGo, self.Content, true)
    -- fun.set_active(itemGo, true)
    return item
end

function CarQuestRoadMgr:Update(deltaTime)
    self:Move(deltaTime)
end

function CarQuestRoadMgr:Move(deltaTime)
    local offset = deltaTime * 60 * self.speed
    for i = 1, Const.RoadUnitCount do
        local item = self.roadUnitList[i]
        local obj = item and item.go
        if fun.is_not_null(obj) then
            local pos = fun.get_rect_anchored_position(obj)
            if pos.y < -Const.RoadUnitLength then
                item:UpdateData({index = 5})
                fun.set_rect_anchored_position(obj, 0, pos.y + Const.RoadUnitLength * Const.RoadUnitCount - offset)
            else
                fun.set_rect_anchored_position(obj, 0, pos.y - offset)
            end
        end
    end
end

function CarQuestRoadMgr:StartMove()
    self:StopAccelerate()
    if useDirectSwithSpeed then
        self.speed = Const.RoadLowSpeed
    else
        self.accelerateAnim = Anim.do_smooth_float_update(0, Const.RoadLowSpeed, 1,
            function(num) 
                self.speed = num
            end,
            function()
                self.accelerateAnim = nil
                self.speed = Const.RoadLowSpeed
            end
        )
    end
end

function CarQuestRoadMgr:MoveSlow()
    self:StopAccelerate()
    if useDirectSwithSpeed then
        self.speed = Const.RoadLowSpeed
    else
        self.accelerateAnim = Anim.do_smooth_float_update(self.speed, Const.RoadLowSpeed, 1,
            function(num) 
                self.speed = num
            end,
            function()
                self.accelerateAnim = nil
                self.speed = Const.RoadLowSpeed
            end
        )
    end
end

function CarQuestRoadMgr:MoveFast()
    self:StopAccelerate()
    if useDirectSwithSpeed then
        self.speed = Const.RoadHighSpeed
    else
        self.accelerateAnim = Anim.do_smooth_float_update(self.speed, Const.RoadHighSpeed, 1,
            function(num) 
                self.speed = num
            end,
            function()
                self.accelerateAnim = nil
                self.speed = Const.RoadHighSpeed
            end
        )
    end
end

function CarQuestRoadMgr:StopAccelerate()
    if self.accelerateAnim then 
        self.accelerateAnim:Kill()
        self.accelerateAnim = nil
    end
end

function CarQuestRoadMgr:ShowStartLine()
    for i = 1, Const.RoadUnitCount do
        local item = self.roadUnitList[i]
        item:ShowStartLine()
    end
end

function CarQuestRoadMgr:ShowUpgradeFlag()
    for i = 1, Const.RoadUnitCount do
        local item = self.roadUnitList[i]
        item:ShowUpgradeFlag()
    end
end

function CarQuestRoadMgr:HideUpgradeFlag()
    for i = 1, Const.RoadUnitCount do
        local item = self.roadUnitList[i]
        item:HideUpgradeFlag()
    end
end

return CarQuestRoadMgr