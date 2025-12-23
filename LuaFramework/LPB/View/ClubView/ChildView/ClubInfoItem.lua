local ClubInfoItem = BaseView:New('ClubInfoItem')
local this = ClubInfoItem
local private = {}

local TextColorType = {
    Recommend = Color.New(133 / 255, 43 / 255, 128 / 255, 1),
    Common = Color.New(60 / 255, 42 / 255, 152 / 255, 1),
}

function ClubInfoItem:New(clubData)
    local o = {};
    setmetatable(o, { __index = this, })
    o._clubData = clubData
    return o
end

this.auto_bind_ui_items = {
    "club_style_1",
    "club_style_2",
    "club_icon",
    "recommend",
    "club_name",
    "club_member_count",
    "club_owner",
    "btn_click_mask",
    "club_icon_bg",
}

function ClubInfoItem:Awake()
    self:on_init()
end

function ClubInfoItem:OnEnable()
    private.SetClubInfo(self)
end

function ClubInfoItem:OnDisable()
end

function ClubInfoItem:OnDestroy()
    self:Destroy()
end

function ClubInfoItem:SetItemInfo(clubData)
    self._clubData = clubData
    private.SetClubInfo(self)
end

--返回数据在数据列表中的key
function ClubInfoItem:GetDataKey()
    if self._clubData then
        return self._clubData.dataKey
    end
end

function ClubInfoItem:GetPosY()
    if self.go then
        return fun.get_localposition_y(self.go)
    end
    return 0
end

function ClubInfoItem:SetActive(active)
    fun.set_active(self.go,active)
end

function ClubInfoItem:on_btn_click_mask_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubDetailView, nil, nil, self._clubData)
end

----------------------Private Func-----------------------------

function private.SetClubInfo(self)
    if not self._clubData then
        return
    end

    local clubData = self._clubData
    local isRecommend = clubData.isRecommend
    fun.set_active(self.club_style_1, isRecommend)
    fun.set_active(self.club_style_2, not isRecommend)

    Cache.SetImageSprite("ClubAtlas", clubData.icon, self.club_icon, true)
    Cache.SetImageSprite("ClubAtlas", clubData.underIcon, self.club_icon_bg, true)
    
    self.club_name.text = clubData.name
    self.club_member_count.text = string.format("%s/%s", clubData.curNum, clubData.totalNum)
    
    --会长名字，第一个版可以先显示公会简介，只显示前n个字母
    local text = not string.is_empty(clubData.creatorName) and clubData.creatorName or clubData.profile
    local number = tonumber(text)
    if number and number > 0 then
        --描述文本ID
        text = Csv.GetDescription(number)
        --限制字符数
        if string.len(text) > 10 then
            text = string.match(text, "%w+%s")
            text = string.format("%s ...", text)
        end
    end
    self.club_owner.text = text
    
    --颜色
    self.club_owner.color = isRecommend and TextColorType.Recommend or TextColorType.Common
    self.club_member_count.color = isRecommend and TextColorType.Recommend or TextColorType.Common
    self.club_name.color = isRecommend and TextColorType.Recommend or TextColorType.Common
end

return this 