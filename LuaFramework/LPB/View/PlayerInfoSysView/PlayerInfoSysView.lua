
PlayerInfoSysView = BaseView:New("PlayerInfoSysView","PlayerInfoSysAtlas")
local this = PlayerInfoSysView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
require "View/CommonView/RemainTimeCountDown"

local avatarAndFrameViewCode = require "View/PlayerInfoSysView/PlayerInfoUpdateAvatarAndFrame"
local avatarAndFrameView = nil



local achievementItemView = require "View/PlayerInfoSysView/AchievementItem"
-- local TournamentMyRankItem = require "View/Tournament/TournamentMyRankItem"
-- local remainTimeCountDown = RemainTimeCountDown:New()

local achievementItemPosFirst = {x = 287 , y = -201}    --第一个开始位置

local achievementItemOffset = {x = 461 , y = -328}   --间距
local achievementItemPosHorizonalNum = 2    --每横行个数
local achievementItemHight = 350  --每横行成就高度


this.auto_bind_ui_items = {
    "btn_setting",
    "textLevel",
    "textExpProgress",
    "imageExpProgress",
    "achievementList",
    "Content",
    "contentIcon",
    "achievementItemPrefab",
    "textBiggestTitle",
    "textBiggestNum",
    "textPosition",
    "btn_close",
    "btn_Change",
    "imageFrame",
    "imgHead",
    "passProgress",
    "textPassLevel",
    "btn_activate",
    "textPassProgress",
    "anima",
    "pass",
    "head_Obj",
    "textPassLevelTime",
    "player_Info_root",
    --"club_Info_root",
    "player_name",
    --"vipIcon",
    "btn_nickName",
    "player_name_inclub",
    --"club_name",
    "btn_nickName_inclub",
    --"vipIcon_inclub",
    --"club_icon",
    --"club_icon_bg",
    --"uidBg",
    "textUid",
    "btn_copy_uid",
}

function PlayerInfoSysView:Awake(obj)
    self:on_init()
end

function PlayerInfoSysView:SysChangeNickNameSuccess(isSuccess)
    self:SetInfo()
    self:InitNickChangeState()
end

function PlayerInfoSysView:OnEnable()
    Facade.RegisterView(self)
    Event.AddListener(NotifyName.PlayerInfo.SysChangeNickNameSuccess,self.SysChangeNickNameSuccess,self)
    Event.AddListener(EventName.Event_Refresh_Vip_Icon,self.OnVipLevelChange,self)
    self:InitBingoPass()
    self:InitView()
    self:InitAchievementItem()
    self:InitNickChangeState()

    self:BuildFsm()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()

        AnimatorPlayHelper.Play(self.anima,{"enter","commonViewenter"},false,function()

            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
end

function PlayerInfoSysView:InitNickChangeState()
    if ModelList.PlayerInfoSysModel.CheckCanChangeNickName() then
        fun.set_active(self.btn_nickName, true)
        --fun.set_active(self.btn_nickName_inclub, true)
    else
        fun.set_active(self.btn_nickName, false)
        --fun.set_active(self.btn_nickName_inclub, false)
    end
end

function PlayerInfoSysView:InitBingoPass()
    local functionIconBingopassView = require("View/CommonView/FunctionIconBingopassView")
    local imageBtnActivate = fun.get_component(self.btn_activate, fun.IMAGE)
    if  ModelList.BingopassModel:IsSeasonValid() and not ModelList.BingopassModel:IsPayAccomplish()  then
        --符合开启条件
        self:EnableBingoPass()
    else
        self:UnableBingoPass()
    end
    local totalItemCount = #Csv.season_pass - 1 --最终奖励不放一起，独立开来了

    local level = ModelList.BingopassModel:GetLevel()
    local level2 = level + 1
    local data = Csv.GetData("season_pass",level)
    local data2 = Csv.GetData("season_pass",level2)
    local exp = ModelList.BingopassModel:GetExp()
    if level == 0 then
        level = level2
        data = data2
    elseif data2 == nil or level == totalItemCount then
        --达到最大等级
        level2 = level
        data2 = data
        exp = data2.sum_exp
    end

    local toExp = data2.exp

    local curLevel = ModelList.BingopassModel:GetLevel()
    self.textPassLevel.text = tostring(level2)
    self.textPassProgress.text = ((curLevel == level2 and level2 == totalItemCount) and {"MAX"} or {string.format("%s/%s",exp,toExp)})[1]
    self.passProgress.value = exp / math.max(1,toExp)
end

function PlayerInfoSysView:EnableBingoPass()
    Util.SetImageColorGray(self.pass, false)
    fun.enable_button(self.btn_activate, true)
    self.remainTimeCountDown = RemainTimeCountDown:New()
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt2,ModelList.BingopassModel:GetRemainTime(),self.textPassLevelTime,function()
        self:UnableBingoPass()
    end)
