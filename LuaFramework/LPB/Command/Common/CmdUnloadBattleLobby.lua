local Command = {};

function Command.LoadUiFromCache(view,viewGo,callback,params)

end

---从预制体中生成一个UI出来
function Command.Execute(notifyName, view,callback,is_click,params)
    --UnityEngine.Resources.UnloadUnusedAssets()
    Util.ClearMemory()
end

return Command;