
local EnterMachineModel = BaseModel:New()
local this = EnterMachineModel
this.parent_feature = nil --上层feature数据 一般是freespin
this.percent = 0 -- 加载进度
this.machineId = 1 --机台 id
this.reelItemsAtBegin = nil --机台初始Item数据
this.featureLists = nil --进机台的Feature列表
---当前触发的featureID
this.featureId = nil


--[[
    @desc: 获取当前机台 id
    author:{author}
    time:2020-07-15 20:50:55
    @return:
]]
function EnterMachineModel:GetMachineId()
    return self.machineId
end


--[[
    @desc: 清除feature数据 ，用于恢复feature使用，在对应的恢复位置调用
    author:{author}
    time:2020-07-15 20:50:50
    @return:
]]
function EnterMachineModel:CleanFeatureData()
    self.featureId = nil
end

--[[
    @desc: 获取当前进机台时的恢复featureid
    author:{author}
    time:2020-07-15 20:51:33
    @return:
]]
function EnterMachineModel:GetFeatureId()
    return self.featureId

end

--[[
    @desc: 获取机台当前行
    author:{author}
    time:2020-07-15 20:51:53
    @return:
]]
function EnterMachineModel:GetMachineRow()
    if(self.reelItemsAtBegin and self.reelItemsAtBegin[1])then
        return fun.table_len(self.reelItemsAtBegin[1])
    end

end


function EnterMachineModel:AddLoadingPercent(value)

    self.percent = self.percent + value
    if (self.percent >= 100) then
        self.percent = 100
    end

    if (self.percent == 100) then
        --this.SendNotification(NotifyName.DoEnterMachine,self)
        this.SendNotification(NotifyName.UpdatePercent, self.percent)
        return
    end

    this.SendNotification(NotifyName.UpdatePercent, self.percent)
end



function EnterMachineModel.GetEnterFeatures()
    return this.featureLists
end
function EnterMachineModel.Clean()
    this.featureLists = nil
end



function EnterMachineModel.SetMachineId(machineId)
    this.machineId = machineId
end

function EnterMachineModel.GetMachineId()
    return this.machineId
end



function EnterMachineModel.EnterBingoGame()
    this.room_type = "general"
    this.percent = 90
    --this.SendNotification(NotifyName.PreLoadMachineRes, this)
    this.inviterID = nil;
end



function EnterMachineModel:set_finish()
    self:AddLoadingPercent(100)
    if GameUtil.is_windows_editor() then
        self.SendNotification(NotifyName.DoEnterMachine, this)
    end
end






function EnterMachineModel:getReelInitData()
    return self.reelItemsAtBegin
end

function EnterMachineModel.S2C_SetEnterMachineData(code, data)

    if (code == RET.RET_SUCCESS) then
        --事件打点_游戏行为_进入机台
        SDK.enter_machine(data.machineId)


        this.data = NetDataParser.deal_enter_machine_data(data)
        this.reelItemsAtBegin = deep_copy(this.data.reel_items)
        this.enter_machine_data_ready = true

        this:check_parent_feature(this.data)
        this:check_betting_data(this.data)
        this:AddLoadingPercent(40)
        this.SendNotification(NotifyName.PreLoadMachineRes, this)
        -- this:check_and_recover_hold_spin(this.data)
    else
        -- local content = LangManager.GetErrorTxt('TxtException');
        -- Network.ShowErrorView(content)
        log.r("网络异常"..tostring(code))
    end
    --通知进度条
end

this.MsgIdList = {
    {msgid = MSG_ID.MSG_ENTER_MACHINE, func = this.S2C_SetEnterMachineData},
}

return this