end

function PlayerInfoSysView:UnableBingoPass()
    Util.SetImageColorGray(self.pass, true)
    fun.enable_button(self.btn_activate, false)
end

function PlayerInfoSysView:on_btn_activate_click()
    --self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
    --    self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
    --    AnimatorPlayHelper.Play(self.anima,"Common_window01_end",false,function()     
    --        Facade.SendNotification(NotifyName.CloseUI,this)
    --    end)
    --    Facade.SendNotification(NotifyName.ShowUI,ViewList.BingoPassPurchaseView)
    --end)
end

function PlayerInfoSysView:on_btn_nickName_inclub_click()
    self:on_btn_nickName_click()
end

function PlayerInfoSysView:on_btn_nickName_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        Facade.SendNotification(NotifyName.ShowUI,ViewList.PlayerInfoSysChangeNickNameView,nil,nil)
    end)
end

function PlayerInfoSysView:SetHeadIcon(headIconId)
    local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(headIconId)
    self.imgHead.sprite = AtlasManager:GetSpriteByName("HeadAtlas",iconSpriteName) 
end

function PlayerInfoSysView:SetFrameIcon(frameIconId)
    local isDefault = ModelList.PlayerInfoSysModel:GetConfigFrameIsDefault(frameIconId)
    log.log("替换框体" , frameIconId)
    if isDefault then
        --是默认头像框
        fun.set_active(self.imageFrame, false)
    else
        fun.set_active(self.imageFrame, true)
        local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigFrameIconName(frameIconId)
        self.imageFrame.sprite = AtlasManager:GetSpriteByName("HeadIconFrameAtlas",iconSpriteName) 
    end
end

function PlayerInfoSysView:InitView()
    self:SetInfo()
    self:InitVip()

    avatarAndFrameView = avatarAndFrameViewCode:New()
    avatarAndFrameView:SkipLoadShow(self.head_Obj)
    avatarAndFrameView:SetIsOneSelf(true)
end

function PlayerInfoSysView:SetInfo()
    local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
    if userInfo then
        local exp = Csv.GetData("level", userInfo.level,"exp")
        --self.imageExpProgress.fillAmount = userInfo.exp / exp
        --self.textExpProgress.text = string.format("%s%s",math.floor((userInfo.exp / exp) * 100),"%")
        self.textLevel.text = userInfo.level
        self.player_name.text = userInfo.nickname
        --self.player_name_inclub.text = userInfo.nickname
    end

    local isJoinClub = ModelList.ClubModel.CheckPlayerHasJoinClub()
    fun.set_active(self.player_Info_root, not isJoinClub)
    --fun.set_active(self.club_Info_root, isJoinClub)
    --if isJoinClub then
    --    local clubInfo = ModelList.ClubModel.getClubinfo()
    --    self.club_name.text = clubInfo.name
    --    --公会Icon
    --    Cache.SetImageSprite("PlayerInfoSysAtlas", clubInfo.icon, self.club_icon, true)
    --    --空iconBg判断
    --    if string.is_empty(clubInfo.underIcon) then
    --        clubInfo.underIcon = Csv.GetData("club_default", clubInfo.clubId, "club_under_icon")
    --    end
    --    Cache.SetImageSprite("PlayerInfoSysAtlas", clubInfo.underIcon, self.club_icon_bg, true)
    --end

    self.textUid.text = "UID:" .. ModelList.PlayerInfoModel:GetUid()
end

function PlayerInfoSysView:OnDisable()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown = nil
    end
    avatarAndFrameView = nil
    Event.RemoveListener(EventName.Event_Refresh_Vip_Icon,self.OnVipLevelChange,self)
    Event.RemoveListener(NotifyName.PlayerInfo.SysChangeNickNameSuccess,self.SysChangeNickNameSuccess,self)
    Facade.RemoveView(self)
    self:DisposeFsm()
end

function PlayerInfoSysView:InitAchievementItem()
    local showAchievementTable = ModelList.PlayerInfoSysModel:GetShowAchievementTable()
    -- log.log("个人信息 展示成就列表" , showAchievementTable)

    local totalVerticalNum = 0
    local useIndex = 1
    for i , v in pairs(showAchievementTable) do
        if i ~= 1 then
            --local go = fun.get_instance(this.achievementItemPrefab,this.contentIcon)
            local go = fun.get_instance(this.achievementItemPrefab,this.Content)
            local pos , verticalIndex = self:GetAchievementIconPos(useIndex)
            local item = achievementItemView:New()
            item:SkipLoadShow(go)
            go.name = "playertest" .. useIndex
            totalVerticalNum = verticalIndex
            fun.set_transform_pos(go.transform,pos.x,pos.y,pos.z,true)
            fun.set_active(go.transform,true)
            item:SetAchievementItemData(v, useIndex)
            useIndex = useIndex + 1
        else
            --1号位的展示固定的
            self:SetBiggest(v)
        end
    end

    local achievementHight = totalVerticalNum * achievementItemHight
    local odlSize = self.Content.transform.sizeDelta
    self.Content.transform.sizeDelta = Vector2.New(odlSize.x,odlSize.y + achievementHight)
