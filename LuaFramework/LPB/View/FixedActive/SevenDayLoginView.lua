 local SevenDayLoginView = BaseView:New('SevenDayLoginView', "SevenDayLoginAtlas");


local SevenDayLoginItem = require("View.FixedActive.SevenDayLoginItem")
 local SevenDayLoginEnterState = require("State.SevenDayLogin.SevenDayLoginEnterState")
 local SevenDayLoginIdleState = require("State.SevenDayLogin.SevenDayLoginIdleState")
 local SevenDayLoginWaitDataState = require("State.SevenDayLogin.SevenDayLoginWaitDataState")
 local SevenDayLoginRewardState = require("State.SevenDayLogin.SevenDayLoginRewardState")
 local SevenDayLoginExitState = require("State.SevenDayLogin.SevenDayLoginExitState")
 local SevenDayLoginHistoryState = require("State.SevenDayLogin.SevenDayLoginHistoryState")
 local SevenDayLoginFlyState = require("State.SevenDayLogin.SevenDayLoginFlyState")
 local SevenDayLoginRefreshSliderState = require("State.SevenDayLogin.SevenDayLoginRefreshSliderState")

local this = SevenDayLoginView;
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this.CanSignReward = false              --有签到奖励
this.CanSignDayCount = 0              --能领取签到奖励次数
this.CanProcessReward = false           -- 有进度奖励

this.auto_bind_ui_items = {
    "Slider",
    "box1",
    "box2",
    "box3",
    "dayitem1",
    "dayitem2",
    "dayitem3",
    "dayitem4",
    "dayitem5",
    "dayitem6",
    "dayitem7",
    "viewAnima",
    "btn_continue",
    "currProcess",
    "box1Process",
    "box2Process",
    "box3Process",
    "box1Reward",
    "box2Reward",
    "box3Reward",
    "startFlag",
    "btn_box1",
    "btn_box2",
    "btn_box3"
}

function SevenDayLoginView.Awake(obj)
    --this.update_x_enabled = true
    this:on_init()

end

function SevenDayLoginView.OnEnable()
    --Facade.RegisterView(this)
    this.data = ModelList.FixedActivityModel:GetSevenDayLoginData()
    this.delayExitTime = 0.5
    this.SetDayItem()
    this.SetSlider()
    FsmCreator:Create("SevenDayLoginView",this, {
        SevenDayLoginEnterState:New(),
        SevenDayLoginIdleState:New(),
        SevenDayLoginWaitDataState:New(),
        SevenDayLoginRewardState:New(),
        SevenDayLoginExitState:New(),
        SevenDayLoginHistoryState:New(),
        SevenDayLoginFlyState:New(),
        SevenDayLoginRefreshSliderState:New(),
    })
    this._fsm:StartFsm("SevenDayLoginEnterState")
    --this:rebind_sprite()
end

function SevenDayLoginView:ShowReward()
    --UISound.play("signin_reward") --七日签到奖励播放声音
    LuaTimer:SetDelayFunction(2,function()
        UISound.play("signin_reward") --七日签到奖励播放声音
        this._fsm:ChangeState("SevenDayLoginRewardState")
    end,nil,LuaTimer.TimerType.UI)
end

function SevenDayLoginView.RefreshUI()
    this.data = ModelList.FixedActivityModel:GetSevenDayLoginData()
    if this.CanSignDayCount >0 then
        --this.startFlag:Play("go")
        this.RefreshMondayToSaturday()
        this:RefreshState()
    else
        this.RefreshDayItem()
        this.SetSlider()
        this:RefreshState()
    end
end

---滑动条刷新
function SevenDayLoginView:RefreshSliderUI()
    if fun.is_null(this.startFlag) then
        return
    else
        this.startFlag:Play("go")
        if not fun.is_null(this.Slider) then
            Anim.slide_to_num(this.Slider, this.currProcess, this.data.sevenSignProgress, this.data.sevenSignProgressList[3].target, 0.5, function()
                this.SetSlider()
                this:RefreshState()
            end)
        end
    end
end

local function HasSevenDayLoginHistoryReward()
    return this.data.hasHistoryReward == 1
end

---历史奖励
function SevenDayLoginView:CheckHistroyReward()
    if HasSevenDayLoginHistoryReward() then
        this._fsm:ChangeState("SevenDayLoginHistoryState")
    else
        this._fsm:ChangeState("SevenDayLoginIdleState")
    end
end

