
local FlyRewardEffectsView = BaseView:New("FlyRewardEffectsView","")
local this = FlyRewardEffectsView
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog

this.auto_bind_ui_items = 
{
    "anima",
    "root",
    "top_area",
    "flyitem1",
    "flyitem2",
    "flyitem3",
    "flyitem4",
    "flyitem5",
    "flyitem6",
    "flyitem7",
    "flyitem8",
    "flyitem9",
    "flyitem10",
    "flyitem11",
    "flyitem12",
    "flyitem13",
    "flyitem14",
    "flyitem15",
    "flyitem16",
    "flyitem17"
}

local AnimationCurve = UnityEngine.AnimationCurve
local Keyframe = UnityEngine.Keyframe
local Time = UnityEngine.Time

function FlyRewardEffectsView:New(viewName,atlasName)
    local o = {}
    o.viewName = viewName
    o.atlasName = atlasName
    self.__index = self
    setmetatable(o,self)
    return o
end

function FlyRewardEffectsView:Awake()

    self:on_init()
end

function FlyRewardEffectsView:OnEnable()
    self._init = true
    self:InitFly()
    if self._pos then
        self:SetPos(self._pos)
        --self:SetPos(Vector3.New(0,0,0))
    else 
        self._pos =Vector3.New(0,0,0)
    end
	
    local pos = self:GetFlyTargetPos()
	if self._targetPos then
		pos = self._targetPos;
	end

    local distOrigin = Vector2.Distance(Vector2.New(0,0),pos)
    local distThis = Vector2.Distance(self._pos or Vector3.New(0,0,0),pos)
    local rate = math.min(distThis / distOrigin,1)

    self.flyItemCount = 0
    self.flyItemIndex = 0
    self.finishCount = 0

    self.actime = Time.time -- 到一定时间自己销毁

    if not self.anima then return end
    AnimatorPlayHelper.Play(self.anima,self:GetAnimationName(),true,function()
        local durations = self:GetDurations()
        self.animDataList = {}
        for key, value in pairs(self.auto_bind_ui_items) do
            if key ~= 1 and key ~= 2 and key ~= 3 then
                local obj = self[value]
                if not IsNull(obj) then
                    self.flyItemCount = self.flyItemCount + 1
                    local ac_x = AnimationCurve.New(Keyframe.New(0,self[value].transform.position.x),Keyframe.New(durations[key - 3] * rate,pos.x))
                    local ac_y = AnimationCurve.New(Keyframe.New(0,self[value].transform.position.y),Keyframe.New(durations[key - 3] * rate,pos.y))
                    local ac_s = AnimationCurve.New(Keyframe.New(0,1),Keyframe.New(durations[key - 3] * rate,0.7))
                    local animData = {go = self[value],acx = ac_x,acy = ac_y,acs = ac_s,time = Time.time}
                    table.insert(self.animDataList,animData)
                end
            end
        end
    end,0.71)

    self.update_x_enabled = true
    self:start_x_update()
end

function FlyRewardEffectsView:InitFly()
    --子类重写
end

function FlyRewardEffectsView:GetFlyTargetPos()
    --子类重写
    return GetTopCurrencyRightIconPos()
end

function FlyRewardEffectsView:GetAnimationName()
    --子类重写
    return "shopbuycoin"
end

function FlyRewardEffectsView:GetDurations()
    --子类重写
    return {0.35,0.383,0.5,0.6,0.5,0.5,0.383,0.4,0.62,0.5,0.383,0.5,0.61,0.45,0.37,0.5,0.5}
end

function FlyRewardEffectsView:on_x_update()
    if self.animDataList then
        local time = 0
        for key, value in pairs(self.animDataList) do
            if not value.finish then
                time = Time.time - value.time
                value.go.transform.position = Vector3.New(value.acx:Evaluate(time),value.acy:Evaluate(time),0)
                value.go.transform.localScale = Vector3.New(value.acs:Evaluate(time),value.acs:Evaluate(time),1)
                if time >= value.acx[value.acx.length - 1].time then
                    value.finish = true
                    self:FlyCallback(value.go.transform.position,value.go)
                end
            end
        end
    else 
        if self.actime and  Time.time - self.actime >2 then 
            --Facade.SendNotification(NotifyName.CloseUI,self)
            self:FinishHandle()
        end 
    end
    
