local SGPitemLockState = require "State/SpecialGameplay/SGPitemBaseState"
local SGPitemidleState = require "State/SpecialGameplay/SGPitemidleState"
local SGPitemloadState = require "State/SpecialGameplay/SGPitemloadState"
local SGPitemLockState = require "State/SpecialGameplay/SGPitemLockState"
local DownloadCommonView = BaseView:New("DownloadCommonView")
local this = DownloadCommonView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "ilde",              --item得背景
    "Loading",           --正在进行得
    "Process",           --相关进度
    "Nothing",           --不存在得
    "CountProcess",      --当前进度
    "CountTxt" ,         --当前进度 CountTxt
} 


function DownloadCommonView:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.data = data
    this.data = data
    return o
end

function DownloadCommonView:Awake()
    this:on_init()
end

function DownloadCommonView:OnEnable()
   -- Facade.RegisterView(this)
    self:BuildFsm()
    Facade.RegisterView(this)
    self:addEventList()
end

function DownloadCommonView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("DownloadCommonView",self,{
        SGPitemidleState:New(),
        SGPitemloadState:New(),
        SGPitemLockState:New(),
    })
    self._fsm:StartFsm("SGPitemidleState")
end

function DownloadCommonView:DisposeFsm()
    if this._fsm then
        this._fsm:Dispose()
        this._fsm = nil
    end
end

function DownloadCommonView:GetTransform()
    if this.go then
        return this.go.transform
    end
    return nil
end


--正常没有下载得状态
function DownloadCommonView:OnIdleState()
    fun.set_active(self.Loading,true)
    fun.set_active(self.CountProcess,false)
    fun.set_active(self.ilde,true)
end

--正在进行下载得状态
function DownloadCommonView:OnLoadState()
    fun.set_active(self.ilde,true)
    fun.set_active(self.Loading,true)
    fun.set_active(self.CountProcess,true)

    if Network.isConnect == false then 
        self._fsm:ChangeState("SGPitemidleState")
    end 
    self:UpdateProcess(0 )
end

--锁住得
function DownloadCommonView:OnLockState()
   
end

--可以玩得状态
function DownloadCommonView:OnPlayState()
    fun.set_active(self.ilde,true)
    fun.set_active(self.Loading,false)
    fun.set_active(self.CountProcess,false)
end

function DownloadCommonView:OnComeSonState()
   
end

--正在进行下载得状态
function DownloadCommonView:OnStopState()
    fun.set_active(self.ilde,false)
    fun.set_active(self.Loading,true)
    fun.set_active(self.CountProcess,true)
end

--更新进度
function DownloadCommonView:UpdateProcess(count)
    self.Process.fillAmount = count 
    self.CountTxt.text = count == 0 and "0%" or math.ceil(count * 100) .."%"
end


function DownloadCommonView:OnDisable()
    Facade.RemoveView(this)
    self:removeEventList()
end

function DownloadCommonView:getSelfData()
  
    return self.data
end 

--是否在下载状态
function DownloadCommonView:GetIsLoadingStateAndChange()
    if self._fsm:GetCurState().name ~= "SGPitemloadState" then 
        return 
    end 

    self._fsm:ChangeState("SGPitemidleState")
end

--事件监听 下载更新
function DownloadCommonView.OnEventUpdate_notift(id,progress,size)
    Event.Brocast(NotifyName.EventDownload.Event_download_update, id,progress,size)
end

function DownloadCommonView:OnEventUpdate(id,progress,size)
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
function DownloadCommonView.OnEventSuccess_notift(id)
    Event.Brocast(NotifyName.EventDownload.Event_download_success, id)
end

--事件监听 下载成功
function DownloadCommonView:OnEventSuccess(id)
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

    local tmpData = Csv.GetData("modular",this.data.id)
    ModelList.BattleModel.RequireModuleLua(tmpData.modular_name)
    SDK.extrapac_end(tmpData.modular_name,0)
    fun.set_active(self.go,false)

end

--事件监听 下载开始
function DownloadCommonView.OnEventStart_notift(id)
    Event.Brocast(NotifyName.EventDownload.Event_download_start, id)
end

--事件监听 下载开始
function DownloadCommonView:OnEventStart(id)
    local data  = this.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 
    fun.set_active(this.go,true)
    self:UpdateProcess(0 )
    self._fsm:ChangeState("SGPitemloadState")
   
end

function DownloadCommonView.OnEventError_notift(id)
    Event.Brocast(NotifyName.EventDownload.Event_download_error, id)
end

--事件监听 下载错误
function DownloadCommonView:OnEventError(id)
    local data  = this.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 

    local tmpmodData = Csv.GetData("modular",data.id)
    SDK.extrapac_end(tmpmodData.modular_name,1)
    self._fsm:ChangeState("SGPitemidleState")

    fun.set_active(self.go,false)
end

function DownloadCommonView.OnEventStop_notift(id)
    Event.Brocast(NotifyName.EventDownload.Event_download_stop, id)
end

--事件监听 下载错误
function DownloadCommonView:OnEventStop(id)
    local data  = this.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 

    self._fsm:ChangeState("SGPitemidleState")
    
end


function DownloadCommonView:SetParent(paren)
    if paren and self.go then
        fun.set_parent(self.go,paren,true)
    end
end

function DownloadCommonView:SetActive(active)
    if self.go then
        fun.set_active(self.go,active)
    end
end

function DownloadCommonView:Shutoff(enabled)
  
end

this.NotifyList ={
    {notifyName = NotifyName.Event_machine_download_update, func = this.OnEventUpdate_notift},
    {notifyName = NotifyName.Event_machine_download_success_view, func = this.OnEventSuccess_notift},
    {notifyName = NotifyName.Event_machine_download_error, func = this.OnEventError_notift},
    {notifyName = NotifyName.Event_machine_download_start, func = this.OnEventStart_notift},
    {notifyName = NotifyName.Event_machine_download_stop, func = this.OnEventStop_notift},
}

function DownloadCommonView:addEventList()
    Event.AddListener(NotifyName.EventDownload.Event_download_update,self.OnEventUpdate,self)
    Event.AddListener(NotifyName.EventDownload.Event_download_success,self.OnEventSuccess,self)
    Event.AddListener(NotifyName.EventDownload.Event_download_error,self.OnEventError,self)
    Event.AddListener(NotifyName.EventDownload.Event_download_start,self.OnEventStart,self)
    Event.AddListener(NotifyName.EventDownload.Event_download_stop,self.OnEventStop,self)
    Event.AddListener(NotifyName.EventDownload.Event_download_success_view,self.OnEventSuccess,self)
end 

function DownloadCommonView:removeEventList()
    Event.RemoveListener(NotifyName.EventDownload.Event_download_update,self.OnEventUpdate,self)
    Event.RemoveListener(NotifyName.EventDownload.Event_download_success,self.OnEventSuccess,self)
    Event.RemoveListener(NotifyName.EventDownload.Event_download_error,self.OnEventError,self)
    Event.RemoveListener(NotifyName.EventDownload.Event_download_start,self.OnEventStart,self)
    Event.RemoveListener(NotifyName.EventDownload.Event_download_stop,self.OnEventStop,self)
    Event.RemoveListener(NotifyName.EventDownload.Event_download_success_view,self.OnEventSuccess,self)
end 

return this 