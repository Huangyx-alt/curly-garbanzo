local ClubDetailView = BaseView:New('ClubDetailView',"ClubAtlas")
local this = ClubDetailView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
local private = {}

function ClubDetailView:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end

this.auto_bind_ui_items = {
    "btn_close",
    "btn_leave",
    "btn_claim",
    "club_desc",
    "club_frequency",
    "club_name",
    "club_icon",
    "club_member_state",
    "club_member_text",
    "club_member_state2",
    "club_level_limit_tip",
    "club_level_limit_text",
    "club_icon_bg",
}

function ClubDetailView:Awake()
    self:on_init()
end

function ClubDetailView:OnEnable(params)
    Facade.RegisterView(self)

    if params then
        self.clubInfo = params
    else
        self.clubInfo = ModelList.ClubModel.getClubinfo()
    end

    if self.clubInfo then
        private.ShowView(self)
    else
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function ClubDetailView:OnDisable()
    Facade.RemoveView(self)
end

function ClubDetailView:OnDestroy()
    self:Destroy()
    local culbAssetList = require("Module/ClubAssetList")
    if culbAssetList then
        Cache.unload_ab_no_depen(culbAssetList["ClubDetailView"],false)
    end
end

function ClubDetailView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, self)
end

function ClubDetailView:on_btn_leave_click()
    local text = Csv.GetDescription(30057)
    text = string.format(text, self.clubInfo.name)
    
    Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubLeaveView, nil ,nil ,{
        leaveTip = text,   --ClubLeaveView界面提示文本
        onLeaveClub = function()
            --获取公会列表
            ModelList.ClubModel.C2S_ClubQueryList(function()
                Facade.SendNotification(NotifyName.CloseUI, self)
                Facade.SendNotification(NotifyName.ShowUI,ViewList.ClubListSearchView)
                Facade.SendNotification(NotifyName.CloseUI, ViewList.ClubMainView)
            end)
        end
    })
end

function ClubDetailView:on_btn_claim_click()
    if not self.canJoinClub then
        return UIUtil.show_common_popup(30083,true)
    end
    
    --检测是否已经加入了Club
    if ModelList.ClubModel.CheckPlayerHasJoinClub() then
        local text = Csv.GetDescription(30055)
        text = string.format(text, self.clubInfo.name)
        
        Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubLeaveView, nil ,nil ,{
            leaveTip = text,   --ClubLeaveView界面提示文本
            onlyTip = true,
            onLeaveClub = function()
                private.RequestJoinClub(self)
            end
        })
    else
        private.RequestJoinClub(self)
    end
end

function ClubDetailView:_close()
    self.__index.closeWithAnimation(self)
end

----------------------Private Func-----------------------------

function private.ShowView(self)
    local playerClubInfo = ModelList.ClubModel.getClubinfo()
    local clubInfo = self.clubInfo
    
    --是否是当前加入的公会
    local isPlayerClub = playerClubInfo and playerClubInfo.clubId == clubInfo.clubId
    fun.set_active(self.btn_leave, isPlayerClub)
    fun.set_active(self.btn_claim, not isPlayerClub)
    
    --公会描述
    self.club_desc.text = Csv.GetDescription(tonumber(clubInfo.profile))
    
    --公会限制活跃频率
    self.club_frequency.text = private.GetNeedGameFrequencyText(self, clubInfo)
    
    --公会名字
    self.club_name.text = clubInfo.name
    
    --公会Icon
    Cache.SetImageSprite("ClubAtlas", clubInfo.icon, self.club_icon, true)
    Cache.SetImageSprite("ClubAtlas", clubInfo.underIcon, self.club_icon_bg, true)
    
    --公会人数状态
    local checkMember = (clubInfo.curNum / clubInfo.totalNum) == 1
    local memberStateImageName = checkMember and "ClubZtXqRd" or "ClubZtXqGd"
    Cache.SetImageSprite("ClubAtlas", memberStateImageName, self.club_member_state, true)
    self.club_member_text.text = string.format("%s/%s", clubInfo.curNum, clubInfo.totalNum)
    
    --等级限制
    local playerLevel = ModelList.PlayerInfoModel:GetLevel()
    local checkLevelLimit = playerLevel < clubInfo.clubLimit.levelLimit
    local levelLimitStateImageName = checkLevelLimit and "ClubZtXqRd" or "ClubZtXqGd"
    Cache.SetImageSprite("ClubAtlas", levelLimitStateImageName, self.club_level_limit_tip, true)
    if clubInfo.clubLimit.levelLimit == 0 then
        self.club_level_limit_text.text = Csv.GetDescription(30054)
    else
        self.club_level_limit_text.text = string.format("%s+", clubInfo.clubLimit.levelLimit)
    end

    self.canJoinClub = not checkMember and not checkLevelLimit
    --不能加入时，按钮变灰
    Util.SetImageColorGray(self.btn_claim.gameObject, not self.canJoinClub)
end

local DayLimitToTextID = { 
    [0] = 30053,
    [1] = 30050,
    [7] = 30051,
    [30] = 30052,
}
function private.GetNeedGameFrequencyText(self, clubInfo)
    local playDaysLimit = clubInfo.clubLimit.playDaysLimit
    local textID = DayLimitToTextID[playDaysLimit] or DayLimitToTextID[0]
    local text = Csv.GetDescription(textID)
    return text
end

function private.RequestJoinClub(self)
    --先关闭，不然新加公会会延迟显示公会信息
    Facade.SendNotification(NotifyName.CloseUI, ViewList.ClubMainView)
    --加入公会请求
    ModelList.ClubModel.C2S_Clubjoin(self.clubInfo.clubId)
end

function private.ResJoinClub(code, data)
    if code == RET.RET_SUCCESS then
        Facade.SendNotification(NotifyName.CloseUI, this)
        Facade.SendNotification(NotifyName.CloseUI, ViewList.ClubListSearchView)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubMainView)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubWelcomeView)
    elseif code == RET.RET_CLUB_JOIN_FULL then
        UIUtil.show_common_popup(30087, true)
        Facade.SendNotification(NotifyName.CloseUI, this)
        --获取公会列表
        ModelList.ClubModel.C2S_ClubQueryList(function()
            Facade.SendNotification(NotifyName.ShowUI,ViewList.ClubListSearchView)
        end)
    elseif code == RET.RET_CLUB_JOIN_IN_CD then
        local remainTime = ModelList.ClubModel.GetJoinClubRemainTime()
        remainTime = fun.format_time(remainTime)
        UIUtil.show_common_popup(30088, true, nil, nil, remainTime)
    end
end

this.NotifyList = {
    {notifyName = NotifyName.Club.JoinClub, func = private.ResJoinClub},
}

return this 

