---特殊玩法里面得Item
local SGPitemLockState = require "State/SpecialGameplay/SGPitemBaseState"
local SGPitemidleState = require "State/SpecialGameplay/SGPitemidleState"
local SGPitemloadState = require "State/SpecialGameplay/SGPitemloadState"
local SGPitemLockState = require "State/SpecialGameplay/SGPitemLockState"
local SGPitemplayState = require "State/SpecialGameplay/SGPitemplayState"

local SGPRecommend = BaseView:New("SGPRecommend")

local this = SGPRecommend
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_item",     --点击
    "Logo",         --logo
    "Personalized", --上锁得文本
    "process",      --进度条
    "Count",        --数量
    "btn_claim",    --开始游戏按钮
    "txt_claim",    --按钮文本
    "Idle",
    "Noplay",       --非正常状态的总节点
    "process",      --
    "Count",        -- 下载时的图片表现
    "Download",     --下载标识符
    "Lock",         --上锁
    "unlock",
    "unlockText"
}

function SGPRecommend:New(parentView)
    local o = {}
    o.parentView = parentView
    self.__index = self
    setmetatable(o, self)
    return o
end

function SGPRecommend:Awake()
    self:on_init()
end

function SGPRecommend:OnEnable(data)
    self:BuildFsm()
    self:UpdateData(data)
end

function SGPRecommend:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("SGPRecommend", self, {
        SGPitemidleState:New(),
        SGPitemloadState:New(),
        SGPitemLockState:New(),
        SGPitemplayState:New(),
    })
    self._fsm:StartFsm("SGPitemidleState")
end

function SGPRecommend:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function SGPRecommend:OnDisable()
    this:Close()
end

function SGPRecommend:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

function SGPRecommend:UpdateData(data)
    if not data then
        return
    end

    self.data = data
    local tmpData = Csv.GetData("feature_enter", data.id)

    if not self._fsm then
        return
    end

    if data.lock == true then --切换成
        self._fsm:ChangeState("SGPitemLockState")
    else
        if data.downtye == 0 then     --还没下载
            self._fsm:ChangeState("SGPitemidleState")
        elseif data.downtye == 1 then --下载中
            self._fsm:ChangeState("SGPitemloadState")
        else                          --下载完
            self._fsm:ChangeState("SGPitemplayState")
        end
    end

    local featuredId = ModelList.CityModel:GetRecommendModleList(data.id)

    if featuredId ~= nil then
        tmpData.featured_type = featuredId
    end

    if tmpData.featured_type == 1 then     --hot热门玩法
        self:ShowLogo(true, "TsrkHot")
    elseif tmpData.featured_type == 2 then --new新玩法
        self:ShowLogo(true, "TsrkNew")
    elseif tmpData.featured_type == 3 then --普通玩法
        self:ShowLogo(false)
    elseif tmpData.featured_type == 4 then --压根没开放
        self:ShowLogo(false)
    end

    --读取的预制体
    local abName, posterPrefabName = AssetList[tmpData.modular_poster]
    if not abName then
        local modularCfg = Csv.GetData("modular", tmpData.modular_id)
        posterPrefabName = string.format("%sposter", modularCfg.modular_name)
    else
        posterPrefabName = tmpData.modular_poster
    end
    if not AssetList[posterPrefabName] then
        return
    end
    Cache.load_prefabs(nil, posterPrefabName, function(ret)
        fun.get_instance(ret, self.Personalized)
    end)
end

---新增需求 https://www.tapd.cn/65500448/prong/stories/view/1165500448001013665
---副玩法入口增加气泡提示，气泡内显示EVENTS，主要用于提示对应副玩法中，存在活动任务
function SGPRecommend:ShowLogo(isOpen, resourceName)
    if isOpen == true then
        local tmpData = Csv.GetData("feature_enter", self.data.id)
        if ModelList.GameActivityPassModel.HasDataByCityData(tmpData.city_play) then
            self.Logo.sprite =  AtlasManager:GetSpriteByName("CommonAtlas", "TsrkEvent")
        else
            self.Logo.sprite = AtlasManager:GetSpriteByName("CommonAtlas", resourceName)
        end
        fun.set_active(self.Logo, true)
    else
        local tmpData = Csv.GetData("feature_enter", self.data.id)
        if ModelList.GameActivityPassModel.HasDataByCityData(tmpData.city_play) then
            self.Logo.sprite = AtlasManager:GetSpriteByName("CommonAtlas", "TsrkEvent")
            fun.set_active(self.Logo, true)
        else
            fun.set_active(self.Logo, false)
        end
    end
