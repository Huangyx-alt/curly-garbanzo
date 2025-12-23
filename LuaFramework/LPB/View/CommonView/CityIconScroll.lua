
local CityIconScroll = Clazz()

local bottomOffset = 900
local topOffset = 0
local itemHeightOffset = 950 -- 1100
local lastContentPosY = 0
local startDragPos = nil
local maxCityScale =Vector2.New(1,1)
local minCityScale =Vector2.New(0.9,0.9)
local moveTime = 1
local isMoving = false

function CityIconScroll:New(cityScrollView,cityItem)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.cityScrollView = cityScrollView
    o.cityItem = cityItem
    return o
end

function CityIconScroll:OnEnable()
    isMoving = false
    self.cityScrollView.enabled = false
    startDragPos = nil
    self.cityIconList = {}
    local view = require("View/CommonView/CityIconItem")
    local config = Csv.new_city_play_scene
    self.maxCityIndex = GetTableLength(config)
    local itemParent =self.cityScrollView.content

    for index = 1 ,self.maxCityIndex do
        local cityId = config[index].scene_id
        local item = fun.get_instance(self.cityItem,itemParent)
        local itemView = view:New(self,config[index])
        itemView:SkipLoadShow(item)
        self.cityIconList[cityId] = itemView
        local pos = self:GetItemPos(cityId)
        item.transform.localPosition = Vector3.New(0,pos,0)
        item.transform.name = "cityIcon_" ..cityId    
    end
    local UIDragControl = fun.get_component(self.cityScrollView, "UIDragControl")
    UIDragControl:SetDragFunc(function(position)
        --正在拖动
    end,
    function(position)
        --结束拖动
        if not startDragPos then
            return
        end
        if isMoving then
            return
        end
        if startDragPos.y > position.y then
            --向上滑动
            if self.curStayCityIndex + 1 <= self.maxCityIndex then
                local lastIndex = self.curStayCityIndex
                self.curStayCityIndex = self.curStayCityIndex + 1
                startDragPos = nil
                self:MoveToCity(lastIndex,self.curStayCityIndex)
            end
        else
            --向下滑动
            if self.curStayCityIndex > 1 then
                local lastIndex = self.curStayCityIndex
                self.curStayCityIndex = self.curStayCityIndex - 1
                startDragPos = nil
                self:MoveToCity(lastIndex,self.curStayCityIndex)
            else
                --已经最小城市id
            end
        end
    end,
    function(position)
        --开始拖动
        startDragPos = position
    end)

    self:SetContentSize(self.maxCityIndex)
    self:FocusOnCity(false)
end
--
----每次手动滑动只能移动一个城市
function CityIconScroll:MoveNextOneCity(value)
    local originPos = fun.get_rect_anchored_position(self.cityScrollView.content)
    if lastContentPosY < originPos.y then
        --向下滑动
        if self.curStayCityIndex > 1 then
            local lastIndex = self.curStayCityIndex
            self.curStayCityIndex = self.curStayCityIndex - 1
            self:MoveToCity(lastIndex,self.curStayCityIndex)
        else
            --已经最小城市id
        end
    elseif lastContentPosY > originPos.y then
        --向上滑动
        if self.curStayCityIndex + 1 <= self.maxCityIndex then
            local lastIndex = self.curStayCityIndex
            self.curStayCityIndex = self.curStayCityIndex + 1
            self:MoveToCity(lastIndex,self.curStayCityIndex)
        end
    end
end

function CityIconScroll:OnReShow()
end

function CityIconScroll:CityFocusShow(cityId)
    log.log("打开角色展示 " ,cityId)
    for i = 1 , GetTableLength(self.cityIconList) do
        if self.cityIconList[cityId] then
            if i == cityId then
                self.cityIconList[i]:CityFocusShow()
            else
                self.cityIconList[i]:CityLeaveShow()
            end
        end
    end

end

function CityIconScroll:OnDestroy()
    for k ,v in pairs(self.cityIconList) do
        v:Close()
    end
    self.cityIconList = {}
end

function CityIconScroll:SetContentSize(cityNum)
    local height = self:GetContenHeight(cityNum)
    fun.set_recttransform_native_size(self.cityScrollView.content ,  1000 , height)
end

function CityIconScroll:GetContenHeight(cityNum)
    return  topOffset + cityNum  * itemHeightOffset + bottomOffset
end


function CityIconScroll:GetItemPos(cityIndex)
    return (cityIndex - 1) * itemHeightOffset + bottomOffset
end

function CityIconScroll:GetMoveItemPos(cityIndex)
    if cityIndex == 1 then
        return 0
    end
    return (cityIndex - 1) * -itemHeightOffset
end

function CityIconScroll:AnimCityScale(lastCityIndex,targetCity)
    if self.cityIconList[targetCity] then
        self.cityIconList[targetCity]:AnimCityItemScale(minCityScale , maxCityScale,lastCityIndex,targetCity)
    end
    if self.cityIconList[targetCity - 1] then
        self.cityIconList[targetCity-1]:AnimCityItemScale(maxCityScale,minCityScale,lastCityIndex,targetCity)
    end
    if self.cityIconList[targetCity + 1] then
        self.cityIconList[targetCity+1]:AnimCityItemScale(maxCityScale,minCityScale,lastCityIndex,targetCity)
    end
