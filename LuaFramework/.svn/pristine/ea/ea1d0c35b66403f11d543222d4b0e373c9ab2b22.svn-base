local Command = {};

function Command.LoadUiFromCache(view,viewGo,args)
 
    local parent =  view:GetRootView()
    if(parent)then 
        viewGo.transform:SetParent(parent.transform)
        viewGo.transform.localScale = Vector3.New(1,1,1)
        viewGo.transform.localPosition = Vector3.New(0,0,0)
        local rect = fun.get_component(viewGo,fun.RECT)
        if rect then
            rect.offsetMin = Vector2.New(0, 0)
            rect.offsetMax = Vector2.New(0, 0)
        end
        view:SkipLoadShow(viewGo)
        local callback = args
        if(callback and type(callback)=="function")then 
            callback()
        end
    else
        log.r(view.viewName.." 无法找到RootView,可能当前在loading场景中")
    end

end

---从预制体中生成一个UI出来
function Command.Execute(notifyName, view,callback,is_click)


    if(view==nil or type(view)~="table")then
        log.r("view is nil")
        return
    end
    if not view then
        return
    end ;
    if is_click then
        --事件打点_UI交互_点击打开界面
        SDK.click_view(view.viewName, SceneViewManager.GetCurrentSceneName())
    end

    --(SceneViewManager.AddView(view,nil))then
    --    log.y("ShowPopup view:",view.viewName )
    --log.r("ShowPopup view:",view )

    local viewGo = SceneViewManager.RemoveToCache(view.viewName)
    if (viewGo) then
        Command.LoadUiFromCache(view, viewGo, callback)
    else
        view:Show(callback);
    end
    --end

end
return Command;