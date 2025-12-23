local GiftPackBaseView = require("View.GiftPack.GiftPackBaseView")
local GiftPackAnniversary02View = GiftPackBaseView:New('GiftPackAnniversary02View')
local this = GiftPackAnniversary02View
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local GiftPackEnterState = require("View.GiftPack.State.GiftPackEnterState")
local GiftPackShowState = require("View.GiftPack.State.GiftPackShowState")
local GiftPackExitState = require("View.GiftPack.State.GiftPackExitState")
local GiftPackTransState = require("View.GiftPack.State.GiftPackTransState")

local selfstep = nil
local sweetflag = false
local isMoveing = false
local localGiftData = nil
local data = nil
local product_list = {}
local click_interval = 0.5
local ItemEntityCache = {}
local itemList = {}
local vipExpList = {}
local coinTextList = {}
local buttonEnableList = {}
local clickTimeList = 0
local _DeloopTimer = nil 
local last_click_time =  nil 
local itemListPos = 
{
    Up = 1,
    Middle = 2,
    Down = 3,
}

this.auto_bind_ui_items = {
    "left_time_txt",
    "btn_close",
    "GiftPackValentineItem",
    "GiftPackAnniversary02View",
    "item",
    "parent",
    "btn_up_Free",
    "lbvalentineslove11", 
}

local remainTimeCountDown = RemainTimeCountDown:New()

function GiftPackAnniversary02View:Awake(obj)
    self:on_init()
    self._isInit = true
    --- 修复部分机型首次进入界面不显示问题
    if self._reshowAfterInit then
        self._reshowAfterInit = nil
        self:ShowDetailGift()
    end
end

function GiftPackAnniversary02View:BuildFsm(owner)
    FsmCreator:Create("GiftPackAnniversary02View",owner,{
        GiftPackEnterState:New(),
        GiftPackShowState:New(),
        GiftPackExitState:New(),
        GiftPackTransState:New(),
    })
    this.state = {
        GiftPackEnterState = "GiftPackEnterState",
        GiftPackShowState =  "GiftPackShowState",
        GiftPackExitState =  "GiftPackExitState",
        GiftPackTransState = "GiftPackTransState",
    }
    owner._fsm:StartFsm(this.state.GiftPackEnterState,owner)
end

function GiftPackAnniversary02View:OnEnable()
    Facade.RegisterView(self)
    self:BuildFsm(this)
    self:Bi_Tracker()
    isMoveing = false 
    UISound.play("sale_junkiess")
end

function GiftPackAnniversary02View:OnDisable()
    Facade.RemoveView(self)
    buttonEnableList = {}
    itemList = {}
    clickTimeList = 0
    vipExpList = {}
    coinTextList = {}
    selfstep = nil 
    localGiftData = nil 
    isMoveing = false 
    self:ClearCountDown() 
    self:CleanChildView()
end

function GiftPackAnniversary02View:CleanChildView()
    if(ItemEntityCache)then 
        for k,v in pairs(ItemEntityCache) do
            if(v)then 
                v:Close()
            end
        end
    end
    local destoryCache= {}
    local cout = fun.get_child_count(self.parent) 
    for i=0,cout do
        local goObj = fun.get_child(self.parent,i)
        if(fun.is_null(goObj)==false)then 
            local itemName = goObj.name
            if(itemName == "item") then 
                table.insert(destoryCache,goObj)
            end 
        end
    end 

    for k,v in pairs(destoryCache) do
        Destroy(v)
    end

    ItemEntityCache = {}
end

function GiftPackAnniversary02View:ShowDetailGift()
    if self._isInit then
        self:ShowItemGrid()
    else
        self._reshowAfterInit = true
    end
end

function GiftPackAnniversary02View:ShowItemGrid()
    data = ModelList.GiftPackModel:GetShowGiftPack()
    log.r("lxq GiftPackAnniversary02View",data)
    self:CollectProduct(data.pId,data.giftInfo) 
    self:InitShopItem()
end

function GiftPackAnniversary02View:CleanShopItem()
    if(self.fullItems)then 
        for k,v in pairs(self.fullItems) do
            Destroy(v.go)
        end
    end
    self.fullItems = {}
end

