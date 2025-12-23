-- 城市6
local Play14package = {}
local this = Play14package

function Play14package:LoadRequire()
    --- 资源列表添加到主AssetList
    local list = require "Module/Play14AssetList"
    if list then
        for k,v in pairs(list) do
            if not AssetList[k] then
                AssetList[k] = v
            end
        end
    end
end

return this