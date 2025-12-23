--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-03-21 15:26:26
]]
require "View/CommonView/RemainTimeCountDown"
require("View/Bingo/FsmCreator")
local StateMainViewFaild = require("View.VolcanoMission.State.StateMainViewFaild")
local StateMainViewInit = require("View.VolcanoMission.State.StateMainViewInit")
local StateMainViewPlayerLevelUp = require("View.VolcanoMission.State.StateMainViewPlayerLevelUp")
local StateMainViewReward = require("View.VolcanoMission.State.StateMainViewReward")
local StateMainViewUpdateCollect = require("View.VolcanoMission.State.StateMainViewUpdateCollect")
local StateMainViewUpdateRound = require("View.VolcanoMission.State.StateMainViewUpdateRound")
local StateMainViewIdle = require("View.VolcanoMission.State.StateMainViewIdle")
local StateMainViewRevive = require("View.VolcanoMission.State.StateMainViewRevive")
local StateMainViewOpenBox = require("View.VolcanoMission.State.StateMainViewOpenBox")


local VolcanoMissionMainView = BaseView:New('VolcanoMissionMainView',"VolcanoMissionMainViewAtlasInMain");

local this = VolcanoMissionMainView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
function VolcanoMissionMainView:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end

local stepHideTime = 3 

this.auto_bind_ui_items = {
    "btn_close",
    "left_time_txt",
    "Content",
    "img_store0",
    "img_store1",
    "img_store2",
    "img_store3",
    "btn_help",
    "txt_levels",
    "txt_playersinfo",
    "img_mapprogress",
    "btn_hidemap",
    "playIcon",
    "ItemStepObj",
    "rPos",
    "lPos",
    "img_store_top",
    "txt_icon_left_time",
    "topbg",
    "img_collecgprogress",
    "itemImg",
    "changebarparent",
    "Viewport",
    "scrollrect",
    "btn_giftpack",
    "txt_mapinfo",
    "idleState",
    "txt_faild",
    "txt_collectmapinfo",
    "Rewardbuffer",
    "Itembuffer",
    "baoshan",
    "txt_collectinfo",
    "map1",
    "map2",
    "baoeffect",
    "zuanshi",
    "gift_reddot",
    "map_bg_root",
    "txt_collectroundinfo",
    "btn_continue",
    "baoeffect2",
}

local itemoffsetH = -50
local topoffSet = 250   --顶部偏移
local topHeight = 625
local bottomHeight= 306
local bottomOffset = 70

local _listStepObjs = {} -- 生成的台阶
local _endStepView =  nil  --终点台阶

--local _roundObjs = {}  --  生成的体力值 为

local _model = nil 
local remainTimeCountDown= nil 

local isMove = false 

local sTopBgPos = nil

local owernHeader= nil
local npcObjs = nil


local BufferNameMapping = {
    Rewardbuffer = "GetMoreRewardBuffTime",
    Itembuffer = "GetDoubleItemBuffTime",
}

local shakeBox = {}  --- 遇到的抖动宝箱


----------------------------local funcion -----------------------------------------------------
----------------------------------------  
--[[
    @desc: 设置图片亮黑状态，用在回合图片
    author:{author}
    time:2024-04-10 18:36:13
    --@img:
	--@isBlack: 
    @return:
]]
local function SetImageBlack(img,isBlack)
    if(isBlack)then 
        fun.set_img_color(img, Color(0, 0, 0, 1)) 
        img.name = "0"
    else
         fun.set_img_color(img, Color(255, 255, 255, 1))  
         img.name = "1"
    end 
    
end

--[[
    @desc: 清除所有台阶显示对象VolcanoMissionMainStepItemView
    author:{author}
    time:2024-04-10 18:37:16
    @return:
]]
local function CleanStepObjs()
    if(_listStepObjs)then 
        for k,v in pairs(_listStepObjs) do
            if(k~=0)then   --第一个石块台阶不能销毁
                v:Close()
            end
            
        end
        _listStepObjs = nil 
    end
end

--[[
    @desc: npc清除
    author:{author}
    time:2024-04-10 18:37:44
    @return:
]]
local function CleanNpc()
    if(npcObjs)then 
        for k,v in pairs(npcObjs) do
            Destroy(v)
        end
        npcObjs = nil 
    end
end


local function ConvertLocalPosToWorldPos(target)
    -- Calculate pivot offset
    local pivotOffsetX = (0.5 - target.pivot.x) * target.rect.size.x
    local pivotOffsetY = (0.5 - target.pivot.y) * target.rect.size.y
    local pivotOffset = Vector3.New(pivotOffsetX, pivotOffsetY, 0)
  
    -- Combine local position and pivot offset
    local localPosition = target.localPosition + pivotOffset
  
    -- Transform local position to world space using parent
    return target.parent:TransformPoint(localPosition)
end

local function vector3_array(n)
    local arr = {}
    for i = 1, n do
      arr[i] = Vector3.New()
    end
    return arr
  end

local function vector2_min(v1, v2)
    return Vector2.New(math.min(v1.x, v2.x), math.min(v1.y, v2.y))
  end
  
  -- Find the maximum values between two vectors
  local function vector2_max(v1, v2)
    return Vector2.New(math.max(v1.x, v2.x), math.max(v1.y, v2.y))
end

local function RectTransToScreenPos(rt, cam)
    -- Get all four corners of the RectTransform in world space
    -- local corners = Vector3.array(4)
    local corners = rt:GetWorldCorners()
    
    -- Convert corner points from world space to screen space using the camera
    local v0 = UnityEngine.RectTransformUtility.WorldToScreenPoint(cam, corners:GetValue(1))
    local v1 = UnityEngine.RectTransformUtility.WorldToScreenPoint(cam,  corners:GetValue(3))
  
    -- Calculate bottom-left corner and size based on transformed points
    local bottomLeft = vector2_min(v0, v1)
    local size = vector2_max(v0, v1) - bottomLeft
  
    -- Construct and return the Rect
    return UnityEngine.Rect.New(bottomLeft.x, bottomLeft.y, size.x, size.y)
end
  

    -- 获取两个 Rect 的相交面积
    local function GetIntersectionArea(rect1, rect2)
        -- 计算相交的最小和最大点
        local minX = math.max(rect1.xMin, rect2.xMin)
        local minY = math.max(rect1.yMin, rect2.yMin)
        local maxX = math.min(rect1.xMax, rect2.xMax)
        local maxY = math.min(rect1.yMax, rect2.yMax)
      
        -- 计算相交的宽度和高度
        local width = maxX - minX
        local height = maxY - minY
      
        -- 返回相交面积
        return width * height
      end
    

-- 获取两个 Rect 的相交比例
local function GetIntersectionRatio(rect1, rect2)
    -- 计算相交面积
    local intersectionArea = GetIntersectionArea(rect1, rect2)
  
    -- 计算两个 Rect 的面积
    local rect1Area = rect1.width * rect1.height
    local rect2Area = rect2.width * rect2.height
  
    -- 返回相交面积与两个 Rect 总面积的比值
    -- return intersectionArea / (rect1Area + rect2Area - intersectionArea)
    return intersectionArea/rect2Area
  end
  
----------------------------------------