---历史奖励
function SevenDayLoginView:GetHistroyRewards()
     return this.data.historyReward
end

function SevenDayLoginView:SetSliderContent()
    local count = #this.data.sevenSignProgressList
    local max = this.data.sevenSignProgressList[count].target
    if this.CanSignDayCount > 0 then
        local oldProcess =  this.data.sevenSignProgress-this.CanSignDayCount
        this.Slider.value = oldProcess/max
        this.currProcess.text = oldProcess.."/"..this.data.sevenSignProgressList[3].target
    else
        this.Slider.value = (this.data.sevenSignProgress)/max
        this.currProcess.text = this.data.sevenSignProgress.."/"..this.data.sevenSignProgressList[3].target
    end
end

---签到礼包弹窗内容
function SevenDayLoginView:SetGiftPop(rewardObj,id)
    --if id == 1 then id = 7
    --elseif id == 2 then id = 14
    --elseif id == 3 then id = 28
    --end
    local processInfo = Csv.GetData("reward_signin_progress", id)
    for i = 1, #processInfo.progress_reward do
        local child = fun.find_child(rewardObj, tostring(i))
        local img = fun.get_component(child, fun.IMAGE)
        if img then
          local itemId = processInfo.progress_reward[i][1]
          local icon = Csv.GetItemOrResource(itemId,"icon")
            AtlasManager:LoadImageAsync("ItemAtlas" , icon , function(spriteAtals,sprite)
                if sprite then
                    img.sprite = sprite
                end
            end)
        end
        child = fun.find_child(child, "Text")
        img = fun.get_component(child, "Text")
        img.text = fun.formatNum(processInfo.progress_reward[i][2])
    end
end

function SevenDayLoginView:PlayGiftDescripPanelEffect(isOpen, index)
    if not isOpen and fun.get_active_self(this["box"..index.."Reward"]) then
        local an = fun.get_component(this["box"..index.."Reward"],fun.ANIMATOR)
        if an then
            an:Play("out")
            LuaTimer:SetDelayFunction(0.3,function()
                fun.set_active(this["box"..index.."Reward"],false)
            end,nil,LuaTimer.TimerType.UI)
        end
    elseif isOpen then
        fun.set_active(this["box"..index.."Reward"],true)
    end
end

function SevenDayLoginView.SetSlider()
    this.CanProcessReward = false
    this:SetSliderContent()
    local showNextPop = true
    for i = 1, 3 do
        this["box"..i.."Process"].text = tostring(this.data.sevenSignProgressList[i].target)
        local anim = this["box"..i]
        local ref = fun.get_component(this["box"..i] , fun.REFER)
        local box = ref:Get("box")
        local box2 = ref:Get("box2")
        if this.data.sevenSignProgressList[i].status == 2 then
            fun.set_active(box , false)
            fun.set_active(box2 , true)
            local boxChild = fun.find_child(this["box" .. i], "btn_box" .. i)
            Util.SetImageColorGray(boxChild, true)
            anim:Play("idle")
            this:PlayGiftDescripPanelEffect(false,i)
        elseif this.data.sevenSignProgressList[i].status == 1  then
            fun.set_active(box , true)
            fun.set_active(box2 , false)
            this.CanProcessReward = true
            if this.data.sevenSignProgress-this.CanSignDayCount >=  this.data.sevenSignProgressList[i].target then
                anim:Play("btn_boxigo")
            else
                anim:Play("idle")
            end
            if this.data.sevenSignProgress >= this.data.sevenSignProgressList[i].target or showNextPop then
                this:SetGiftPop(this["box" .. i .. "Reward"], i)
                this:PlayGiftDescripPanelEffect(true, i)
                showNextPop = false
            end
        elseif this.data.sevenSignProgressList[i].status == 0 and this.data.sevenSignProgress < this.data.sevenSignProgressList[i].target and  showNextPop then
            fun.set_active(box , true)
            fun.set_active(box2 , false)
            this:SetGiftPop(this["box"..i.."Reward"],i)
            showNextPop = false
            this:PlayGiftDescripPanelEffect(true,i)
        else
            fun.set_active(box , true)
            fun.set_active(box2 , false)
            this:PlayGiftDescripPanelEffect(false,i)
        end
    end
end

