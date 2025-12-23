local BankView = BaseView:New("BankView","BankAtlas")
local this = BankView

this.auto_bind_ui_items = {
  ----------------主界面-----------------------
    "btn_close",--关闭按钮
    "bankMax",  --bank最大化
    "PigTileTxt", --猪标题
    "EleTileTxt", --象标题
    "btn_Pig", ---底部按钮
    "PigBgOff",  --开启的切换
    "PigBgOn",   
    "btn_Elephant", --底部大象按钮
    "ElephantgOff",
    "ElephantBgOn",
    "PiggIcon",  -----------中间的ICON
    "img_StateSaving_Pig",
    "EleIcon",
    "img_StateSaving_Ele",
    "btn_claim",  --收集按钮
    "txt_price", ---价格
--    "txt_price2",-- 价格
  ----------------获得默认--------------------- v 
    "buyAni",
  --------------------------------------------
    
}

--存钱罐状态
this.PigSavingPotState = {
    ["little"] = "xBankPiggyCoins1",
    ["more"] = "xBankPiggyCoins2",
}
this.EleSavingPotState = {
    ["little"] = "xBankPiggyGems1",
    ["more"] = "xBankPiggyGems2",
}

---------------------生命周期--------------------------------
function BankView:Awake()
   
    this:on_init()
end

function BankView:OnEnable()
   
    this:RegisterEvent()
    self:BuildFsm()
    
end 

function BankView:OnDisable()
    this:UnRegisterEvent()
end 

function BankView:OnDestroy()
 
end

-----------------------内建的函数-----------------------------------

function BankView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("BankView",self,{
        BankEleState:New(),
        BankPigState:New(),
        BankRewardState:New(),
    })
    --点击小猪
    self:Change2FitState()
end

function BankView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function BankView:Change2FitState()
    self._fsm:ChangeState("BankPigState")
end

-------------------------响应函数-----------------------------

--关闭按钮
function BankView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

--点击小猪
function BankView:on_btn_Pig_click()
    self._fsm:ChangeState("BankPigState")
end 

--点击小象
function BankView:on_btn_Elephant_click()
    self._fsm:ChangeState("BankEleState")
end 

function BankView:on_btn_claim_click()
    self._fsm:GetCurState():CollectReward(self.fsm)
end
-------------------------状态机逻辑处理------------------------------

function BankView:OnPigCollectReward(fsm)  --小猪响应收集
    ---收集小猪的奖励
    
end 

function BankView:OnEleCollectReward()  --小象响应收集
    ---收集小象的奖励

end 

function BankView:OnPigSate()  --小猪状态
    fun.set_active(self.PigTileTxt,true)
    fun.set_active(self.EleTileTxt,false)

    fun.set_active(self.PigBgOff,false)
    fun.set_active(self.PigBgOn,true)
    
    fun.set_active(self.ElephantBgOn,false)
    fun.set_active(self.ElephantgOff,true)

    fun.set_active(self.PiggIcon,true)
    fun.set_active(self.img_StateSaving_Pig,true)

    fun.set_active(self.EleIcon,false)
    fun.set_active(self.img_StateSaving_Ele,false)

    --价格变换
end 

function BankView:OnEleSate()  --小象状态
    fun.set_active(self.PigTileTxt,false)
    fun.set_active(self.EleTileTxt,true)

    fun.set_active(self.PigBgOff,true)
    fun.set_active(self.PigBgOn,false)
    
    fun.set_active(self.ElephantBgOn,true)
    fun.set_active(self.ElephantgOff,false)

    fun.set_active(self.PiggIcon,false)
    fun.set_active(self.img_StateSaving_Pig,false)

    fun.set_active(self.EleIcon,true)
    fun.set_active(self.img_StateSaving_Ele,true)
end 

-------------------------订阅事件-------------------------------------------

function BankView:RegisterEvent()
   -- Event.AddListener(EventName.ApplicationGuide_ResetFinger, this.DelayShowFinger)
end

function BankView:UnRegisterEvent()
   --Event.RemoveListener(EventName.ApplicationGuide_ResetFinger, this.DelayShowFinger)
end


-- this.NotifyList = {
 
-- }

return this 