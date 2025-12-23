local GiftPackBaseView = require("View.GiftPack.GiftPackBaseView")
local ItemView = require "View/GiftPack/GiftPackSweetmeats/GiftPackSweetmeatsItem"
local GiftPackMothersDayUnlimitView = GiftPackBaseView:New('GiftPackMothersDayUnlimitView', "GiftPackMothersDayUnlimitAtlas")
local this = GiftPackMothersDayUnlimitView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
local ItemEntityCache = {}
local selfstep = 1
local moveOffset = 80
local _data = nil
local _DeloopTimer = nil
local _Delopptimer2 = nil
local sweetflag = false
this.auto_bind_ui_items = {
    "GiftPackChildrenDayView",
    "btn_close",
    "Content",
    "item",
    "left_time_txt",
    "candysweets2",
}

local remainTimeCountDown = RemainTimeCountDown:New()

function GiftPackMothersDayUnlimitView:Awake(obj)
    self:on_init()
    Facade.RegisterView(self)
    self._isInit = true
    --- 修复部分机型首次进入界面不显示问题
    if self._reshowAfterInit then
        self._reshowAfterInit = nil
        self:ShowDetailGift()
    end
end

function GiftPackMothersDayUnlimitView:OnEnable()
    Facade.RegisterView(self)
    --   this:ClearMailList()
    self:BuildFsm(self)
    self:Bi_Tracker()
    UISound.play("salesweet")
    sweetflag = true
    fun.set_active(self.item, false)
end

function GiftPackMothersDayUnlimitView:OnDisable()
    Facade.RemoveView(self)
    self:ClearMailList()
    self:ClearCountDown()
    --Event.Brocast(Notes.CARD_COLLIDER_OPEN, true)
end

function GiftPackMothersDayUnlimitView:ClearCountDown()
    if remainTimeCountDown then
        remainTimeCountDown:StopCountDown()
        remainTimeCountDown = nil
    end

    if _Delopptimer2 ~= nil then
        LuaTimer:Remove(_Delopptimer2)
        _Delopptimer2 = nil
    end
end

function GiftPackMothersDayUnlimitView:ShowItemGrid()
    _data = ModelList.GiftPackModel:GetShowGiftPack()
    local tmpData = Csv.getPopInfiniteForId(_data.pId)
    local itemRect = fun.get_component(self.item, fun.RECT)
    local rect = fun.get_component(self.Content, fun.RECT)
    rect.sizeDelta = Vector2.New(rect.sizeDelta.x, itemRect.sizeDelta.y * fun.table_len(tmpData) + 251)
    ModelList.GiftPackModel:SendEndlessGiftFetch(_data.pId)
    local xls = Csv.GetData("pop_up", _data.giftInfo[1].id)
    self.candysweets2:ShowSprite(self:Icon2ImgName(xls.icon))
end

function GiftPackMothersDayUnlimitView:Icon2ImgName(icon)
    local map ={
        cEntMotherDayIcon03 = "MotherDaynsGemsDi",
        cEntMotherDayIcon04 = "MotherDaynsCoinsDi",
    }
    
    return map[icon] or "MotherDaynsCoinsDi"
end

function GiftPackMothersDayUnlimitView:ShowItemGridData(step,flag)
    _data = ModelList.GiftPackModel:GetShowGiftPack() 
    local tmpData = Csv.getPopInfiniteForId(_data.pId)
    local count = 0

    table.sort( tmpData, function(a, b)
        return a.step < b.step
    end)

    for _, v in ipairs(tmpData) do
        count = count +1
        local view = self:GetItemViewInstance(count)
        if view then
            local data = {id = v.id, step = step, sid = _data.giftInfo[1].id}
            view:UpdateData(data)
        end
    end

    self:SetLeftTime(_data.giftInfo[1].expireTime)

    if step <= fun.table_len(tmpData) then
        self:movetoGrid(step, flag)
    end
end