function GiftPackAnniversary02View:InitShopItemPos()
    if(self.fullItemPos==nil)then 
        self.fullItemPos = {}
        for i=1,6 do
            local goObj = fun.find_child(self.parent,tostring(i))
            local pos = fun.get_gameobject_pos(goObj,true)
            self.fullItemPos[i]  = pos 
            local view = self:GetItemViewInstance(i)
        end
    end
end

function GiftPackAnniversary02View:InitShopItem()
    self:CleanShopItem()
    self:InitShopItemPos() 
 
    data = ModelList.GiftPackModel:GetShowGiftPack()
    local tmpData = Csv.getPopInfiniteForId(data.pId)
    ModelList.GiftPackModel:SendEndlessGiftFetch(data.pId)
end

function GiftPackAnniversary02View:ClearCountDown()
    if remainTimeCountDown then
        remainTimeCountDown:StopCountDown()
        remainTimeCountDown = nil
    end
end

function GiftPackAnniversary02View:CloseUIShiny(obj)
    local uishiny = fun.get_component(obj,"UIShiny")
    if uishiny then
        uishiny.enabled = false
    end
end

function GiftPackAnniversary02View:on_btn_up_buy_click()
    if this._fsm:GetCurName() ~= "GiftPackEnterState" then return end 
    if buttonEnableList[itemListPos.Up] then
        local click_time = UnityEngine.Time.time
        if click_time - self:GetLastClickTime(itemListPos.Up) > click_interval then
            clickTimeList = UnityEngine.Time.time
            ModelList.GiftPackModel:ReqEditorBuySucess(data.pId, product_list[1])
        end
    else 
        UIUtil.show_common_popup(8020,true)
    end
end

function GiftPackAnniversary02View:GetLastClickTime(pos)
    return clickTimeList or 0
end