--[[
    @desc: 
    author:{author}
    time:2024-04-07 12:25:44
    --@source:
	--@target:
	--@count:废弃不用了，
	--@isUpdate: 
    @return:
]]
function VolcanoMissionMainView:UpdateNewProgress(source,target,count,isUpdate) 

    local delayT = 0.5
    
    local delayT = (0.05 / count)*0.5
    local delayT2 = (0.02 / count)*0.5

    self:run_coroutine(function()
        if not self.isFlyCollect then
            fun.set_active(self.zuanshi,true)
            local collectType = _model:GetBattleCollectItemType()
            fun.play_animator(self.zuanshi,"start"..collectType,true)
            self.isFlyCollect = true
            UISound.play("missionpropshow")
            coroutine.wait(1)
        end

        UISound.play_loop("missionincrease")
        if(isUpdate)then   --升级的话，先满，再升到目标
            local model = ModelList.VolcanoMissionModel 
            local uploadCount =   model:GetLevelUpTarget()
            --local cursetp = model:GetCurStepId()
            --local cursetp = model:GetLevelUpdateCurrStep()
            local cursetp = self:GetCurrStep()
            local idx = 0
            -- fun.set_active(self.zuanshi,false)
            local tempCount = count 
            while(uploadCount>cursetp)do
                uploadCount = uploadCount-1
                idx = idx+1
                tempCount = model:GetStepNeedResourcesById(cursetp+idx)
                for i = source, tempCount do
                    coroutine.wait(delayT2)
                    self.img_collecgprogress.fillAmount = i/tempCount 
                    this.txt_collectinfo.text = string.format("%s/%s", i, tempCount)  
                end
                UISound.stop_loop("missionincrease")
                coroutine.wait(delayT)    
                fun.set_active(self.zuanshi,true)
                fun.play_animator(self.zuanshi,"full",true) 
                self.img_collecgprogress.fillAmount = 0
                local newStep = cursetp+idx

                if(_listStepObjs[newStep])then 
                    _listStepObjs[newStep]:SetPassLevel(true)   --播放节点动画 
                    _listStepObjs[newStep]:SetPassEffect(true) 
                end
                if uploadCount > cursetp then
                    coroutine.wait(0.8)
                end
            end

            if model:IsLastRoundStep() then
                if model:IsFinalStep() then
                    self.img_collecgprogress.fillAmount = 0
                    this.txt_collectinfo.text = string.format("%s/%s", 0, tempCount)
                else
                    for i = 0, target do
                        coroutine.wait(delayT2)
                        self.img_collecgprogress.fillAmount = i/tempCount
                        this.txt_collectinfo.text = string.format("%s/%s", i, tempCount)
                    end
                end
                self:SetFullRound()
            end
            self._fsm:GetCurState():Complete()
            
        else  

            for i = source, target do
                coroutine.wait(delayT2)
                self.img_collecgprogress.fillAmount = i/count 
                this.txt_collectinfo.text = string.format("%s/%s", i, count)  
            end
            UISound.stop_loop("missionincrease")
            self._fsm:GetCurState():Complete()
        end  
    end)
  
end


function VolcanoMissionMainView:UpdateNewRound(source,target)  
    local model = ModelList.VolcanoMissionModel  
    local isUp = model:IsLevelUp() 
    local delayT = 1
    self:run_coroutine(function()

        for i=source,target do
            local roundItem = self:SetRound(i,nil,true)
            UISound.play("missionroundfinish")
            self:AddEffect(roundItem)
            coroutine.wait(delayT)
        end
        --if source + 1<= target then
        --    local roundItem = self:SetRound(source)
        --
        --    self:AddEffect(roundItem)
        --    coroutine.wait(delayT)
        --end




        self._fsm:GetCurState():Complete()
    
    end) 

end


function VolcanoMissionMainView:AddEffect(parent)
    local effect = fun.get_instance(self.baoeffect)
    fun.set_parent(effect,parent,true)
    fun.set_active(effect,true) 
    self:register_invoke(function()
        Destroy(effect)
    end,1)
end

function VolcanoMissionMainView:Awake(obj, obj2)
    this:on_init()
end


--[[
    @desc: 刷新buffer
    author:{author}
    time:2024-04-10 18:39:22
    --@name: 
    @return:
]]
function VolcanoMissionMainView:StartBufferByName(name)
    
    if(self[name] == nil)then 
        return 
    end

    if(self.bufferList==nil)then 
        self.bufferList = {}
    end

    local buffer =  self.bufferList[name]

    if(buffer==nil)then 
        buffer = {}
        buffer.obj = self[name]
        local ref = fun.get_component(buffer.obj,fun.REFER)
        buffer.txt_buffer_time = ref:Get("txt_buffer_time")
        buffer.countDown = RemainTimeCountDown:New()
        self.bufferList[name] = buffer
    end
 

    buffer.countDown:StopCountDown()

    local remainTime = ModelList.VolcanoMissionModel[BufferNameMapping[name]]()
    if remainTime <= 0 then
        fun.set_active(buffer.obj , false)
    else
        fun.set_active(buffer.obj , true)
        remainTime = remainTime + 2
        buffer.countDown:StartCountDown(CountDownType.cdt3, remainTime,  buffer.txt_buffer_time, function()
            if self then
                self:StartBufferByName(name)
            end
        end)
    end
end


--[[
    @desc: 接收buffer通知
    author:{author}
    time:2024-04-10 18:39:40
    @return:
]]
function VolcanoMissionMainView:OnVolcanoMissionItemBuffChange()
    self:StartBufferByName("Itembuffer")

end


--[[
    @desc: 接收buffer通知
    author:{author}
    time:2024-04-10 18:39:40
    @return:
]]
--宝箱buffer
function VolcanoMissionMainView:OnVolcanoMissionRewardBuffChange()
    self:StartBufferByName("Rewardbuffer")

    self._fsm:GetCurState():OnTrigetBuffer() 
    local hasBuffer = ModelList.VolcanoMissionModel:HasBoxBuffer()
    
    self:SetHeadBuffer(owernHeader,hasBuffer)
end


--[[
    @desc: 废弃
    author:{author}
    time:2024-04-10 18:39:57
    @return:
]]
function VolcanoMissionMainView:OnBuyBuffer()
    -- self._fsm:GetCurState():OnBuyBuffer() 
end






function VolcanoMissionMainView:OnEnable()
    self.isFlyCollect = false
    UISound.play_temporary_bgm("missionbgm")
    Event.AddListener(EventName.Event_VolcanoMission_Item_Buff, self.OnVolcanoMissionItemBuffChange, self)
    Event.AddListener(EventName.Event_VolcanoMission_Reward_Buff, self.OnVolcanoMissionRewardBuffChange, self)

    
    Event.AddListener(EventName.Event_Buy_VolcanoMission_Buff, self.OnBuyBuffer, self)

    Facade.RegisterViewEnhance(self)
    remainTimeCountDown = RemainTimeCountDown:New()
    _model =  ModelList.VolcanoMissionModel
    isMove = false
    shakeBox = {}
    self:BuildFsm()
    
    self:StartBufferByName("Itembuffer") 
    self:StartBufferByName("Rewardbuffer")
    if not ModelList.GuideModel:IsGuideComplete(66) then
        ModelList.GuideModel:TriggerFireVolcanoEngerGuide(530)
    end
    
    fun.set_active(self.gift_reddot, ModelList.GiftPackModel:CheckVolcanoMissionHaveFreePack())

    self.openTime = os.time()
    self.rewardStateComplete = nil
end



function VolcanoMissionMainView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("VolcanoMissionMainView",self,{
        StateMainViewFaild:create(),
        StateMainViewInit:create(),
        StateMainViewPlayerLevelUp:create(),
        StateMainViewReward:create(),
        StateMainViewUpdateCollect:create(),
        StateMainViewUpdateRound:create(),
        StateMainViewIdle:create(),
        StateMainViewRevive:create(),
        StateMainViewOpenBox:create(),
    })
    this.state = {
        StateMainViewOpenBox = "StateMainViewOpenBox",
        StateMainViewRevive = "StateMainViewRevive",
        StateMainViewIdle = "StateMainViewIdle",
        StateMainViewFaild = "StateMainViewFaild",
        StateMainViewInit = "StateMainViewInit",
        StateMainViewPlayerLevelUp = "StateMainViewPlayerLevelUp",
        StateMainViewReward = "StateMainViewReward",
        StateMainViewUpdateRound = "StateMainViewUpdateRound",
        StateMainViewUpdateCollect = "StateMainViewUpdateCollect",
    }
    self._fsm:StartFsm(this.state.StateMainViewInit,self)
end

function VolcanoMissionMainView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
 
end

function VolcanoMissionMainView:OnDisable()
    UISound:resume_last_bgm()
    self:DisposeFsm()    
    remainTimeCountDown:StopCountDown()
    remainTimeCountDown = nil   
    if(self.bufferList)then 
        for k,v in pairs(self.bufferList) do
            v.countDown:StopCountDown()
        end
    end 
    self.bufferList = nil 
    Event.RemoveListener(EventName.Event_VolcanoMission_Item_Buff, self.OnVolcanoMissionItemBuffChange, self)
    Event.RemoveListener(EventName.Event_VolcanoMission_Reward_Buff, self.OnVolcanoMissionRewardBuffChange, self) 
    Event.RemoveListener(EventName.Event_Buy_VolcanoMission_Buff, self.OnBuyBuffer, self)

    Facade.RemoveViewEnhance(self) 
    self:CleanChildView() 
    Event.Brocast(EventName.Event_VolcanoMission_PopuEnd)
    owernHeader = nil
    self.isFlyCollect = false
    shakeBox={}
    self.openTime = nil
    UISound.stop_loop("missionincrease")
