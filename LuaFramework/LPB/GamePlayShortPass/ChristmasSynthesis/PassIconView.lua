local base = require "GamePlayShortPass/Base/BasePassIconView"
local PassIconView = class("PassView",base)
local this = PassIconView
this.viewName = "PassIconView"
--- flag:短令牌 每次增加新的短令牌都要修改
local buffId = 903102

function PassIconView:GetBuffId()
    return buffId
end

--- 点击icon处理,有长任务,额外增加请求数据的处理
function PassIconView:on_btn_icon_click()
    if(self.isClick==false)then
        return
    end

    if not CmdCommonList.CmdEnterCityPopupOrder.IsFinish() then
        return
    end

    ModelList.GameActivityPassModel.C2S_ForceRequestBingopassDetail(true,function()
        Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassTaskView")
    end)

    --Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassView")
end

return this