function GiftPackMothersDayUnlimitView:movetoGrid(step, tflag)
    step = step or 1
    local rect = fun.get_component(self.item, fun.RECT)
    local y = step-1<=0 and 50 or (((step-1) * rect.rect.height * 0.89) + moveOffset)
    local pos = fun.get_gameobject_pos(self.Content, true)
    if tflag then
        local startY = step-2 <= 0 and 0 or y - (2 * rect.rect.height)
        fun.set_gameobject_pos(self.Content, pos.x, startY, 0, true)
    end

    Anim.move_ease(self.Content, pos.x, y, 0, 0.5, true, DG.Tweening.Ease.Flash, function() end)
end

function GiftPackMothersDayUnlimitView:ClearMailList()
    for i, v in pairs(ItemEntityCache) do
        v:Close()
    end
    ItemEntityCache ={}
end

function GiftPackMothersDayUnlimitView:GetItemViewInstance(index)
    local view_instance = nil
    if ItemEntityCache[index] == nil then
        local item = fun.find_child(self.Content, tostring(index))
        if not item then
            item = fun.get_instance(self.item, self.Content)
            if item then
                item.name = tostring(index)
            end
        end
        fun.set_active(item, true)
        view_instance = ItemView:New()
        view_instance:SkipLoadShow(item)
        ItemEntityCache[index] = view_instance
    else
        view_instance = ItemEntityCache[index]
    end
    return view_instance
end

function GiftPackMothersDayUnlimitView:ShowDetailGift()
    if self._isInit then
        self:ShowItemGrid()
    else
        self._reshowAfterInit = true
    end
end

function GiftPackMothersDayUnlimitView:SetLeftTime(endTimeStamp)
    local start_time = ModelList.PlayerInfoModel.get_cur_server_time()
    local endTime = endTimeStamp - start_time
    if not remainTimeCountDown then
        remainTimeCountDown = RemainTimeCountDown:New()
    end
    remainTimeCountDown:StartCountDown(CountDownType.cdt2, endTime, self.left_time_txt, function()
        self:ClosePackView()
        Event.Brocast(EventName.Event_Gift_Update)
    end)
end

function GiftPackMothersDayUnlimitView:OnDestroy()
    log.g("GiftPackMothersDayUnlimitView.OnDestroy ing !")
    Facade.RemoveView(self)
    self:Destroy()
    self:ClearMailList()
end

function GiftPackMothersDayUnlimitView:CloseFunc()
    Facade.SendNotification(NotifyName.HideUI, this)
end

function GiftPackMothersDayUnlimitView:ClosePackView()
    if _Delopptimer2 ~= nil then
        LuaTimer:Remove(_Delopptimer2)
    end

    self:ClearCountDown()
    Facade.SendNotification(NotifyName.HideUI, self)
    ModelList.GiftPackModel:CloseView()
end

function GiftPackMothersDayUnlimitView:on_btn_close_click()
    self:ClosePackView()
end

function GiftPackMothersDayUnlimitView:OnBuySuccess(needClose, itemData)
    --  this:ChangeState(this, "GiftPackShowState", itemData)
    _data = ModelList.GiftPackModel:GetShowGiftPack()
    ModelList.GiftPackModel:SendEndlessGiftFetch(_data.pId)

    --播放领奖界面
    self:showGetRewardEffect(itemData, false)
end

local function GetFlyPos(step, rewardId)
    local flyStartPos = nil
    if step then
        local view = ItemEntityCache[step]
        if view then
            flyStartPos = view:GetFlyPos(rewardId)
        end
    end
    if not flyStartPos then
        flyStartPos = this.left_time_txt
    end
    return flyStartPos.transform.position
end

function GiftPackMothersDayUnlimitView:showGetRewardEffect(itemData, isFree)
    if itemData and itemData.itemData then
        local offset = 0
        if isFree then offset = -1 end
        for i = 1, #itemData.itemData do
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts, GetFlyPos(itemData.step + offset, itemData.itemData[i].id), itemData.itemData[i].id, function()
                Event.Brocast(EventName.Event_currency_change)
                if ModelList.SeasonCardModel:IsCardPackage(itemData.itemData[i].id) then
                    ModelList.SeasonCardModel:OpenCardPackage({bagIds = {itemData.itemData[i].id}})
                end
            end, nil, i - 1)
        end
    end
    self:SetTimer()
