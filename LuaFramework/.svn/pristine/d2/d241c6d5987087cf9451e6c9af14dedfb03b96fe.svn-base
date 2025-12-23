local GiftPackSweetmeatsItemBigState = require "State/GiftPackSweetmeatsItem/GiftPackSweetmeatsItemBigState"
local GiftPackSweetmeatsItemFreeState = require "State/GiftPackSweetmeatsItem/GiftPackSweetmeatsItemFreeState"
local GiftPackSweetmeatsItemOutState = require "State/GiftPackSweetmeatsItem/GiftPackSweetmeatsItemOutState"
local GiftPackSweetmeatsSmallState = require "State/GiftPackSweetmeatsItem/GiftPackSweetmeatsSmallState"
local GiftPackSweetmeatsItemIdleState = require "State/GiftPackSweetmeatsItem/GiftPackSweetmeatsItemIdleState"

local GiftPackSweetmeatsItem = BaseView:New("GiftPackSweetmeatsItem")
local this = GiftPackSweetmeatsItem
this.viewType = CanvasSortingOrderManager.LayerType.None


this.auto_bind_ui_items = {
   "textExtra",
   "bl_buy_txt",
   "textVip",
   "item" ,  --rewarditem 
   "itemParent",
   "extra",
   "bgType1",
   "bgType2",
   "Mask",
   "btn_up_buy",
   "btn_up_Free",
   "btn_up_Unlock",
   "bl_buy_txt2",
   "cityExp1",
   "Anima"
}   

local last_click_time = 0
function GiftPackSweetmeatsItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function GiftPackSweetmeatsItem:Awake()
    self.tempRewardList = {}
    self:on_init()
end


function GiftPackSweetmeatsItem:OnEnable(data)
    self:BuildFsm()
    fun.set_active(self.item, false)
end

function GiftPackSweetmeatsItem:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("GiftPackSweetmeatsItem",self,{
        GiftPackSweetmeatsItemBigState:New(),
        GiftPackSweetmeatsItemFreeState:New(),
        GiftPackSweetmeatsItemOutState:New(),
        GiftPackSweetmeatsSmallState:New(),
        GiftPackSweetmeatsItemIdleState:New()
    })
    

    self._fsm:StartFsm("GiftPackSweetmeatsItemIdleState")
end


function GiftPackSweetmeatsItem:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function GiftPackSweetmeatsItem:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end
-- {
-- id = 当前的id
-- step = 当前的step 
-- sid = sid 
-- }
function GiftPackSweetmeatsItem:UpdateData(data)
    local tmpdata = Csv.GetData("pop_up_infinite",data.id)
    self.data = data
    --初始化奖励
    --初始化Vip经验
    self:SetItem(data.id)
    --初始化bourns 
    if tmpdata.bonus ~= 0 then 
        self.textExtra.text = tostring(tmpdata.bonus).."%"
        fun.set_active(self.extra,true )
    else 
        fun.set_active(self.extra,false )
    end 

    --初始化价格
    if tmpdata.price ~= "0" then 
        self.bl_buy_txt.text = "$"..tmpdata.price
        self.bl_buy_txt2.text = "$"..tmpdata.price
    else 
        self.bl_buy_txt.text = "Free!  "
        self.bl_buy_txt2.text = "Free!  "
    end 

    if tmpdata.step > data.step then --没有购买过
        self._fsm:ChangeState("GiftPackSweetmeatsSmallState",self._fsm)
    elseif  tmpdata.step == data.step then --等于，需要判断是免费还是收费
        if  tmpdata.price == "0" then
            self._fsm:ChangeState("GiftPackSweetmeatsItemFreeState",self._fsm)
        else 
            self._fsm:ChangeState("GiftPackSweetmeatsItemBigState",self._fsm)
        end 
    else 
        self._fsm:ChangeState("GiftPackSweetmeatsItemOutState",self._fsm)
    end 
    
    last_click_time = 0
end

function GiftPackSweetmeatsItem:SetItem(id )
    
    --只设置一次
    if fun.get_child_count(self.itemParent) > 0 then 
        return 
    end 

    local xls = Csv.GetData("pop_up_infinite", id)
    fun.set_active(self.cityExp1,false)
    for k ,v in pairs(xls.item) do
        local itemId = tonumber(v[1])
        local itemNum = v[2]
        if itemId ~= Resource.vipExp   then
            
            local itemGrid = fun.get_instance(self.item, self.itemParent)
            self:SetItemGrid(itemId, itemNum , itemGrid)
            fun.set_active(itemGrid, true)
            table.insert(self.tempRewardList, {id = itemId, obj = itemGrid})
        else
            fun.set_active(self.cityExp1,true)
            self.textVip.text = fun.format_money_reward({id = itemId, value = itemNum})
            table.insert(self.tempRewardList, {id = itemId, obj = self.cityExp1})
        end
    end


