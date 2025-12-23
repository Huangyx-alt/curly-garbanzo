local CarQuestRoadMgr = require "View/CarQuest/CarQuestRoadMgr"
local CarQuestRoadUnit = require "View/CarQuest/CarQuestRoadUnit"
local CarQuestCarMgr = require "View/CarQuest/CarQuestCarMgr"
local CarQuestSectionMgr = require "View/CarQuest/CarQuestSectionMgr"

local Const = require "View/CarQuest/CarQuestConst"

local CarQuestTest = BaseDialogView:New('CarQuestTest')
local this = CarQuestTest
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_test1",
    "btn_test2",
    "btn_test3",
    "btn_test4",
    "btn_test5",
    "btn_test6",
    "btn_test7",
    "btn_close",
    "InputField1",
    "root",
    "InputField2",
    "InputField3",
    "InputField4",
    "InputField5",
    "InputField6",
    "InputField7",
    "btn_show",    
}

function CarQuestTest:Awake()
end

function CarQuestTest:OnEnable()
end

function CarQuestTest:on_after_bind_ref()
    self:InitView()
end

function CarQuestTest:InitView()
end

function CarQuestTest:OnDisable()
end

function CarQuestTest:on_btn_show_click()
    fun.set_active(self.root, true)
end

function CarQuestTest:on_btn_close_click()
    fun.set_active(self.root, false)
end

function CarQuestTest:on_btn_test1_click()
    local txt = self.InputField1.text
    if tonumber(txt) then
        Const.RoadLowSpeed = tonumber(txt)
    end
    CarQuestRoadMgr:StartMove()
end

function CarQuestTest:on_btn_test2_click()
    local txt = self.InputField2.text
    if tonumber(txt) then
        Const.RoadHighSpeed = tonumber(txt)
    end
    CarQuestRoadMgr:MoveFast()
end

function CarQuestTest:on_btn_test3_click()
    local txt = self.InputField1.text
    if tonumber(txt) then
        Const.RoadLowSpeed = tonumber(txt)
    end
    CarQuestRoadMgr:MoveSlow()
end

function CarQuestTest:on_btn_test4_click()
    local startPos = fun.get_gameobject_pos(ViewList.CarQuestMainView.startPos, true)
    local posList = {}
    for i = 1, 5 do
        posList[i] = startPos.y
    end
    CarQuestCarMgr:SetAllCarsPosition(posList)
    self:StopAllCars()
end

function CarQuestTest:on_btn_test5_click()
    local startPos = fun.get_gameobject_pos(ViewList.CarQuestMainView.startPos, true)
    local posList = {}
    for i = 1, 5 do
        posList[i] = 0
    end
    CarQuestCarMgr:SetAllCarsPosition(posList)
    self:StopAllCars()
    --Facade.SendNotification(NotifyName.ShowUI, ViewList.CarQuestHelpView)
end

function CarQuestTest:on_btn_test6_click()
    local txt = self.InputField3.text
    if tonumber(txt) then
        Const.CarLowSpeed = tonumber(txt)
    end

    txt = self.InputField5.text
    if tonumber(txt) then
        Const.CarHighSpeed = tonumber(txt)
    end
    local carList = CarQuestCarMgr:GetAllCars()
    carList[1].speed = Const.CarNormalSpeed
    carList[2].speed = Const.CarLowSpeed
    carList[3].speed = Const.CarNormalSpeed
    carList[4].speed = Const.CarHighSpeed
    carList[5].speed = Const.CarLowSpeed
end

function CarQuestTest:on_btn_test7_click()
    local txt = self.InputField6.text
    if tonumber(txt) then
        CarQuestSectionMgr.startFuelVolume = tonumber(txt)
    end

    txt = self.InputField7.text
    if tonumber(txt) then
        CarQuestSectionMgr.endFuelVolume = tonumber(txt)
    end
    CarQuestSectionMgr:Test()
end

function CarQuestTest:StopAllCars()
    local carList = CarQuestCarMgr:GetAllCars()
    for i = 1, 5 do
        carList[i].speed = 0
    end
end

return this