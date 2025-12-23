--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]
 

local BasePassReceivedView = class("BasePassReceivedView",BaseViewEx)
local this = BasePassReceivedView
 
local csv_data_name = "task_pass"
                                                                                     
 
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

function BasePassReceivedView:Awake()
    self:on_init()
end
function BasePassReceivedView:ctor(id)
    self.id = id 
end
function BasePassReceivedView:GetModel()
    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(self.id)
    return model 
end


function BasePassReceivedView:OnEnable(params)
    local rewardData = nil
    rewardData = self:GetModel():get_priceItem() --payData.price_3_item
    log.r("BasePassReceivedView",rewardData) 
    self.text_reward1.text = string.format("x%s",rewardData[2])
    local apos = self.reward_icon1.transform.anchoredPosition
    self.reward_icon1.transform.anchoredPosition = Vector2.New(0,apos.y)
    fun.set_active(self.reward_icon2,false)
    rewardsId = {}
    table.insert(rewardsId,{self.reward_icon1.transform.position,rewardData[1]})

    CommonState.BuildFsm(self,"BasePassReceivedView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"start","BingoPassReceivedView_start2"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)

    UISound.play("bingopass_activate")
end

function BasePassReceivedView:OnDisable()
    CommonState.DisposeFsm(self)
    rewardsId = nil
end




function BasePassReceivedView:on_btn_get_click()
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
                AnimatorPlayHelper.Play(self.anima,{"end","BingoPassReceivedView_end2"},false,function()
                    Facade.SendNotification(NotifyName.CloseUI,self)
                    Facade.SendNotification(NotifyName.GamePlayShortPassView.UpdataBingoPassInfo)
                    Facade.SendNotification(NotifyName.GamePlayShortPassView.ReceivedViewClose)
                    Event.Brocast(EventName.Event_Popup_BingoPass_ReceiveReward)
                end)
            end
            coroutine.resume(coroutine.create(coroutine_fun))
        end
    end)
end

 

return this