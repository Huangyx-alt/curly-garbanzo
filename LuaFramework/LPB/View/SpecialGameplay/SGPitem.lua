---特殊玩法里面得Item
local SGPitemBaseState = require "State/SpecialGameplay/SGPitemBaseState"
local SGPitemidleState = require "State/SpecialGameplay/SGPitemidleState"
local SGPitemloadState = require "State/SpecialGameplay/SGPitemloadState"
local SGPitemLockState = require "State/SpecialGameplay/SGPitemLockState"
local SGPitemplayState = require "State/SpecialGameplay/SGPitemplayState"
local SGPitemComeSonState = require "State/SpecialGameplay/SGPitemComeSonState"
local SGPitem = BaseView:New("SGPitem")
local this = SGPitem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_item",          --点击
    "Personalized",
    "ilde",              --item得背景
    "Loading",           --正在进行得
    "Process",           --相关进度
    "Nothing",           --不存在得
    "TsrkNew",           --logo
    "CountProcess",      --当前进度
    "CountTxt" ,         --当前进度 CountTxt
    "LoTxt",              --地点得文本
    "Lock",              --上锁           
    "LockText",          --上锁得文本
} 


this.Prefabsd={
    [1] = "Jweijiuicon",
    [2] = "Shengdanicon",
    [3] = "LeetouManIcon",
    [4] = "SingleWolf",--"EasterEgg",
    [5] = "ComingSoon",--"LuckJourney",
    [6] = "ComingSoon",
}

function SGPitem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function SGPitem:Awake()
    self:on_init()
end

function SGPitem:OnEnable(data)
   -- Facade.RegisterView(this)
    self.data = data
    self:BuildFsm()
end

function SGPitem:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("SGPitem",self,{
        SGPitemidleState:New(),
        SGPitemloadState:New(),
        SGPitemLockState:New(),
        SGPitemplayState:New(),
        SGPitemComeSonState:New(),
    })
    self._fsm:StartFsm("SGPitemidleState")
end

function SGPitem:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function SGPitem:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

--[[
    data ={
        lock 
        downtye 为lock 是true得时候
        commyType 有没有开放
      
    }
]]

function SGPitem:UpdateData(data)
    local tmpData = Csv.GetData("feature_enter",data.id)
    local PlayData =  Csv.GetData("city_play",tmpData.city_play)
    self.data = data

 
    if data.lock == true then --切换成
        if data.commyType then 
            self._fsm:ChangeState("SGPitemComeSonState")
        else 
            self._fsm:ChangeState("SGPitemLockState")
        end 
      
    else 
        if data.downtye == 0 then  --还没下载
            self._fsm:ChangeState("SGPitemidleState")
        elseif data.downtye == 1 then --下载中
            self._fsm:ChangeState("SGPitemloadState")
        else                        --下载完
            self._fsm:ChangeState("SGPitemplayState")
        end 
    end 

    local featuredId = ModelList.CityModel:GetRecommendModleList(data.id)

    if featuredId ~= nil then 
        tmpData.featured_type = featuredId
    end 

    if tmpData.featured_type == 1 then --hot热门玩法
        fun.set_active(self.TsrkNew,true)
       self.TsrkNew.sprite =  AtlasManager:GetSpriteByName("CommonAtlas", "TsrkHot")
    elseif tmpData.featured_type == 2 then --new新玩法
        fun.set_active(self.TsrkNew,true)
        self.TsrkNew.sprite =  AtlasManager:GetSpriteByName("CommonAtlas", "TsrkNew")
    elseif tmpData.featured_type == 3 then --普通玩法
        fun.set_active(self.TsrkNew,false)
    elseif tmpData.featured_type == 4 then --压根没开放
        fun.set_active(self.TsrkNew,false)
    end 
    
    --城市名字初始化
    local cityId = PlayData ~= nil and PlayData.city_id or 1
    local dec= Csv.GetData("city",cityId)
    local decStr = Csv.GetData("description",dec.name_description) 
    self.LoTxt.text = decStr.description


    --读取的预制体
    Cache.load_prefabs(AssetList[this.Prefabsd[data.id]],this.Prefabsd[data.id],function(ret)
        fun.get_instance(ret,self.Personalized)
    end)
end 

--正常没有下载得状态
function SGPitem:OnIdleState()
    fun.set_active(self.Loading,false)
    fun.set_active(self.Nothing,false)
    fun.set_active(self.CountProcess,false)
    fun.set_active(self.ilde,false)
    fun.set_active(self.Lock,false)
end

--正在进行下载得状态
function SGPitem:OnLoadState()
    fun.set_active(self.ilde,false)
    fun.set_active(self.Nothing,false)
    fun.set_active(self.Lock,false)

    fun.set_active(self.Loading,true)
    fun.set_active(self.CountProcess,true)

    if Network.isConnect == false then 
        self._fsm:ChangeState("SGPitemidleState")
    end 
    self:UpdateProcess(0 )
end

--锁住得
function SGPitem:OnLockState()
    fun.set_active(self.Loading,false)
    fun.set_active(self.Nothing,false)
    fun.set_active(self.CountProcess,false)
    fun.set_active(self.ilde,false)

    fun.set_active(self.Lock,true)
    --置灰

    if (not self.data or not self.data.id ) then 
        return;
    end 

    --读取开放级别
    local tmpData = Csv.GetData("feature_enter",self.data.id)
    self.LockText.text =   Csv.GetRateOpenByCityId(tmpData.city_play)
    
end