end


function VolcanoMissionMainView:SetScrollTouch(isTouch)
    local scrollrect = fun.get_component(self.scrollrect,fun.SCROLL_RECT)
    if(isTouch)then 
        scrollrect:StopMovement()
        scrollrect.vertical = isTouch;
    else
        scrollrect.vertical = isTouch;
    end  
end


function VolcanoMissionMainView:StopBoxShade()
    if shakeBox then
        for i = 1, #shakeBox do
            shakeBox[i]:StopBoxShake()
        end
    end
end

--[[
    @desc: 跳下一个节点
    author:{author}
    time:2024-03-27 12:02:25
    --@step: 
    @return:
]]
function VolcanoMissionMainView:JumpNextStep(step) 
  
    self:run_coroutine(function() 
        self:SetScrollTouch(false)
        local jumpCout = step --假定最大跳的次数  
        local idx = 0
        while(jumpCout>0)do 
            jumpCout = jumpCout-1
            idx = idx+1
            local curStep = tonumber(owernHeader.name)
            local isFinalStep = false 
            if(curStep+1==step)then
                isFinalStep = true 
            end
            local nextStep = curStep+1
            local target = _listStepObjs[nextStep] 
            if(target==nil)then 
                break
            end
            local playTargetPos =  fun.get_gameobject_pos(target.role,false)
            if(isFinalStep)then 
                self:JumpWithNpc(target,-1,2)
                owernHeader.name = tostring(curStep+1)
                self:UpdateLevelInfo(nextStep)
                local moveTime = 0.5
                self:MoveToStepPos(nextStep,true,moveTime,nil)  --移动地图
                coroutine.wait(moveTime)
                break
            else
                self:JumpWithNpc(target,-1,0)   --跳npc
                local moveTime = 0.5 
                -- if(nextStep>2)then 
                    
                -- end 
                self:MoveToStepPos(nextStep,true,moveTime,nil)  --移动地图
                coroutine.wait(moveTime)
            end  
            self:UpdateLevelInfo(nextStep)
            owernHeader.name = tostring(curStep+1)
        end 
        --self:SetFullRound()
        self:SetScrollTouch(true)     --恢复地图滚动
 
        self._fsm:GetCurState():Complete()
    end)
    
end


function VolcanoMissionMainView:UpdateLevelInfo( newstep) 
    --local step,stepCount = _model:GetCurStepId()
    local step,stepCount =  self:GetCurrStep() --_model:GetCurStepId()
    this.txt_levels.text = string.format("%s/%s", newstep, stepCount)
    UISound.play("missionnumbercomplete")
    self:AddEffect(this.txt_levels)
end



-- txt_playersinfo
 

function VolcanoMissionMainView:PlayDieInfoData( )
    -- self:run_coroutine(function() 
        fun.set_active(self.baoshan,false)
        local model = ModelList.VolcanoMissionModel
        local scaleT = 0.2
        local scale = 1.2
        Anim.scale_to_xy(self.txt_playersinfo.gameObject,scale,scale,scaleT)   --文字放大
    --UISound.play("missionnumbercomplete")
        coroutine.wait(scaleT)


        --local _dieCount,_count = model:GetPlayerInfo()
        --local newCount,newDie = model:GetNewMapDataPlayInfo()
        local _aliveCount,_count,newDie = model:GetAlivePersonCount(self:GetCurrStep()+1)
        --local _dieCount = model:GetAlivePersonCount(self:GetCurrStep())

        -- local _dieCount,_count =20,99
        -- local newDie,newCount =44,99
        
        local scrollT = 2
        -- Anim.do_smooth_int(_dieCount,newDie,scrollT,function(x) 
        --     this.txt_playersinfo.text = string.format("%s/%s", math.max(_count-x,0), _count) 
        -- end)
        UISound.play_loop("missionnumberchange")
        for i = newDie, 0,-1 do
            coroutine.wait(0.4 / _count)
            this.txt_playersinfo.text = string.format("%s/%s", math.max(_aliveCount+ i,0), _count)
        end
        UISound.stop_loop("missionnumberchange")
        -- coroutine.wait(scrollT)

        Anim.scale_to_xy(self.txt_playersinfo.gameObject,1,1,scaleT,function()
        
            fun.set_active(self.baoshan,true)
            fun.set_active(self.baoshan,false,1)
        end)
    UISound.play("missionnumbercomplete")
        coroutine.wait(scaleT)

    -- end)
end


--[[
    @desc: 获取存活npc，在结算时奖励时使用
    author:{author}
    time:2024-04-10 18:40:42
    @return:
]]
function VolcanoMissionMainView:GetLivingNpcId() 
    local ret = {}
    if(npcObjs)then 
        for k,v in pairs(npcObjs) do
            if(fun.is_not_null(v))then 
                local id = tonumber(v.name)
                table.insert(ret,id)
            end 
        end
    end
    return ret 
end


function VolcanoMissionMainView:GetNpcRect( npc) 
    local  npcParent = npc.gameObject.transform.parent

    local rect = fun.get_component(npcParent.gameObject,fun.RECT)

    -- local rect = ref:Get("npcrect")

    return rect
end


--[[
    @desc: 带npc跳转到目标节点，
    author:{author}
    time:2024-04-10 18:41:05
    --@target:
	--@npcCout:
	--@faildCount: 
    @return:
]]
function VolcanoMissionMainView:JumpWithNpc(target,npcCout,faildCount) 

        -- fun.SetAsFirstSibling(owernHeader)
        -- fun.set_parent(sourceObj.gameObject,self.Content)

        if(npcCout ==-1)then 
            npcCout = GetTableLength(npcObjs)
        end
        
        if(faildCount>0)then 
            npcCout = math.abs(npcCout-faildCount)
        end

        local moveT = 0.5 
       --移动主角 
       local ui_cout = fun.get_child_count(self.Content)
        local ownerStartPos = fun.get_gameobject_pos(owernHeader,false)
       UISound.play("missionplayerjump")
       self:MoveToTarger(owernHeader,target.role,moveT,false,0,false,target.go)
       coroutine.wait(moveT)
        target:PlayBoxShake()
        table.insert(shakeBox,target)
       UISound.play("missionrobotjump")
       --移动队友
       local delay=0.05
       for i=1,npcCout do
          local npc = npcObjs[i]
          if(fun.is_not_null(npc))then 
                local npcTarger = target.npcrect 
                self:MoveToTarger(npc,npcTarger,moveT/2+delay,false,0.5,false,target.go)
                delay = math.min(delay+0.1,0.5)
          end 
       end

       coroutine.wait(moveT/2+moveT)

       --清除原来的npc，防止多跳不跟随
       self:CleanChild(target.npcrect)
       for i=npcCout,1,-1 do
            local npc = npcObjs[i]
            local npcTarger = target.npcrect  
            fun.set_parent(npc,npcTarger)
        end
        fun.set_parent(owernHeader,target.role)
        --处理失败npc

       local faildCount = math.min(3,faildCount)
       local emptyObj = self:GetEmptyPos(target,faildCount,ownerStartPos)
       local emptyCout = GetTableLength(emptyObj)
       local destoryNpc = {}
       while(faildCount>0 and emptyCout>0)do 
            local npcCount  =GetTableLength(npcObjs)  
            if(npcCount-faildCount>=0)then 
                local npc =  npcObjs[npcCount]
                local emptyPos1 = emptyObj[emptyCout]
                if(npc and emptyPos1)then 
                    self:MoveToTarger(npc,emptyPos1,moveT,false,-0.2,true,target.go)
                    emptyObj[emptyCout] = nil 
                    npcObjs[npcCount] = nil
                    emptyCout = GetTableLength(emptyObj) 
                    table.insert(destoryNpc,npc)
                end
                faildCount = faildCount-1  
            else
                break
            end  
       end
       coroutine.wait(moveT+0.2)

       local destoryNpcCount = GetTableLength(destoryNpc)
       if(destoryNpcCount>0)then 
            UISound.play("missionburn")
            for key, value in pairs(destoryNpc) do
                self:PlayFailedAnimation(value)
            end
            self:PlayDieInfoData()  --播放顶部数字动画
            coroutine.wait(2.5)    
            for key, value in pairs(destoryNpc) do
                Destroy(value)
            end
           --- 刷新Players数据
           --local diecount,count = _model:GetPlayerInfo()
           --this.txt_playersinfo.text = string.format("%s/%s", math.max(count-diecount,0), count)

       else
            coroutine.wait(moveT/2)

       end
        
