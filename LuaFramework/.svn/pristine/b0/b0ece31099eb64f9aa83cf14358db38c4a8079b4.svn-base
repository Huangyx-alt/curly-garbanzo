local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"

local FunctionIconGamePassView = FunctionIconBaseView:New()
local this = FunctionIconGamePassView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "content",

}

local debug = true 

function FunctionIconGamePassView:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FunctionIconGamePassView:IsExpired()
    ModelList.GameActivityPassModel.CheckRefreshTime()
    local model = ModelList.GameActivityPassModel.GetCurPassDataComponent()
    if(model==nil )then 
        return true 
    end
    
    local isExpired = model:IsExpired()

 
    return isExpired
end

function FunctionIconGamePassView:Awake()
    self:on_init()
end


function FunctionIconGamePassView:GetModel()
    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(self.id)
    return model
end

function FunctionIconGamePassView:OnEnable()

   
   
    self:RegisterEvent()
    
    if(self.childIconView)then  
        self.childIconView:Close() 
    end

    Facade.SendNotification(NotifyName.GamePlayShortPassView.LoadGamePassIcon,function(iconObj) 
        local id = ModelList.GameActivityPassModel.GetCurrentId() 
        if(id==-1)then 
            return 
        end
        self.id = id
        local view = ModelList.GameActivityPassModel.GetViewById(id,"PassIconView")  
        if(view==nil or fun.is_null(iconObj) )then  
            log.e(" passicon is nil "..id)
            return 
            
        end
        self.childIconView = view:create(id,true,"FunctionIconGamePassView") 
        self.childIconView:SkipLoadShow(iconObj,true,nil,true)
        fun.set_parent(iconObj,self.content,true) 
        self.childIconView:SetCoutDown(self:GetModel():GetRemainTime())
        self.childIconView:SetProgress( ) 
        ModelList.GameActivityPassModel.SetIconPos(self.childIconView:GetPos(),true)
    end)  
end

function FunctionIconGamePassView:OnDestroy()
 
	self:Close()
    ModelList.GameActivityPassModel.SetIconPos(nil,true)
    if(self.childIconView)then 
        self.childIconView:Close()
    end
end


function FunctionIconGamePassView:OnDisable()
 
end

 


function FunctionIconGamePassView:RegisterEvent()
    Facade.RegisterCommand(NotifyName.GamePlayShortPassView.LoadGamePassIcon,CmdCommonList.CmdLoadGamePassIcon,self)
end

function FunctionIconGamePassView:UnRegisterEvent()
    Facade.RemoveCommand(NotifyName.GamePlayShortPassView.LoadGamePassIcon)
end

-- function FunctionIconGamePassView:on_btn_icon_click()
--     -- Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassView")
-- end

return this