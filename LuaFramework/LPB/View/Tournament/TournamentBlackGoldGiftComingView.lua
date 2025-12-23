require "State/Common/CommonState"

local TournamentBlackGoldGiftComingView = BaseView:New("TournamentBlackGoldGiftComingView","TournamentAtlas")
local this = TournamentBlackGoldGiftComingView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "btn_ok",
    "anima",
    "card",
}

function TournamentBlackGoldGiftComingView:Awake(obj)
    self:on_init()
end

function TournamentBlackGoldGiftComingView:OnEnable(params)
    Facade.RegisterView(self)
    CommonState.BuildFsm(self,"TournamentBlackGoldGiftComingView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"start","TournamentBlackGoldGiftComingView_start"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)

    if fun.is_ios_platform() then
        self.card.sprite = AtlasManager:GetSpriteByName("TournamentAtlas", "ZByoujian3old")
    else
        self.card.sprite = AtlasManager:GetSpriteByName("TournamentAtlas", "ZByoujian3")
    end
end

function TournamentBlackGoldGiftComingView:OnDisable()
    -- self:RemoveTopAreaEvent()
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
end

function TournamentBlackGoldGiftComingView:on_btn_ok_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"end","TournamentBlackGoldGiftComingView_end"},false,function()
            Event.Brocast(NotifyName.Tournament.BlackCardSendTipFinish)
            Facade.SendNotification(NotifyName.CloseUI,self)
        end)
    end)
end

this.NotifyList = {
}

return this