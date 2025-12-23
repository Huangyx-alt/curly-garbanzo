local ClubMemberItem = BaseView:New('ClubMemberItem')

local this = ClubMemberItem
local private = {}

function ClubMemberItem:New(playerData)
    local o = {};
    setmetatable(o, { __index = this })
    o.playerData = playerData
    return o
end

this.auto_bind_ui_items = {
    "headIcon",
    "nameTxt",
    "titleTxt",
    "iconFrame",
}

function ClubMemberItem:Awake()
    self:on_init()
end

function ClubMemberItem:OnEnable()
    private.SetPlayerInfo(self)
end

function ClubMemberItem:OnDisable()

end

function ClubMemberItem:OnDestroy()
    self:Destroy()
end

function ClubMemberItem:SetItemInfo(playerData)
    self.playerData = playerData
    private.SetPlayerInfo(self)
end

--返回数据在数据列表中的key
function ClubMemberItem:GetDataKey()
    if self.playerData then
        return self.playerData.dataKey
    end
end

function ClubMemberItem:GetPosY()
    if self.go then
        return self.go.transform.localPosition.y
    end
end

function ClubMemberItem:SetActive(active)
    fun.set_active(self.go.transform,active)
end

----------------------Private Func-----------------------------

function private.SetPlayerInfo(self)
    if not self.playerData then
        return
    end
    
    local playerData = self.playerData
    local cfg = Csv.GetData("robot_name", playerData.uid)
    if cfg then
        playerData.avatar = cfg.icon
        playerData.frame = cfg.edge
        playerData.nickname = cfg.name
    end
    
    if tonumber(playerData.avatar) ~= nil then
        --玩家的数据存储的时avatarID
        playerData.avatar = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(playerData.avatar)
    end
    ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(playerData.avatar, self.headIcon)

    
    if tonumber(playerData.frame) ~= nil then
        --玩家的数据存储的时FrameID
        playerData.frame = ModelList.PlayerInfoSysModel:GetConfigFrameIconName(playerData.frame)
    end
    Cache.SetImageSprite("HeadIconFrameAtlas", playerData.frame, self.iconFrame, true)
    
    self.nameTxt.text = not string.is_empty(playerData.nickname) and playerData.nickname or playerData.uid
    self.titleTxt.text = "member"
end

return this 