-- 城市6
local Play15package = {}
local this = Play15package

function Play15package:LoadRequire()
    --- 资源列表添加到主AssetList
    local list = require "Module/Play15AssetList"
    if list then
        for k,v in pairs(list) do
            if not AssetList[k] then
                AssetList[k] = v
            end
        end
    end
end

return this