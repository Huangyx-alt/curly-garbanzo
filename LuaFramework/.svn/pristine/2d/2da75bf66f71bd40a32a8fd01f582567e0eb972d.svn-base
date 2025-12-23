require("Combat/BaseMachine")
local PirateShipAStar = require("PirateShipAStar")

---  海盗船寻路移动
local PirateShipMachine = BaseMachine:New("PirateShipMachine")
local this = PirateShipMachine
this.normalSpeed = 1
this.quickSpeed = 2

local private = {}

--宝箱队列
local treasureQueue = {}

function this:Start()
    this.model = ModelList.BattleModel:GetCurrModel()
    private.InitShip(self)
end

function this:Pause(isPause)

end

function this:on_x_update()
    table.each(this.movePath, function(pathList, cardID)
        if #pathList > 0 then
            local node = pathList[1]
            local nodeCellCtrl = self.model:GetRoundData(cardID, node):GetCellObj().transform
            local moveItemCtrl = self.shipCtrlList[cardID]
            local dir = (nodeCellCtrl.position - moveItemCtrl.position).normalized
            moveItemCtrl.Translate(dir * this.normalSpeed * Time.deltaTime)
        else
            self.movingState[cardID] = false
        end
    end)
end

function this:Stop()

end

function this:IsMoving(cardId)
    return this.movingState[cardId]
end

function this.Register()
    Event.AddListener(EventName.Event_Collect_Item_By_Sign, this.OnCellSigned, this)
end

function this.UnRegister()
    Event.RemoveListener(EventName.Event_Collect_Item_By_Sign, this.OnCellSigned, this)
end

---有格子盖章后，重新规划路线
function this:OnCellSigned(cardID, cellIndex)
    local cellData = this.model:GetRoundData(cardID, cellIndex)
    local treasureItems = cellData:Treasure2Item()

    if treasureItems then
        local data = Csv.GetData("item", treasureItems.id)
        --是宝箱
        if 33 == data.result[1] then
            treasureQueue[cardID] = treasureQueue[cardID] or {}
            table.insert(treasureQueue[cardID], cellIndex)
            
            if not this:IsMoving() then
                this:MoveToNextTreasure(cardID)
            end
        end
    end
end

--移动到下一个宝箱
function this:MoveToNextTreasure(cardID)
    local nextTreasure = private.GetNextTreasure(self, cardID)
    local path = PirateShipAStar:FindPath(cardID, nextTreasure)
end

--当前移动到哪个格子了
function this:GetCurCellIndex()
    
end

--------------------------------------------------------------------------------
function private.InitShip(self)
    self.movingState = {}
    self.movePath = {}
    self.shipCtrlList = {}
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    for cardID = 1, 4 do
        local view = cardView:GetCard(cardID) 
        local moveItemCtrl = view.moveItemCtrl
        self.shipCtrlList[cardID] = moveItemCtrl.transform
        self.movingState[cardID] = false
        self.movePath[cardID] = {}
    end
end

function private.GetNextTreasure(self, cardID)
    local queue = treasureQueue[cardID]
    for i = 1, #queue do
        local treasure = queue[i]
        local cellData = self.model:GetRoundData(cardID, treasure)
        if not cellData.isGained then
            return treasure
        end
    end
end

return this