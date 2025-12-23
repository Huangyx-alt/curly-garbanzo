require "State/Common/CommonState"

local HallofFameGoldGiftComingView = BaseView:New("HallofFameGoldGiftComingView", "TournamentAtlas")
local this = HallofFameGoldGiftComingView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "btn_ok",
    "anima",
}

function HallofFameGoldGiftComingView:Awake(obj)
    self:on_init()
end

function HallofFameGoldGiftComingView:OnEnable(params)
    Facade.RegisterView(self)
    CommonState.BuildFsm(self, "HallofFameGoldGiftComingView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm, "CommonState1State", function()
        AnimatorPlayHelper.Play(self.anima, { "start", "TournamentBlackGoldGiftComingView_start" }, false, function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm, "CommonOriginalState")
        end)
    end)
end

function HallofFameGoldGiftComingView:OnDisable()
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
end

function HallofFameGoldGiftComingView:on_btn_ok_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm, "CommonState1State", function()
        AnimatorPlayHelper.Play(self.anima, { "end", "TournamentBlackGoldGiftComingView_end" }, false, function()
            Event.Brocast(NotifyName.HallofFame.FameBlackCardSendTipFinish)
            Facade.SendNotification(NotifyName.CloseUI, self)
        end)
    end)
end

this.NotifyList = {
}

return this