end

function PlayerInfoSysView:SetBiggest(data)
    local model = ModelList.PlayerInfoSysModel
    local achievementID = data[1]
    local iconName = data[3]
    local iconDesIndex = data[4]

    --self.textBiggestTitle.text = Csv.GetDescription(iconDesIndex)
    --local params = model.GetAchievementIconValue(achievementID)
    --if params and params.iconValue then
    --    local iconValue = JsonToTable(params.iconValue)
    --    local num = iconValue[1][2]
    --    if not num or num == 0 then
    --        --还没有最佳记录
    --        --self.textPosition.text = ""
    --        --self.textBiggestNum.text = 0
    --    else
    --        local unixTime = iconValue[2][2]
    --        local cityId = model.GetAchievementBiggestCityId()
    --        local cityDesId = Csv.GetData("city_play",cityId,"name")
    --        local cityDes = Csv.GetDescription(cityDesId)
    --        local dayTh = string.format("%s%s" ,os.date("%d",unixTime) ,"th " )
    --        local month = string.format("%s%s" ,os.date("%B",unixTime) ,"," )
    --        local year = os.date("%Y",unixTime)
    --        --self.textPosition.text = string.format("%s %s%s%s",cityDes , dayTh , month ,year )
    --        --self.textBiggestNum.text = fun.format_money(num)
    --    end
    --else
    --    self.textPosition.text = ""
    --    self.textBiggestNum.text = 0
    --end
end

function PlayerInfoSysView:GetAchievementIconPos(index)
    local verticalIndex = 1
    local mulIndex , left = math.modf(index / achievementItemPosHorizonalNum)
    if left == 0 then
        verticalIndex = mulIndex
    else
        verticalIndex = mulIndex + 1
    end

    local horionalIndex =   1  --横向序号
    local hor = index % achievementItemPosHorizonalNum
    if hor == 0 then
        horionalIndex = achievementItemPosHorizonalNum
    else
        horionalIndex = hor
    end

    local pos = Vector3.New(achievementItemPosFirst.x + achievementItemOffset.x * (horionalIndex - 1) , achievementItemPosFirst.y + achievementItemOffset.y * (verticalIndex - 1)   , 0)
    return pos , verticalIndex
end

function PlayerInfoSysView:BuildFsm()
    self:DisposeFsm()
    CommonState.BuildFsm(self,"PlayerInfoSysView")
end

function PlayerInfoSysView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function PlayerInfoSysView:PlayEnter()
    AnimatorPlayHelper.Play(self.anima,{"enter","commonViewenter"},false,function()
        self._fsm:GetCurState():EnterFinish(self._fsm)
        self._fsm:GetCurState():StartClimb(self._fsm)
    end)
end

function PlayerInfoSysView:on_btn_setting_click()
    --UnityEngine.EditorApplication.isPaused = false
    --UnityEditor.EditorApplication.isPaused = false
    --Util.EditorPause()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        Facade.SendNotification(NotifyName.ShowUI,ViewList.SettingView)
    end)
end

function PlayerInfoSysView:on_btn_close_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()

        AnimatorPlayHelper.Play(self.anima,{"end","commonViewend"},false,function()

            Facade.SendNotification(NotifyName.CloseUI,this)
        end)
    end)
end

function PlayerInfoSysView:on_btn_Change_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        Facade.SendNotification(NotifyName.ShowUI,ViewList.PlayerInfoSysHeadFrameView)
    end)
end

function PlayerInfoSysView:OnVipLevelChange(vipLevel)
    local vip = Csv.GetData("vip",vipLevel,nil)
    Cache.SetImageSprite("VipAtlas", vip.icon, self.vipIcon)
    --Cache.SetImageSprite("VipAtlas", vip.icon, self.vipIcon_inclub)
end

function PlayerInfoSysView:InitVip()
    local vip_exp,vip_level = ModelList.PlayerInfoModel:GetOldVipPts()
    if vip_level then
        local vip = Csv.GetData("new_vip",vip_level,nil)
        --Cache.SetImageSprite("VipAtlas", vip.icon, self.vipIcon)
        --Cache.SetImageSprite("VipAtlas", vip.icon, self.vipIcon_inclub)
    else
        --fun.set_active(self.vipIcon, false)
        --fun.set_active(self.vipIcon_inclub, false)
    end
end

function PlayerInfoSysView:on_btn_copy_uid_click()
    Util.CopyTextToClipboard(tostring(ModelList.PlayerInfoModel:GetUid()))
    Facade.SendNotification(NotifyName.Common.CommonTip, "copy uid success")
end


return this


