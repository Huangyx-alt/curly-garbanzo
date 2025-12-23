
local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"

local FunctionIconCuisinesIdelState = require "State/FunctionIconCuisinesView/FunctionIconCuisinesIdelState"
local FunctionIconCuisinesChangeState = require "State/FunctionIconCuisinesView/FunctionIconCuisinesChangeState"
local FunctionIconCuisinesLockState = require "State/FunctionIconCuisinesView/FunctionIconCuisinesLockState"
local FunctionIconCuisinesOpenState = require "State/FunctionIconCuisinesView/FunctionIconCuisinesOpenState"

local FunctionIconCuisinesView = FunctionIconBaseView:New()
local this = FunctionIconCuisinesView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_cuisines",
    "slider",
    "slider_text",
    "anim",
    --"icon",
    "group",
    "img_reddot",
    "double1",
    "double2",
}

function FunctionIconCuisinesView:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FunctionIconCuisinesView:Awake()
    self:on_init()
end

function FunctionIconCuisinesView:OnEnable(params)
    self:SetProgress() 
    self:BuildFsm()
    self:RegisterRedDotNode()
    self:RegisterEvent()
    self.isEnable = true
end

function FunctionIconCuisinesView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.cuisines_reddot_event,"function_cuisines",self.img_reddot)
end

function FunctionIconCuisinesView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.cuisines_reddot_event,"function_cuisines")
end

function FunctionIconCuisinesView:RegisterEvent()
    Event.AddListener(EventName.Event_cityResource_change,self.OnCityResourceChange,self)
end

function FunctionIconCuisinesView:RemoveEvent()
    Event.RemoveListener(EventName.Event_cityResource_change,self.OnCityResourceChange,self)
end

function FunctionIconCuisinesView:OnCityResourceChange()
    self:SetProgress()
    self:RefreshRedDot()
end

function FunctionIconCuisinesView:SetProgress()
    local cityexp = ModelList.CityModel:GetCityExp()
    self.slider.value = math.abs(cityexp) / 100
    self.slider_text.text = string.format("%s%s",tostring(cityexp),"%")
    
    --local progress = ModelList.CityModel:GetCityRecipeProcess()
    --self.slider.value = progress
    --self.slider_text.text = string.format("%s%s", math.floor( progress * 100),"%")
end

function FunctionIconCuisinesView:BuildFsm(params)
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("HallCityView",self,{
        FunctionIconCuisinesIdelState:New(),
        FunctionIconCuisinesChangeState:New(),
        FunctionIconCuisinesLockState:New(),
        FunctionIconCuisinesOpenState:New()
    })
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local open_level = nil
    local isRUser = false 

    -- if ModelList.PlayerInfoModel:GetUserType() and (UserTypeBigR ==  ModelList.PlayerInfoModel:GetUserType() or
    -- UserTypeMidR ==  ModelList.PlayerInfoModel:GetUserType() or UserTypeSmaR == ModelList.PlayerInfoModel:GetUserType() )  then
    --     isRUser = true
    -- end

    if isRUser then 
        open_level = Csv.GetData("new_city_play",playId,"pay_level_open")
    else 
        open_level = Csv.GetData("new_city_play",playId,"level_open")
    end 
   

    if ModelList.PlayerInfoModel:GetLevel() >= open_level[1][2] then
        self._fsm:StartFsm("FunctionIconCuisinesOpenState")
    else
        self._fsm:StartFsm("FunctionIconCuisinesLockState")
    end
end

function FunctionIconCuisinesView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function FunctionIconCuisinesView:GetAnimation_Change()
    return "FunctionIconCuisines_changeCity"
end

function FunctionIconCuisinesView:GetAnimation_Idle()
    if ModelList.ActivityModel:IsActiveAndDuringDouble(self:GetFunctionId()) then
        return "FunctionIconCuisines_doubleidle"
    end
    return "FunctionIconCuisines_idel"
end

function FunctionIconCuisinesView:GetAnimation_ExitDouble()
    return "FunctionIconCuisines_doubleout"
end

function FunctionIconCuisinesView:GetAnimation_Open()
    if ModelList.ActivityModel:IsActiveAndDuringDouble(self:GetFunctionId()) then
        return "FunctionIconCuisines_doublego"
    end
    return "FunctionIconCuisines_open"
end

function FunctionIconCuisinesView:GetAnimation_Lock()
    return "FunctionIconCuisines_cityLock"
end

function FunctionIconCuisinesView:GetAnimation_Double()
    return "FunctionIconCuisines_doublego"
end

function FunctionIconCuisinesView:PlayIdle()
    self.anim:Play(self:GetAnimation_Idle(),0,0)
end

function FunctionIconCuisinesView:PlayChangeCity()
    AnimatorPlayHelper.Play(self.anim,self:GetAnimation_Change(),false,0.2,function()
        self:SetInfo()
        self:RefreshRedDot()
    end,function()
        self._fsm:GetCurState():ChangeComplete(self._fsm)
    end)
end

function FunctionIconCuisinesView:RefreshRedDot()
    RedDotManager:Refresh(RedDotEvent.cuisines_reddot_event)
end

function FunctionIconCuisinesView:SetInfo()
    --self:SetIcon()
    self:SetProgress()
end

function FunctionIconCuisinesView:PlayLock()
    --self.anim:Play(self:GetAnimation_Lock(),0,0)
    AnimatorPlayHelper.Play(self.anim,self:GetAnimation_Lock(),false,function()
        self:Hide()
    end)
end

function FunctionIconCuisinesView:PlayOpen()
    AnimatorPlayHelper.Play(self.anim,self:GetAnimation_Open(),false,0.1,function()
        self:SetInfo()
    end,function()
        self._fsm:GetCurState():ChangeComplete(self._fsm)
    end)
end

function FunctionIconCuisinesView:SetIcon()
    --[[现在不区分菜品图标了
    --self.icon.sprite = AtlasManager:GetSpriteByName("CommonAtlas",string.format("c_ent_icon03_0%s", ModelList.CityModel:GetCity()))
    --]]
end

function FunctionIconCuisinesView:CheckChangeCity()
    self._fsm:GetCurState():ChangeCityOpen(self._fsm)
end

function FunctionIconCuisinesView:OnChangeCity(isCityOpen,cityChange)
    if not self.isEnable then
        return
    end
    if isCityOpen then
        self._fsm:GetCurState():ChangeCityOpen(self._fsm)
    else
        self._fsm:GetCurState():ChangeCityLock(self._fsm)
    end     
end

function FunctionIconCuisinesView:OnDisable()
    self:DisposeFsm()
    self:UnRegisterRedDotNode()
    self:RemoveEvent()
    self.isEnable = nil
end

function FunctionIconCuisinesView:on_close()
    -- body
end
 
function FunctionIconCuisinesView:OnDestroy()
    self:Close()
end

function FunctionIconCuisinesView:on_btn_cuisines_click()
    --Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"MakeFoodRestaurantView",true) --FoodIngredientView
end

function FunctionIconCuisinesView:OnChangeDouble()
    AnimatorPlayHelper.Play(self.anim,self:GetAnimation_Double(),false,0.2,function()
    end,function()
    end)
end

return this