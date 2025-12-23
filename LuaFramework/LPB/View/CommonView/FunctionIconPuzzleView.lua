local FunctionIconCuisinesView = require "View/CommonView/FunctionIconCuisinesView"

local FunctionIconPuzzleView = FunctionIconCuisinesView:New()
local this = FunctionIconPuzzleView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_puzzle",
    "slider",
    "slider_text",
    "anim",
    "icon",
    "group",
    "img_reddot"
}

function FunctionIconPuzzleView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FunctionIconPuzzleView:on_btn_puzzle_click()
    local city = ModelList.CityModel:GetCity()
    local loadDefault, MachineItemData = ModelList.CityModel.checkModuleDownload(city)

    if loadDefault ~= 2 then
        UIUtil.show_common_error_popup(8011,true,nil)
        if MachineItemData and loadDefault == 0 then
            log.log("on_btn_puzzle_click() start download cityp", MachineItemData.machine_id, city)
            Facade.SendNotification(NotifyName.StartDownloadMachine, MachineItemData.machine_id)
        end
        return false
    end

    Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"PuzzleView",true)
end

function FunctionIconPuzzleView:SetProgress()
    local curProcess = ModelList.PuzzleModel:GetCurPuzzlePorcess()
    local targetProcess = ModelList.PuzzleModel:GetCurPuzzleTarget()
    local process = math.max(0,curProcess / math.abs(targetProcess))
    self.slider.value = process
    self.slider_text.text = string.format("%s%s", math.floor( process * 100),"%")
end

--[[
function FunctionIconPuzzleView:GetAnimation_Change()
    return "FunctionIconPuzzle_changeCity"
end

function FunctionIconPuzzleView:GetAnimation_Idle()
    return "FunctionIconCuisines_idel"
end

function FunctionIconPuzzleView:GetAnimation_Open()
    return "FunctionIconPuzzle_open"
end

function FunctionIconPuzzleView:GetAnimation_Lock()
    return "FunctionIconPuzzle_cityLock"
end
--]]

function FunctionIconPuzzleView:SetIcon()

end

function FunctionIconPuzzleView:IsFunctionOpenCity()

    if not self._fsm then
        return
    end

    local city = ModelList.CityModel:GetCity()
    local loadDefault ,_ = ModelList.CityModel.checkModuleDownload(city)

    if  loadDefault == 2 then
        self._fsm:GetCurState():ChangeCityOpen(self._fsm)
    else
        self._fsm:GetCurState():ChangeCityLock(self._fsm)
    end

    return true
end

function FunctionIconPuzzleView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.puzzle_reddot_event,"function_puzzle",self.img_reddot)
end

function FunctionIconPuzzleView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.puzzle_reddot_event,"function_puzzle")
end

function FunctionIconPuzzleView:RefreshRedDot()
    RedDotManager:Refresh(RedDotEvent.puzzle_reddot_event)
end



return this