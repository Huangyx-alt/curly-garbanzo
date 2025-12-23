MiniGame01StageProperty = BaseView:New("MiniGame01StageProperty")
local this = MiniGame01StageProperty
this.ViewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "anima",
    "icon",
    "value",
    "rewards",
    "hat01",
    "hat02",
    "start_lucky",
    "lucky",
    "start",
    
}

function MiniGame01StageProperty:New(index_num)
    local o = {}
    self.__index = self
    o._index_num = index_num
    setmetatable(o,self)
    return o
end

function MiniGame01StageProperty:Awake()
    self:on_init()
end

function MiniGame01StageProperty:OnEnable()
    self:SetHatTint()
end

function MiniGame01StageProperty:OnDisable()
    self.hat_background = nil
    self._isLock = nil
    self.rabbitAnima = nil
end

function MiniGame01StageProperty:GetIndexNum()
    return self._index_num
end

function MiniGame01StageProperty:SetLock(isLock)
    self._isLock = isLock
end

function MiniGame01StageProperty:IsLock()
    return self._isLock
end

function MiniGame01StageProperty:PlayOpenBoxGetReward()
    if not self._isLock then
        if self:CheckIsThief() then
            UISound.play("hat_thief")
        else
            UISound.play("hat_reward")
        end
        LuaTimer:SetDelayFunction(0.8, function()
            self:CheckGetShowBestRewardImg()
        end)
        AnimatorPlayHelper.Play(self.anima,{"get","stageProperty_get"},false,function()
        end)
    end
end

function MiniGame01StageProperty:PlayOpenBoxMissReward()
    if not self._isLock then
        self:CheckNoGetShowBestRewardImg()
        AnimatorPlayHelper.Play(self.anima,{"noget","stageProperty_noget"},false,function()
        end)
    end
end

function MiniGame01StageProperty:PlayHidePropertyBox()
    if not self._isLock then
        UISound.play("hat_disappear")
        AnimatorPlayHelper.Play(self.anima,{"end","stageProperty_end"},false,function()
            self:HideGetBestRewardImg()
        end)
    end
end

function MiniGame01StageProperty:PlayShowPropertyBox()
    if not self._isLock then
        self:SetHatTint()
        UISound.play("hat_appear")
        AnimatorPlayHelper.Play(self.anima,{"start","stageProperty_start"},false,function()
        end)
    end
end

function MiniGame01StageProperty:SetHatTint()
    local layer = ModelList.MiniGameModel:GetLayerInfo()
    if layer and layer.background ~= self.hat_background then
        self.hat_background = layer.background
        local bg_name1 = "MiniHatG01"
        local bg_name2 = "MiniHatG02"
        if 0 == self.hat_background then
            bg_name1 = "MiniHatY01"
            bg_name2 = "MiniHatY03"
        elseif 1 == self.hat_background then
            bg_name1 = "MiniHatG01"
            bg_name2 = "MiniHatG02"  
        elseif 2 == self.hat_background then
            bg_name1 = "MiniHatB01"
            bg_name2 = "MiniHatB02"     
        elseif 3 == self.hat_background then
            bg_name1 = "MiniHatP01"
            bg_name2 = "MiniHatP02"    
        end
        Cache.SetImageSprite("MiniGame01Atlas",bg_name1,self.hat01)
        Cache.SetImageSprite("MiniGame01Atlas",bg_name2,self.hat02)
    end
end

function MiniGame01StageProperty:ResetPalyRound()
    if self.transform and self.rewards then
        fun.set_gameobject_pos(self.rewards,0,-10,0,true)
        fun.set_active(self.rewards,true)
        self._isLock = nil
        if self.rabbitAnima then
            fun.set_active(self.rabbitAnima,false)
        end
        self:PlayShowPropertyBox()
    end
end

function MiniGame01StageProperty:SetReward(reward)
    self._reward = reward
    if not reward or not reward.IslayerGreatRewardIndex then
        --选中小偷 会只有3个奖励数据 reward会变成空的
        self.IslayerGreatRewardIndex =  false
    else
        self.IslayerGreatRewardIndex = true
    end
    if self._reward then
        if self:CheckIsThief() then
            fun.enable_component(self.icon,false)
            fun.enable_component(self.value,false)
            if not self.rabbitAnima then
                Cache.load_prefabs("luaprefab_minigame_minigame01","rabbit",function(obj)
                    if obj and self.icon then
                        local go = fun.get_instance(obj,self.icon)
                        if go then
                            self.rabbitAnima = fun.get_component(go,fun.ANIMATOR)
                            self.rabbitAnima:Play("rabbit_show",0,0)
                        end
                    end
                end)
            else
                fun.set_active(self.rabbitAnima,true)
                self.rabbitAnima:Play("rabbit_show",0,0)
            end
        else
            fun.enable_component(self.icon,true)
            fun.enable_component(self.value,true    )
            local img = Csv.GetItemOrResource(self._reward.id)
            Cache.SetImageSprite("ItemAtlas",img.more_icon or img.icon,self.icon)
            self.value.text = fun.FormatText(self._reward)   --tostring(self._reward.value)
        end
    end
end

function MiniGame01StageProperty:FlyReward(pos,callback)
    Anim.move_ease(self.rewards,pos.x,pos.y,pos.z,0.8,false,DG.Tweening.Ease.InOutSine,function()
        self:HideGetBestRewardImg()
        fun.set_active(self.rewards,false)
        if callback then
            callback()
        end
    end)
end

function MiniGame01StageProperty:SetParent(parent,isInitPos)
    if self.go then
        fun.set_parent(self.go,parent,isInitPos)
    end
end

--选择了最好的奖励 播放闪光特效
function MiniGame01StageProperty:ShowGetBestRewardLight()
    fun.set_active(self.start_lucky , true)
    LuaTimer:SetDelayFunction(1, function()
        fun.set_active(self.start_lucky , false)
    end)
end

function MiniGame01StageProperty:CheckNoGetShowBestRewardImg()
    if self.IslayerGreatRewardIndex then
        self:ShowGetBestRewardImg()
    else
        self:HideGetBestRewardImg()
    end
end

function MiniGame01StageProperty:CheckGetShowBestRewardImg()
    if self.IslayerGreatRewardIndex then
        if self:CheckIsThief() then
            fun.set_active(self.start_lucky , false)
            self:HideGetBestRewardImg()
        else
            self:ShowGetBestRewardLight()
            self:ShowGetBestRewardImg()
        end
    else
        self:HideGetBestRewardImg()
        if self:CheckIsThief() then
            fun.set_active(self.start , false)
        else
            self:ShowChooseNormalRewardEffect()
        end
    end
end

--展示luck文字
function MiniGame01StageProperty:ShowGetBestRewardImg()
    fun.set_active(self.lucky , true)
end

--隐藏luck文字
function MiniGame01StageProperty:HideGetBestRewardImg()
    fun.set_active(self.lucky , false)
end

--展示未选中 luack特效
function MiniGame01StageProperty:ShowChooseNormalRewardEffect()
    fun.set_active(self.start , true)
    LuaTimer:SetDelayFunction(1, function()
        fun.set_active(self.start , false)
    end)
end

function MiniGame01StageProperty:CheckIsThief()
    if self._reward and self._reward.id == 2004 then
        return true
    end
    return false
end