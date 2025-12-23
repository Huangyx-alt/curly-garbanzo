local HallExplainHelpView = require "View/CommonView/HallExplainHelpView"
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder, "")
local this = PopupOrder

function PopupOrder.Execute(args)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local playType = Csv.GetData("city_play", playid, "play_type")
    if playType == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        this.Finish()
        return
    end
    
    local playerInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local value = fun.read_value("howHallHelp" .. tostring(playid) .. "uid" .. playerInfo.uid, nil)
    --城市1 不主动弹出 
    if playid == 1 then value = 1 end
    
    if not value or value == 0 then
        Event.AddListener(EventName.Event_popup_GameHallHelp_finish, this.Finish)

        if not value then
            fun.save_value("howHallHelp" .. tostring(playid) .. "uid" .. playerInfo.uid, 1)
        end

        if playType == PLAY_TYPE.PLAY_TYPE_NORMAL then
            Cache.Load_Atlas(AssetList["HallMainHelpAtlas"], "HallMainHelpAtlas", function()
                this.LoadView(playid)
            end)
        else
            this.LoadView(playid)
        end
    else
        this.Finish()
    end
end

function PopupOrder.LoadView(playID)
    local helpSetting = Csv.GetData("new_game_help_setting", playID)
    local assetViewName, atlasViewName = helpSetting.asset_viewname, helpSetting.atlas_viewname
    Cache.load_prefabs(AssetList[assetViewName], atlasViewName, function(obj)
        local root = HallExplainHelpView:GetRootView()
        local gameObject = fun.get_instance(obj, root)
        HallExplainHelpView:SkipLoadShow(gameObject)
    end)
end

function PopupOrder.Finish()
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.RemoveListener(EventName.Event_popup_GameHallHelp_finish, this.Finish)

    Event.Brocast(EventName.Event_Is_Can_Show_Help_View)
    this.NotifyCurrentOrderFinish()
end

return this