--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};

local debug = false 

function Command.Execute(FunctionIconGamePassView, callback)
     
 
    local playid = ModelList.CityModel.GetPlayIdByCity()
 
    ModelList.GameActivityPassModel.SetCurrentId(playid)

    local viewName = "FunctionIcon"
    local id = playid

    local mapping = ModelList.GameActivityPassModel.GetMappingData() 
  
    -- local name = mapping[id]
    -- local abPath = "luaprefab_uiviews_"..name
    -- abPath = string.lower(abPath) 
    if(AssetList.FunctionIcon)then 
        Cache.load_prefabs(AssetList.FunctionIcon,viewName,function(ret)
            if ret then
                if(callback)then 
                    local go = fun.get_instance(ret) --Cache.create(ab,data.prefab_name)
                    callback(go)
                end 
            end
        end)
    end
   
end

return Command;