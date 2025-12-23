
local Command = {};

function Command.Execute(notifyName, view,is_click,playsound)

    if not view then return end;
    if is_click then
        -- 事件打点_UI交互_点击关闭界面
        SDK.click_view_exit(view.viewName,SceneViewManager.GetCurrentSceneName())
    end
    SceneViewManager.RemoveView(view)
    -- SceneViewManager.RemoveBindView(view)
    view:Hide();
end
return Command;