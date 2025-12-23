--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]


local BasePassHelperView = class("BasePassHelperView",BaseViewEx)
local this = BasePassHelperView
this._cleanImmediately = true 
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.auto_bind_ui_items = {
    "btn_close",
    "anima",
    "text_task2",
    "text_task",
    "text_exp",
    "text_rewards",
    
}


function BasePassHelperView:ctor(id)
    self.id = id 
end




local this = BasePassHelperView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole







this.descriptionTxt1 = 1920 
this.descriptionTxt2 = 1921 
this.descriptionTxt2 = 1922 

--继承时，修改以上id做动态修改
function BasePassHelperView:Awake()
    self:on_init()
end

function BasePassHelperView:OnEnable()
    self.text_task.text = Csv.GetDescription(self.descriptionTxt1) 
    self.text_exp.text = Csv.GetDescription(self.descriptionTxt2) 
    self.text_rewards.text = Csv.GetDescription(self.descriptionTxt2) 


    CommonState.BuildFsm(self,"BingoPassPurchaseView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"start","BingoPassHelperView_start"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
end

function BasePassHelperView:OnDisable()
    CommonState.DisposeFsm(self)
end

function BasePassHelperView:on_btn_close_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"end","BingoPassHelperView_end"},false,function()
            Facade.SendNotification(NotifyName.CloseUI,self)
        end)
    end)
end

return this 