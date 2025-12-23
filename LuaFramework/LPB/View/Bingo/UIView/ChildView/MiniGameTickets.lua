
MiniGameTickets = BaseView:New()
local this = MiniGameTickets
this.viewType = CanvasSortingOrderManager.LayerType.None

local ticket_num = nil
local ticket_target = nil
local cachePos = nil
local flyHatCount = nil
local flyObjList = nil

this.auto_bind_ui_items = {
    "anima",
    "slider",
    "btn_icon",
    "miniExtra",
    "img_double",
    "text_collect",
    "text_extra",
    "Fill",
    "text_remainTime",
    "Background",
    "text_remainTime_double_reward",
}

require "View/CommonView/RemainTimeCountDown"
local remainTimeCountDown = RemainTimeCountDown:New()
local remainTimeCountDownDoubleReward = RemainTimeCountDown:New()

local hasMoveToCollectTargetPos = false		              --判断到达了收集位置
local collectTargetPos = {x = -146.7, y = -300 , z  = 0}  --火箭触发收集 移动到的位置
local collectBackPos = {x = 400, y = -300 , z  = 0}       --火箭触发收集结束 移动回到的位置


function MiniGameTickets:Awake(obj)
    self:on_init()
end

function MiniGameTickets:OnEnable(params)
    hasMoveToCollectTargetPos = false
    local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    local needLevel = Csv.GetLevelOpenByType(13,0)
    local minigameInfo = ModelList.GameModel:GetBattleMiniGameInfo()
    if nowLevel >= needLevel and minigameInfo then
        local miniGameData = Csv.GetData("minigame",minigameInfo.id)
        if miniGameData and miniGameData.game_type == 1 then
            ticket_num = minigameInfo.progress
            ticket_target = minigameInfo.target 
            cachePos = Vector3.New(-146.7,-300,0)
            local doublehat = ModelList.ItemModel:get_doublehat()
            fun.set_active(self.img_double.transform,doublehat > 0)   
            self:SetTicketsProgress()
            self:CheckShowExtra()
            --Event.AddListener(EventName.cardBingoEffect_flyMiniGame,self.OnFlyMiniGame,self)

            self:OnMiniGameUpdateInfo()
           
            
        end
    end
    if not ticket_num or not ticket_target then
        fun.set_active(self.transform,false)
    end
end

function MiniGameTickets:OnDisable()
    remainTimeCountDown:StopCountDown()
    remainTimeCountDownDoubleReward:StopCountDown()
    ticket_num = nil
    ticket_target = nil
    cachePos = nil
    flyHatCount = nil
    flyObjList = nil
    self.addHatStep = nil
    --Event.RemoveListener(EventName.cardBingoEffect_flyMiniGame,self.OnFlyMiniGame,self)
end

function MiniGameTickets:OnFlyMiniGame(flyObj)
    if flyObj then
        local IsRocket = ModelList.BattleModel:IsRocket()
        if IsRocket then
            ---积累的第一次mini飞行帽子没有清理，导致第二次的帽子不会飞行
            if flyObjList then
                for i = #flyObjList,  1,-1 do
                    if not fun.get_active_self(flyObjList[i]) then
                        table.remove(flyObjList,i)
                    end
                end
            end
            
            if hasMoveToCollectTargetPos then
                --已经移动了目标位置 直接飞
                self:DoFlayObj(flyObj)
            else
                --不在收集位置 添加table
                if not flyObjList  or #flyObjList == 0 then
                    flyObjList = {}
                end
                table.insert(flyObjList,flyObj) 
                cachePos = self.transform.localPosition
                Anim.move(self.go,collectTargetPos.x,collectTargetPos.y,collectTargetPos.z,0.25,true,DG.Tweening.Ease.InOutSine,function()
                    hasMoveToCollectTargetPos = true
                    for index, value in ipairs(flyObjList) do
                        self:DoFlayObj(value)
                    end
                end)
            end
        else
            self:DoFlayObj(flyObj)
        end
    end
end