end



--[[
    @desc: 播放玩家播放，在状态机调用
    author:{author}
    time:2024-04-10 18:41:42
    @return:
]]
function VolcanoMissionMainView:PlayOwnerRevival() 
    fun.set_active(owernHeader,false)
    self:run_coroutine(function()
        coroutine.wait(0.2)
        fun.set_active(owernHeader,true)
        fun.play_animator(owernHeader,"fuhuo")
    end)
     
end


--[[
    @desc: 废弃
    author:{author}
    time:2024-04-10 18:41:58
    @return:
]]
function VolcanoMissionMainView:PlayCurStepHide() 
    local curStep = tonumber(owernHeader.name)
       
       if(curStep>0)then 
            local curStepView = _listStepObjs[curStep] 
            curStepView:PlayHide()   --播放地图块消失 
       end
end



--[[
    @desc: 跳失败处理，状态机调用
    author:{author}
    time:2024-04-10 18:42:07
    --@step: 
    @return:
]]
function VolcanoMissionMainView:JumpFaild()
    local step = self:GetCurrStep()+1
    local target = _listStepObjs[step]
    local ownerStartPos = fun.get_gameobject_pos(owernHeader,false)
    local emptyObj = self:GetEmptyPos(target,3,ownerStartPos)
    local moveT = 0.5
    local emptyCount=  GetTableLength(emptyObj)
    local playTargetPos =  fun.get_gameobject_pos(target.role,false)
    self:run_coroutine(function() 

        -- coroutine.wait(moveT)
        --移动队友
        local delay=0.05
       
        local npcCount = math.max(0,GetTableLength(npcObjs)-emptyCount+1)
        local jumpNpcList= {}
        for i=1,npcCount do
           local npc = npcObjs[i]
           local npcTarger = target.npcrect
           if(npcTarger)then 
            self:MoveToTarger(npc,npcTarger,moveT/2+delay,false,0,false,target.go)
            delay = delay+0.1
               table.insert(jumpNpcList,i)
           end 
        end
        coroutine.wait(moveT/2+moveT)
        --移动失败
        --移动主角 

        self:MoveToTarger(owernHeader,emptyObj[1],moveT,false,0,true,target.go)

        local allNpcs = GetTableLength(npcObjs)

        local destoryNpc = {}
        for i=1,2 do
            local npcIndex = allNpcs-i+1
            local npcObj =  npcObjs[npcIndex]
            local emptyPos1 = emptyObj[i+1]
            if(npcObj and emptyPos1) and not fun.is_include(npcIndex,jumpNpcList) then
                table.insert(destoryNpc,npcObj)
                self:MoveToTarger(npcObj,emptyPos1,moveT,false,0,true,target.go)
            end
        end
        jumpNpcList = nil
        coroutine.wait(moveT+0.2)
        UISound.play("missionburn")
        for k,v in pairs(destoryNpc) do
            self:PlayFailedAnimation(v)
        end
        self:PlayFailedAnimation(owernHeader)
        --fun.play_animator(owernHeader,"end")   --播放消失
        -- self:PlayCurStepHide() 
        -- fun.GetAnimatorTime(animator, animation_name)

        self:PlayDieInfoData()
        -- coroutine.wait(stepHideTime)

        for k,v in pairs(destoryNpc) do
            Destroy(v)
        end 
        fun.set_active(owernHeader,false)  
        coroutine.wait(1)
        self._fsm:GetCurState():Complete()

    end)
end


--[[
    @desc: 状态机调用 ，成功调用
    author:{author}
    time:2024-04-10 18:42:26
    @return:
]]
function VolcanoMissionMainView:SetSuccessInfo() 
    self:SetTopVisiable(true)
    fun.set_active(self.idleState,false)
    fun.set_active(self.txt_faild,true)
    self.txt_faild.text =Csv.GetData("description", 8065, "description")
    self.rewardStateComplete = true
end


--[[
    @desc: 刷新顶部信息
    author:{author}
    time:2024-04-10 18:42:42
    @return:
]]
function VolcanoMissionMainView:ShowTopInfo()
    -- self:SetTopVisiable(true)
    local value = self.img_mapprogress.fillAmount 
    local curMapid,mapCount = _model:GetLevelInfo()

    if(curMapid<=3)then    
    else 
        curMapid = curMapid - 3 
    end 
    local source = (curMapid-1)/3
 
    self.img_mapprogress.fillAmount = source
    if(self:IsTopHide())then 
        self:on_btn_hidemap_click(function()  
            Anim.do_smooth_float_update(source,curMapid/3,0.5,function(x)
                self.img_mapprogress.fillAmount = x
            end,nil)
        end)
    end

end


--[[
    @desc: 设置失败信息
    author:{author}
    time:2024-04-10 18:42:56
    @return:
]]
function VolcanoMissionMainView:SetFaildInfo()      
    self:SetTopVisiable(true)
    fun.set_active(self.idleState,false)
    fun.set_active(self.txt_faild,true)
    self.txt_faild.text =Csv.GetData("description", 8066, "description")
end





function VolcanoMissionMainView:on_btn_giftpack_click() 
    -- Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionGiftPackView)
    self._fsm:GetCurState():OnShowGift()
end

function VolcanoMissionMainView:on_btn_help_click()  
     Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionHelpView)
    --self._fsm:GetCurState():OnShowHelp()
     --self:JumpNextStep(15)
    -- self:JumpFaild(6)

    -- self:UpdateNewRound(0,2)
    -- this:PlayDieInfoData()
end


local function new_throw_top_position(start_pos, end_pos,isFailNpc,target)
    local topy = fun.find_child(target,"topy")
    local topyPos = 0
    if topy then
        topyPos = fun.get_gameobject_pos(topy.gameObject, false).y
    end

    if isFailNpc then
        local x = start_pos.x + (end_pos.x - start_pos.x) * 0.5
        local y = math.max(start_pos.y,end_pos.y)   +  math.abs((end_pos.y - start_pos.y) * 0.5)+  (isFailNpc and math.abs((end_pos.x - start_pos.x) * 0.2) or 0 )
        local z = start_pos.z + (end_pos.z - start_pos.z) * 0.5;
        --return Vector3.New(x, y, z)+   (isFailNpc and   Vector3.New(0,math.abs( (end_pos.y - start_pos.y) * 0.5),0) or   Vector3.New(0,math.abs( (end_pos.y - start_pos.y) * 0.2),0) )
        return Vector3.New(x, math.min(topyPos,y+math.abs( (end_pos.y - start_pos.y) * 0.2))  , z)
    else
        local x = start_pos.x + (end_pos.x - start_pos.x) * 0.5
        local y = math.max(start_pos.y,end_pos.y)   +  math.abs((end_pos.y - start_pos.y) * 0.5)
        --y = math.min(y,topyPos)
        local z = start_pos.z + (end_pos.z - start_pos.z) * 0.5;
        return Vector3.New(x, math.min(topyPos,y+math.abs( (end_pos.y - start_pos.y) * 0.2))  , z)

    end



end

