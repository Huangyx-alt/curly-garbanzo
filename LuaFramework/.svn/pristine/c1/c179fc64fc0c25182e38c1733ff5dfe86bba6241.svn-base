---@type ResourcesManager
local resSys = ResourcesManager

local function OnSceneChanged()
    resSys:LoadSceneAsync(
        "SceneGame",
        function(handle, errMsg)
            if handle ~= nil and errMsg == nil then
                handle:UnSuspend()
                print('取消 SceneGame 挂起 ========================= ')
            end
        end,
        false
    )
end

local function Run()
    OnSceneChanged()
    print("SceneLoaderTest Pass!")
end

return {
    Run = Run
}