end

function GiftPackMothersDayUnlimitView:SetTimer()
    if _DeloopTimer ~= nil then
        LuaTimer:Remove(_DeloopTimer)
    end
    _DeloopTimer = nil
    _DeloopTimer = LuaTimer:SetDelayFunction(3.5, function()
        local needClose = ModelList.GiftPackModel:ShowingGiftComplete()
        if needClose then
            self:on_btn_close_click()
        end
    end)
end

--领取成功
function GiftPackMothersDayUnlimitView.OnClaimEndlessGiftSuccess(data)
    if #ItemEntityCache == 0 then
        return
    end

    --  this:ShowItemGridData(data.step, false)
    local tmpdata = {itemData = data.reward, step = data.step}
    this:showGetRewardEffect(tmpdata, true)
    --现实第一个
end

--领取失败
function GiftPackMothersDayUnlimitView.OnClaimEndlessGiftFail(data)
    --提示下领取失败
end

--查询成功
function GiftPackMothersDayUnlimitView.OnFetchEndlessGiftSuccess(data)
    selfstep = data.step
    local tmpflag = false

    if sweetflag then
        tmpflag = true
        sweetflag = false
    end
    --- 按购买项数量调整
    if #ItemEntityCache >= 48 then
        this:ShowItemGridData(data.step, tmpflag)
    else
        if _Delopptimer2 ~= nil then
            LuaTimer:Remove(_Delopptimer2)
            _Delopptimer2 = nil
        end

        local tmpData = Csv.getPopInfiniteForId(_data.pId)
        local count = 0
        local startIndex = 1
        local endIndex = 16  -- 首次创建16个
 
        table.sort(tmpData, function(a, b)
            return a.step < b.step
        end)

        if data.step >= startIndex and data.step <= endIndex then
            for _,v in ipairs(tmpData) do
                count = count +1
                if count >= startIndex and count <= endIndex then
                    local view = this:GetItemViewInstance(count)
                    if view then
                        local data = {id = v.id, step = data.step, sid = _data.giftInfo[1].id}
                        view:UpdateData(data)
                    end
                end
            end

            _Delopptimer2 = LuaTimer:SetDelayLoopFunction(0.5, 0.5, 8, function()
                startIndex = endIndex
                endIndex = endIndex +5
                local tmpcount = 0
                for _, v in ipairs(tmpData) do
                    tmpcount = tmpcount +1
                    if tmpcount >= startIndex and tmpcount <= endIndex then
                        local view = this:GetItemViewInstance(tmpcount)
                        if view then
                            local data = {id = v.id, step = data.step, sid = _data.giftInfo[1].id}
                            view:UpdateData(data)
                        end
                    end
                end
            end)

            this:SetLeftTime(_data.giftInfo[1].expireTime)
            if data.step <= fun.table_len(tmpData) then
                this:movetoGrid(data.step)
            end
        else
            this:ShowItemGridData(data.step, tmpflag)
        end
    end
end

--领取失败
function GiftPackMothersDayUnlimitView.OnFetchEndlessGiftFail(data)
    --提示下查询失败
end

--监听事件列表
this.NotifyList = {
    {notifyName = NotifyName.EndlessGift.ClaimSuccess, func = this.OnClaimEndlessGiftSuccess},
    {notifyName = NotifyName.EndlessGift.ClaimFail, func = this.OnClaimEndlessGiftFail},
    {notifyName = NotifyName.EndlessGift.FetchSuccess, func = this.OnFetchEndlessGiftSuccess},
    {notifyName = NotifyName.EndlessGift.FetchFail, func = this.OnFetchEndlessGiftFail},
}

return this