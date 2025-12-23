---特殊玩法里面得Item
local SGPitemBaseState = require "State/SpecialGameplay/SGPitemBaseState"
local SGPitemidleState =require "State/SpecialGameplay/SGPitemidleState"
local SGPitemloadState =require "State/SpecialGameplay/SGPitemloadState"
local SGPitemLockState =require "State/SpecialGameplay/SGPitemLockState"
CityDownloadView = BaseView:New("CityDownloadView")
local this = CityDownloadView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_item",          --点击
    "Personalized",
    "ilde",              --item得背景
    "Loading",           --正在进行得
    "Process",           --相关进度
    "Nothing",           --不存在得
    "CountProcess",      --当前进度
    "CountTxt" ,         --当前进度 CountTxt
} 


function CityDownloadView:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.data = data
    return o
end

function CityDownloadView:Awake()
    self:on_init()
end

function CityDownloadView:OnEnable()
   -- Facade.RegisterView(this)
    self:BuildFsm()

    self:UpdateData(self.data)
end

function CityDownloadView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("CityDownloadView",self,{
        SGPitemidleState:New(),
        SGPitemloadState:New(),
        SGPitemLockState:New(),
    })
    self._fsm:StartFsm("SGPitemidleState")
end

function CityDownloadView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function CityDownloadView:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

--[[
    data ={
        loadType 0 未下载，1 下载中， 2 已下载
    }
--]]
function CityDownloadView:UpdateData(data)
    -- TODO by LwangZg 运行时热更部分
    if data.loadType == 0 then --切换成
        self._fsm:ChangeState("SGPitemidleState")
    elseif data.loadType == 1 then 
        self._fsm:ChangeState("SGPitemloadState")
    end 
end 

--正常没有下载得状态
function CityDownloadView:OnIdleState()
    fun.set_active(self.Loading,false)
    fun.set_active(self.Nothing,false)
    fun.set_active(self.CountProcess,false)
    fun.set_active(self.ilde,false)
end

--正在进行下载得状态
function CityDownloadView:OnLoadState()
    fun.set_active(self.ilde,false)
    fun.set_active(self.Nothing,false)
    fun.set_active(self.Loading,true)
    fun.set_active(self.CountProcess,true)

    if Network.isConnect == false then 
        self._fsm:ChangeState("SGPitemidleState")
    end 
    self:UpdateProcess(0 )
end

--锁住得
function CityDownloadView:OnLockState()
    -- fun.set_active(self.Loading,false)
    -- fun.set_active(self.Nothing,false)
    -- fun.set_active(self.CountProcess,false)
    -- fun.set_active(self.ilde,false)
    -- if (not self.data or not self.data.id ) then 
    --     return;
    -- end 
end

--可以玩得状态
function CityDownloadView:OnPlayState()
    fun.set_active(self.ilde,true)

    fun.set_active(self.Nothing,false)
    fun.set_active(self.Loading,false)
    fun.set_active(self.CountProcess,false)
end

function CityDownloadView:OnComeSonState()
   
end

--正在进行下载得状态
function CityDownloadView:OnStopState()
    fun.set_active(self.ilde,false)
    fun.set_active(self.Nothing,false)
    fun.set_active(self.Loading,true)
    fun.set_active(self.CountProcess,true)
end

--更新进度
function CityDownloadView:UpdateProcess(count)
    self.Process.fillAmount = count 
    self.CountTxt.text = count ==0 and "0%" or math.ceil(count * 100) .."%"
end

--CommySoon 未开放
function CityDownloadView:OnBtnItemComeSonClick()

end 

--没有下载时
function CityDownloadView:OnBtnItemIdleClick()
    --调用下载接口
    if not self.data or not self.data.id then 
        log.r("not self.data or not self.data.id")
        return 
    end 
    local tmpmodData = Csv.GetData("modular",self.data.id)
    SDK.click_download_extrapac(tmpmodData.modular_name)
   
    log.r("NotifyName.StartDownloadMachine ")
    Facade.SendNotification(NotifyName.StartDownloadMachine,self.data.id )
end 

--正在下载时
function CityDownloadView:OnBtnItemloadClick()
    --弹出下载时的提示

end

--上锁的时候
function CityDownloadView:OnBtnItemlockClick()
     --弹出上锁的提示
end


--停止的时候
function CityDownloadView:OnBtnItemStopClick()
    --弹出停止  

end

--
function CityDownloadView:OnBtnItemplayClick()
    local tmpData = Csv.GetData("modular",self.data.id)
    local PlayData = Csv.GetData("city_play",tmpData.city_play_id)
    
    --设置玩法id 
    --ModelList.CityModel.SetPlayId(tmpData.city_play)
    --跳转到固定城市
    Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter,nil,PlayData.city_id,tmpData.city_play_id)
   
end

function CityDownloadView:on_btn_item_click()
    self._fsm:GetCurState():OnBtnItemClick(self._fsm)
end

function CityDownloadView:OnDisable()
   
end

function CityDownloadView:getSelfData()
  
    return self.data
end 

--是否在下载状态
function CityDownloadView:GetIsLoadingStateAndChange()
    if self._fsm:GetCurState().name ~= "SGPitemloadState" then 
        return 
    end 

    self._fsm:ChangeState("SGPitemidleState")
end

--事件监听 下载更新
function CityDownloadView:OnEventUpdate(id,progress,size)
    local data  = self.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 

    log.g("id"..id)
    self:UpdateProcess(progress )
end


--事件监听 下载成功
function CityDownloadView:OnEventSuccess(id)
    local data  = self.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 
    if self.go then 
        fun.set_active(self.go,false )
    end 

    local tmpData = Csv.GetData("modular",self.data.id)
    ModelList.BattleModel.RequireModuleLua(tmpData.modular_name)
   
    SDK.extrapac_end(tmpData.modular_name,0)

    --跳转到固定城市
end

--事件监听 下载开始
function CityDownloadView:OnEventStart(id)
    local data  = self.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 
    self:UpdateProcess(0 )
    self._fsm:ChangeState("SGPitemloadState")
end

--事件监听 下载错误
function CityDownloadView:OnEventError(id)
    local data  = self.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 

    local tmpmodData = Csv.GetData("modular",data.id)
    SDK.extrapac_end(tmpmodData.modular_name,1)
    
    self._fsm:ChangeState("SGPitemidleState")
end

--事件监听 下载错误
function CityDownloadView:OnEventStop(id)
    local data  = self.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 
    self._fsm:ChangeState("SGPitemidleState")
end


function CityDownloadView:SetParent(paren)
    if paren and self.go then
        fun.set_parent(self.go,paren,true)
    end
end

function CityDownloadView:SetActive(active)
    if self.go then
        fun.set_active(self.go,active)
    end
end


function CityDownloadView:PlayDragMoveLeft(startPlayTime)
    --AnimatorPlayHelper.Play(self.anima,string.format("efCity%sEntyMoveLeft",self.cityId),startPlayTime or 0, false,nil)
end

function CityDownloadView:PlayDragMoveRight(startPlayTime)
    --AnimatorPlayHelper.Play(self.anima,string.format("efCity%sEntyMoveRight",self.cityId),startPlayTime or 0,false,nil)
end


function CityDownloadView:PlayEnterLobby(callback)
        if callback then
            callback()
        end
        self:SetActive(false)
end

function CityDownloadView:PlayExitLobby(callback)
    if self._enable then
        if callback then
            callback()
        end
    else
        self._callback = callback    
    end
end

function CityDownloadView:Shutoff(enabled)
    -- if self.anima then
    --     self.anima.enabled = enabled or false
    -- end
end

return this 