--[[
    @desc: 跳头像，
    author:{author}
    time:2024-04-10 18:43:23
    --@sourceObj:需要动画头像
	--@target:目标位置
	--@moveT:移动时间
	--@isChild:是否添加到目标子节点
	--@offset: 贝塞尔偏移调整用
    @return:
]]
function VolcanoMissionMainView:MoveToTarger(sourceObj,target,moveT,isChild,offset,isFailNpc,groundObj)
    offset = offset or 0

    local startPos = fun.get_gameobject_pos(sourceObj.gameObject, false)
    
    local npcRect = self:GetNpcRect(sourceObj)

    local npcRectPos = fun.get_gameobject_pos(npcRect.gameObject, false)

    local relativePosStart =  Vector2.New((startPos.x - npcRectPos.x) ,(startPos.y - npcRectPos.y) )
    
    local endPos = fun.get_gameobject_pos(target.gameObject, false)

    local endPos1 = Vector3.New((endPos.x + relativePosStart.x) ,(endPos.y + relativePosStart.y),endPos.z )--endPos

    local distance = math.abs(startPos.x - endPos.x) + math.abs(startPos.y - endPos.y)
    if false then
        local path = {}
        path[1] = fun.calc_new_position_between(startPos, endPos1, 0.45+offset, 1+offset, 0)
        path[#path + 1] =  endPos1
        fun.play_animator(sourceObj.gameObject,"qi")
        Anim.bezier_move(sourceObj.gameObject, path, moveT, 0, 1, 2, function()
            if(isChild)then
                fun.set_parent(sourceObj,target)
            end
            fun.play_animator(sourceObj.gameObject,"luo")
        end)
    else
        local path = {}
        path[1] = startPos
        path[2] = new_throw_top_position(startPos, endPos1,isFailNpc,groundObj)
        path[3] =  endPos1
        --fun.play_animator(sourceObj.gameObject,"qi")

        local sourceAnia = fun.get_component(sourceObj,fun.ANIMATOR)

        AnimatorPlayHelper.Play(sourceAnia,{"qi","VolcanoMissionMainViewrenqi"},false,function()
            fun.play_animator(sourceObj.gameObject,"fei")
            Anim.throw_move(sourceObj.gameObject, path, moveT, function()
                if(isChild)then
                    fun.set_parent(sourceObj,target)
                end
                if not isFailNpc then
                    fun.play_animator(sourceObj.gameObject,"luo")
                end
            end)
        end)


        --Anim.throw_move(sourceObj.gameObject, path, moveT, function()
        --    if(isChild)then
        --        fun.set_parent(sourceObj,target)
        --    end
        --    fun.play_animator(sourceObj.gameObject,"luo")
        --end)
    end


    -- UIUtil.ThrowMove(     --可以考虑使用这个方法，ThrowLine 参考c#脚本，用于精细调试曲线
end







--[[
    @desc: 获取空的位置，用来跳失败，不能跟左右两边的山相撞
    author:{author}
    time:2024-03-26 20:18:56
    --@stepObj: 
    @return:
]]
function VolcanoMissionMainView:GetEmptyPos(stepObj,count,ownerStartPos)
    
     local allPos = {"up","down","right","left"}
    
     local stores = {"img_store1","img_store2","img_store3","img_store0","img_store_top"}
     local cameraGo = fun.GameObject_find("Canvas/Camera")
      cameraGo = fun.get_component(cameraGo,"Camera")
     local emptyCount = 0
     local ret = {}
     for _,vv in pairs(allPos) do
        local dir = stepObj[vv]
        local dirT = fun.get_component(dir,fun.RECT) 
        local dirRect = RectTransToScreenPos(dirT,cameraGo) 
        local isOvert = false 
        for k,v in pairs(stores) do 
            local store = self[v]
            local storeT = fun.get_component(store,fun.RECT) 
            local storeRect = RectTransToScreenPos(storeT,cameraGo)
            isOvert = dirRect:Overlaps(storeRect) 

            local ratio = GetIntersectionRatio(storeRect,dirRect)
            
            if(isOvert)then 
                log.r("lxq ratio",ratio,vv,v)

                if(ratio>0.5)then 
                    break
                else
                    isOvert = false 
                end  
            end 
        end
        if(isOvert==false)then 
            table.insert(ret,dir)
            emptyCount = emptyCount+1
        end 

        --if(emptyCount>=count)then
        --    break
        --end
    end
    --- time: 2024-04-11 12:03 按距离排序
    if ownerStartPos then
        table.sort(ret, function(a, b)
            return math.abs( a.transform.position.x - ownerStartPos.x) + math.abs( a.transform.position.y - ownerStartPos.y)
                    < math.abs( b.transform.position.x - ownerStartPos.x) + math.abs( b.transform.position.y - ownerStartPos.y)
        end)
    end
    return ret

end


-- local function IsOverLaps(rect1,rect2)
--     local rect = fun.get_component(rect1, fun.RECT)
--     --local isInRect = UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(rect, params.startPos)
--     local isInRect
--     local cameraGo = fun.GameObject_find("Canvas/Camera")
--     if cameraGo then
--         local uiCamera = fun.get_component(cameraGo, "Camera")
--         -- isInRect = UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(rect, params.startPos, uiCamera)
--         isInRect = UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(rect, params.startPos, uiCamera)
--     end
-- end

 

--[[
    @desc: 移动scrollver过程childview的位置，不能往下移动，只能网上
    author:{author}
    time:2024-04-10 18:46:02
    --@targetStep:
	--@isAniMove:
	--@moveTime:
	--@moveCallback: 
    @return:
]]
function VolcanoMissionMainView:MoveToStepPos(targetStep,isAniMove,moveTime,moveCallback)

    local step = targetStep 
    if(step==nil)then 
        --step =  math.min(_model:GetCurStepId(),_model:GetStepCount())
        step =  math.min(self:GetCurrStep(),_model:GetStepCount())
    end

    local y,scroolY = self:GetScrollChildsPos(step)
    if(y<scroolY and step>0)then 
        return 
    end
 

    local curStepObj = nil  
    curStepObj = _listStepObjs[step].go
    local curStepObjRect = fun.get_component(curStepObj,fun.RECT) 
    self:nevigateScrollerChild(self.scrollrect,self.Viewport,self.Content,curStepObjRect,isAniMove,moveTime,moveCallback)
end


function VolcanoMissionMainView:GetScrollChildsPos(targetStep)


    local curStepObj = nil  
    curStepObj = _listStepObjs[targetStep].go
    local curStepObjRect = fun.get_component(curStepObj,fun.RECT)  
    local y,scrollrect = self:ScrollChildCenterPosY(self.scrollrect,self.Viewport,self.Content,curStepObjRect)
    return y,scrollrect.normalizedPosition.y
end


function VolcanoMissionMainView:ScrollChildCenterPosY(scrollrect,viewPort,content,childview)
    local itemCurrentLocalPostion  = scrollrect:InverseTransformVector(ConvertLocalPosToWorldPos(childview))
    local itemTargetLocalPos = scrollrect:InverseTransformVector(ConvertLocalPosToWorldPos(viewPort))

    local diff =  Vector3.New(itemTargetLocalPos.x-itemCurrentLocalPostion.x,itemTargetLocalPos.y-itemCurrentLocalPostion.y,0) 
    
    
    local newNormalizedPosition = Vector2.New(
        diff.x / (content.rect.width - viewPort.rect.width),
        diff.y / (content.rect.height - viewPort.rect.height)
        );
    
    local _ScrollRect = fun.get_component(scrollrect,fun.SCROLL_RECT)

    local y =_ScrollRect.normalizedPosition.y - newNormalizedPosition.y;

    return y,_ScrollRect
end

function VolcanoMissionMainView:nevigateScrollerChild(scrollrect,viewPort,content,childview,isAniMove,moveTime,moveCallback)
    local itemCurrentLocalPostion  = scrollrect:InverseTransformVector(ConvertLocalPosToWorldPos(childview))
    local itemTargetLocalPos = scrollrect:InverseTransformVector(ConvertLocalPosToWorldPos(viewPort))

    local diff =  Vector3.New(itemTargetLocalPos.x-itemCurrentLocalPostion.x,itemTargetLocalPos.y-itemCurrentLocalPostion.y,0) 
    
    
    local newNormalizedPosition = Vector2.New(
        diff.x / (content.rect.width - viewPort.rect.width),
        diff.y / (content.rect.height - viewPort.rect.height)
        );
    
    local _ScrollRect = fun.get_component(scrollrect,fun.SCROLL_RECT)

    local y =_ScrollRect.normalizedPosition.y - newNormalizedPosition.y;

   
    if(isAniMove)then 
        local time = moveTime
        Anim.do_smooth_float_update_average(_ScrollRect.normalizedPosition.y,y,time,function(value)
           
            _ScrollRect.normalizedPosition =   Vector2.New(_ScrollRect.normalizedPosition.x, value)

           
        end,function() 
            if(moveCallback)then 
                moveCallback()
            end
            
        end)

    else
        _ScrollRect.normalizedPosition =   Vector2.New(_ScrollRect.normalizedPosition.x,  y)
       
    end

    
end



---------begin按钮事件----------------




--[[
    @desc: 隐藏上方进度
    author:{author}
    time:2024-04-10 18:46:50
    --@callback: 
    @return:
]]
function VolcanoMissionMainView:on_btn_hidemap_click(callback)
    if(isMove)then 
        return 
    end
    local moveT = 0.25    
    isMove = true  
    local offset = 180 
    local sTopBgPos = fun.get_localposition(self.topbg) 
    local moveFinish = function()
        isMove = false
        self:SetbtnhideState()
        if(callback)then 
            callback()
        end
    end 
    local y  = 0 
    if(sTopBgPos.y>0)then 
          y = -200 
    else 
          y = 50
    end  
 
    self.moveAnim = Anim.move_to_y(self.topbg.gameObject,y,moveT,moveFinish)
end



function VolcanoMissionMainView:on_btn_close_click()
    if self:CanClickCloseBtn() then
        Facade.SendNotification(NotifyName.CloseUI,ViewList.VolcanoMissionMainView)   ---特殊处理  防止卡状态机，
        -- self._fsm:GetCurState():OnCloseSelf()
    end
end

--说明，之前无此条件判断（等价此函数永真）
function VolcanoMissionMainView:CanClickCloseBtn()
    if self.openTime and os.time() - self.openTime >= 100 then
        return true
    end

    if self.rewardStateComplete then
        return true
    end

    if self._fsm:GetCurName() == "StateMainViewPlayerLevelUp" then
        return false
    end

    if self._fsm:GetCurName() == "StateMainViewFaild" then
        return false
    end

    if self._fsm:GetCurName() == "StateMainViewReward" then
        return false
    end

    return true
end
---------end按钮事件----------------


function VolcanoMissionMainView:SetbtnhideState()
    local sTopBgPos = fun.get_localposition(self.topbg)
    log.r("lxq topbg",sTopBgPos)

    if(sTopBgPos.y>0)then 
        fun.select_image(self.btn_hidemap, "btn_down") 
    else
        fun.select_image(self.btn_hidemap, "btn_up") 
    end 
end


function VolcanoMissionMainView:SetTopVisiable(visiable)
    if(self.moveAnim)then 
        self.moveAnim:Kill()
        self.moveAnim = nil 
        isMove = false 
    end

    local sTopBgPos = fun.get_localposition(self.topbg)  
    local y  = 0  
     
    local moveFinish = function() 
        
    end 

    if(visiable)then 
          y = -200 
    else 
          y = 50
    end   
    local sPos = fun.get_localposition(self.topbg.gameObject)
    fun.set_gameobject_pos(self.topbg.gameObject,sPos.x,y,sPos.z,true)
    -- fun.SetGameObjectLocalY(self.topbg.gameObject,y)
    self:SetbtnhideState()
end


function VolcanoMissionMainView:IsTopHide()
    local sTopBgPos = fun.get_localposition(self.topbg) 
    if(sTopBgPos.y>0)then 
       return true 
    else
        return false  
    end 
end



function VolcanoMissionMainView:CleanChildView()
    if(_listStepObjs)then 
        for k,v in pairs(_listStepObjs) do
            v:Close()
        end 
        _listStepObjs = {}
    end 
end


function VolcanoMissionMainView:SetLeftTime( )
    local endtime = _model:GetRemainTime()
    remainTimeCountDown:StartCountDown(CountDownType.cdt2,_model:GetRemainTime(),self.left_time_txt,function()
        -- this:on_btn_close_click()
    end,function()
        self.txt_icon_left_time.text = self.left_time_txt.text  
    end)


end

function VolcanoMissionMainView:InitTopPanelInfo()
    local diecount,count = _model:GetPlayerInfo()
    this.txt_playersinfo.text = string.format("%s/%s", math.max(count-diecount,0), count) 
    self:SetLeftTime()
    self:SetbtnhideState()
    fun.set_active(self.txt_faild,false)
    fun.set_active(self.idleState,true)
    local step,stepCount = _model:GetCurStepId() 
    this.txt_levels.text = string.format("%s/%s", step, stepCount) 
    local curMapid,mapCount = _model:GetLevelInfo()
    if(curMapid<=3)then  
        fun.set_active(self.map1,true)
        fun.set_active(self.map2,false) 
    else
        fun.set_active(self.map2,true)
        fun.set_active(self.map1,false) 
        curMapid = curMapid - 3
    end 
    self.img_mapprogress.fillAmount = curMapid/3

    local isReachLastMap, isLoopLastMap = _model:IsReachLastMap(), _model:IsLoopLastMap()
    if isReachLastMap then
        self.txt_mapinfo.text = Csv.GetData("description", 8065, "description")
    elseif isLoopLastMap then
        self.txt_mapinfo.text = Csv.GetData("description", 8073, "description")
        --隐藏进度条，文字位置居中
        fun.set_active(self.img_mapprogress.transform.parent, false)
        fun.set_rect_local_pos_y(self.txt_mapinfo, 0)
    else
        self.txt_mapinfo.text = Csv.GetData("description", 8064, "description")
    end
end


function VolcanoMissionMainView:InitHead()
 
    local step =  _model:GetCurStepId()
    if(_model:IsFristStep())then 
        step = 0
    end
    self:SetStepPlayer(step)
end



local function GetRandomPositionWithinRect(rectTransform,index)
    -- Get rectangle dimensions
    local  minX = rectTransform.rect.xMin;
    local  maxX = rectTransform.rect.xMax;
    local  minY = rectTransform.rect.yMin;
    local  maxY = rectTransform.rect.yMax;
    -- Generate random values within the range
    local center =   (minX+ maxX) +rectTransform.rect.width/2
    local randomY = math.random(minY, maxY)
    local x = 0
    local offset = 10
    if(index%2==0)then 
        x = center+ (index-1)*offset
    else
        x = center+ math.abs(index-2)*offset*-1
    end

    

    -- Return the random position as a vector
    return  Vector2.New(x,randomY)    --{x=randomX,y=randomY}
end

--[[
    @desc: 生成地图节点的npc
    author:{author}
    time:2024-04-03 17:39:50
     --@step: 
    @return:
]]
function VolcanoMissionMainView:SetStepNpc(step) 


    local stepView  = _listStepObjs[step]

    local stepNpcCount = _model:GetNpcCountByStepId(step)

    if(stepNpcCount==0)then 
        return stepNpcCount
    end

    local showCount = math.max(math.ceil(stepNpcCount/10),1)

    local players = _model:GetMapPlayerByStep(step,showCount) 
 

    local npcAllCount = GetTableLength(players)
    self:CleanChild(stepView.npcrect)
    -- local scale = 0.5
    -- local initPos = nil 
    self:GenerateNpc(players,stepView)
    
    return stepNpcCount
end


--[[
    @desc: 生成初始节点的玩家与npc
    author:{author}
    time:2024-04-03 17:40:05
    --@step: 
    @return:
]]
function VolcanoMissionMainView:SetStepPlayer(step) 
    if(owernHeader)then 
        Destroy(owernHeader)
        owernHeader = nil 
    end
    local scale = 0.5
    owernHeader = self:GetOwnerHead()  
    owernHeader.name = tostring(step)--记录位置
    local stepView  = _listStepObjs[step]

    local stepNpcCount = _model:GetNpcCountByStepId(step)
    local showCount = math.max(math.ceil(stepNpcCount/10),1)

    local players = _model:GetMapPlayerByStep(step,showCount) --跟随npc
    CleanNpc()
    npcObjs = {}

    players = _model:GetDieNpc(players)   --添加死亡npc
    -- local npcAllCount = GetTableLength(players)
    --local npcOjbsRef = fun.get_component(npcObjs,fun.REFER)
    npcObjs = self:GenerateNpc(players,stepView)
     
    local scale = 0.8
    fun.set_parent(owernHeader,stepView.role,true)
    fun.set_gameobject_scale(owernHeader, scale,scale,scale)
    -- fun.set_parent(owernHeader,stepView.go)
end
 

--[[
    @desc: 生成npc
    author:{author}
    time:2024-04-10 18:48:28
    --@players:
	--@stepView: 
    @return:
]]
function VolcanoMissionMainView:GenerateNpc(players,stepView)
    local retNpcs = {}
    local npcAllCount = GetTableLength(players)
    local initPos = nil 
    local scale = 0.7
    local layerCount = 0
    local setY = -1
    for i=1,npcAllCount do  
        local playInfo = players[i]
        local npcObj = nil
        if(playInfo)then 
            npcObj = self:GetHeadByAvatarId(playInfo.uid)  
            local hasBuffer = GetTableLength(playInfo.gameProps)>0
            self:SetHeadBuffer(npcObj,hasBuffer)    
            fun.set_parent(npcObj,stepView.go,true)  
            table.insert(retNpcs,npcObj) 
            local npcrect = stepView.npcrect 
            local rectTrans = fun.get_component(npcObj,fun.RECT)
            local setPos = nil 
            layerCount = layerCount+1
            if(initPos==nil)then 
                fun.set_parent(npcObj,npcrect,true)  
                fun.set_parent(npcObj,stepView.go)  
                initPos = rectTrans.anchoredPosition  
                setY = initPos.y
            end
            if(layerCount>4)then 
                layerCount = 1
                setY = setY+math.random(20,40)
            end
            local x = 0
            local offset = math.random(20,50)
            if(layerCount==3)then 
                x = initPos.x + offset*-2
            elseif(layerCount==1)then 
                x = initPos.x + offset*-1
            elseif(layerCount==2)then 
                x = initPos.x +  offset*1
            else
                x = initPos.x +  offset*2
            end
            setPos = Vector2.New(x,setY)
            rectTrans.anchoredPosition = setPos; 
            fun.set_parent(npcObj,npcrect)  
            fun.set_gameobject_scale(npcObj, scale,scale,scale)
        end
    end 

    for k,v in pairs(retNpcs) do
        fun.SetAsFirstSibling(v)
    end

    return retNpcs
end

--[[
    @desc: 获取npc对象
    author:{author}
    time:2024-04-10 18:48:40
    @return:
]]
function VolcanoMissionMainView:GetNpcObj()
    local ret =  fun.get_instance(self.npcs)
    return ret 
end


--[[
    @desc: 生成玩家头像
    author:{author}
    time:2024-04-10 18:49:04
    @return:
]]
function VolcanoMissionMainView:GetOwnerHead()
    local obj = fun.get_instance(self.playIcon)
    fun.set_active(obj,true)
    local model = ModelList.PlayerInfoSysModel
    local ref = fun.get_component(obj,fun.REFER)
    local head = ref:Get("imgHead")
    model:LoadOwnHeadSprite(head)
    local scale = 0.6
    fun.set_gameobject_scale(obj, scale,scale,scale)
    return obj 
end

--[[
    @desc: 设置头像buffer
    author:{author}
    time:2024-04-10 18:49:17
    --@obj:
	--@isShowBuffer: 
    @return:
]]
function VolcanoMissionMainView:SetHeadBuffer(obj,isShowBuffer)
    local ref = fun.get_component(obj,fun.REFER)
    local buffericon = ref:Get("buffericon")
    fun.set_active(buffericon,isShowBuffer)
end


--[[
    @desc: 生成npc 头像
    author:{author}
    time:2024-04-10 18:49:52
    --@id:
	--@headObj:
	--@hasBuffer: 
    @return:
]]
function VolcanoMissionMainView:GetHeadByAvatarId(id,headObj,hasBuffer) 
    local obj = nil 
    if(headObj==nil)then 
        obj = fun.get_instance(self.playIcon)
    else
        obj = headObj
    end 
    local model = ModelList.PlayerInfoSysModel
    fun.set_active(obj,true)
    local ref = fun.get_component(obj,fun.REFER)
    local head = ref:Get("imgHead")
    
    local useAvatarName = Csv.GetData("robot_name", id, "icon")
    model:LoadTargetHeadSpriteByName(useAvatarName ,head)
    obj.name = tostring(id)
    local scale = 0.5
   
    return obj 
end

function VolcanoMissionMainView:InitBottomPanel()
    local collect, collectTotal = _model:GetCollectInfo()
    self.img_collecgprogress.fillAmount = collect / collectTotal
    this.txt_collectinfo.text = string.format("%s/%s", collect, collectTotal)
    fun.set_active(self.itemImg, false)
    local round, _totalRound = _model:GetRoundInfo()
    self:InitRound()
    self:SetRound(round, _totalRound)
end

--[[
    @desc: 设置回合数
    author:{author}
    time:2024-04-10 18:50:27
    --@round: 
    @return:
]]
function VolcanoMissionMainView:SetRound(round,totalRound,isUpdateNewRound)
    if not totalRound then
        local roundtemp = nil
        roundtemp, totalRound = _model:GetRoundInfo()
    end
    --local cout = totalRound
    --local ret = nil
    --for i = 1, round do
    --   local roundItem =  _roundObjs[cout-i+1]
    --   SetImageBlack(roundItem,true)
    --    ret = roundItem
    --end
    self.txt_collectmapinfo.text = Csv.GetData("description", 8067, "description")
    self.txt_collectroundinfo.text = string.format("<color=#fffc0e> %s</color><color=#ecd0ff>/%s</color>",round,totalRound)
    if isUpdateNewRound then
        fun.set_active(self.baoeffect2,false,0.5)
        fun.set_active(self.baoeffect2,true)
    end
    --return ret
end


--[[
    @desc: 填充回合数
    author:{author}
    time:2024-04-10 18:50:18
    @return:
]]
function VolcanoMissionMainView:SetFullRound()
    --local cout = GetTableLength(_roundObjs)
    --
    --for i = 1, cout do
    --   local roundItem =  _roundObjs[i]
    --   SetImageBlack(roundItem,false)
    --end
    local round, _totalRound = _model:GetRoundInfo()
    self.txt_collectroundinfo.text = string.format("<color=#fffc0e> %s</color><color=#ecd0ff>/%s</color>",0,_totalRound)
    fun.set_active(self.baoeffect2,false,0.5)
    fun.set_active(self.baoeffect2,true)
end




function VolcanoMissionMainView:InitRound()
    --self:CleanBottomChangeViewChilds()
    --_roundObjs = nil
    --local round,_totalRound = _model:GetRoundInfo()
    --_roundObjs = {}
    --for i = 1, _totalRound do
    --    -- body
    --    local obj = fun.get_instance(self.itemImg, self.changebarparent)
    --    fun.set_active(obj,true)
    --    SetImageBlack(obj,false)
    --    table.insert(_roundObjs,obj)
    --end
end

function VolcanoMissionMainView:CleanChild(obj)
 
    local cout = fun.get_child_count(obj)
    local idx = 0
    while(cout>0)do 
        local objChild = fun.get_child(obj,0)
       
        DestroyImmediate(objChild)
        idx = idx+1
        cout = fun.get_child_count(obj)
        if(idx>10)then 
            break 
        end
    end 
end

function VolcanoMissionMainView:CleanBottomChangeViewChilds()
    self:CleanChild(self.changebarparent)
end

function VolcanoMissionMainView:InitMap()
    self:InitMapBg()
    
    local cout = _model.GetStepCount()
    local lPos = fun.get_gameobject_pos(self.lPos,true)
    local rPos = fun.get_gameobject_pos(self.rPos,true) 
    local lPosX = lPos.x
    local rPosX = rPos.x 
    local topStonePos = fun.get_gameobject_pos(self.img_store_top,true)
    local topstoreSize = fun.get_rect_delta_size(self.img_store_top)  
    local itemSize = fun.get_rect_delta_size(self.ItemStepObj)
    local storeSize = fun.get_rect_delta_size(self.img_store0)  
    local itemHeight = itemSize.y
    local itemWidth = itemSize.x 
    local conenteHeight = (topHeight)+((itemHeight+itemoffsetH)*cout)+storeSize.y+bottomHeight -bottomOffset

    fun.set_recttransform_native_height(self.Content, conenteHeight) 
    local nextPos =  Vector3.New(rPosX, topStonePos.y-topstoreSize.y/2-topoffSet, topStonePos.z)
  
    nextPos = self:InitStepObj(nextPos,cout,lPosX,rPosX,itemHeight)
    self:SetBeginStonePos(nextPos)
end

--地图贴图、特效轮换
local Suffix = {"b", "", "a"}
function VolcanoMissionMainView:InitMapBg()
    local mapID = _model:GetMapId()
    local temp = (mapID % 3)
    local suffix = Suffix[temp + 1]
    
    --贴图
    local setImage = function(obj)
        local image = fun.get_component(obj, fun.IMAGE)
        local spriteName = image.sprite.name
        local targetSpriteName = spriteName..suffix
        if targetSpriteName ~= spriteName then
            Cache.GetSpriteByName("VolcanoMissionMainViewAtlasInMain", targetSpriteName, function(sprite)
                if not fun.is_null(sprite) then
                    image.sprite = sprite
                end
            end)
        end
    end
    fun.eachChild(self.map_bg_root, function(child)
        setImage(child)
    end)
    local stepBg = fun.find_child(self.ItemStepObj, "bg/di")
    if stepBg then
        setImage(stepBg)
    end
    setImage(self.img_store_top)
    setImage(self.img_store0)
    setImage(self.img_store1.transform.parent)
    setImage(self.img_store2.transform.parent)
    setImage(self.img_store3.transform.parent)

    --特效
    local setEffect = function(trans)
        local ef1 = fun.find_child(trans, "Ef1_Yanjiang")
        local ef2 = fun.find_child(trans, "Ef2_Duye")
        local ef3 = fun.find_child(trans, "Ef3_Wushui")
        fun.set_active(ef1, temp == 1)
        fun.set_active(ef2, temp == 2)
        fun.set_active(ef3, temp == 0)
    end
    setEffect(self.img_store_top)
    setEffect(self.img_store0)
    setEffect(self.img_store1.transform.parent)
    setEffect(self.img_store2.transform.parent)
    setEffect(self.img_store3.transform.parent)
end

--玩家掉水动画
function VolcanoMissionMainView:PlayFailedAnimation(ctrl)
    local mapID = _model:GetMapId()
    local temp = (mapID % 3)
    if temp == 1 then
        fun.play_animator(ctrl, "end1Yanjiang")
    elseif temp == 2 then
        fun.play_animator(ctrl, "end2Duye")
    elseif temp == 0 then
        fun.play_animator(ctrl, "end3Wushui")
    else
        fun.play_animator(ctrl, "end1Yanjiang")
    end
end

function VolcanoMissionMainView:InitStepObj(nextPos,cout,lPosX,rPosX,itemHeight)
        CleanStepObjs()
        _listStepObjs= {}
        local itemViewClass = require ("View.VolcanoMission.VolcanoMissionMainStepItemView")
        --初始化节点
        local isRight = true  

        local curStep = self:GetCurrStep()-- ModelList.VolcanoMissionModel:GetCurStepId()
        self:InitEndStepObj(nextPos,cout,lPosX,rPosX,itemHeight)
        for i = cout,1,-1 do
            local itemView = itemViewClass:New()
            local itemObj = fun.get_instance(self.ItemStepObj,self.Content)
            itemView:SkipLoadShow(itemObj) 
            itemObj.name = tostring(i)   --debug
            --if i == cout then
            --    nextPos = Vector3.New((lPosX + rPosX)*0.5, nextPos.y+50, nextPos.z)
            --end
            itemView:SetPos(nextPos) 
            itemView:SetId(i) 

            -- itemView:SetVisiable(i>=curStep)
            --if i == cout then
            --    nextPos = Vector3.New(0, nextPos.y-itemHeight-itemoffsetH+10, nextPos.z)
            --else
            if(isRight)then
                nextPos = Vector3.New(lPosX, nextPos.y-itemHeight-itemoffsetH, nextPos.z)
            else
                nextPos = Vector3.New(rPosX, nextPos.y-itemHeight-itemoffsetH, nextPos.z)
            end
            --end

          

            isRight = not isRight  
            _listStepObjs[i] = itemView
        end



        local itemView = itemViewClass:New()
        itemView:SkipLoadShow(self.img_store0.gameObject) 
        _listStepObjs[0] = itemView   --初始地块0

        fun.SetAsLastSibling(self.img_store0.gameObject)



        self:UpdateBoxState(true,true)
        return nextPos
end

--- 初始化终点地块
function VolcanoMissionMainView:InitEndStepObj(nextPos,cout,lPosX,rPosX,itemHeight)
    local itemViewClass = require ("View.VolcanoMission.VolcanoMissionMainStepItemView")

    local itemView = itemViewClass:New()
    local itemObj = fun.get_instance(self.ItemStepObj,self.Content)
    itemView:SkipLoadShow(itemObj)
    itemObj.name = tostring(cout+1)   --debug
    --if i == cout then
    --    nextPos = Vector3.New((lPosX + rPosX)*0.5, nextPos.y+50, nextPos.z)
    --end
    local  nnextPos = Vector3.New((lPosX + rPosX)*0.5, nextPos.y+topoffSet, nextPos.z)
    itemView:SetPos(nnextPos)
    itemView:SetId(cout+1)
    itemView:SetBoxShow(false)
    _listStepObjs[cout+1] = itemView
    _endStepView = itemView
end



function VolcanoMissionMainView:UpdateBoxState(isGenerateNpc,isStartInit)
    isGenerateNpc = isGenerateNpc or false 
    local cout = _model.GetStepCount()
    local curStep = ModelList.VolcanoMissionModel:GetCurStepId()
 
    for i = cout,0,-1 do
        local isShowBox = _model:HasRewardByStepId(i) 
        _listStepObjs[i]:SetBoxShow(isShowBox) 
        if(i~=curStep)then 
           local npcCount = 0
           if(isGenerateNpc)then 
                npcCount = self:SetStepNpc(i)
           else
                npcCount = _model:GetNpcCountByStepId(i)
           end
             --_model:GetNpcCountByStepId(i)  -- 
            _listStepObjs[i]:SetShowNpc(npcCount>0)
        else
            local step = self:GetCurrStep() -- _model:GetCurStepId()
            --local hasReward = _model:HasRewardByStepId(step)
            _listStepObjs[i]:SetShowNpc(true)
        end 

        if(isGenerateNpc )then  
            _listStepObjs[i]:SetPassLevel(i<=curStep,isStartInit)
        end


    end
end


function VolcanoMissionMainView:SetBeginStonePos(nextPos)
    local storeSize = fun.get_rect_delta_size(self.img_store0)  
    local beginStone =  fun.get_gameobject_pos(self.img_store0,true)
    local storePos =  Vector3.New(beginStone.x, nextPos.y-storeSize.y-itemoffsetH, beginStone.z)
    fun.set_transform_pos(self.img_store0.transform, storePos.x,storePos.y,storePos.z,true)
end

function VolcanoMissionMainView.OnDestroy()
    this:Destroy()
end

function VolcanoMissionMainView:OnGiveUp()
    self._fsm:GetCurState():OnGiveUP() 
end

function VolcanoMissionMainView:OnRewardEnd()
    self._fsm:GetCurState():OnRewardEnd() 
end

function VolcanoMissionMainView:OnShowBoxTips()
    self._fsm:GetCurState():OnShowBoxTips()
end


function VolcanoMissionMainView:OnReviveSuccess()
    self._fsm:GetCurState():OnReviveSuccess()
end


 
function VolcanoMissionMainView:OnUpdateData()
    self._fsm:GetCurState():OnUpdateData()
end


function VolcanoMissionMainView:OnCloseGift()
    self._fsm:GetCurState():OnCloseGift()
end


function VolcanoMissionMainView:GetCurrStep()
    if owernHeader then
        return tonumber(owernHeader.name),  ModelList.VolcanoMissionModel:GetStepCount()
    end
    return ModelList.VolcanoMissionModel:GetCurStepId()
end

function VolcanoMissionMainView:OnBuyGiftSuccess()
    fun.set_active(self.gift_reddot, ModelList.GiftPackModel:CheckVolcanoMissionHaveFreePack())
end



this.NotifyEnhanceList = {

   
    {notifyName =  NotifyName.VolcanoMission.UpdateData, func = this.OnUpdateData},
    {notifyName = NotifyName.VolcanoMission.ReviveSuccess, func = this.OnReviveSuccess},
    {notifyName = NotifyName.VolcanoMission.GiveUp, func = this.OnGiveUp},
    {notifyName = NotifyName.VolcanoMission.RewardEnd, func = this.OnRewardEnd},  
    {notifyName =  NotifyName.VolcanoMission.ShowBoxTips, func = this.OnShowBoxTips},
    {notifyName =  NotifyName.VolcanoMission.CloseGift, func = this.OnCloseGift},

    {notifyName =  NotifyName.VolcanoMission.OpenBoxEnd, func = this.OnRewardEnd},
    
   
}

---
function VolcanoMissionMainView:on_btn_continue_click()
    Facade.SendNotification(NotifyName.CloseUI,ViewList.VolcanoMissionMainView)
    ModelList.VolcanoMissionModel:C2S_PlayeMatch()
end

function VolcanoMissionMainView:ShowContinueClcik()
    fun.set_active(self.btn_continue,true)
end
return this 