--可以玩得状态
function SGPitem:OnPlayState()
    fun.set_active(self.ilde,true)

    fun.set_active(self.Nothing,false)
    fun.set_active(self.Lock,false)
    fun.set_active(self.Loading,false)
    fun.set_active(self.CountProcess,false)
end

function SGPitem:OnComeSonState()
    fun.set_active(self.Nothing,true)

    fun.set_active(self.ilde,false)
    fun.set_active(self.Lock,false)
    fun.set_active(self.Loading,false)
    fun.set_active(self.CountProcess,false)
end

--正在进行下载得状态
function SGPitem:OnStopState()
    fun.set_active(self.ilde,false)
    fun.set_active(self.Nothing,false)
    fun.set_active(self.Lock,false)

    fun.set_active(self.Loading,true)
    fun.set_active(self.CountProcess,true)
end

--更新进度
function SGPitem:UpdateProcess(count)
    self.Process.fillAmount = count 
    self.CountTxt.text = count ==0 and "0%" or math.ceil(count * 100) .."%"
end

--CommySoon 未开放
function SGPitem:OnBtnItemComeSonClick()

end 

--没有下载时
function SGPitem:OnBtnItemIdleClick()
    --调用下载接口
    if not self.data or not self.data.id then 
        log.r("not self.data or not self.data.id")
        return 
    end 
 

    if self.data.commyType ~= nil and  self.data.commyType == true then 
        return 
    end

    Facade.SendNotification(NotifyName.StartDownloadMachine,self.data.id)

    local tmpmodData = Csv.GetData("modular",self.data.id)
    SDK.click_download_extrapac(tmpmodData.modular_name)
end 

--正在下载时
function SGPitem:OnBtnItemloadClick()
    --弹出下载时的提示

end

--上锁的时候
function SGPitem:OnBtnItemlockClick()
     --弹出上锁的提示
end


--停止的时候
function SGPitem:OnBtnItemStopClick()
    --弹出停止  

end

--
function SGPitem:OnBtnItemplayClick()
    local tmpData = Csv.GetData("feature_enter",self.data.id)
    local PlayData =  Csv.GetData("city_play",tmpData.city_play)
    if fun.IsEditor() and (self.data.id == 3 or self.data.id == 4 ) and self.data.version ==0 then
        self.data.version = 1
    end
    if (self.data.version and self.data.version >0 and tmpData ~= nil ) then 
        local tmpmodData = Csv.GetData("modular", tmpData.modular_id)
        ModelList.BattleModel.RequireModuleLua(tmpmodData.modular_name)
    end 

    if (self.CountTxt and self.CountTxt.text and self.CountTxt.text == "100%") then 

        local tmpmodData = Csv.GetData("modular",self.data.id)
        ModelList.BattleModel.RequireModuleLua(tmpmodData.modular_name)
        SDK.extrapac_open(tmpmodData.modular_name)
    end

    Facade.SendNotification(NotifyName.SpecialGameplay.CloseSpecialGameplayView)
    --跳转到固定城市
    Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter,nil,PlayData.city_id,tmpData.city_play)
   
end

function SGPitem:on_btn_item_click()
    self._fsm:GetCurState():OnBtnItemClick(self._fsm)
end

function SGPitem:OnDisable()
   
end

function SGPitem:getSelfData()
    return self.data
end 

--是否在下载状态
function SGPitem:GetIsLoadingStateAndChange()
    if self._fsm:GetCurState().name ~= "SGPitemloadState" then 
        return 
    end 

    self._fsm:ChangeState("SGPitemidleState")
end

--事件监听 下载更新
function SGPitem:OnEventUpdate(id,progress,size)

    if self._fsm:GetCurState().name ~= "SGPitemloadState" then 
        self._fsm:ChangeState("SGPitemloadState")
    end 

    local data  = self.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 

    log.g("OnEventUpdateid"..id)
    self:UpdateProcess(progress )
end


--事件监听 下载成功
function SGPitem:OnEventSuccess(id)
    local data  = self.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 

    if data.commyType ~= nil and  data.commyType == true then 
        return 
    end

    local tmpmodData = Csv.GetData("feature_enter",data.id)

    if tmpmodData.modular_type ~= 1 then 
        return 
    end 

    SDK.extrapac_end(tmpmodData.modular_name,0)
    
    self._fsm:ChangeState("SGPitemplayState")
end

--事件监听 下载开始
function SGPitem:OnEventStart(id)
    local data  = self.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 

    if data.commyType ~= nil and   data.commyType == true then 
        return 
    end

    local tmpmodData = Csv.GetData("modular",data.id)

    if tmpmodData.modular_type ~= 1 then 
        return 
    end 

    self:UpdateProcess(0 )
    self._fsm:ChangeState("SGPitemloadState")
end

--事件监听 下载错误
function SGPitem:OnEventError(id)
    local data  = self.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 

    if  data.commyType ~= nil and  data.commyType == true then 
        return 
    end

    local tmpmodData = Csv.GetData("modular",data.id)
    if tmpmodData.modular_type ~= 1 then 
        return 
    end 
    SDK.extrapac_end(tmpmodData.modular_name,1)
    self._fsm:ChangeState("SGPitemidleState")
end

--事件监听 下载错误
function SGPitem:OnEventStop(id)
    local data  = self.data
    if not data or not data.id then 
        return 
    end

    if  data.id ~= id then 
        return 
    end 

    local tmpmodData = Csv.GetData("modular",data.id)
    if tmpmodData.modular_type ~= 1 then 
        return 
    end 

    self._fsm:ChangeState("SGPitemidleState")
end

return this 