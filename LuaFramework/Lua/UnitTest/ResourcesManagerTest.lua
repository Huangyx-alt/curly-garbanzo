---@type ResourcesManager

local resSys = ResourcesManager
local loader = {}
function loader.LoadAssetAsync()
    resSys:LoadAssetAsync(
        BundleCategory.Test,
        "yooTest/sphere",
        typeof(CS.GameObject),
        function(assetId, err)
            if assetId ~= nil and assetId > 0 then
                local prefab = resSys:GetAssetObject(assetId)
                CS.GameObject.Instantiate(prefab)
            end
        end)
end

function loader.LoadAssetSync()
    local sphere_object = resSys:LoadAssetSync(
        BundleCategory.Test,
        "yooTest/sphere",
        typeof(CS.GameObject))
    CS.GameObject.Instantiate(sphere_object)
end

function loader.OnSceneChanged()
    resSys:LoadSceneAsync(
        "SceneLoading",
        function(handle, errMsg)
            if handle ~= nil and errMsg == nil then
                print('SceneLoading ========================== ')
            end
        end,
        true,
        CS.LoadSceneMode.Additive
    )
end

local function Run()
    loader.LoadAssetSync()
    loader.LoadAssetSync()
    loader.LoadAssetSync()
    loader.LoadAssetSync()
    loader.LoadAssetSync()
    loader.LoadAssetSync()
    loader.LoadAssetSync()
    print("ResourcesManagerTest Pass!")
end

return {
    Run = Run
}
