--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]

local base = require "GamePlayShortPass/Base/BasePassReceivedView"
local PassReceivedView = class("PassReceivedView",base ) 
local this = PassReceivedView
this.viewName = "PassReceivedView"
this.atlasName = "ScratchWinnerPopupAtlas"

function PassReceivedView:SetParam(param)
    if(param.onCloseCallback)then 
        self:SetCloseCallback(param.onCloseCallback)
    end
end

function PassReceivedView:SetCloseCallback(closeCallback)
    self.closeCallback = closeCallback
end

function PassReceivedView:OnDisable()
    base.OnDisable(self)
    if self.closeCallback then
        self.closeCallback()
    end
    self.closeCallback = nil
end

return this 
