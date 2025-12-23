
local TournamentBlackGoldRankItem = BaseView:New("TournamentBlackGoldRankItem")
local this = TournamentBlackGoldRankItem
this.viewType = CanvasSortingOrderManager.LayerType.None

local flyScoreView = nil

this.auto_bind_ui_items ={
    "img_head",
    "text_thValue",
    "text_thSign",
    "text_userName",
    "text_rewards",
    "btn_item",
    "imageFrame",
    "rankNormal",
    "rankTop2",
    "rankTop3",
    "rankTop45",
}

function TournamentBlackGoldRankItem:New(isSettle)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._isSettle = isSettle
    return o
end

function TournamentBlackGoldRankItem:SetParent(parent)
    self.parent = parent
end

function TournamentBlackGoldRankItem:Awake()
    self:on_init()
end

function TournamentBlackGoldRankItem:OnEnable()
    self._init = true
    self:InitSprintBuff()
    self:SetRankData(self._data , self.isBlackTier)
end

function TournamentBlackGoldRankItem:OnDisable()
    self:OnDispose()
    self._init = nil
    self._data = nil
    self._posOffset = nil
    -- fun.set_active(self.flyScore,false)    
    self.flyScore = nil
    self.lightEffect = nil
    self.FadeLightEffect = nil
    self.isBlackTier = false
    
    if flyScoreView then
        fun.set_active(flyScoreView.go,false)
        flyScoreView = nil
    end

    if not fun.is_null(self.sprintBuffBtn) then
        self.luabehaviour:RemoveClick(self.sprintBuffBtn)
        self.sprintBuffBtn = nil
    end
end

function TournamentBlackGoldRankItem:IsMyRank()
    return false
end

function TournamentBlackGoldRankItem:SetLayerIndex(index)
    if self.go then
        self.go.transform:SetSiblingIndex(index)
    end
end

function TournamentBlackGoldRankItem:SetRankData(data,isBlackTier)
    self._data = data or self._data
    self.isBlackTier = isBlackTier or self.isBlackTier
    if self._init and self._data then
        self:ShowRankInfo()
        self:SetOrderSuffix()
        self:CheckSprintBuff()
    end
end

function TournamentBlackGoldRankItem:ShowRankInfo()
    --log.log("黑卡调整 格子数据" ,  self._data.order)
    
    if self.isBlackTier then
        --玩家自己是黑金段位
        if self._data.order == 1 then
            --是第一名 出现这里会有错误 
            fun.set_active(self.rankTop2, false)
            fun.set_active(self.rankTop3, false)
            fun.set_active(self.rankTop45, false)
            fun.set_active(self.rankNormal, true)
    
        elseif self._data.order == 2 then
            --是第二名
            fun.set_active(self.rankTop2, true)
            fun.set_active(self.rankTop3, false)
            fun.set_active(self.rankTop45, false)
            fun.set_active(self.rankNormal, false)
        elseif self._data.order == 3 then
            --是第三名
            fun.set_active(self.rankTop2, false)
            fun.set_active(self.rankTop3, true)
            fun.set_active(self.rankTop45, false)
            fun.set_active(self.rankNormal, false)
        elseif self._data.order >= 4  and self._data.order <= 5 then
            --是第三名
            fun.set_active(self.rankTop2, false)
            fun.set_active(self.rankTop3, false)
            fun.set_active(self.rankTop45, true)
            fun.set_active(self.rankNormal, false)
            local child = fun.find_child(self.rankTop45,"topIcon/Text")
            if child then
                local txt = fun.get_component(child,fun.OLDTEXT)
                if txt then
                    txt.text = self._data.order
                end
            end
        else
            fun.set_active(self.rankTop2, false)
            fun.set_active(self.rankTop3, false)
            fun.set_active(self.rankTop45, false)
            fun.set_active(self.rankNormal, true)
        end
    else
        fun.set_active(self.rankNormal, true)
        fun.set_active(self.rankTop2, false)
        fun.set_active(self.rankTop3, false)
        fun.set_active(self.rankTop45, false)
    end
   

    -- self:SetOrderSuffix()
    if self._data.nickname == nil or self._data.nickname == "" then
        
        local myUid = ModelList.PlayerInfoModel.GetUid()
        if myUid == self._data.uid then
            self.text_userName.text = string.format("User_%s",self._data.uid)
        else
            local robotName = Csv.GetData("robot_name",tonumber(self._data.uid),"name")
            self.text_userName.text = robotName
        end
    else
        self.text_userName.text = self._data.nickname
    end
    self.text_rewards.text = fun.NumInsertComma(self._data.score)
    self:SetHeadIcon()
    self:SetHeadFrame()
    -- Cache.SetImageSprite("HeadIconFrameAtlas",self:GetHeadFrame(),self.imageFrame)
    if self._isSettle then
        local tier,difficulty = ModelList.TournamentModel:GetSettleClimbPreviousTier(rankIndex or 1)
        self:SetRewardItem(tier,difficulty)
    else
        self:SetRewardItem()
    end