function GiftPackAnniversary02View:SetItemGrid(itemId, itemNum , itemGrid)
    local refItem = fun.get_component(itemGrid , fun.REFER)
    local icon = refItem:Get("icon")
    local textNum = refItem:Get("textNum")
    local iconName = nil 
    local itemData = Csv.GetData("item", itemId)
 
    iconName = Csv.GetItemOrResource(itemId, "more_icon") 
    
    if(iconName==nil or #iconName==0)then 
        iconName = Csv.GetItemOrResource(itemId, "icon")
    end 
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    textNum.text = fun.format_money_reward({id = itemId, value = itemNum})
end

function GiftPackAnniversary02View:SetItem(itemUI,id, pos, btn)
    local itemParent = itemUI:Get("itemParent")
    local textExtra = itemUI:Get("textExtra")
    local bl_buy_txt = itemUI:Get("bl_buy_txt")
    local textVip = itemUI:Get("textVip")
    local textCoinNum = itemUI:Get("textCoinNum")
    local item = itemUI:Get("item")
    local extra = itemUI:Get("extra")
    local xls = Csv.GetData("pop_up", id)

    bl_buy_txt.text = "$" .. xls.price
    itemList[pos] = itemList[pos] or  {}
    for k ,v in pairs(xls.item_description) do
        local itemId = tonumber(v[1])
        local itemNum = v[2]
        if itemId ~= Resource.vipExp   then
            
            if (itemId == Resource.coin and pos ~= itemListPos.Up) then 
                textCoinNum.text = fun.format_money_reward({id = itemId, value = itemNum})
            else 
                local itemGrid = self:GetItemGrid(pos , k , item, itemParent)
                fun.set_active(itemGrid, true)
                self:SetItemGrid(itemId, itemNum , itemGrid)
                itemList[pos][k] = itemGrid
            end 

        else
            textVip.text = fun.format_money_reward({id = itemId, value = itemNum})
            vipExpList[pos] = textVip
        end
    end
     
end

function GiftPackAnniversary02View:GetItemGrid(pos,index,prefab, parent)
    if itemList[pos] and itemList[pos][index] then
        return itemList[pos][index]
    end
    local itemGrid = fun.get_instance(prefab, parent)
    return itemGrid
end

function GiftPackAnniversary02View:HideGridItem()
    for k ,v in pairs(itemList) do
        for z,w in pairs(v) do
            if w then
                fun.set_active(w, false)
            end 
        end
    end
end

function GiftPackAnniversary02View:SetButton(button, id,pos)
    local data = ModelList.GiftPackModel:GetGiftById(id)
    buttonEnableList[pos] = true
    if not data or data.canBuyCount <= 0 then
        buttonEnableList[pos] = false
        self:CloseUIShiny(button)
        Util.SetUIImageGray(button, true)
    elseif   self:OpenUIShiny(button) then
        Util.SetUIImageGray(button, false)
    end
end

function GiftPackAnniversary02View:SetLeftTime(endTimeStamp)
    local start_time = ModelList.PlayerInfoModel.get_cur_server_time()
    local endTime = endTimeStamp - start_time
    if not remainTimeCountDown then
        remainTimeCountDown = RemainTimeCountDown:New()
    end
    remainTimeCountDown:StartCountDown(CountDownType.cdt2,endTime,self.left_time_txt,function()
        self:ClosePackView()
        Event.Brocast(EventName.Event_Gift_Update)
    end)
end

function GiftPackAnniversary02View:CollectProduct(pId,giftInfo)
    product_list = {}
    for _, v in pairs(Csv.pop_up) do
        if pId == v.gift_id then
            for i = 1, #giftInfo do
                if giftInfo[i].id == _ then
                    table.insert(product_list, v.id)
                    break
                end
            end
        end
    end
    table.sort(product_list)
end

function GiftPackAnniversary02View.OnDestroy()
    this:Destroy()
end

function GiftPackAnniversary02View:on_close()
    --Event.Brocast(Notes.CARD_COLLIDER_OPEN, true)
end

function GiftPackAnniversary02View:CloseFunc()
    Facade.SendNotification(NotifyName.HideDialog, this)
end

function GiftPackAnniversary02View:ClosePackView()
    if self._fsm:GetCurName() == "GiftPackShowState" then return end
    self:ClearCountDown()
    Facade.SendNotification(NotifyName.CloseUI, self)
    ModelList.GiftPackModel:CloseView()
end

function GiftPackAnniversary02View:on_btn_close_click()
    self:ClosePackView()
end

function  GiftPackAnniversary02View:OnBuySuccess(needClose,itemData)
    -- this:ChangeState(this,"GiftPackShowState",itemData)
    data = ModelList.GiftPackModel:GetShowGiftPack()
    ModelList.GiftPackModel:SendEndlessGiftFetch(data.pId) 
    --播放领奖界面
    self:showGetRewardEffect(itemData,false)
end

function  GiftPackAnniversary02View:GetGiftPos(id)
    if id == product_list[1] then
        return self:GetItemPos(itemListPos.Up)
    elseif id == product_list[2] then
        return self:GetItemPos(itemListPos.Middle)
    else
        return self:GetItemPos(itemListPos.Down)
    end
end

function GiftPackAnniversary02View:SetItemVisiable(giftPackSweetmeatsItemView,visiable)
    if(giftPackSweetmeatsItemView.canvasgroup)then 

    else
        
    end
end

function GiftPackAnniversary02View:GetItemPos(pos)
     return self.fullItemPos[pos]
end

function GiftPackAnniversary02View:GetItemViewInstance(index)
    local view = require "View/GiftPack/GiftPackValentine/GiftPackValentineItem"
    local view_instance = nil
    if ItemEntityCache[index] == nil then
        local item = fun.get_instance(self.GiftPackValentineItem,self.parent)
        fun.set_active(item,false)
        view_instance = view:New()
        view_instance:SkipLoadShow(item)
        ItemEntityCache[index] = view_instance
    else
        view_instance = ItemEntityCache[index]
    end
    return view_instance
end

function GiftPackAnniversary02View:GetLocalGiftData()
    -- if(localGiftData==nil)then 
        data = ModelList.GiftPackModel:GetShowGiftPack()
        local tempData = ModelList.GiftPackModel:GetShowGiftPack()
        local tmpData = Csv.getPopInfiniteForId(data.pId) 
        table.sort( tmpData, function(a,b)
            return a.step < b.step
        end)
        localGiftData = tmpData
    -- end
    return localGiftData
end

function GiftPackAnniversary02View:ShowItemGridData(step,isShow)
    local count = 0
    local tempData = ModelList.GiftPackModel:GetShowGiftPack()
    local tmpData = self:GetLocalGiftData()
    for _,v in ipairs(tmpData) do 
        if(v.step >=step and count<6)then 
            count = count +1
            local view =  self:GetItemViewInstance(count)
            local pos = self:GetItemPos(count)
            local data = { id = v.id,step = step,sid = tempData.giftInfo[1].id,pos = pos ,index = count}
            view:UpdateData(data,isShow) 
        end 
    end

    while count<6 do
        count = count +1
        local view =  self:GetItemViewInstance(count)
        view:Hide()
    end
    self:ShowAllItemDir()
    self:SetLeftTime(data.giftInfo[1].expireTime)

    local xls = Csv.GetData("pop_up",tempData.giftInfo[1].id)
    self.lbvalentineslove11:ShowSprite(xls.icon)
end

function GiftPackAnniversary02View:FullItemGridData(step,view,pos)
    local tempData = ModelList.GiftPackModel:GetShowGiftPack()
    local tmpData =self:GetLocalGiftData()
    local count = 0 
    for _,v in ipairs(tmpData) do 
        if(v.step ==step)then   
            local data = { id = v.id,step = step,sid = tempData.giftInfo[1].id,pos = pos ,index = count}
            view:UpdateData(data) 
            view:PlayIn()
            break
        end 
    end 
end

--查询成功
function GiftPackAnniversary02View.OnFetchEndlessGiftSuccess(data)
   
    local isChange = false 
    if(selfstep==nil)then 
        selfstep = data.step
        this:ShowItemGridData(data.step,false)   --初始化
        return 
    end  
    --移动
    if(selfstep~=data.step)then 
        this:MoveItem(data.step) 
    end 
end

function GiftPackAnniversary02View.TestMove()
   
    local step = selfstep+1
    this:MoveItem(step) 
end

function GiftPackAnniversary02View:MoveItem(step) 
    if(isMoveing)then 
        return 
    end
    isMoveing = true 
    if(self.playMoveHandler)then 
        fun.stop(self.playMoveHandler)
        self.playMoveHandler = nil 
    end
    self.playMoveHandler = self:run_coroutine(function()
        local topView = self:RemoveItemViewByPos(1)
        topView:PlayOut()   --播放消失动画 
        coroutine.wait(0.4)   --等待0.4秒
        self:HideAllItemDir()  --隐藏所有
        -- coroutine.wait(0.3) 
        local delayCout = self:MoveAllItem(0.2,0.1)
        -- coroutine.wait(0.2)  
        local movePos = self:MoveToLast(topView)
        local objPos  = self:GetItemPos(movePos) 
        local newStep = step + movePos-1
        log.r("lxq newstep:",newStep,movePos)
        self:FullItemGridData(newStep,topView,objPos) 

        coroutine.wait(0.3)  
        self:ShowAllItemDir()  -- 

        selfstep = step
        coroutine.wait(0.2) --保证2秒后才能下次点击
        ItemEntityCache[1].isUnlock = true   --允许第一个可以点击
        isMoveing = false 
    end)
end

function GiftPackAnniversary02View:MoveToLast(view)
    local pos = 6
    local i = 6
    while i>1 do
        local itemView = ItemEntityCache[i]
        if(itemView and itemView:IsHide())then 
            pos = i
            break
        end
        if(itemView==nil)then 
            pos = i
            break
        end
        i = i-1
    end
    if(pos==6)then 
        ItemEntityCache[pos] = view
    else
        local tempView = ItemEntityCache[pos]
        ItemEntityCache[6] = tempView
        ItemEntityCache[pos] = view
    end
    return pos 
end

function GiftPackAnniversary02View:MoveAllItem(flyTime,delay) 
    local delayCout = 0 
    for i=1,5 do
        local pos = self:GetItemPos(i)
        local itemView = self:RemoveItemViewByPos(i+1) 
 
        if(i==1 and itemView)then 
            itemView:MoveToPos(pos,flyTime,function()
                itemView:ChangeUnLock(true)   --移动前面就解锁 
            end) 
            coroutine.wait(delayCout) 
            delayCout = delay 
        else
            if(itemView~=nil)then 
                itemView:MoveToPos(pos,flyTime) 
                coroutine.wait(delayCout) 
                delayCout = delay 
            end 
        end

        self:SetViewByPos(itemView,i)
    end
    return delayCout
end

function GiftPackAnniversary02View:SetViewByPos(view,pos)
    ItemEntityCache[pos] = view
end

function GiftPackAnniversary02View:HideAllItemDir()
    for k,v in pairs(ItemEntityCache) do
        v:SetDirection(7)  --隐藏所有方向 
    end
end

function GiftPackAnniversary02View:ShowAllItemDir()
    local islastPos = 1
    local isFull = true 
    for k,v in pairs(ItemEntityCache) do
        if(v and v:IsHide()==false)then 
            v:SetDirection(k)   
            islastPos = k
        else
           
            isFull = false 
            if(v)then 
                v:SetDirection(7)  --隐藏所有方向 
            end
        end 
    end

    if(isFull==false or islastPos<=6)then 
        ItemEntityCache[islastPos]:SetDirection(7)
    end
end

function GiftPackAnniversary02View:RemoveItemViewByPos(index)
    local ret = ItemEntityCache[index]
    ItemEntityCache[index] = nil 
    return ret
end

local function GetFlyPos(step,rewardId)
    local flyStartPos = nil
    if step then
        local view = ItemEntityCache[1]
        if view then
            flyStartPos = view:GetFlyPos(rewardId)
        end
    end
    if not flyStartPos then
        flyStartPos = this.left_time_txt
    end
    return fun.get_gameobject_pos( flyStartPos)
end

function GiftPackAnniversary02View:on_btn_up_Free_click() --免费的
    if UnityEngine.Time.time - last_click_time <2 then 
        return 
    end 

    if not self.data then 
        return 
    end 
    local tmpdata = Csv.GetData("pop_up_infinite",self.data.id)
    if tmpdata.price ~= "0" then  
        return 
    end 
    
    last_click_time = UnityEngine.Time.time
    --无限礼包领取
    ModelList.GiftPackModel:SendEndlessGiftClaim(tmpdata.gift_id, tmpdata.step)
end

function GiftPackAnniversary02View:showGetRewardEffect(itemData,isFree)
    if itemData and  itemData.itemData then
        local offset = 0
        if isFree then offset = -1 end
        for i = 1, #itemData.itemData do
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,GetFlyPos(itemData.step+offset,itemData.itemData[i].id),itemData.itemData[i].id ,function()
                Event.Brocast(EventName.Event_currency_change)
                if ModelList.SeasonCardModel:IsCardPackage(itemData.itemData[i].id) then
                    ModelList.SeasonCardModel:OpenCardPackage({bagIds = {itemData.itemData[i].id}})
                end
            end,nil,i-1)
        end
    end
    self:CheckAutoClose()
