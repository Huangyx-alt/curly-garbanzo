require "State/Common/CommonState"
local RewardIconValueView = require "View/CommonView/RewardIconValueView"

local BingoPassBenefitsView = BaseView:New("BingoPassBenefitsView","BingoPassPopupAtlas")
local this = BingoPassBenefitsView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

--local evntsystem = UnityEngine.EventSystems.EventSystem
local input = UnityEngine.Input
local keyCode = UnityEngine.KeyCode

local rewardItemCache1;
local rewardItemCache2;

this.auto_bind_ui_items = {
    "img_reward1",
    "img_reward2",
    "content1",
    "content2",
    "item",
    "text1",
    "text2",
    "text3",
    "text4",
    "text5",
    "anima",
    "viewPort1",
    "viewPort2"
}

function BingoPassBenefitsView:Awake()
    self.update_x_enabled = true
    self:on_init()
end

function BingoPassBenefitsView:OnEnable(params)
    CommonState.BuildFsm(self,"BingoPassBenefitsView")
    
    if params then
        self.go.transform.position = params[2]
        local localPos = self.go.transform.localPosition
        self.go.transform.localPosition = Vector3.New(0,localPos.y + 292,0)
    end
    local levelNormal = ModelList.BingopassModel:GetLevel()
    local levelGolden = (params[1] == BingoPassPayType.Pay999 and {this:GetPayGoldPassLevel()} or {levelNormal})[1]
    local rewardNow = {}
    local rewardSoon = {}
    for i = 1, #Csv.season_pass do
        local cache_list = nil
        local passData = Csv.GetData("season_pass",i)
        if i <= levelNormal or i <= levelGolden then
            if not ModelList.BingopassModel:IsPayReceived(i) then
                cache_list = rewardNow
            end
        else
            if passData.exp == 0 and levelNormal == i - 1 then
                cache_list = rewardNow 
            else
                cache_list = rewardSoon
            end
        end
        if cache_list then
            for key2, value2 in pairs(passData.pay_reward) do
                local key = value2[1]
                local value = value2[2]
                if key and value then
                    cache_list[key] = (cache_list[key] or 0) + value
                end
            end
        else
            break    
        end
    end

    if rewardItemCache1 == nil then
        rewardItemCache1 = {}
    end
    if rewardItemCache2 == nil then
        rewardItemCache2 = {}
    end
    self.text3.text = fun.NumInsertComma(rewardNow[Resource.coin] or 0) --fun.format_number(rewardNow[Resource.coin] or 0)
    self.text4.text = fun.NumInsertComma(rewardSoon[Resource.coin] or 0) --fun.format_number(rewardSoon[Resource.coin] or 0)

    rewardNow[Resource.coin] = nil
    rewardSoon[Resource.coin] = nil

    self:BuildRewardItem(rewardItemCache1,rewardNow,self.item,self.content1)
    self:BuildRewardItem(rewardItemCache2,rewardSoon,self.item,self.content2)

    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"start","Common_dialog_start"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
end

function BingoPassBenefitsView:OnDisable()
    rewardItemCache1 = nil
    rewardItemCache2 = nil
end

function BingoPassBenefitsView:GetPayGoldPassLevel()
    local level = ModelList.BingopassModel:GetLevel()
    local exp = ModelList.BingopassModel:GetExp()
    local seasonId = ModelList.BingopassModel:GetSeasonId()
    local rewardData = ModelList.BingopassModel:get_priceItem2()
    local rewardExp = tonumber(rewardData[2][2] or 0)
    while true do
        local needExp = Csv.GetData("season_pass",level + 1,"exp")
        if needExp then
            needExp = needExp - exp
            rewardExp = math.max(0,rewardExp - needExp)
            exp = 0
            level = level + 1
        else
            break    
        end
        if rewardExp == 0 then
            break
        end
    end
    return level
end

function BingoPassBenefitsView:Promote(params)

end

function BingoPassBenefitsView:BuildRewardItem(itemCache,rewardData,itemGo,content)
    local keyIndex = 1
    local keyCount = #itemCache
    for key, value in pairs(rewardData) do
        if itemCache and itemCache[keyIndex] then
            itemCache[keyIndex]:SetInfo({key,value})
            fun.set_active(itemCache[keyIndex].go.transform,true)
        else
            local go = fun.get_instance(itemGo,content)
            fun.set_active(go.transform,true)
            local riv = RewardIconValueView:New({key, value, kbm = false})
            riv:SkipLoadShow(go)
            table.insert(itemCache,riv)
        end
        keyIndex = keyIndex + 1
    end
    if keyIndex < keyCount then
        for i = keyIndex, keyCount do
            fun.set_active(itemCache[i].go.transform,false)
        end
    end
end

function BingoPassBenefitsView:on_x_update()
    if input.GetKeyDown(keyCode.Mouse0) then
        local camera = ProcedureManager:GetCamera()
        if Util.IsTopGraphic(camera,self.viewPort1) or 
            Util.IsTopGraphic(camera,self.viewPort2)then
            return
        end
        self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
            AnimatorPlayHelper.Play(self.anima,{"end","Common_dialog_end"},false,function()
                Facade.SendNotification(NotifyName.CloseUI,self)
            end)
        end)
    end
end

return this