end

function TournamentBlackGoldRankItem:GetHeadIcon()
    local icon = Csv.GetData("robot_name",tonumber(self._data.uid),"icon")
    return fun.get_strNoEmpty(icon, "xxl_head016")
end

function TournamentBlackGoldRankItem:SetHeadIcon()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local model = ModelList.PlayerInfoSysModel
    if myUid == tonumber(self._data.uid) then
        model:LoadOwnHeadSprite(self.img_head)
    else
        local useAvatarName = model:GetCheckAvatar(self._data.avatar , self._data.uid)
        model:LoadTargetHeadSpriteByName(useAvatarName ,self.img_head)
    end
end

function TournamentBlackGoldRankItem:SetHeadFrame()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local model = ModelList.PlayerInfoSysModel
    if myUid == tonumber(self._data.uid) then
        model:LoadOwnFrameSprite(self.imageFrame)
    else
        local useFrameName = model:GetCheckFrame(self._data.frame , self._data.uid)
        model:LoadTargetFrameSpriteByName(useFrameName ,self.imageFrame)
    end
end

function TournamentBlackGoldRankItem:LoadLightEffect(callback)
    Cache.load_prefabs(AssetList["TournamentSettleViewTail"],"TournamentSettleViewTail",function(obj)
        if obj then
            self.lightEffect = fun.get_instance(obj,self.go)
            fun.set_rect_anchored_position(self.lightEffect,0,0)
            if callback then
                callback()
            end
        end
    end)
end

function TournamentBlackGoldRankItem:HideLightEffect()
    if self.lightEffect then
        fun.set_active(self.lightEffect.transform,false)
    end
end

function TournamentBlackGoldRankItem:FadeOutLightEffect(isShowLight)
    Cache.load_prefabs(AssetList["TournamentSettleViewShow"],"TournamentSettleViewShow",function(obj)
        if obj then
            if self.lightEffect then
                fun.set_active(self.lightEffect.transform,false)
            end
            if isShowLight then
                self.FadeLightEffect = fun.get_instance(obj,self.go)
                fun.set_rect_anchored_position(self.FadeLightEffect,0,0)
            end
        end
    end)
end

