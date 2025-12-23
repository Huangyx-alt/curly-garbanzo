
local BaseBingoView = require("View.Bingo.UIView.MainView.BaseBingoView")
local GameBingoView = BaseBingoView:New("GameBingoView","BingoAtlas")
setmetatable(GameBingoView,BaseBingoView)

local this = GameBingoView;
this.isCleanRes = true

this.ViewName = "GameBingoView"

function GameBingoView:LoadBingoViewRequire(isGuide)
    getmetatable(self).LoadBingoViewRequire(self,isGuide)
    
    if self.miniGame then
        local tickets = require "View/Bingo/UIView/ChildView/MiniGameTickets"
        self.minigameTicket = tickets:New()
        self.minigameTicket:SkipLoadShow(self.miniGame)
    end
end

function GameBingoView:InitCityBg()
    self.__index.InitCityBg(self, function(bg_animator)
        local cityID = ModelList.CityModel:GetCity()
        if cityID == 7 or cityID == 8 then
            self:PlayBackgroundAction("enter")
        end
    end)
end

function GameBingoView:TimeCountOver(jokerPos)
    self.__index.TimeCountOver(self, jokerPos)
    
    local cityID = ModelList.CityModel:GetCity()
    if cityID == 7 or cityID == 8 then
        self:PlayBackgroundAction("move")
    end
end

return this










