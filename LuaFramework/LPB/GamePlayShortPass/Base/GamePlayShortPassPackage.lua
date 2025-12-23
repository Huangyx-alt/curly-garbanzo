--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]

-- require "GamePlayShortPass/Base/BasePassDataComponent"
-- require "GamePlayShortPass/Base/BasePassHelpView"
-- require "GamePlayShortPass/Base/BasePassView"
-- require "GamePlayShortPass/Base/BaseSpinRewardView"
-- require "GamePlayShortPass/Base/BaseTaskDataComponent"
-- require "GamePlayShortPass/Base/BaseTaskView"
-- require "GamePlayShortPass/Base/GamePlayShortPassPackage"



local GamePlayShortPassPackage = class("GamePlayShortPassPackage")-- Clazz(ClazzBase,"GamePlayShortPassPackage")

function GamePlayShortPassPackage:LoadPlayPackage(playName,id)
        local package = require("GamePlayShortPass."..playName..".Package")
        local ret = {}
        for i,v in ipairs(package.clazz_list) do
            local s = Split(v,"%.")
            local name = s[#s]   --取最后的 Lua名字 比如  "ModeState.StateHoldSpinFreespin",   name = StateHol1dSpinFreespin
            local luaPath = "GamePlayShortPass."..playName.."."..v
            local class = require(luaPath)
            -- log.r("LoadPlayPackage",luaPath,class)
            ret[name] = class:create(id)
        end
        return ret
end


return GamePlayShortPassPackage