function TournamentBlackGoldRankItem:FlyScore(callback,targetScore)
    if flyScoreView == nil then
        -- flyScoreView = require "View/Tournament/TournamentSettleFlyScoreView"
        local flyScoreViewCode = require "View/Tournament/TournamentSettleFlyScoreView"
        flyScoreView = flyScoreViewCode:New()
        Cache.load_prefabs(AssetList["TournamentSettleViewgo"],"TournamentSettleViewgo",function(obj)
            if obj then
                self.flyScore = fun.get_instance(obj,self.go)
                fun.set_rect_anchored_position(self.flyScore,0,0)
                flyScoreView:SkipLoadShow( self.flyScore,true)
                flyScoreView:PlayFlyScore(function()
                    Anim.do_smooth_int2(self.text_rewards,self._data.score,targetScore,0.5,DG.Tweening.Ease.InFlash,nil,function()
                        if callback then
                            callback()
                        end
                        self._data.score = targetScore
                    end)
                end,math.max(0,targetScore - self._data.score))
            end
        end)
    else
        flyScoreView:PlayFlyScore(function()
            Anim.do_smooth_int2(self.text_rewards,self._data.score,targetScore,0.5,DG.Tweening.Ease.InFlash,nil,function()
                if callback then
                    callback()
                end
                self._data.score = targetScore
            end)
        end,math.max(0,targetScore - self._data.score))
    end
end

function TournamentBlackGoldRankItem:SetOrderSuffix()
    local order = self._data.order % 10
    self.text_thValue.text = tostring(self._data.order)
    if order == 1 then
        self.text_thSign.text = "ST"
    elseif order == 2 then
        self.text_thSign.text = "ND"  
    elseif order == 3 then
        self.text_thSign.text = "RD"  
    else
        self.text_thSign.text = "TH"
    end
  
    if  ( self._data.order- 11 ) % 100 == 0 or   -- 特殊处理，如果11，12，13
        ( self._data.order- 12 ) % 100 == 0 or
        ( self._data.order- 13 ) % 100 == 0  then 

        self.text_thSign.text = "TH"
    end 

end

function TournamentBlackGoldRankItem:SetOrder(order)
    if self._data then
        self._data.order = order
        --log.log("黑金调整 设置排名 SetOrder" , order)
        self:ShowRankInfo()
        self:SetOrderSuffix()
    end
end

function TournamentBlackGoldRankItem:SetOrderDataOnly(order,isBlackTier)
    self.isBlackTier = isBlackTier or self.isBlackTier
    if self._data then
        self._data.order = order
        --log.log("黑金调整 设置排名 SetOrderDataOnly" , order)

        self:ShowRankInfo()
        self:SetOrderSuffix()
    end
end

function TournamentBlackGoldRankItem:GetOrder()
    if self._data then
        return self._data.order
    end
    return 1
end

function TournamentBlackGoldRankItem:SetRewardItem()

end

function TournamentBlackGoldRankItem:SetTopReward()
    
end

function TournamentBlackGoldRankItem:OnDispose()

end

function TournamentBlackGoldRankItem:on_btn_item_click()
    self:RequestPlayerTournamentInfo()
end

function TournamentBlackGoldRankItem:RequestPlayerTournamentInfo()
    if self._data then
        ModelList.TournamentModel.C2S_RequestPlayerTournamentInfo(self._data.uid,self._data.robot)
    end
end

function TournamentBlackGoldRankItem:GetPos()
    if self.go then
        return self.go.transform.localPosition
    end
end

function TournamentBlackGoldRankItem:GetPosY()
    if self.go then
        return self.go.transform.localPosition.y
    end
end

function TournamentBlackGoldRankItem:DoSmoothRankOrderNum(targetOrder,time,ease,updatCallback, finishCallback)
    if self._data then
        Anim.do_smooth_int2(self.text_thValue,self._data.order,targetOrder,time,ease,updatCallback,finishCallback)
    end
end

function TournamentBlackGoldRankItem:ChangeOrder(order1,order2,isBlackTier)
    self.isBlackTier = isBlackTier or self.isBlackTier
    if self._data and   self._data.order < order1 and self._data.order >= order2 then
        self._data.order = self._data.order + 1
        --log.log("黑金调整 设置排名 ChangeOrder" , self._data.order)
        self:ShowRankInfo()
        self:SetOrderSuffix()
    end
end

function TournamentBlackGoldRankItem:CachePosOffset(offset)
    self._posOffset = offset
