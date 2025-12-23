
require "State/Common/CommonState"

local BingoPassReceivedView = BaseView:New("BingoPassReceivedView","BingoPassPopupAtlas")
local this = BingoPassReceivedView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local rewardsId = nil
--this.isCleanRes = true
this.auto_bind_ui_items = {
    "btn_get",
    "anima",
    "reward_icon1",
    "reward_icon2",
    "text_reward1",
    "text_reward2"
}

function BingoPassReceivedView:Awake()
    self:on_init()
end

function BingoPassReceivedView:OnEnable(params)
    local rewardData = nil
    if params == BingoPassPayType.Pay499 then
      rewardData = ModelList.BingopassModel:get_priceItem1() --payData.price_1_item
      self.text_reward1.text = string.format("x%s",rewardData[2])
      local apos = self.reward_icon1.transform.anchoredPosition
      self.reward_icon1.transform.anchoredPosition = Vector2.New(0,apos.y)
      fun.set_active(self.reward_icon2,false)
      rewardsId = {}
      table.insert(rewardsId,{self.reward_icon1.transform.position,rewardData[1]})
    elseif params == BingoPassPayType.Pay999 then
        rewardData = ModelList.BingopassModel:get_priceItem2() --payData.price_2_item
        rewardsId = {}
        table.insert(rewardsId,{self.reward_icon1.transform.position,type(rewardData) == "table" and rewardData[1][1] or rewardData })
        table.insert(rewardsId,{self.reward_icon2.transform.position,type(rewardData) == "table" and rewardData[2][1] or rewardData })
        self.text_reward1.text = string.format("x%s", type(rewardData) == "table" and  rewardData[1][2] or rewardData )
        self.text_reward2.text = string.format("x%s", type(rewardData) == "table" and  rewardData[2][2] or rewardData)
    else
        rewardData = ModelList.BingopassModel:get_priceItem3() --payData.price_3_item
        rewardsId = {}
        table.insert(rewardsId,{self.reward_icon1.transform.position,rewardData[1][1]})
        table.insert(rewardsId,{self.reward_icon2.transform.position,rewardData[2][1]})
        self.text_reward1.text = string.format("x%s",rewardData[1][2])
        self.text_reward2.text = string.format("x%s",rewardData[2][2])
    end
    CommonState.BuildFsm(self,"BingoPassReceivedView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"start","BingoPassReceivedView_start"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)

    UISound.play("bingopass_activate")
end

function BingoPassReceivedView:OnDisable()
    CommonState.DisposeFsm(self)
    rewardsId = nil
end

function BingoPassReceivedView:on_btn_get_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        if rewardsId then
            local delay = 0
            local coroutine_fun = nil
            for index, value in ipairs(rewardsId) do
                coroutine_fun = function()
                    delay = delay + 0.2
                    coroutine.wait(delay)
                    Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,tonumber(value[1]),tonumber(value[2]),function()
                        Event.Brocast(EventName.Event_currency_change)
                    end,nil,true,GetBingoPassFlashPos())
                end
                coroutine.resume(coroutine.create(coroutine_fun))
            end
            coroutine_fun = function()
                delay = delay + 0.2
                coroutine.wait(delay)
                AnimatorPlayHelper.Play(self.anima,{"end","BingoPassReceivedView_end"},false,function()
                    Facade.SendNotification(NotifyName.CloseUI,self)
                    Facade.SendNotification(NotifyName.BingoPass.UpdataBingoPassInfo)
                    Facade.SendNotification(NotifyName.BingoPass.ReceivedViewClose)
                    Event.Brocast(EventName.Event_Popup_BingoPass_ReceiveReward)
                end)
            end
            coroutine.resume(coroutine.create(coroutine_fun))
        end
    end)
end

return this