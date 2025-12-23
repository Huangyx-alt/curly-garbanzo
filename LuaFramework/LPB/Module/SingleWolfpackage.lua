-- 绿头人的加载


local SingleWolfpackage = {}
local this = SingleWolfpackage

function SingleWolfpackage:LoadRequire()
    require "Procedure/ProcedureSingleWolf"
    if not ModelList.SingleWolfGameModel then
        --log.r("load SingleWolfGameModel")
        ModelList.SingleWolfGameModel = require "Model/SingleWolfGameModel"
        ModelList:InitModule(ModelList.SingleWolfGameModel)
    end
    if not ViewList.SingleWolfBingoView then
        ViewList.SingleWolfBingoView = require "View.Bingo.UIView.PartView.CardView.SingleWolfBingoView"
    end
end

return this