end

function TournamentBlackGoldRankItem:SetPosByOffset(pos)
    if self._posOffset then
        fun.set_gameobject_pos(self.go,0,pos - self._posOffset,0,true)
    end
end


function TournamentBlackGoldRankItem:TopOneDown(data , isBlackTier)
    self.isBlackTier = isBlackTier or self.isBlackTier
    self._data = data
    self._data.order = 2 --固定从第一名掉到第二名 名次固定
    self:ShowRankInfo()
end

function TournamentBlackGoldRankItem:InitSprintBuff()
    local flag = self.parent and self.parent.TournamentSprintBuffFlag
    if not flag then
        return
    end
    local posParams = self:GetBuffPosParams()
    local target = fun.find_child(self.go, "ZBTmJbtb") or self.go
    --local flagGo = fun.get_instance(flag, target)
    local flagGo = fun.get_instance(flag, self.go)
    local pos = fun.get_gameobject_pos(target, false)
    fun.set_gameobject_pos(flagGo, pos.x, pos.y, 0, false)
    pos = fun.get_gameobject_pos(flagGo, true)
    fun.set_gameobject_pos(flagGo, pos.x + (posParams.buffX or 0), pos.y + (posParams.buffY or 0), 0, true)
    fun.set_active(flagGo, true)
    local ref = fun.get_component(flagGo, fun.REFER)
    local btn = ref:Get("btn")
    self.luabehaviour:AddClick(btn, function()
        self:PlayBtnClickSound()
        self:OnBtnTournamentBuffClick(btn)
    end)
    self.sprintBuffBtn = btn
    self.buffFlag = flagGo
    fun.set_active(self.buffFlag, false)
end

function TournamentBlackGoldRankItem:CheckSprintBuff()
    if fun.is_null(self.buffFlag) then
        return
    end

    if self:HasSprintBuff() then
        fun.set_active(self.buffFlag, true)
    else
        fun.set_active(self.buffFlag, false)
    end
end

function TournamentBlackGoldRankItem:HasSprintBuff()
    --if true then return true end --test
    if not self._data or not self._data.buffs then
        return false
    end

    local sprintBuffIds = ModelList.TournamentModel:GetSprintBuffIds()
    for key, buffId in ipairs(sprintBuffIds) do
        for idx , buff in ipairs(self._data.buffs) do
            if buff.id == buffId then
                return true
            end
        end
    end

    return false
end

function TournamentBlackGoldRankItem:OnBtnTournamentBuffClick(target)
    if self:IsMyRank() then
        local bubble = ViewList.BubbleTipView and ViewList.BubbleTipView.go
        if bubble and bubble.gameObject.activeSelf then
            return
        end
        local posParams = self:GetBuffPosParams()
        local des_text = ModelList.TournamentModel:GetSprintBuffDes()
        local ArrowDirection = ViewList.BubbleTipView.ArrowDirection
        local params = {
            pos = target.transform.position, 
            dir = ArrowDirection.bottom,
            text = des_text,
            offset = Vector3.New(posParams.bubbleX or 0, posParams.bubbleY or 0, 0),
            exclude = {target},
            arrowOffset = posParams.arrowOffset or 0,
        }
        Facade.SendNotification(NotifyName.ShowUI, ViewList.BubbleTipView, nil, false, params)
    end
end

function TournamentBlackGoldRankItem:GetBuffPosParams()
    local params = {}
    if self.parent.viewName == "TournamentBlackGoldView" then
        params.buffX = 20
        params.buffY = 20
        params.bubbleX = 0
        params.bubbleY = 90
        params.arrowOffset = 0
    elseif self.parent.viewName == "TournamentBlackGoldSettleView" then
        params.buffX = 20
        params.buffY = 20
        params.bubbleX = 0
        params.bubbleY = 90
        params.arrowOffset = 0
    end
    return params
end

return this