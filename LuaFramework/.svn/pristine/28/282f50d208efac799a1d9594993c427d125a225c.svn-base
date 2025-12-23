-- 初始化资源系统
---@type AtlasManager
-- local atlasSys = AtlasManager:GetInstance()

local function OnLoadAtlas()
    AtlasManager:LoadAtlasesAsync(
        {"AchievementItemAtlas"},
        nil,
        function(success)
            if success then
                print("Atlas loaded successfully!")
                -- 这里可以添加对加载完成的图集进行操作的代码
            else
                print("Failed to load atlas.")
            end
        end)
end

local function LoadImage()
    AtlasManager:LoadImageAsync(
        "AutoHallAtlas",
        nil,
        function(spriteAtals,sprite,err)
            if spriteAtals then
                print("Atlas loaded successfully!")
                -- 这里可以添加对加载完成的图集进行操作的代码
            else
                print("Failed to load atlas.")
            end
        end)
end



local function Run()
    OnLoadAtlas()
    LoadImage()
end

return {
    Run = Run
}
