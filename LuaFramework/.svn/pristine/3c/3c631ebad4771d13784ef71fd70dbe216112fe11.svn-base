local ClubMemberItemView = require "View/ClubView/ChildView/ClubMemberItem"
local InfiniteList = require "View/CommonView/Comp/InfiniteList"

local ClubMemberListView = BaseView:New('ClubMemberListView', "ClubAtlas")

local this = ClubMemberListView
local private = {}

function ClubMemberListView:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end

this.auto_bind_ui_items = {
    "btn_close",
    "member_item",
    "scrollView",
    "count_text"
}

function ClubMemberListView:Awake()
    self:on_init()
    private.InitMembersData()
    private.InitInfiniteList(self)
end

function ClubMemberListView:OnEnable()
    local clubInfo = ModelList.ClubModel.getClubinfo()
    local text = string.format("%s/%s", clubInfo.curNum, clubInfo.totalNum)
    self.count_text.text = text
    
    private.UpdateInfiniteList()
end

function ClubMemberListView:OnDisable()

end

function ClubMemberListView:OnDestroy()
    self:Destroy()
    if private.InfiniteList then
        private.InfiniteList:OnDestroy()
    end
end

function ClubMemberListView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, self)
end

--function ClubMemberListView:_close()
--    self.__index.closeWithAnimation(self)
--end

----------------------Private Func-----------------------------

function private.InitMembersData()
    local data = ModelList.ClubModel.GetMemberList()
    private.membersData = DeepCopy(table.values(data))
end

function private.InitInfiniteList(self)
    local options = {
        tempItemCtrl = self.member_item.transform,
        scrollView = self.scrollView,
        luabehaviour = self.luabehaviour,
        itemView = ClubMemberItemView,

        spacing = 12.47,
        paddingTop = 10,
        paddingBottom = 20,
    }
    private.InfiniteList = InfiniteList:New(options)
end

function private.UpdateInfiniteList()
    private.InfiniteList:UpdateListByData(private.membersData)
end

return this 

