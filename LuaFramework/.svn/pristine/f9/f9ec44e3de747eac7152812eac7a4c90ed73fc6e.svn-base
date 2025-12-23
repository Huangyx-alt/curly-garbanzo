
local RofyModel = BaseModel:New("RofyModel")
local this = RofyModel

local rofyList = nil

local curRofyId = nil

local isPopupRofy = false

function RofyModel:InitData()
end

function RofyModel:SetLoginData(data)
    if data and data.normalActivity and data.normalActivity.roFyState then
        this:SetRofyListData(data.normalActivity.roFyState)
    end
end

function RofyModel:SetRofyListData(data)
    if data then
        rofyList = deep_copy(data)
    end
    if rofyList then
        curRofyId = nil
        isPopupRofy = false
        for key, value in pairs(rofyList) do
            if value.status == 0 then
                curRofyId = value.id
                isPopupRofy = true
                break
            end
        end
    end
end

--[[
function RofyModel.C2S_RequestActivityRofy()
    this.SendMessage(MSG_ID.MSG_ACTIVITY_ROFY,{})
    --Facade.SendNotification(NotifyName.AdventureView.Pick_a_dice_box_result)
end

function RofyModel.S2C_OnActivityRofy(code,data)
    --log.r("========================>>S2C_OnActivityRofy " .. code .. "   " .. tostring(data.id) .. "     " .. tostring(data.rofyReceive) .. "      ".. tostring(data.success))
    if code == RET.RET_SUCCESS and data then
        curRofyId = data.id
        if data.rofyReceive then --可以领奖
            isPopupRofy = true
            Facade.SendNotification(NotifyName.HallCity.EnterCityPopupOrder,PopupOrderOccasion.forcePopup)
        end
        if data.success then -- 领奖返回
            isPopupRofy = false
            Facade.SendNotification(NotifyName.AdventureView.Pick_a_dice_box_result)
        end
    end
end
--]]

function RofyModel:GetRofyId()
    return curRofyId
end

function RofyModel:CanPopupRofy()
    return isPopupRofy
end

function RofyModel:IsHallMainPopupRofy()
    local popUpType = nil
    local rofyid = self:GetRofyId()
    if rofyid then
        popUpType = Csv.GetData("reward_sky",rofyid,"application")
        return CityHomeScene:IsNormalLobby() and self:CanPopupRofy() and popUpType ~= 2
    end
    return false 
end

function RofyModel:IsHallAutoPopupRofy()
    local popUpType = nil
    local rofyid = self:GetRofyId()
    if rofyid then
        popUpType = Csv.GetData("reward_sky",rofyid,"application")
        return CityHomeScene:IsAutoLobby() and self:CanPopupRofy() and popUpType ~= 1
    end
    return false 
end

function RofyModel:C2S_RequestOpenRofy()
    this.SendMessage(MSG_ID.MSG_ACTIVITY_ROFY_OPEN,{id = this:GetRofyId()})
end

function RofyModel.S2C_OnOpenRofy(code,data)
    if code == RET.RET_SUCCESS and data then
        if data.success then
            Facade.SendNotification(NotifyName.AdventureView.Pick_a_dice_box_result)
        end
    end
end

function RofyModel.S2C_OnRofyUpdata(code,data)
    if code == RET.RET_SUCCESS and data then
        this:SetRofyListData(data.state)
    end
end

this.MsgIdList = 
{
    {msgid = MSG_ID.MSG_ACTIVITY_ROFY,func = this.S2C_OnActivityRofy},
    {msgid = MSG_ID.MSG_ACTIVITY_ROFY_UPDATE,func = this.S2C_OnRofyUpdata},
    {msgid = MSG_ID.MSG_ACTIVITY_ROFY_OPEN,func = this.S2C_OnOpenRofy},
}

return this