function MiniGameTickets:DoFlayObj(fly_obj)
    local parent = ModelList.BattleModel:GetCurrBattleView().effectObjContainer.FlyGiftContainer
    fun.set_parent(fly_obj,parent,false)
    local toPos = self.transform.position
    Anim.scale_to_xy(fly_obj,2,2,1)
    local path = {}
    path[1] = fun.calc_new_position_between(fly_obj.transform.position, toPos, 0.45, 1, 0)
    path[2] = toPos
    local moveBack = function()
        if 0 == flyHatCount then
            LuaTimer:SetDelayFunction(1, function()
                hasMoveToCollectTargetPos = false-- 又飞到了右侧
                Anim.move(self.go,collectBackPos.x,collectBackPos.y,collectBackPos.z,0.35,true,DG.Tweening.Ease.InOutSine)
            end,nil,LuaTimer.TimerType.Battle)
        end
    end
    flyHatCount = (flyHatCount or 0) + 1
    Anim.bezier_move(fly_obj, path, 1, 0, 1, 2, function()
        fun.set_active(fly_obj.transform,false)
        Destroy(fly_obj)
        ticket_num = ticket_num + self.addHatStep
        self:SetTicketsProgress()
        self:CheckShowExtra()
        flyHatCount = math.max(0,flyHatCount - 1)
        if ModelList.BattleModel:IsRocket() then
            --火箭收集 才回退位置
            moveBack()
        end
    end)

end

function MiniGameTickets:SetTicketsProgress()
    if ticket_num and ticket_target then
        self.slider.value = math.min(1,ticket_num / ticket_target)
        self.text_collect.text = string.format("%s%s",math.floor(math.min(1,ticket_num / ticket_target) * 100),"%")
        if ticket_num >= ticket_target then
            self.anima:SetInteger("minigame",1)
            self.anima:Play("show",0,0)
        else
            self.anima:SetInteger("minigame",0)
            self.anima:Play("show",0,0)    
        end
    end
end

function MiniGameTickets:GetIconPos()
    if self.transform then
        return self.transform.position
    end
    return Vector3.New(0,0,0)
end


function MiniGameTickets:CheckShowExtra()
    if ticket_num and ticket_target then
        local percent = ticket_num / ticket_target
        if percent > 1 then
            self.text_extra.text = string.format("EXTRA\n%s%s", math.floor((percent - 1) * 100  + 0.4), "%")
            fun.set_active(self.miniExtra,true)
            LuaTimer:SetDelayFunction(2, function()
                fun.set_active(self.miniExtra,false)
            end,nil,LuaTimer.TimerType.Battle)
        end
    end
end

function MiniGameTickets:OnMiniGameUpdateInfo()
    local doublehat = ModelList.ItemModel:get_doublehat()
    local doubleReward = ModelList.ItemModel.get_doublehatReward()
    if doubleReward > 0 and doublehat > 0 then
        --双倍帽子和双倍奖励 都有
        self.addHatStep = 2

        fun.set_active(self.img_double.transform,true)
        remainTimeCountDown:StartCountDown(CountDownType.cdt2,doublehat,self.text_remainTime,function()
            self:OnMiniGameUpdateInfo()
        end)

        remainTimeCountDownDoubleReward:StartCountDown(CountDownType.cdt2,doubleReward,self.text_remainTime_double_reward,function()
            self:OnMiniGameUpdateInfo()
        end)

        self:ShowHatImage("MiniZDhat4")
        self:ShowHatBg("MiniZDhat5")
    elseif doubleReward > 0 and doublehat <= 0 then
        --只有双倍奖励
        self.addHatStep = 1

        self:ShowHatImage("MiniZDhat4")
        self:ShowHatBg("MiniZDhat5")
        fun.set_active(self.img_double.transform,false)
        remainTimeCountDownDoubleReward:StartCountDown(CountDownType.cdt2,doubleReward,self.text_remainTime_double_reward,function()
            self:OnMiniGameUpdateInfo()
        end)
    elseif doubleReward <= 0 and doublehat > 0  then
        --只有双倍帽子
        self.addHatStep = 2

        self:ShowHatImage("MiniZDhat2")
        self:ShowHatBg("MiniZDhat3")
        fun.set_active(self.img_double.transform,true)
        remainTimeCountDown:StartCountDown(CountDownType.cdt2,doublehat,self.text_remainTime,function()
            self:OnMiniGameUpdateInfo()
        end)
    else
        --没有任何buff
        self.addHatStep = 1

        self:ShowHatImage("MiniZDhat2")
        self:ShowHatBg("MiniZDhat3")
        fun.set_active(self.img_double.transform,false)
    end
end


function MiniGameTickets:ShowHatImage(stringHatName)
    Cache.GetSpriteByName("CommonAtlas",stringHatName,function(sprite)
        if self.Fill and not fun.is_null(self.Fill) then
            self.Fill.sprite = sprite
        end
    end)
end

function MiniGameTickets:ShowHatBg(stringHatName)
    Cache.GetSpriteByName("CommonAtlas",stringHatName,function(sprite)
        if self.Background and not fun.is_null(self.Background) then
            self.Background.sprite = sprite
        end
    end)
end

return this