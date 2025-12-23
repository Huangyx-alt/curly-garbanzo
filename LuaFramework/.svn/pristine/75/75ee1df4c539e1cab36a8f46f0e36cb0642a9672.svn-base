--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};

function Command.Execute(notifyName, ...)
    local view, args = HandleNotifyParams(...);
    -- 初始化GameUI

    local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    local gameBingoView =  fun.find_child(game_ui,"GameBingoView")
    log.w("Bingo --  InitSceneGame ")
    Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.GameBingoView,gameBingoView )
end

return Command;