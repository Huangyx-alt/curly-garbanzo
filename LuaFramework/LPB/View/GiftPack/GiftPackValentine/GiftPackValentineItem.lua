 
local GiftPackValentineItem = BaseView:New("GiftPackSweetmeatsItem")


local this = GiftPackValentineItem
this.viewType = CanvasSortingOrderManager.LayerType.None


this.auto_bind_ui_items = {
    "bl_buy_txt",
    "textVip",
    "item",
    "itemParent",
    "right",
    "bottom",
    "left",
    "GiftPackValentineItem",
    "btn_up_buy",
    "btn_up_Free",
    "cityExp1",
    "direction",
    "animator"
}   

local last_click_time = 0

 
function GiftPackValentineItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function GiftPackValentineItem:Awake()
    self.tempRewardList = {}
    self:on_init()
end


function GiftPackValentineItem:OnEnable(data)
    
end

 
 

function GiftPackValentineItem:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

function GiftPackValentineItem:SetPos(pos)
    if(pos)then 
        self.data.pos = pos
        fun.set_gameobject_pos_opt(self.go,pos.x,pos.y,pos.z,true)
    end

end

-- {
-- id = 当前的id
-- step = 当前的step 
-- sid = sid 
-- }
function GiftPackValentineItem:UpdateData(data,isShowAni)
    log.r("lxq GiftPackValentineItem",data)
    local tmpdata = Csv.GetData("pop_up_infinite",data.id)
    self.data = data
    --初始化奖励
    --初始化Vip经验
    log.log("无限礼包道具初始化 tmpdata " ,data.id , tmpdata )
    log.log("无限礼包道具初始化 data " ,  self.data)
    
    
    self:SetItem(data.id,tmpdata.price)
    self.go.name = "item"
    self:SetDirection(data.index)
    self:SetPos(data.pos)

    --初始化价格
    if tmpdata.price ~= "0" then 
        self.bl_buy_txt.text = "$"..tmpdata.price
        -- self.bl_buy_txt2.text = "$"..tmpdata.price
        fun.set_active(self.btn_up_buy,true)
        fun.set_active(self.btn_up_Free,false)
        fun.set_active(self.textVip , true)
    else 
        fun.set_active(self.btn_up_buy,false)
        fun.set_active(self.btn_up_Free,true)
        fun.set_active(self.textVip , false)
    end
    if tmpdata.step > data.step then --没有购买过 
        self:ChangeLock()
    elseif  tmpdata.step == data.step then --等于，需要判断是免费还是收费
        self:ChangeUnLock()
    else 
         
    end 
    
    last_click_time = 0
end


function GiftPackValentineItem:ChangeLock()
    if not self.animator:GetCurrentAnimatorStateInfo(0) :IsName("in") then
        fun.play_animator(self.go,"lock")
    else
        log.r("当前动画正在播放 in")
    end
   -- log.r(self.go.name .."         play lock")
    self.isUnlock = false  
end

function GiftPackValentineItem:ChangeUnLock(isAni)
    if(isAni)then 
        fun.play_animator(self.go,"unlock")
    else
        fun.play_animator(self.go,"buy")
    end 
end


function GiftPackValentineItem:SetItem(id ,price)
    
    --只设置一次
    if fun.get_child_count(self.itemParent) > 0 then 
        return 
    end 
    fun.set_active(self.cityExp1,false)
    local xls = Csv.GetData("pop_up_infinite", id)
 
    for k ,v in pairs(xls.item) do
        local itemId = tonumber(v[1])
        local itemNum = v[2]
        if itemId ~= Resource.vipExp   then 
            local itemGrid = fun.get_instance(self.item, self.itemParent)
            fun.set_active(itemGrid, true)
            self:SetItemGrid(itemId, itemNum , itemGrid,price)
            table.insert(self.tempRewardList, {id = itemId, obj = itemGrid})
        else
            fun.set_active(self.cityExp1,true)
            log.r("itemId:",itemId,itemNum,id,self.textVip)
            self.textVip.text = fun.format_money_reward({id = itemId, value = itemNum})
            table.insert(self.tempRewardList, {id = itemId, obj = self.cityExp1})
        end
    end


end


function GiftPackValentineItem:SetItemGrid(itemId, itemNum , itemGrid,price)
    if price == "0" then
        fun.set_rect_anchored_position_y(fun.get_child(itemGrid,0),0)
        fun.set_rect_anchored_position_y(fun.get_child(itemGrid,1),-85)
    end
    local refItem = fun.get_component(itemGrid , fun.REFER)
    local itemData = Csv.GetData("item", itemId)
    local icon = refItem:Get("icon")
    local textNum = refItem:Get("textNum")
    local iconName = Csv.GetItemOrResource(itemId, "icon")
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
            if iconName == "b_bingo_find" then
                textNum.text = fun.FormatText({id = itemId, value = itemNum})
            else
                textNum.text = fun.format_reward({id = itemId, value = itemNum}) 
            end
        end 
    end
end