end

--正常没有下载得状态
function SGPRecommend:OnIdleState()
    self.txt_claim.text = "DOWNLOAD"

    fun.set_active(self.btn_claim, false)
    fun.set_active(self.Noplay, true)

    fun.set_active(self.process, false)
    fun.set_active(self.Download, true)
    fun.set_active(self.Lock, false)
    fun.set_active(self.unlock, false)
end

--正在进行下载得状态
function SGPRecommend:OnLoadState()
    fun.set_active(self.btn_claim, false)
    fun.set_active(self.Noplay, true)

    fun.set_active(self.process, true)
    fun.set_active(self.Download, false)
    fun.set_active(self.Lock, false)
    fun.set_active(self.unlock, false)
    if Network.isConnect == false then
        self._fsm:ChangeState("SGPitemidleState")
    end
    self:UpdateProcess(0)
end

--锁住得
function SGPRecommend:OnLockState()
    fun.set_active(self.btn_claim, false)
    fun.set_active(self.Noplay, true)

    fun.set_active(self.process, false)
    fun.set_active(self.Download, false)
    fun.set_active(self.Lock, true)
    fun.set_active(self.unlock, true)
    local tmpData = Csv.GetData("feature_enter", self.data.id)

    self.unlockText.text = string.format(Csv.GetData("description", 30095, "description"),
        Csv.GetRateOpenByCityId(tmpData.city_play))
end

function SGPRecommend:OnPlayState()
    self.txt_claim.text = "PLAY"
    fun.set_active(self.btn_claim, true)
    fun.set_active(self.Noplay, false)
end

--更新进度
function SGPRecommend:UpdateProcess(count)
    self.Count.fillAmount = 1 - count
end

--没有下载时
function SGPRecommend:OnBtnItemIdleClick()
    --调用下载接口
    if not self.data or not self.data.id then
        return
    end

    local tmpData = Csv.GetData("feature_enter", self.data.id)
    Facade.SendNotification(NotifyName.StartDownloadMachine, tmpData.modular_id)
    local tmpmodData = Csv.GetData("modular", tmpData.modular_id)

    SDK.click_download_extrapac(tmpmodData.modular_name)
end

--没有下载时
function SGPRecommend:OnBtnItemloadClick()
    --调用下载接口
end

--上锁的时候
function SGPRecommend:OnBtnItemlockClick()
    --弹出上锁的提示
end

--
function SGPRecommend:OnBtnItemplayClick()
    if self.parentView and self.parentView.CheckGuidAnimOpen then
        local check = self.parentView:CheckGuidAnimOpen()
        if check then
            --self.parentView:SetGuidAnimState(false)
            return
        end
    end

    if not self:CheckValidFeature() then
        local tip = Csv.GetDescription(85007) or "Activity is End !!"
        UIUtil.show_common_popup_with_options({
            isSingleBtn = true,
            contentText = tip,
        })
        return
    end

    if ModelList.WinZoneModel:Check_WinZone_Need_Open() then
        if ModelList.WinZoneModel:CheckVersion() then
            ModelList.BattleModel.RequireModuleLua("WinZone")
            local winzoneView = require("View/WinZone/WinZoneInPropgressView")
            Facade.SendNotification(NotifyName.ShowUI, winzoneView:New())
            return
        end
    end
    local tmpData = Csv.GetData("feature_enter", self.data.id)
    local PlayData = Csv.GetData("city_play", tmpData.city_play)

    if (self.data.version and self.data.version > 0 and tmpData ~= nil) then
        local tmpmodData = Csv.GetData("modular", tmpData.modular_id)
        if (tmpmodData ~= nil and tmpmodData.modular_name ~= nil) then
            ModelList.BattleModel.RequireModuleLua(tmpmodData.modular_name)
        end
    end

    if (self.Count and self.Count.fillAmount == 1) then
        local tmpmodData = Csv.GetData("modular", tmpData.modular_id)
        if (tmpmodData ~= nil and tmpmodData.modular_name ~= nil) then
            ModelList.BattleModel.RequireModuleLua(tmpmodData.modular_name)
            SDK.extrapac_open(tmpmodData.modular_name) --打点
        end
    end

    --SpecialGameplayView 参数回调
    if self.parentView and self.parentView.params and self.parentView.params.OnClickPlay then
        self.parentView.params.OnClickPlay()
    end

    Facade.SendNotification(NotifyName.SpecialGameplay.CloseSpecialGameplayView)

    --跳转到固定城市
    Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter, nil, PlayData.city_id, tmpData.city_play)
