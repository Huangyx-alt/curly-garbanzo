local HallCityBannerItem = BaseView:New("HallCityBannerItem")
local this = HallCityBannerItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items ={
    "left_time",
    "left_time_txt",
    --"btn_banner",
    "remainTimeCountDown",
    "textBannerPriority",
}

require "View/CommonView/RemainTimeCountDown"

local autoOffsetMoveTime = 1--动画自动补齐时间


function HallCityBannerItem:New(viewName,atlasName)
    local o = {viewName = viewName,atlasName = atlasName}
    self.__index = self
    setmetatable(o,self)
    return o
end

--点击命中方法
function HallCityBannerItem:HitBannerFunc()
    log.r("banner点击检查 需要添加方法" , self.go.name)
end

function HallCityBannerItem:SetBannerConfigData(id,priority,index)
    self.isUpRight = false
    self.isUpLeft = false
    self.bannerId = id
    self.bannerPriority = priority
    self.bannerIndex = index
end

--使用这个判断index数据需要
function HallCityBannerItem:SetBannerIndex(index)
    self.bannerIndex = index
end

function HallCityBannerItem:Awake()
    self:on_init()
end

function HallCityBannerItem:OnDestroy()
    self.bannerId = nil
    self.bannerPriority = nil
    self.bannerIndex = nil
    self.isUpRight = false
    self.isUpLeft = false
    self.initPosX = nil
    self:ClearResetBannerItemOffset()
    -- self:OnDispose()
end

function HallCityBannerItem:OnEnable()
    -- self:PlayResetBannerItemOffset()0
end

function HallCityBannerItem:ReopenFunc()
    self:PlayResetBannerItemOffset()
end

function HallCityBannerItem:OnDisable()
    -- self:CompleteResetBannerItemOffset()
    self:PauseResetBannerItemOffset()
    self:StopTimeLeft()
end

function HallCityBannerItem:GetBannerIndex()
    return self.bannerIndex
end

function HallCityBannerItem:GetBannerId()
    return self.bannerId
end

function HallCityBannerItem:GetBannerPriority()
    return self.bannerPriority
end

--设置层级
function HallCityBannerItem:SetOrder(order)
    -- if self.go then
    --     order = order or self.bannerPriority
    --     self.go.transform:SetSiblingIndex(order) 
    -- end
end

function HallCityBannerItem:CloseBanner()
    Facade.SendNotification(NotifyName.CloseUI,self)
end

function HallCityBannerItem:SetLockAddPosX(state)
    -- self.lockAddPosXState = state
end

--使用初始位置修改现在的位置
function HallCityBannerItem:AddBannerPosXByInit(posX)
    if self.go and self.initPosX then
        local px = Vector3.New(posX + self.initPosX , 0)
        self.go.transform.localPosition = px
    end
end

--自动补齐 动画调整位置
function HallCityBannerItem:ResetBannerItemOffset(posX)
    if self.go then
        local oldPos =  self.go.transform.localPosition
        local px = Vector3.New(posX + oldPos.x , 0)
        self:ClearResetBannerItemOffset()
        self.bannerItemOffset = Anim.move_to_xy_local(self.go,px.x,px.y, autoOffsetMoveTime,function()
            self:ClearResetBannerItemOffset()
        end)
    end

end

function HallCityBannerItem:ClearResetBannerItemOffset()
    if self.bannerItemOffset then
        self.bannerItemOffset:Kill()
        self.bannerItemOffset = nil
    end
end

function HallCityBannerItem:PauseResetBannerItemOffset()
    if self.bannerItemOffset then
        self.isPause = true
        self.bannerItemOffset:Pause()
    end
end

function HallCityBannerItem:CompleteResetBannerItemOffset()
    if self.bannerItemOffset  then
        self.bannerItemOffset:Complete()
        self.bannerItemOffset = nil
    end
end

function HallCityBannerItem:PlayResetBannerItemOffset()
    if self.isPause and self.bannerItemOffset  then
        self.bannerItemOffset:Play()
    end
end

function HallCityBannerItem:SetBannerPosX(posX)
    if self.go then
        self.go.transform.localPosition = Vector3.New(posX , 0,0)
    end
end


function HallCityBannerItem:ResetInitPosX()
    local posX = self.go.transform.localPosition.x
    self.initPosX = posX
end

function HallCityBannerItem:SetInitPosX(posX , isResetPos)
    self.initPosX = posX
    if isResetPos then
        self.go.transform.localPosition = Vector3.New(self.initPosX, self.go.transform.localPosition.y,0)
    end
end


function HallCityBannerItem:GetBannerLocalPos()
    if self.go then
        return  self.go.transform.localPosition.x
    end
    return nil
end

function HallCityBannerItem:GetBannerLocalPosX()
    if self.go then
        return  self.go.transform.localPosition.x
    end
    return nil
end

function HallCityBannerItem:GetBannerPosition()
    if self.go then
        return  self.go.transform.position
    end
    return nil
end


--banner结束发送消息 移除banner
function HallCityBannerItem:BannerOver()
    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem , self.bannerId)
end

--最左最右
--设置是否是最右侧
function HallCityBannerItem:SetBannerIsUpRight(state)
    self.isUpRight = state
end

--设置是否是最左侧
function HallCityBannerItem:SetBannerIsUpLeft(state)
    self.isUpLeft = state
end

--是否是最右侧
function HallCityBannerItem:GetBannerIsUpRight()
    return self.isUpRight or false
end

--是否是最左侧
function HallCityBannerItem:GetBannerIsUpLeft()
    return self.isUpLeft or false
end
--最左最右


--倒计时
function HallCityBannerItem:CreatTimeLeft()
    if not self.remainTimeCountDown then
        self.remainTimeCountDown = RemainTimeCountDown:New()
    end
end

function HallCityBannerItem:GetLeftTime()
    return 1000
end

--停止时间（可能会有问题）
function HallCityBannerItem:StopTimeLeft()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
    end
end

function HallCityBannerItem:InitTime()
    self:StopTimeLeft()
    local leftTime = self:GetLeftTime()
    if leftTime <= 0 then
        return
    end
    self:CreatTimeLeft()
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt7,
        self:GetLeftTime(),
        self.left_time_txt,
    function()
        self:FinishEndTime()
        self:StopTimeLeft()
    end)    
end

function HallCityBannerItem:FinishEndTime()
end
--倒计时


return this