function SevenDayLoginView.SetDayItem()
    this.Items ={}
    this.CanSignReward = false
    this.CanSignDayCount = 0
    log.log("七日登录数据q ", this.data)
    for i = 1, 7 do
        local item = SevenDayLoginItem.New()
        table.insert(this.Items, item)
        item:Init(this["dayitem" .. i], this)
        if item:SetInfo(this.data.sevenSignList[i],i) then
            this.CanSignReward = true
            this.CanSignDayCount = this.CanSignDayCount + 1
        end
        item:SetReward(this.data.sevenSignList[i].coefficient,i)
    end
end

function SevenDayLoginView.RefreshDayItem()
    this.CanSignReward = false
    this.needPlayFly = true
    this.CanSignDayCount = 0
    for i = 1, 7 do
        local item = this.Items[i]
        if item:SetInfo(this.data.sevenSignList[i],i) then
            this.CanSignReward = true
            this.CanSignDayCount = this.CanSignDayCount + 1
        end
        if i == 7 and this.data.sevenSignList[i].status == 2 then this.needPlayFly = false end
        if i == 7 and  not this.needPlayFly  then
            item:SetReward(this.data.sevenSignList[i].coefficient,i)
        end
    end
end

function SevenDayLoginView.RefreshMondayToSaturday()
    this.CanSignReward = false
    this.needPlayFly = true
    this.CanSignDayCount = 0
    for i = 1, 7 do
        local item = this.Items[i]
        if item:SetInfo(this.data.sevenSignList[i],i,i~=7) then
            this.CanSignReward = true
            this.CanSignDayCount = this.CanSignDayCount + 1
        end
    end
end

---点击collect 第七天Item要立即刷新动画
function SevenDayLoginView:RefreshSeventhDayItem()
    this.data = ModelList.FixedActivityModel:GetSevenDayLoginData()
    if this.Items[7]  and this.data.sevenSignList[7]  and  this.data.sevenSignList[7].status == 2 then
        this.Items[7]:PlayRewardFly(7)
    end
end

---点击collect 第七天Item要立即刷新动画
function SevenDayLoginView:RefreshData()
    this.data = ModelList.FixedActivityModel:GetSevenDayLoginData()
end

function SevenDayLoginView:GetEndRewardPos()
    return this.Items[7]:GetRewardTxtPos()
end

function SevenDayLoginView:LastDayRewardEffect()
    this.Items[7]:SetReward(this.data.sevenSignList[7].coefficient,7)
    this.Items[7]:SetInfo(this.data.sevenSignList[7],7)
    this.Items[7]:PlayRewardAnima2()
end

this.delayExitTime = 0.5

function SevenDayLoginView.RefreshState()
    if this.needPlayFly then
        this.needPlayFly = false
        this._fsm:ChangeState("SevenDayLoginFlyState")
        this.delayExitTime = 0
    elseif this._fsm:GetCurName() == "SevenDayLoginFlyState" then
        this._fsm:ChangeState("SevenDayLoginRefreshSliderState")
    elseif this.CanSignReward or this.CanProcessReward then
        this.delayExitTime = 0
        this._fsm:ChangeState("SevenDayLoginIdleState")
    else
        this._fsm:ChangeState("SevenDayLoginExitState")
    end
end

function SevenDayLoginView.PlayFly()
    for i = 1, #this.Items do
        if this.Items[i]:CanFly() then
            this.Items[i]:PlayRewardFly(i)
        elseif this.Items[i]:NeedChangeIdle() then
            this.Items[i]:ChangeIdleWithoutFly()
        end
    end
end

---type  默认值0-七日活动全部进度奖励+全部签到奖励，-1历史未领取的全部奖励 1-全部签到奖励，2-全部进度奖励，3-单个签到奖励，4-单个进度奖励
function SevenDayLoginView.ReqReward()
    this._fsm:ChangeState("SevenDayLoginWaitDataState")
    if this.delayCheck then
        LuaTimer:Remove(this.delayCheck)
        this.delayCheck = nil
    end
    AddLockCountOneStep()
    if this.data.hasHistoryReward and this.data.hasHistoryReward == 1 then
        ModelList.FixedActivityModel.Req_SEVENSIGN_RECEIVE_REWARD(-1)
    elseif this.CanSignReward then
        ModelList.FixedActivityModel.Req_SEVENSIGN_RECEIVE_REWARD(1)
    elseif this.CanProcessReward then
        ModelList.FixedActivityModel.Req_SEVENSIGN_RECEIVE_REWARD(2)
    end
end

