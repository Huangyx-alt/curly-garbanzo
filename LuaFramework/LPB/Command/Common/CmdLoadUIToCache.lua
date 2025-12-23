--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-18 15:52:11
]]


local Command = {};
--[[
    @desc: 将UI压入cache中,
    author:{author}
    time:2020-11-18 15:53:29
    --@notifyName:
	--@args: 
    @return:
]]
function Command.Execute(notifyName, view,callback)
 
    if not view then return end; 
    if(not SceneViewManager.CheckViewIsCache(view.viewName))then
        if view.viewName and view.atlasName then
            Cache.load_view_prefab(nil,view.viewName,view.atlasName,function(panel_name,prefabs)
                local go = fun.get_instance(prefabs[0])
    
                if go and go.transform then
                    go.name = panel_name
                    local cacheObj = UnityEngine.GameObject.Find("UICache")
                    go.transform:SetParent(cacheObj.transform)
                    go.transform.localScale = Vector3.New(1,1,1)
                    go.transform.localPosition = Vector3.New(0,0,0)
                    SceneViewManager.AddToCache(go)
        
                    if(callback)then 
                        callback()
                    end
                end
            end,view.second_atlas_name)
        end
    else
        if(callback)then 
            callback()
        end
    end  
end

return Command;