end

--检查全机台活动
function SGPRecommend:CheckValidFeature()
    local isFullGameOpen = ModelList.CityModel:GetFullGameplayRemainTime() > 0
    if isFullGameOpen then
        return true
    end

    local featureID   = self.data.id
    local ServerData  = ModelList.CityModel:GetRecommendBanners()
    local playerLevel = ModelList.PlayerInfoModel:GetLevel()
    local limitLevel  = Csv.GetData("control", 157, "content")[1][1] or 2
    if not ServerData or #ServerData <= 2 or playerLevel < limitLevel then
        --确保数据存在
        local featureData = Csv.GetData("feature_enter", featureID)
        if featureData ~= nil and featureData.featured_banner > 0 then
            return true
        end
    else
        for k, v in ipairs(ServerData) do
            if featureID == v then
                return true
            end
        end
    end
end

function SGPRecommend:on_btn_item_click()
    self._fsm:GetCurState():OnBtnItemClick(self._fsm)
end

function SGPRecommend:on_btn_claim_click()
    self._fsm:GetCurState():OnBtnItemClick(self._fsm)
end

function SGPRecommend:getSelfData()
    return self.data
end

--事件监听 下载更新
function SGPRecommend:OnEventUpdate(id, progress, size)
    local data    = self.data
    local tmpData = Csv.GetData("feature_enter", self.data.id)
    if not data or not data.id then
        return
    end

    if tmpData.modular_id ~= id then
        return
    end

    self:UpdateProcess(progress)
end

--是否在下载状态
function SGPRecommend:GetIsLoadingStateAndChange()
    if self._fsm:GetCurState().name ~= "SGPitemloadState" then
        return
    end

    if Network.isConnect == true then
        return
    end
    log.r("SGPRecommend:GetIsLoadingStateAndChange()")
    self._fsm:ChangeState("SGPitemidleState")
end

--事件监听 下载成功
function SGPRecommend:OnEventSuccess(id)
    local data    = self.data
    local tmpData = Csv.GetData("feature_enter", self.data.id)
    if not data or not data.id then
        return
    end

    if tmpData.modular_id ~= id then
        return
    end

    local tmpmodData = Csv.GetData("modular", data.id)
    SDK.extrapac_end(tmpmodData.modular_name, 0)
    log.r("SGPRecommend:OnEventSuccess(id)")
    self._fsm:ChangeState("SGPitemplayState")
end

--事件监听 下载开始
function SGPRecommend:OnEventStart(id)
    local data    = self.data
    local tmpData = Csv.GetData("feature_enter", self.data.id)
    if not data or not data.id then
        return
    end

    if tmpData.modular_id ~= id then
        return
    end
    self:UpdateProcess(0)
    log.r("SGPRecommend:OnEventStart(id)")
    self._fsm:ChangeState("SGPitemloadState")
end

--事件监听 下载错误
function SGPRecommend:OnEventError(id)
    local data    = self.data
    local tmpData = Csv.GetData("feature_enter", self.data.id)
    if not data or not data.id then
        return
    end

    if tmpData.modular_id ~= id then
        return
    end

    local tmpmodData = Csv.GetData("modular", data.id)
    SDK.extrapac_end(tmpmodData.modular_name, 1)
    log.r("SGPRecommend:OnEventError(id)")
    self._fsm:ChangeState("SGPitemidleState")
end

return this