--免费购买的状态
function GiftPackValentineItem:ChangeFreeState()
    --show 
    fun.set_active(self.btn_up_Free, true)
   
    fun.set_active(self.btn_up_Unlock,false)
 
    --设置itemParent 大小
 
 
    fun.play_animator(self.Anima,"unlock")
end 

--大的买的状态
function GiftPackValentineItem:ChangeBuyState()
    --show 
    fun.set_active(self.btn_up_buy, true)
    --hide
    fun.set_active(self.btn_up_Unlock,false)
    fun.set_active(self.btn_up_Free,false)
    fun.play_animator(self.Anima,"unlock")
end 

--小的上锁状态状态
function GiftPackValentineItem:ChangeUnlockState()
     --show 
    fun.set_active(self.btn_up_Unlock, true)

 --   fun.set_active(self.bgType1,false)
    fun.set_active(self.btn_up_buy,false)
    fun.set_active(self.btn_up_Free,false)
    if not self.animator:GetCurrentAnimatorStateInfo(0) :IsName("in") then
        fun.play_animator(self.animator,"lock")
    else
        log.e("当前状态是in")
    end
    log.r(self.go.name .."         play lock")
end 

-- 购买后上了mask 的灰色状态
function GiftPackValentineItem:ChangeOutState()
  
    fun.set_active(self.btn_up_Unlock,false)
    fun.set_active(self.btn_up_Free,false)
    fun.set_active(self.btn_up_buy, false) 
    fun.play_animator(self.Anima,"pick")
  
end 


function GiftPackValentineItem:SetDirection(index)
  
     local dir = {}
     dir[1]="right"
     dir[2]="bottom"
     dir[3]="left"
     dir[4]="bottom"
     dir[5]="right"
     dir[6]="bottom"
     
     fun.set_active(self.right,false)
     fun.set_active(self.bottom,false)
     fun.set_active(self.left,false)
     
     if(index <=6)then  
        fun.set_active(self[dir[index]],true)
        fun.play_animator(self.direction,"show",true)
     else
        fun.play_animator(self.direction,"hide",true)
     end
  
end 




function GiftPackValentineItem:on_btn_up_buy_click()  --需要购买 

    if(self.isUnlock==false )then 
        return 
    end

    if UnityEngine.Time.time - last_click_time <2 then 
        return 
    end 

    if not self.data  then 
        log.e("self.data.price ")
        return 
    end 

    local tmpdata = Csv.GetData("pop_up_infinite",self.data.id)

    if tmpdata.price == "0" then  
        return 
    end 
    last_click_time = UnityEngine.Time.time
    Event.Brocast(EventName.UnlimitSale_Click_Purchase)
    --普通购买礼包
    ModelList.GiftPackModel:ReqEditorBuySucess(tmpdata.gift_id, self.data.sid)
end
 
function GiftPackValentineItem:on_btn_up_Free_click() --免费的
    if(self.isUnlock==false )then 
        return 
    end
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

function GiftPackValentineItem:on_btn_up_Unlock_click() --上锁的 --点不动
    --提示未解锁
end

function GiftPackValentineItem:MoveToObj(obj) --上锁的 --点不动
    --提示未解锁

end

function GiftPackValentineItem:OnDisable()
    self:RemoveRewaritem()
    self.isUnlock = false  
end

function GiftPackValentineItem:PlayOut()
    self.isUnlock = false   
    log.log("播放消失动画")
     fun.play_animator(self.go,"out")
     self:register_timer(0.2,function() 
        self:RemoveRewaritem()
    end)
end



 
function GiftPackValentineItem:RemoveRewaritem()
    
    if self.tempRewardList then
        for i = 1, #self.tempRewardList do
            if(self.tempRewardList[i].id ~= Resource.vipExp) then 
                local obj = self.tempRewardList[i].obj 
                Destroy(obj)
            end 
        end
    end

    local cout = fun.get_child_count(self.itemParent)
    
    local cacheObj = {}
    for i=0,cout do
            local obj = fun.get_child(self.itemParent, i)
            table.insert(cacheObj,obj)
    end

    for k,v in pairs(cacheObj) do
        if(fun.is_null(v)==false)then 
            Destroy(v)
        end
       
    end

    self.tempRewardList = {}
end

function GiftPackValentineItem:PlayIn()
    fun.play_animator(self.go,"in") 
end
function GiftPackValentineItem:MoveToPos(pos,moveTime,callback) --上锁的 --点不动
    local mTime = moveTime or 0.5
    Anim.move(self.go,pos.x,pos.y,pos.z,mTime,true,true,callback)
end

function GiftPackValentineItem:IsHide() --上锁的 --点不动
    --提示未解锁
     local isVisable = fun.get_active_self(self.go)
     if(isVisable==false )then 
        return true 
     end
     local canvasGroup = fun.get_component(self.GiftPackValentineItem,fun.CANVAS_GROUP)
     if(canvasGroup and canvasGroup.alpha==0)then 
        return true 
     end
     return false 
end
function GiftPackValentineItem:GetFlyPos(itemId)
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

return this