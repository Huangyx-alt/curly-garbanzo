-- 绿头人的加载


local LeetoleManpackage = {}
local this = LeetoleManpackage

function LeetoleManpackage:LoadRequire()
    require "Procedure/ProcedureLeeToleMan"
    if not ModelList.LeetoleManModel then
        log.r("LeetoleManModel   init")
        ModelList.LeetoleManModel = require "Model/LeetoleManModel"
        ModelList:InitModule(ModelList.LeetoleManModel)
    end
    if not ViewList.LeetoleManView then
        ViewList.LeetoleManView = require "View.Bingo.UIView.PartView.CardView.LeetoleManView"
    end
end

return this