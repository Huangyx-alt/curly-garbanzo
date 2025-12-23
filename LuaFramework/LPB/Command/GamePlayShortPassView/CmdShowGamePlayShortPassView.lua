--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};

function Command.Execute(GameActivityPassModel,viewName,param )

    local id = GameActivityPassModel.GetCurrentId()
    local mapping = GameActivityPassModel.GetMappingData() 
    local view = GameActivityPassModel.GetViewById(id,viewName) 
    -- local name = mapping[id]
    -- local abPath = "luaprefab_uiviews_"..name.."_"..viewName
    -- abPath = string.lower(abPath) 

    if(view==nil)then 
        log.e(" not found "..viewName)
        return 
    end

    if( AssetList[viewName]==nil)then 
        log.e(" not found "..viewName.." id:"..id)
        return 
    end

    view.bundleName = AssetList[viewName]
    view.viewName = viewName

    if(view.SetParam and param)then 
        view:SetParam(param)
    end

    Facade.SendNotification(NotifyName.ShowUI,view) 
end

return Command;