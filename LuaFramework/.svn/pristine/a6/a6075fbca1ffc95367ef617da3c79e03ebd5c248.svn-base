
require "State/Common/CommonState"

local BingoPassHelperView = BaseView:New("BingoPassHelperView","BingoPassPopupAtlas")
local this = BingoPassHelperView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
--this.isCleanRes = true
this.auto_bind_ui_items = {
    "btn_close",
    "btn_mask",
    "anima",
    "text_task2"
}

function BingoPassHelperView:Awake()
    self:on_init()
end

function BingoPassHelperView:OnEnable()
    this.openTime = os.time()
    
    self.text_task2.text = Csv.GetDescription(527)

    CommonState.BuildFsm(self,"BingoPassPurchaseView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"start","BingoPassHelperView_start"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
end

function BingoPassHelperView:OnDisable()
    CommonState.DisposeFsm(self)
end

function BingoPassHelperView:on_btn_close_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"end","BingoPassHelperView_end"},false,function()
            Facade.SendNotification(NotifyName.CloseUI,self)
        end)
    end)
end

function BingoPassHelperView:on_btn_mask_click()
    if os.time() - this.openTime > 2 then
        this:on_btn_close_click()
    end
end

return this