end

function FlyRewardEffectsView:FlyCallback(pos,go)
    fun.set_active(go,false)
    self.flyItemIndex = self.flyItemIndex + 1
    if self.flyItemIndex == 1 then
        if self._flyEffectCallback then
            self._flyEffectCallback()
        end
        --- 战斗中从特效池获取，避免反复创建
        if ModelList.BattleModel:IsGameing()  and ModelList.BattleModel:IsShowDetail()  then
            local go = Cache.load_pool_or_instance("FlyRewardhit",nil)
            if go then
                go.transform:SetAsFirstSibling()
                fun.set_gameobject_pos(go, pos.x, pos.y, 0, false)
                local duration = Util.PlayParticle(go)
                if duration then
                    self.efPlayTimer = Invoke(function()
                        self:Finish()
                    end, duration)
                    BattleEffectPool:DelayRecycle("FlyRewardhit", go, duration)
                end
            else
                Cache.load_prefabs(AssetList.FlyRewardhit, "FlyRewardhit", function(obj)
                    local go = fun.get_instance(obj, self.go)
                    go.transform:SetAsFirstSibling()
                    fun.set_gameobject_pos(go, pos.x, pos.y, 0, false)
                    local duration = Util.PlayParticle(go)
                    if duration then
                        self.efPlayTimer = Invoke(function()
                            self:Finish()
                        end, duration)
                        BattleEffectPool:DelayRecycle("FlyRewardhit", go, duration)
                    end
                end)
            end
        else
            Cache.load_prefabs(AssetList.FlyRewardhit, "FlyRewardhit", function(obj)
                local go = fun.get_instance(obj, self.go)
                go.transform:SetAsFirstSibling()
                fun.set_gameobject_pos(go, pos.x, pos.y, 0, false)
                local duration = Util.PlayParticle(go)
                if duration then
                    self.efPlayTimer = Invoke(function()
                        self:Finish()
                    end, duration)
                end
            end)

        end
    end
    if self.flyItemIndex == self.flyItemCount then
        self:Finish()
    end
end

function FlyRewardEffectsView:Finish()
    self.finishCount = self.finishCount + 1
    if self.finishCount > 1 then
       -- log.r("FlyRewardEffectsView:Finish() finishCount > 1")
        self:FinishHandle()
        --Facade.SendNotification(NotifyName.CloseUI,self)
    end
end

--- 飞行结束后的关闭表现,战斗中回收，非战斗中直接关闭
function FlyRewardEffectsView:FinishHandle()
    if ModelList.BattleModel:IsGameing() and fun.is_not_null(self.go) and ModelList.BattleModel:IsShowDetail()   then
        BattleEffectPool:Recycle2(self.viewName, self.go,self:GetRootView())
        Facade.SendNotification(NotifyName.CloseUI,self,true)
    else
        Facade.SendNotification(NotifyName.CloseUI,self)
    end
end


function FlyRewardEffectsView:SetPos(pos)
    self._pos = pos
    if self._init then
        fun.set_gameobject_pos(self.root.gameObject,pos.x,pos.y,pos.z,false)
    end
end

function FlyRewardEffectsView:SetTargetPos(pos)
	self._targetPos = pos
end

function FlyRewardEffectsView:SetCommonIcon(icon)
    for i = 1, 16 do
        local img = fun.get_component(self["flyitem"..i],fun.IMAGE)
        if img then
            img.sprite = icon.sprite
        end
    end
end


function FlyRewardEffectsView:SetFlyEffectCallBack(cb)
    self._flyEffectCallback = cb
end

function FlyRewardEffectsView:OnDisable()
    self._init = nil
    self._pos = nil
    self.flyItemCount = nil
    self.flyItemIndex = nil
    self.finishCount = nil
    self.animDataList = nil
    self.actime = nil
    self._flyEffectCallback = nil
    if self.efPlayTimer then
        self.efPlayTimer:Stop()
        self.efPlayTimer = nil
    end
end

function FlyRewardEffectsView:on_close()
    
end

this.NotifyList = 
{

}

return this