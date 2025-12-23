require "State/Common/CommonState"

local LuckyJeckpotView = BaseView:New("LuckyJeckpotView","LuckyJeckpotAtlas")
local this = LuckyJeckpotView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "btn_close",
    "btn_play",
    "anima"
}

function LuckyJeckpotView:Awake()
    self:on_init()
end

function LuckyJeckpotView:OnEnable()
    CommonState.BuildFsm(self,"LuckyJeckpotView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"enter","LuckyJeckpotView_enter"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
end

function LuckyJeckpotView:OnDisable()
    CommonState.DisposeFsm(self)
end

function LuckyJeckpotView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function LuckyJeckpotView:on_btn_play_click()
    self:on_btn_close_click()
end

this.NotifyList = 
{

}

return this