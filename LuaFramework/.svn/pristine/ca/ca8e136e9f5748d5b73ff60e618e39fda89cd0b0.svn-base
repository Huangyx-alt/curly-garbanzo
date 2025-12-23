local HallJokerGuideView = BaseView:New('HallJokerGuideView',"HallMainHelpAtlas");

local this = HallJokerGuideView

this.isCleanRes = true

function HallJokerGuideView:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end

this.auto_bind_ui_items = {
    "btn_close",
    "btn_claim",
    "Toggle",
    "Text1",--说明2
    "Text2",--说明3
    "Text4",--说明4
    "Text5",--说明4
    "Content", --切换
    "Node_1", 
    "Node_2",
    "Node_3",
    "btn_left",
    "btn_right"
}


function HallJokerGuideView.Awake(obj, obj2)
    this:on_init()
end

function HallJokerGuideView.OnEnable()
    this:initData()

    this.showList = {
        [1] = self.Node_1,
        [2] = self.Node_2,
        [3] = self.Node_3
    }
    
    self.index = 1 


    --this:RebindSprite()
end

function HallJokerGuideView:ChangeFixData(index)
    if index >3 or index <1 then 
        return 
    end 

    for _,v in ipars(this.showList) do
        local refect = fun.get_component(v,fun.REFER)
        local nameTxt = refItem:Get("Show")
        fun.set_active(nameTxt,false);
    end 

    local refect = fun.get_component(this.showList[index],fun.REFER)
    local nameTxt = refItem:Get("Show")
    fun.set_active(nameTxt,true);


end 

function HallJokerGuideView.OnDisable()
    Event.Brocast(EventName.Event_popup_GameHallHelp_finish)
end

function HallJokerGuideView:OnDestroy()
    this:Destroy()
end

--左切
function HallJokerGuideView:on_btn_left_click()
    
end

--右切
function HallJokerGuideView:on_btn_right_click()
    
end

function HallJokerGuideView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end 

function HallJokerGuideView:on_btn_claim_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end 

return this 