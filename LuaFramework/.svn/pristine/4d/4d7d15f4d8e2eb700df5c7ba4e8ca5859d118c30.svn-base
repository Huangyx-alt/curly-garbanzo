-- 工会模块的加载


local Clubpackage = {}
local this = Clubpackage

function Clubpackage:LoadRequire()

    if not ModelList.ClubModel then
        --log.r("load SingleWolfGameModel")
        ModelList.ClubModel = require "Model/ClubModel"
        ModelList:InitModule(ModelList.ClubModel)
    end
    if not ViewList.ClubDetailView then
        --ViewList.SingleWolfBingoView = require "View.Bingo.UIView.PartView.CardView.SingleWolfBingoView"
        ViewList.ClubDetailView = require "View/ClubView/ClubDetailView"
        ViewList.ClubLeaveView = require "View/ClubView/ClubLeaveView"
        ViewList.ClubListSearchView = require "View/ClubView/ClubListSearchView"
        ViewList.ClubMainView = require "View/ClubView/ClubMainView"
        ViewList.ClubMemberListView = require "View/ClubView/ClubMemberListView"
        ViewList.ClubReqResAskView = require "View/ClubView/ClubReqResAskView"
        ViewList.ClubWelcomeView = require "View/ClubView/ClubWelcomeView"
        ViewList.ClubReqGiftPacketHelpView = require "View/ClubView/ClubReqGiftPacketHelpView"
        ViewList.ClubOpenPackGiftGetView = require "View/ClubView/ClubOpenPackGiftGetView"
        ViewList.ClubOpenPackGiftGetListView = require "View/ClubView/ClubOpenPackGiftGetListView"
        ViewList.ClubReqCardHelpView = require "View/ClubView/ClubReqCardHelpView"
        ViewList.ClubReqCardView = require "View/ClubView/ClubReqCardView"
        ViewList.ClubGiftPacketHelpView = require "View/ClubView/ClubGiftPacketHelpView"
        --- 资源列表添加到主AssetList
        local clubAssetlist = require "Module/ClubAssetList"
        if clubAssetlist then
            for k,v in pairs(clubAssetlist) do
                if not AssetList[k] then
                    AssetList[k] = v
                end
            end
        end
    end
end

return this