end

function CityIconScroll:MoveToCity(lastCityIndex,cityIndex)
    self:AnimCityScale(lastCityIndex,cityIndex)
    local originPos = fun.get_rect_anchored_position(self.cityScrollView.content)
    local targetY = self:GetMoveItemPos(cityIndex)
    isMoving = true
    Anim.scroll_to_y(self.cityScrollView.content, targetY, moveTime, function()
        fun.set_rect_anchored_position(self.cityScrollView.content, originPos.x, targetY)
        lastContentPosY = targetY
        isMoving = false
        --self:CityFocusShow()
    end)
end

--界面中心显示指定city
function CityIconScroll:FocusOnCity(needAnim, cityIndex,isUnlockNewCity)
    log.r("[CityIconScroll] FocusOnCity sceneId 1:", cityIndex)
    if cityIndex and cityIndex > self.maxCityIndex then
        return
    end

    if isUnlockNewCity then
        cityIndex = cityIndex or ModelList.NewPuzzleModel:GetNewUnlockScene()
    else
        local gameType , gameIndex = ModelList.BetConfigModel.ReadLastPlayCity()
        if gameType == BingoBangEntry.machineType.Main then
            cityIndex = gameIndex or ModelList.NewPuzzleModel:GetNewUnlockScene()
        else
            cityIndex = cityIndex or ModelList.NewPuzzleModel:GetNewUnlockScene()
        end
    end
    
    log.r("[CityIconScroll] FocusOnCity sceneId 2:", cityIndex)
    if not cityIndex or cityIndex <= 0 then
        return
    end
    
    --当前节点的city
    self.curStayCityIndex = cityIndex
    
    local originPos = fun.get_rect_anchored_position(self.cityScrollView.content)
    local targetY = self:GetMoveItemPos(cityIndex)
    log.log("机台小岛 当前使用节点 " , self.curStayCityIndex )
    if needAnim then
        lastContentPosY = targetY
        Anim.scroll_to_y(self.cityScrollView.content, targetY, moveTime, function()
            if not isUnlockNewCity then
                self:CityFocusShow(self.curStayCityIndex)
            end
        end)
    else
        lastContentPosY = targetY
        fun.set_rect_anchored_position(self.cityScrollView.content, originPos.x, targetY)
        if not isUnlockNewCity then
            self:CityFocusShow(self.curStayCityIndex)
        end
    end
    
    return true
end

function CityIconScroll:ShowClickHomeExit()
    self:CityFocusShow(self.curStayCityIndex)
end

--拼图领奖返回
function CityIconScroll:ShowPuzzleRewardExit()
    log.r("[CityIconScroll] CheckCompleteOnGoBackSelectCity curStayCityIndex :", self.curStayCityIndex)
    local curCityItem = self.cityIconList[self.curStayCityIndex]
    if not curCityItem then
        log.r("[CityIconScroll] CheckCompleteOnGoBackSelectCity curCityItem is nil")
        return
    end

    coroutine.start(function()
        coroutine.wait(1)
        local isComplete = ModelList.NewPuzzleModel:IsScenePuzzleComplete(self.curStayCityIndex)
        log.r("[CityIconScroll] CheckCompleteOnGoBackSelectCity isComplete :", isComplete)
        if not isComplete then
            return
        end

        local isGuided = ModelList.NewPuzzleModel:IsGuidedPuzzleComplete(self.curStayCityIndex)
        log.r("[CityIconScroll] CheckCompleteOnGoBackSelectCity isGuided :", isGuided)
        --if isGuided then
        --    return
        --end

        --完成表现
        curCityItem:ShowComplete()
        coroutine.wait(1)
        self.cityIconList[self.curStayCityIndex]:ShowLastCityFinish()
        --聚焦到下一个城市
        local nextCity = self.curStayCityIndex + 1
        local ret = self:FocusOnCity(true, nextCity,true)
        if ret then
            coroutine.wait(0.3)

            --新城市解锁动画
            if nextCity == self.curStayCityIndex then
                curCityItem = self.cityIconList[self.curStayCityIndex]
                curCityItem:ShowUnLock()

                coroutine.wait(2)
                --角色出现在新城市节点上，播放手机点击动画
                curCityItem:PlayGuideTip()
            end
        end
    end)
end

--从城市返回后检查当前节点是否已经完成拼图收集，做表现
function CityIconScroll:CheckCompleteOnGoBackSelectCity(exitType)
    if exitType == BingoBangEntry.exitMachineLobbyType.PuzzleRewardExit then
        self:ShowPuzzleRewardExit()
    elseif exitType == BingoBangEntry.exitMachineLobbyType.ClickBackHome then
        self:ShowClickHomeExit()
    end
    
end

function CityIconScroll:CheckMove(cityIndex)
    if not self:CheckIsCenter(cityIndex) then
        return false
    end
    if isMoving then
        log.log("正在移动")
        return false
    end
    return true
end

function CityIconScroll:CheckIsCenter(cityIndex)
    if not self.curStayCityIndex then
        log.log("没初始化完成")
        return false
    end
    return self.curStayCityIndex == cityIndex
end


function CityIconScroll:Dispose()
  
end


return CityIconScroll