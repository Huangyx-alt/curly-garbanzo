-- 在测试代码中添加内存监控
---@type ResourcesManager
local resSys = ResourcesManager
function TestMemoryLeak()
    local initialMem = collectgarbage("count")

    -- 模拟重复加载同一资源
    for i = 1, 100 do
        resSys:LoadAssetAsync(BundleCategory.LPB.Prefabs,
            "yooTest/sphere.prefab",
            typeof(CS.GameObject), function() end)
    end

    collectgarbage("collect")
    local finalMem = collectgarbage("count")

    assert(finalMem - initialMem < 10,
        string.format("内存泄漏! 初始:%.2fKB, 最终:%.2fKB", initialMem, finalMem))
end

local function Run()
    TestMemoryLeak()
    print("TestMemoryLeak Pass!")
end

return {
    Run = Run
}