end

function GiftPackAnniversary02View:CheckAutoClose()
    if _DeloopTimer ~= nil then
        self:stop_timer(_DeloopTimer)
    end
    _DeloopTimer = nil
    _DeloopTimer = self:register_timer(3.5,function()
        local needClose = ModelList.GiftPackModel:ShowingGiftComplete()
        if needClose then
            self:on_btn_close_click()
        end
    end)
end

--领取成功
function GiftPackAnniversary02View.OnClaimEndlessGiftSuccess(data) 
    local tmpdata  ={ itemData = data.reward,step = data.step}
    this:showGetRewardEffect(tmpdata,true)
    log.r("lxq  GiftPackAnniversary02View.OnClaimEndlessGiftSuccess 领取成功")
    --现实第一个
end

--领取失败
function GiftPackAnniversary02View.OnClaimEndlessGiftFail(data)
    --提示下领取失败
    log.r("lxq GiftPackAnniversary02View.OnClaimEndlessGiftFail")
end

--领取失败
function GiftPackAnniversary02View.OnFetchEndlessGiftFail(data)
    --提示下查询失败
    log.r("lxq GiftPackAnniversary02View.OnFetchEndlessGiftFail")
end

this.NotifyList = {
    {notifyName = NotifyName.EndlessGift.ClaimSuccess, func = this.OnClaimEndlessGiftSuccess},
    {notifyName = NotifyName.EndlessGift.ClaimFail, func = this.OnClaimEndlessGiftFail},
    {notifyName = NotifyName.EndlessGift.FetchSuccess, func = this.OnFetchEndlessGiftSuccess}, 
    {notifyName = NotifyName.EndlessGift.FetchFail, func = this.OnFetchEndlessGiftFail},
}

return this