local CommonRewardNetView = BaseView:New("CommonRewardNetView")
local this = CommonRewardNetView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "btn_try",
    "Content",
    "Title",
    "item",
    "ItemParent",
}
local allReward = {}
function CommonRewardNetView:New(viewName, atlasName)
    local o = {viewName = viewName, atlasName = atlasName, isShow = false, isLoaded = false, changeSceneClear = true}
    self.__index = self
    setmetatable(o, self)
    return o
end

function CommonRewardNetView:Awake(obj)
    self:on_init()
end

--[[
    param.title = string 
    param.content = string 
    param.reward[]
]]
function CommonRewardNetView:OnEnable(param)
    self.Title.text = param.title 
    self.Content.text = param.content 
    allReward = {}
    for _,v in pairs(param.reward) do 
        local itemGrid = fun.get_instance(self.item, self.ItemParent);
        this:SetItemGrid(v.id,v.value,itemGrid);
        
        table.insert(allReward,{go= itemGrid,id =v.id })
    end 


end 

function CommonRewardNetView:SetItemGrid(itemId, itemNum , itemGrid)
    local refItem = fun.get_component(itemGrid , fun.REFER)
    local icon = refItem:Get("icon")
    local textNum = refItem:Get("textNum")
    local iconName = nil 
    if itemId == Resource.coin or itemId == Resource.diamon then 
        iconName = Csv.GetItemOrResource(itemId, "more_icon")
    else 
        iconName = Csv.GetItemOrResource(itemId, "icon")
    end 
    
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    textNum.text = fun.format_money_reward({id = itemId, value = itemNum})
end


function CommonRewardNetView:OnDisable()
    self:Close()
    allReward = {}
    Event.Brocast(EventName.Event_Deep_Link_finish)--结束此order状态
end

function CommonRewardNetView:on_close()
 
end

function CommonRewardNetView:on_btn_try_click()
    local delay = 0
    local coroutine_fun = nil
    local count = 0
    for key, value in ipairs(allReward) do
      
        local pos = nil 
        if value.go then 
            pos = value.go.transform.position 
        end 
        coroutine_fun = function()
            delay = delay + 0.2
            count = count + 1
            coroutine.wait(delay)
             
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts, pos,value.id,function()
                count = math.max(0,count - 1)
                Event.Brocast(EventName.Event_currency_change)
                if 0 == count then
                    Facade.SendNotification(NotifyName.CloseUI, this)
                end
            end, nil, true)
        end
        coroutine.resume(coroutine.create(coroutine_fun))
    end

   
end 

function CommonRewardNetView:DisposeFsm()
 
end


return this