local ClubInfoView = BaseView:New("ClubInfoView","ClubAtlas")

local this = ClubInfoView

this.ViewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "IconBg", --
    "icon",
    "btn_help", --卡牌消息
    "nameTxt",  --名字
    "CountTxt",   --人数
    "btn_Memeberlist", --请求资源按钮
    "btn_Search",  --请求卡牌按钮
    "btn_Leave", --离开俱乐部
    "weeklyLeader" --周榜排名比较靠前的人
}

function ClubInfoView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClubInfoView:Awake()
    self:on_init()
end

function ClubInfoView:OnEnable()
    self:Updata()
    --获取公会列表
    ModelList.ClubModel.C2S_ClubQueryList()
end

function ClubInfoView:OnDisable()
    if this.clubWeekInfoView then 
        this.clubWeekInfoView:OnDestroy()
        this.clubWeekInfoView = nil
    end 
end

--刷新自身数据
function ClubInfoView:Updata()
    local clubInfo = ModelList.ClubModel.getClubinfo()

    if not clubInfo then 
        log.r("没有俱乐部数据")
        return 
    end
    
    --初始化礼盒背景
    Cache.SetImageSprite("ClubAtlas", clubInfo.underIcon, self.IconBg, true)
    self.IconBg.sprite = AtlasManager:GetSpriteByName("ClubAtlas", clubInfo.underIcon)

    --初始化礼盒图片
    Cache.SetImageSprite("ClubAtlas", clubInfo.icon, self.icon, true)

    --初始化人数
    self.CountTxt.text = tostring(clubInfo.curNum) .."/"..tostring(clubInfo.totalNum)

    --初始化俱乐部名字
    self.nameTxt.text = clubInfo.name

    --初始化 top weekinfo
    self:UpdateWeeklyLeader()
end

function ClubInfoView:UpdateWeeklyLeader()
    
    fun.set_active(self.weeklyLeader,true)
    if not this.clubWeekInfoView then 
        local reView = require "View/ClubView/ChildView/ClubWeekTopInfo"
        this.clubWeekInfoView = reView:New()
        this.clubWeekInfoView:SkipLoadShow(self.weeklyLeader,true,nil)
    else 
        this.clubWeekInfoView:Updata()
    end 
end 


--公会详情界面
function ClubInfoView:on_btn_help_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubDetailView)
end

--查看成员列表
function ClubInfoView:on_btn_Memeberlist_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubMemberListView)
end

--调到搜索界面
function ClubInfoView:on_btn_Search_click()
    Facade.SendNotification(NotifyName.ShowUI,ViewList.ClubListSearchView)
end

--离开
function ClubInfoView:on_btn_Leave_click()
    local text = Csv.GetDescription(30057)
    local clubName = ModelList.ClubModel.GetSelfClubName()
    text = string.format(text, clubName)

    Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubLeaveView, nil ,nil ,{
        leaveTip = text,   --ClubLeaveView界面提示文本
        onLeaveClub = function()
            --获取公会列表
            ModelList.ClubModel.C2S_ClubQueryList(function()
                Facade.SendNotification(NotifyName.ShowUI,ViewList.ClubListSearchView)
                Facade.SendNotification(NotifyName.CloseUI, ViewList.ClubMainView)
            end)
        end
    })
end

function ClubInfoView:_close()
    self.__index.closeWithAnimation(self)
end

return this