function SevenDayLoginView.ReqSignReward()
    if this.CanSignReward then
        this._fsm:ChangeState("SevenDayLoginWaitDataState")
        if this.delayCheck then
            LuaTimer:Remove(this.delayCheck)
            this.delayCheck = nil
        end
        AddLockCountOneStep()
        if this.data.hasHistoryReward and this.data.hasHistoryReward == 1 then
            ModelList.FixedActivityModel.Req_SEVENSIGN_RECEIVE_REWARD(-1)
        else
            ModelList.FixedActivityModel.Req_SEVENSIGN_RECEIVE_REWARD(1)
        end
    end
end

---点击礼包 获取奖励
function SevenDayLoginView:ReqGiftReward(boxId)
    if this:CanGetGift(boxId) then
        this._fsm:ChangeState("SevenDayLoginWaitDataState")
        if this.delayCheck then
            LuaTimer:Remove(this.delayCheck)
            this.delayCheck = nil
        end
        AddLockCountOneStep()
        if this.data.hasHistoryReward and this.data.hasHistoryReward == 1 then
            ModelList.FixedActivityModel.Req_SEVENSIGN_RECEIVE_REWARD(-1)
        else
            ModelList.FixedActivityModel.Req_SEVENSIGN_RECEIVE_REWARD(4,boxId)
        end
    end
end

function SevenDayLoginView:CanGetGift(boxId)
    return this.data.sevenSignProgressList[boxId+1].status == 1
end


function SevenDayLoginView:StartTimer()
    if this.CanSignReward or  this.data.hasHistoryReward == 1  then
        this.delayCheck = LuaTimer:SetDelayFunction(3, function()
            this.ReqReward()
            this.delayCheck = nil
        end)
    elseif this.CanProcessReward then
       -- this._fsm:ChangeState("SevenDayLoginExitState")
    else
        this._fsm:ChangeState("SevenDayLoginExitState")
    end
end


function SevenDayLoginView:EnableExitButton()
    fun.set_active(self.btn_continue,true)
end

function SevenDayLoginView:PlayExit()
    self.viewAnima:Play("out")
    local aa = fun.get_component(self.btn_continue,fun.ANIMATOR)
    aa:Play("out")
end
--function SevenDayLoginView:on_x_update()
--end

--function SevenDayLoginView.OnDisable()
--    --Facade.RemoveView(this)
--
--end
--
--
--function SevenDayLoginView.OnDestroy()
--    this:Destroy()
--end

function SevenDayLoginView:TryExit()
    if this._fsm then
        this._fsm:ChangeState("SevenDayLoginExitState")
    end
end


function SevenDayLoginView:on_btn_box1_click()
    this._fsm:GetCurState():GetGiftReward(0)
end
function SevenDayLoginView:on_btn_box2_click()
    this._fsm:GetCurState():GetGiftReward(1)
end
function SevenDayLoginView:on_btn_box3_click()
    this._fsm:GetCurState():GetGiftReward(2)
end

function SevenDayLoginView:on_btn_continue_click()
    this._fsm:GetCurState():OnContinue()
end

function SevenDayLoginView:click_day_item()
    this._fsm:GetCurState():GetReward(1)
end

