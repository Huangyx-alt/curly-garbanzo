local ExtraBonusView = BaseView:New("ExtraBonusView")
local this = ExtraBonusView

local MaskItemEntityCache = {}

this.auto_bind_ui_items = {
    "btn_close",            --关闭按钮
    "Content",              --额外奖励内容
    "MailItem"              --额外奖励具体
}

function ExtraBonusView:Awake()
    Facade.RegisterView(this)
    this:on_init()
end


function ExtraBonusView:OnEnable()
    local data = ModelList.ExtraBonusModel.GetSixExtraList() 
    Facade.RegisterView(self)
    self:BuildFsm()

    this:initInfo(data)
end 

function ExtraBonusView:BuildFsm()
    self:DisposeFsm()
    -- self._fsm = Fsm.CreateFsm("MailView",self,{
    --     MailEnterState:New(),
    --     MailIdleState:New(),
    --     MailNoCountState:New(),
    --     MailLeaveState:New(),  
    -- })
    -- self._fsm:StartFsm("MailEnterState")
end

function ExtraBonusView:initInfo(data)
    local count = 0
    local maxCount = #data >6 and 6 or #data
    for i=1, maxCount do
        count = count +1 
        local item =  this:GetItemViewInstance(count)
        self:initExtraItem(item,data[i])
    end 
end

function ExtraBonusView:GetItemViewInstance(index)
    local view_instance = nil
    
    if MaskItemEntityCache[index] == nil then
        view_instance = fun.get_instance(self.MailItem,self.Content)
        MaskItemEntityCache[index] = view_instance
    else
        view_instance = MaskItemEntityCache[index]
    end 
    
    fun.set_active(view_instance:GetTransform(),true,false)

    return view_instance
end 

function ExtraBonusView:initExtraItem(instance,data)
    --初始化数据
    local headBg =  fun.find_child(instance,"headBG")
    local head = fun.find_child(headBg,"Image") 
    local headBgSp = fun.get_component(head,fun.IMAGE)--头像
    local nameObj = fun.find_child(instance,"Name")
    local nameStr = fun.get_component(nameObj,fun.OLDTEXT)--名字
    local ReawardCountObj = fun.find_child(instance,"ReawardCount")
    local ReawardCountStr = fun.get_component(ReawardCountObj,fun.OLDTEXT)--奖励是多少
    local BetCountObj = fun.find_child(instance,"BetCount")
    local BetCountStr = fun.get_component(BetCountObj,fun.OLDTEXT)--倍数
    local CoinCountObj = fun.find_child(instance,"CoinCount")
    local CoinCountStr = fun.get_component(CoinCountObj,fun.OLDTEXT)--金币数量
    local DayCountObj = fun.find_child(instance,"DayCount")
    local DayCountStr = fun.get_component(DayCountObj,fun.OLDTEXT)--多少天

    if data ~= nil then 
        headBgSp.sprite = data.avatar
        nameStr.text =  data.nickName
        ReawardCountStr.text = data.ReawardCount
        BetCountStr.text = data.BetCount
        CoinCountStr.text = data.CoinCount
        DayCountStr.text = data.DayCount
    end 

end

function ExtraBonusView:OnDisable()

    MaskItemEntityCache ={}
    Facade.RemoveView(this)
end 

function ExtraBonusView:OnDestroy()
    this:Close()
end

--关闭事件
function ExtraBonusView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end


this.NotifyList = {

}

return this 