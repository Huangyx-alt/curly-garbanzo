local base = require "GamePlayShortPass/Base/BasePassReceivedView"
local PassReceivedView = class("PassReceivedView", base) 
local this = PassReceivedView
this.viewName = "PassReceivedView"
this.atlasName = "GotYouPopupAtlas"

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