function SevenDayLoginView:rebind_sprite()
    if fun.is_null(self.go) then return end
    local sprites = {
        { "SafeArea/Top/gun1",                                                        "qSevenTitleDi01" },
        { "SafeArea/Top/gun2",                                                        "qSevenTitleDi01" },
        { "SafeArea/Top/shangding",                                                   "qSevenTitleDi" },
        { "SafeArea/Top/fang1",                                                       "qSevenTitleDiZ02" },
        { "SafeArea/Top/fang2",                                                       "qSevenTitleDiZ01" },
        { "SafeArea/Top/shangding/box",                                               "qSevenTitle03" },
        { "SafeArea/Top/shangding/zixia",                                             "qSevenTitle02" },
        { "SafeArea/Top/shangding/zishang",                                           "qSevenTitle1" },
        { "SafeArea/Middle/hudie",                                                    "qSevenTitleHDJ" },
        { "SafeArea/Middle/Gift/box1Reward",                                          "qSevenJinDuTips" },
        { "SafeArea/Middle/Gift/box2Reward",                                          "qSevenJinDuTips" },
        { "SafeArea/Middle/Gift/box3Reward",                                          "qSevenJinDuTips" },
        { "SafeArea/Middle/Gift/Slider/Background",                                   "qSevenJinDuDi" },
        { "SafeArea/Middle/Gift/Slider/Fill Area/Fill",                               "qSevenJinDu" },
        { "SafeArea/Middle/Gift/startFlag/Flag",                                      "qSevenComplete" },
        { "SafeArea/Middle/Gift/box1/box (1)",                                        "qSevenJinDuF" },
        { "SafeArea/Middle/Gift/box1/box",                                            "LH01" },
        { "SafeArea/Middle/Gift/box2/box (1)",                                        "qSevenJinDuF" },
        { "SafeArea/Middle/Gift/box2/box",                                            "LH02" },
        { "SafeArea/Middle/Gift/box3/box",                                            "LH03" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem2",                       "qSevenDi4" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem/no",                     "qSevenDi2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem/btn_go",                 "qSevenDi3" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem/await",                  "qSevenDi1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem/state",                  "pPuzzleGouDi" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem/no/biaoqian",            "qSevenBQ2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem/btn_go/biaoqian",        "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem/await/biaoqian",         "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (1)/no",                 "qSevenDi2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (1)/btn_go",             "qSevenDi3" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (1)/await",              "qSevenDi1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (1)/state",              "pPuzzleGouDi" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (1)/no/biaoqian",        "qSevenBQ2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (1)/btn_go/biaoqian",    "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (1)/await/biaoqian",     "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (2)/no",                 "qSevenDi2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (2)/btn_go",             "qSevenDi3" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (2)/await",              "qSevenDi1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (2)/state",              "pPuzzleGouDi" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (2)/no/biaoqian",        "qSevenBQ2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (2)/btn_go/biaoqian",    "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (2)/await/biaoqian",     "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (3)/no",                 "qSevenDi2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (3)/btn_go",             "qSevenDi3" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (3)/await",              "qSevenDi1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (3)/state",              "pPuzzleGouDi" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (3)/no/biaoqian",        "qSevenBQ2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (3)/btn_go/biaoqian",    "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (3)/await/biaoqian",     "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (4)/no",                 "qSevenDi2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (4)/btn_go",             "qSevenDi3" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (4)/await",              "qSevenDi1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (4)/state",              "pPuzzleGouDi" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (4)/no/biaoqian",        "qSevenBQ2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (4)/btn_go/biaoqian",    "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (4)/await/biaoqian",     "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (5)/no",                 "qSevenDi2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (5)/btn_go",             "qSevenDi3" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (5)/await",              "qSevenDi1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (5)/state",              "pPuzzleGouDi" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (5)/no/biaoqian",        "qSevenBQ2" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (5)/btn_go/biaoqian",    "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem (5)/await/biaoqian",     "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem2/btn_go",                "qSevenDi4" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem2/no",                    "qSevenDi4hei" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem2/biaoqian",              "qSevenBQ1" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem2/state",                 "qSevenDiZ4" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem2/gou1",                  "pPuzzleGouDi" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem2/gou2",                  "pPuzzleGouDi" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem2/gou3",                  "pPuzzleGouDi" },
        { "SafeArea/Middle/DayReward/GameObject/SevenDayItem2/rewardIcon/rewardIcon", "qSevenIcon04" },
        { "SafeArea/Middle/Light/Image",                                              "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (1)",                                          "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (2)",                                          "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (3)",                                          "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (4)",                                          "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (5)",                                          "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (6)",                                          "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (7)",                                          "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (8)",                                          "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (9)",                                          "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (10)",                                         "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (11)",                                         "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (12)",                                         "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (13)",                                         "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (14)",                                         "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (15)",                                         "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (16)",                                         "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (17)",                                         "qSevenTitleLight02" },
        { "SafeArea/Middle/Light/Image (18)",                                         "qSevenTitleLight02" },
        { "SafeArea/Bottom/you",                                                      "qSevenBG02" },
        { "SafeArea/Bottom/zuo",                                                      "qSevenBG03" },
        { "SafeArea/Bottom/you/youglow1",                                             "qSevenBG02glow1" },
        { "SafeArea/Bottom/you/youglow2",                                             "qSevenBG02glow2" },
        { "SafeArea/Bottom/zuo/zuoglow",                                              "qSevenBG03glow" },
    }


    for i = 1, #sprites do
        local spriteObj = fun.find_child(self.go,sprites[i][1])
        if spriteObj then
            local sprite = fun.get_component(spriteObj,fun.IMAGE)
            if sprite then
                if fun.is_null(sprite.sprite) then
                    sprite.sprite = AtlasManager:GetSpriteByName("SevenDayLoginAtlas", sprites[i][2])
                    lor.r("sprite null "..sprites[i][1])
                end
            end
        end
    end

end

return this
