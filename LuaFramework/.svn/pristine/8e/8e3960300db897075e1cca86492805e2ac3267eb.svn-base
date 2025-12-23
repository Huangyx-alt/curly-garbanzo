-- 城市6
local Play25package = {}
local this = Play25package

function Play25package:LoadRequire()
    --- 资源列表添加到主AssetList
    local list = require "Module/Play25AssetList"
    if list then
        for k,v in pairs(list) do
            if not AssetList[k] then
                AssetList[k] = v
            end
        end
    end
end

return this