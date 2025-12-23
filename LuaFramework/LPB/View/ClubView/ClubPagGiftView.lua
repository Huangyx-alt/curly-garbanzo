-- 聊天界面中得发送礼包得界面

local  ClubPagGiftView = BaseView:New("ClubPagGiftView", "ClubAtlas")

local this = ClubPagGiftView

this.ViewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_help",
    "packet1",
    "packet2",
    "packet3",
}

this.packageList = {}

function ClubPagGiftView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClubPagGiftView:Awake()
    self:on_init()
end

function ClubPagGiftView:OnEnable()
   
end

function ClubPagGiftView:Updata()
    local data = {
        [1] ={
            level = 1,
            pag={}
        },
        [2] = {
            level = 2,
            pag={}
        },
        [3] = {
            level = 3,
            pag={}
        }
    }

    local openTimer = false 
    this:StopCountdown()
    
    for _,v in pairs(data) do 
         --获取是否有某个等级得礼包
        local pagdata = ModelList.ClubModel.getClubGiftPack(v.level)
        v.pag = pagdata
    
        if not this.packageList[v.level] then 
            local review = require "View/ClubView/ChildView/ClubPagItem"
            if fun.table_len(v.pag) > 0 then 
                openTimer = true 
            end 
            
            this.packageList[v.level]= review:New()

            if v.level == 3 then 
                this.packageList[v.level]:SkipLoadShow(self.packet1,true,nil,v)
            elseif v.level == 1 then 
                this.packageList[v.level]:SkipLoadShow(self.packet2,true,nil,v)
            else
                this.packageList[v.level]:SkipLoadShow(self.packet3,true,nil,v)
            end 

            this.packageList[v.level]:UpdateData(v)
        else 

            this.packageList[v.level]:UpdateData(v)
        end 
    end 

    --开启个定时器
    if openTimer then 
        self.TimeLoop = LuaTimer:SetDelayLoopFunction(1, 5,-1, function()
            for _,v in pairs( this.packageList) do
                if  v:UpdateTime() <=0 then 
                    this:StopCountdown()
                    this:Updata()
                    break;
                end 
            end
        end,nil,nil,LuaTimer.TimerType.UI)
    end 
end


function ClubPagGiftView:StopCountdown()
    if self.TimeLoop then
        LuaTimer:Remove(self.TimeLoop)
        self.TimeLoop = nil
    end
end 

function ClubPagGiftView:on_btn_help_click()
    Facade.SendNotification(NotifyName.ShowUI,ViewList.ClubGiftPacketHelpView,nil,nil)
end

function ClubPagGiftView:OnDisable()
    this:StopCountdown()
end

function ClubPagGiftView.OnDestroy()
    for _,v in pairs(this.packageList) do 
        if v ~= nil then 
            v:OnDestroy()
        end 
    end 
    this.packageList = {}
end


return this