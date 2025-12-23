------ 显示弹窗，自定义文本，不使用ContentID
local CommonPopupView = require("View.CommonTipView.CommonPopupView")
local Command = {}

---@param okType 1:单按钮  2:双按钮错误层级弹窗  3:单按钮错误级弹窗 4:双按钮全局弹窗  5:单按钮全局弹窗
function Command.Execute(notifyName, options)
    options = options or {}
    
    local _view
    if not options.okType or options.okType < 2 then
        _view = CommonPopupView:NewPop(CanvasSortingOrderManager.LayerType.Popup_Dialog)
        ModelList.PopupModel:AddPopupView(_view, 3)
    else
        _view = CommonPopupView:NewPop(CanvasSortingOrderManager.LayerType.ErrorDialog)
        ModelList.PopupModel:AddPopupView(_view, 4)
    end
    
    if options.returnCb then
        options.returnCb(_view)
    end
    
    _view:ShowDialog(nil,function()
        _view:SetInfoWithOptions(nil, options)
     end,false)
end

return Command