end


function GiftPackSweetmeatsItem:SetItemGrid(itemId, itemNum , itemGrid)
    local refItem = fun.get_component(itemGrid , fun.REFER)
    local itemData = Csv.GetData("item", itemId)
    local icon = refItem:Get("icon")
    local textNum = refItem:Get("textNum")
    local iconKey = "more_icon"
    local iconName = nil 
  
    if itemId == Resource.coin or itemId == Resource.diamon or itemId == Resource.rocket then 
        iconName = Csv.GetItemOrResource(itemId, "more_icon")
    else 
        if itemData and  itemData.item_type == ItemType.rofy then
            iconName = Csv.GetItemOrResource(itemId, "more_icon")
            fun.set_rect_offset_local_pos(icon.gameObject, 0, 40, 0)
        else 
            iconName = Csv.GetItemOrResource(itemId, "icon")
            fun.set_rect_offset_local_pos(icon.gameObject, 0, 40, 0)
        end
    end 

    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    if ModelList.TournamentModel:IsSprintBuffId(itemId) then
        local des
        local hrs = math.floor(itemNum / 60)
        if hrs > 0 then
            des = fun.NumInsertComma(hrs) .. " HRS"
        else
            local min = itemNum
            des = fun.NumInsertComma(min) .. " Min"
        end
        textNum.text = des
    else
        if itemData ~=nil and itemData.destroy_cd ~= nil and itemData.destroy_cd ~= 0 then 
            textNum.text = fun.format_money_reward({id = itemId, value = itemNum}).."Mins"
        else 
            textNum.text = fun.format_money_reward({id = itemId, value = itemNum}) 
        end 
    end
end

--免费购买的状态
function GiftPackSweetmeatsItem:ChangeFreeState()
    --show 
    fun.set_active(self.btn_up_Free, true)
   
    fun.set_active(self.btn_up_Unlock,false)
    fun.set_active(self.btn_up_buy,false)
    --设置itemParent 大小
 
    if self.Anima then
    self.Anima:Play("unlock",0,0)
    end
end 

--大的买的状态
function GiftPackSweetmeatsItem:ChangeBuyState()
    --show 
    fun.set_active(self.btn_up_buy, true)

    --hide
    fun.set_active(self.btn_up_Unlock,false)
    fun.set_active(self.btn_up_Free,false)
 

    if self.Anima then
        self.Anima:Play("unlock",0,0)
    end
end 

--小的上锁状态状态
function GiftPackSweetmeatsItem:ChangeUnlockState()
     --show 
    fun.set_active(self.btn_up_Unlock, true)

 --   fun.set_active(self.bgType1,false)
    fun.set_active(self.btn_up_buy,false)
    fun.set_active(self.btn_up_Free,false)

    if self.Anima then
        self.Anima:Play("lock",0,0)
    end
end 

-- 购买后上了mask 的灰色状态
function GiftPackSweetmeatsItem:ChangeOutState()
  
    fun.set_active(self.btn_up_Unlock,false)
    fun.set_active(self.btn_up_Free,false)
    fun.set_active(self.btn_up_buy, false)
  
    if self.Anima then
      self.Anima:Play("pick",0,0)
    end
  
end 

function GiftPackSweetmeatsItem:on_btn_up_buy_click()  --需要购买
    
    if UnityEngine.Time.time - last_click_time <2 then 
        return 
    end 

    if not self.data  then 
        log.r("self.data.price ".. tmpdata.price)
        return 
    end 

    local tmpdata = Csv.GetData("pop_up_infinite",self.data.id)

    if tmpdata.price == "0" then  
        return 
    end 
    last_click_time = UnityEngine.Time.time
    --普通购买礼包
    ModelList.GiftPackModel:ReqEditorBuySucess(tmpdata.gift_id, self.data.sid)
end
 
function GiftPackSweetmeatsItem:on_btn_up_Free_click() --免费的
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

function GiftPackSweetmeatsItem:on_btn_up_Unlock_click() --上锁的 --点不动
    --提示未解锁
end

function GiftPackSweetmeatsItem:GetFlyPos(itemId)
    if #self.tempRewardList == 1 then
        return self.tempRewardList[1].obj
    end
    if self.tempRewardList then
        for i = 1, #self.tempRewardList do
            if self.tempRewardList[i].id == itemId then
                local obj = self.tempRewardList[i].obj
                table.remove(self.tempRewardList, i)
                return obj
            end
        end
    end
end


function GiftPackSweetmeatsItem:OnDisable()
    
end

return this
