
require "State/Common/CommonState"

local RouletteConfirmView = BaseView:New("RouletteConfirmView","RouletteConfirmAtlas")
local this = RouletteConfirmView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "img_rewardIcon",
    "text_reward",
    "btn_reject",
    "btn_take",
    "anima"
}
this.isCleanRes = true
this.isCleanAb = false
function RouletteConfirmView:Awake()
    self:on_init()
end

function RouletteConfirmView:OnEnable()
    Facade.RegisterView(self)
    CommonState.BuildFsm(self,"RouletteConfirmView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"start","RouletteConfirmView_start"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)

    local configId = ModelList.RouletteModel:GetCurConfigId()
    if configId then
        local rewards = Csv.GetData("roulette",configId,"item")
        self.text_reward.text = fun.NumInsertComma(rewards[1][3]) --tostring(rewards[1][3])
    end
end

function RouletteConfirmView:OnDisable()
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
end

function RouletteConfirmView:on_btn_reject_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"end","RouletteConfirmView_end"},false,function()
            Facade.SendNotification(NotifyName.Roulette.ExitRoulette,true)
            Facade.SendNotification(NotifyName.CloseUI,this)
        end)
    end)
end

function RouletteConfirmView:on_btn_take_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"end","RouletteConfirmView_end"},false,function()
            Facade.SendNotification(NotifyName.Roulette.ExitRoulette,false)
            Facade.SendNotification(NotifyName.CloseUI,this)
        end)
    end)
end

return this