RedDotParam = {
    city_truenpage_left = 1003,
    city_turnpage_right = 1004,
    shop_coin = 5001,
    shop_gem = 5002,
    shop_offers = 5003,
    shop_items = 5004,
    shop_cherry = 5005,
    city_top_shop = 5013,

    regularlyaward_top_shop = 5017,

    auto_city_cuisines = 5018,

    task_daily = 5019,
    task_weekly = 5020
}

RedDotEvent =
{
    cuisines_reddot_event                       = 1,
    decals_reddot_event                         = 2,
    shop_coinfree_event                         = 3,
    othercitycuisines_reddot_event              = 4,
    task_reddot_event                           = 5,
    puzzle_reddot_event                         = 6,
    maincity_auto_event                         = 7,
    mail_reddot_event                           = 8,
    bingopass_reddot_event                      = 9,
    club_reddot_event                           = 10,
    game_pass_reddot_event                           = 11,
}

RedDotManager = {}
local this = RedDotManager

local node2iconList = {}

function RedDotManager:Init()
    Event.AddListener(EventName.Event_cherry_change,this.OnCherryChange,this)
    Event.AddListener(EventName.Event_items_change,this.OnItemsChange,this)
end

function RedDotManager:OnCherryChange(data)
    this:Refresh(RedDotEvent.decals_reddot_event)
end

function RedDotManager:OnItemsChange(data)
    if data == nil then
        return
    end
    --if data.type == ItemType.food then
    --    this:Refresh(RedDotEvent.cuisines_reddot_event)
    --end
end

function RedDotManager:RegisterNode(reddot_event,key, icon, param)
    assert(icon ~= nil and key ~= nil, "icon异常")
    local node_key = string.format("reddot_%s%s%s",reddot_event,key,param or "")
    if node2iconList[reddot_event] == nil then
        node2iconList[reddot_event] = {}
    end
    node2iconList[reddot_event][node_key] = {icon = icon,param = param}
    local event_data = Csv.GetData("reddotevent",reddot_event)
    assert(event_data ~= nil,"数据表异常")
    for key, value in pairs(event_data.execute) do
        local execute = require(string.format("RedDot/%s",value))
        assert(execute ~= nil,"丢失lua脚本")
        execute:Check(node2iconList[reddot_event][node_key],nil)
    end
end

function RedDotManager:UnRegisterNode(reddot_event, key, param)
    local node_key = string.format("reddot_%s%s%s",reddot_event,key,param or "")
    if node2iconList[reddot_event] and node2iconList[reddot_event][node_key]then
        node2iconList[reddot_event][node_key] = nil
    end
end

function RedDotManager:Check(reddot_event,param)
    if node2iconList[reddot_event] then
        local event_data = Csv.GetData("reddotevent",reddot_event)
        assert(event_data ~= nil,"数据表异常")
        for key, value in pairs(event_data.execute) do
            local execute = require(string.format("RedDot/%s",value))
            assert(execute ~= nil,"丢失lua脚本")
            for key1, value1 in pairs(node2iconList[reddot_event]) do
                execute:Check(value1,param)
            end
        end
    end
end

function RedDotManager:Refresh(reddot_event,param)
    if node2iconList[reddot_event] then
        local event_data = Csv.GetData("reddotevent",reddot_event)
        assert(event_data ~= nil,"数据表异常")
        for key, value in pairs(event_data.execute) do
            local execute = require(string.format("RedDot/%s",value))
            assert(execute ~= nil,"丢失lua脚本")
            execute:Refresh(node2iconList[reddot_event],param)
        end
    end
end