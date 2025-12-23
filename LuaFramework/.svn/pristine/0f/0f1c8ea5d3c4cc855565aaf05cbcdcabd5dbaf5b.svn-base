HallCityBannerView = BaseView:New("HallCityBannerView","MainBannerAtlas")
local this = HallCityBannerView
this.viewType = CanvasSortingOrderManager.LayerType.None
this.auto_bind_ui_items = {
    "bannerSv",
    "Content",
    "touchSv",
    "contentTouch",
    "ctrlDrag",
    "textCountDown",
    "Toggle1",
    "Toggle2",
    "Toggle3",
    "Toggle4",
    "Toggle5",
    "Toggle6",
    "Viewport",
    "ctrlDragtest1",
    "ctrlDragtestRight",
    "ctrlDragtestLeft",
    "mainCanvasGroup",
}

local camera = nil

local leftLinePosX =  0 --可见框左侧边界位置
local rightLinePosX = 0 --可见框右侧边界位置
local widthViewPort = 0

local isPause = false 
local insertBannerList = {} --运行中插入的banner
local creatInsertBannerId = nil --运行中在创建的bannerID

local maxShowBannerNum = 6 --最多展示6个banner（策划要求）

local lastUseToggleIndex = 1 --上次展示的toggle

local lastClickIsDrag = false --上次点击是否拖拽过
local isLimitDrag = false --限制拖拽
local isAutoMove = false --是否自动移动

local dragStartPosX = nil  --拖拽开始位置X

local dragPercent = 1 --位移距离百分比控制

local offsetDistance = 1 --自动补齐距离判断 大于这个数 需要自动移动补齐

local contenHeight = 220
local bannerItemWidth = 505 --banner宽度（所有banner宽度都应该是这个）

local useBannerNum = 0 --使用的banner数量
local hasCreatUseBannerNum = 0 --已经创建的banner数量
local useBannerItemList = {} --使用中的banner
local waitCreatBannerList = {} --创建banner检查可以用的banner列表

local upLeftIndex = nil --最左侧的index  useBannerItemList里面的
local upRightIndex = nil --最右侧的index  useBannerItemList里面的


--检查banner使用状态
function HallCityBannerView:CheckBannerUse(bannerId)
    if bannerId == hallCityBannerType.tournamentTrueGoldLock then
        return ModelList.TournamentModel:CheckShowLockBanner()
    elseif bannerId == hallCityBannerType.tournamentTrueGoldUnlock then
        return ModelList.TournamentModel:CheckShowUnLockBanner()
    elseif bannerId == hallCityBannerType.ultraBet then
        return ModelList.UltraBetModel:IsActivityValid()
    elseif bannerId == hallCityBannerType.recommendGame then
        return true
    elseif bannerId == hallCityBannerType.diamondPromotion then
        return ModelList.GiftPackModel:IsPackAvailableByIcon("cEntdiamondsale")
    elseif bannerId == hallCityBannerType.bravoGuideHelp then 
        return this:CheckBravoGuideCouldPop() -- 放哪都不太合适
    elseif bannerId == hallCityBannerType.winzone then
        return ModelList.WinZoneModel:IsActivityValid()    
    elseif bannerId == hallCityBannerType.halloffame then
        return ModelList.HallofFameModel:CheckShowNormalBanner()   
    elseif bannerId == hallCityBannerType.halloffame_gold then
        return ModelList.HallofFameModel:CheckShowGoldBanner()    
    elseif bannerId == hallCityBannerType.fullGamePlay then
        return ModelList.CityModel:GetFullGameplayRemainTime() > 0
    else
        log.r("需要修改 不展示未知的bannerId：" , bannerId)
        return false
    end
end

--判断banner可用数量大于0
function HallCityBannerView:CheckBannerUnEnable()
    if useBannerNum > 0 then
        return true
    end
    return false
end

--设置banner可见性
function HallCityBannerView:SetMainCanvasGroup()
    if self:CheckBannerUnEnable() then
        self.mainCanvasGroup.alpha = 1
        self.mainCanvasGroup.blocksRaycasts= true
        self.mainCanvasGroup.interactable= true
    else
        self.mainCanvasGroup.alpha = 0
        self.mainCanvasGroup.blocksRaycasts= false
        self.mainCanvasGroup.interactable= false
    end
end

function HallCityBannerView:Awake(obj)
    self:on_init()
end

function HallCityBannerView:InitUseToggle()
    for i =1 , maxShowBannerNum do
        local toggle = self["Toggle" .. i]
        if useBannerNum >= i then
            fun.set_active(toggle, true)
        else
            fun.set_active(toggle, false)
        end
    end
end

function HallCityBannerView:ToggleChange(index)
    if index then
        if lastUseToggleIndex and lastUseToggleIndex == index then
            --相同的展示不处理
            return
        end
        if self["Toggle" .. index] then
            self["Toggle" .. index].isOn = true
        end
        if self["Toggle" .. lastUseToggleIndex] then
            self["Toggle" .. lastUseToggleIndex].isOn = false
        end
        lastUseToggleIndex = index
    end
end

function HallCityBannerView:ChangeIsAutoMoveState(state)
    isAutoMove = state
  --  log.log("自动移动状态修改" , state)
end

function HallCityBannerView:CheckIsAutoMoveState()
    return isAutoMove == true
end

--获取从右转移到左侧后的位置X
function HallCityBannerView:GetRightToLeftPosX(leftIndex, rightIndex)
    local leftPosX = useBannerItemList[leftIndex]:GetBannerLocalPosX()
    return leftPosX - bannerItemWidth
end

--获取从左转移到右侧后的位置X
function HallCityBannerView:GetLeftToRightPosX(leftIndex, rightIndex)
    local leftPosX = useBannerItemList[rightIndex]:GetBannerLocalPosX()
    return leftPosX + bannerItemWidth
end

--获取最右侧的
function HallCityBannerView:GetUpRightIndex()
    return upRightIndex
end

--获取最左侧的
function HallCityBannerView:GetUpLeftIndex()
    return upLeftIndex
end

function HallCityBannerView:InitDragStartPosition()
    dragStartPosX = nil
end

--通过点击位置判断 可以触发哪个banner
function HallCityBannerView:CheckClickBannerIndex(clickPosition)
    if lastClickIsDrag then
        --通过拖拽点击 不处理
        log.log("拖拽触发引用 拖拽点击取消 " )
        return false
    end
    local hitBannerIndex = nil
    for k ,v in pairs(useBannerItemList) do
        local bannerPos = v:GetBannerPosition()
        local bannerScreentPos = camera:WorldToScreenPoint(bannerPos)
        if bannerScreentPos.x < clickPosition.x and bannerScreentPos.x + widthViewPort >= clickPosition.x then
            hitBannerIndex = k
            break
        end
    end
    self:ChangeIsAutoMoveState(true)
    self:DragEndToAutoMoveBanner()
    if hitBannerIndex then
        useBannerItemList[hitBannerIndex]:HitBannerFunc()
        return true
    end
    return false
end

function HallCityBannerView:InitDrag()
    self.ctrlDrag:SetClickFunc(function(position)
        local isClickShow = self:CheckClickBannerIndex(position)  --需要这个
        if isLimitDrag then
            return
        end
        if not self:CheckBannerNumAllowMove() then
          -- log.log("自动移动检查 禁止移动")
            return
        end
        if self:CheckIsAutoMoveState() then
            self:StopAutoMove()
            if not isClickShow then
                self:ChangeIsAutoMoveState(false)
            end
        end
        dragStartPosX = position.x
    end)

    self.ctrlDrag:SetDragFunc(function(position)
        --正在拖动
        if isLimitDrag then
        --    log.log("拖拽禁用中")
            return
        end
        if not self:CheckBannerNumAllowMove() then
       --     log.log("自动移动检查 禁止移动")
            return
        end
        lastClickIsDrag = true
        if self:CheckIsAutoMoveState() then
            self:ChangeIsAutoMoveState(false)
            self:StopAutoMove()
        end
        if not dragStartPosX then
            dragStartPosX = position.x
        end
        if dragStartPosX then
            local distance = (dragStartPosX - position.x ) * dragPercent
            self:ResetBannerItemPos(-distance)
            self:CheckResetBilateral()
            self:MoveChangeUseToggle()
        end
    end, 
    function(position)
        --结束拖动
        if isLimitDrag then
      --      log.log("拖拽禁用中")
            return
        end
        lastClickIsDrag = false
        --重置banner位置
        if not self:CheckBannerNumAllowMove() then
         --   log.log("自动移动检查 禁止移动")
            return
        end

        dragStartPosX = nil
        self:ResetBannerItemInitPos() --每次拖动结束 重置初始位置
        self:BannerMoveEndOffset()
    end)
end


--判断并修改 从最右侧转移到最左侧/最左侧转移到最右侧
function HallCityBannerView:CheckResetBilateral()
    local leftIndex = self:GetUpLeftIndex()
    local rightIndex = self:GetUpRightIndex()
    local upLeftItemView = useBannerItemList[leftIndex]
    --- firebase提示的报错
    if fun.is_null(upLeftItemView) then
        return
    end
    local itemViewRight = useBannerItemList[rightIndex]
    local leftPosX = upLeftItemView:GetBannerLocalPosX()
    local rightPosX = itemViewRight:GetBannerLocalPosX()
    if leftPosX > 0  then --不能等于0 会左右晃动
        --这里需要最右侧转移到最左侧了
        local posX = self:GetRightToLeftPosX(leftIndex , rightIndex)
        upLeftItemView:ResetInitPosX(posX)
        itemViewRight:SetInitPosX(posX)
        itemViewRight:SetBannerPosX(posX)
        self:ResetBannerItemInitPosIgnoreBilateral(leftIndex ,rightIndex)
        self:ResetetBannerBilateral()
        self:InitDragStartPosition()
    elseif rightPosX < 0  then --不能等于0 会左右晃动
        --这里需要最左侧转移到最右侧了
        local posX = self:GetLeftToRightPosX(leftIndex , rightIndex)
        itemViewRight:ResetInitPosX(posX)
        upLeftItemView:SetInitPosX(posX)
        upLeftItemView:SetBannerPosX(posX)
        self:ResetBannerItemInitPosIgnoreBilateral(leftIndex ,rightIndex)
        self:ResetetBannerBilateral()
        self:InitDragStartPosition()
    else
        --不用处理
        -- log.log("检查是否位移 左侧 不处理" )
    end
end

--根据拖拽距离 修改位置
function HallCityBannerView:ResetBannerItemPos(distance)
    for k , v in pairs(useBannerItemList) do
        v:AddBannerPosXByInit(distance)
    end
end

--补齐位置
function HallCityBannerView:ResetBannerItemOffset(distance)
    for k , v in pairs(useBannerItemList) do
        v:ResetBannerItemOffset(distance)
    end
end

--中断补齐
function HallCityBannerView:ClearResetBannerItemOffset()
    for k , v in pairs(useBannerItemList) do
        v:ClearResetBannerItemOffset()
    end
end


--重置banner初始位置
function HallCityBannerView:ResetBannerItemInitPos()
    for k , v in pairs(useBannerItemList) do
        v:ResetInitPosX()
    end
end

--重置banner初始位置 不包括最左/右
function HallCityBannerView:ResetBannerItemInitPosIgnoreBilateral(leftIndex, rightIndex)
    for k , v in pairs(useBannerItemList) do
        if k ~= leftIndex and k ~= rightIndex then
            v:ResetInitPosX()
        end
    end
end

--初始创建使用的banner
function HallCityBannerView:InitUseBannerItemList()
    local bannerList = Csv.banner_list
    if  bannerList then
        for k , v in pairs(bannerList) do
            -- local banner = v.banner
            if self:CheckBannerUse(v.id) and not self:CheckBannerIdExist(v.id) then
                useBannerNum = useBannerNum + 1
                table.insert(waitCreatBannerList ,v.id)
            end
        end
    end
end

--有新增/删除 重置
function HallCityBannerView:ResetUseBanner()
    useBannerNum = GetTableLength(useBannerItemList)
    
end

function HallCityBannerView:CheckCreatFinish()
    hasCreatUseBannerNum = hasCreatUseBannerNum + 1
    if hasCreatUseBannerNum >= useBannerNum then
        waitCreatBannerList = {}
        self:OrderBannnerList()
        self:SetMainCanvasGroup()
    end
end

function HallCityBannerView:CreatBannerList()

    for k , v in pairs(waitCreatBannerList) do
        self:InitBannerView(v, function()
            self:CheckCreatFinish()
        end)
    end
end

function HallCityBannerView:InitBannerView(bannerId, creatFinishFunc)
    local bannerViewName = Csv.GetData("banner_list" ,bannerId ,  "viewname")
    if not ViewList[bannerViewName] then
        log.r("错误创建banner缺少数据" , bannerId)
        return
    end

    local bannerPrefabName = Csv.GetData("banner_list" ,bannerId ,  "prefabname")
    local bannerPrePriority = Csv.GetData("banner_list" ,bannerId ,  "priority")
    local atlasName = Csv.GetData("banner_list" ,bannerId ,  "atlas_name")
    local loadBanner = function()
        Cache.load_prefabs(AssetList[bannerPrefabName]  , bannerPrefabName , function(obj)
            if obj then
                --    log.log("创建banner" , bannerViewName)
                local bannerItem = fun.get_instance(obj,self.Content)
                bannerItem.name = bannerPrefabName
                local viewItem = ViewList[bannerViewName]
                local bannerView = viewItem:New()
                bannerView:SkipLoadShow(bannerItem)
                fun.set_active(bannerItem,true)
                bannerView:SetBannerConfigData(bannerId  , bannerPrePriority)
                table.insert(useBannerItemList , bannerView)
                if creatFinishFunc then
                    creatFinishFunc()
                end
            end
        end)
    end

    --- 修复Banner第一次打开白图的问题(atlasName默认配置为0)
    if not fun.is_null(atlasName) and atlasName ~= "0" then
        Cache.Load_Atlas(AssetList[atlasName], atlasName, function()
            loadBanner()
        end)
    else
        loadBanner()
    end
end

--排序
function HallCityBannerView:SortBannerList()
    table.sort(useBannerItemList , function(bannerA, bannerB)
        local priorityA = bannerA:GetBannerPriority()
        local priorityB = bannerB:GetBannerPriority()
        if priorityA < priorityB then
            return true
        end
        return false
    end)
end

function HallCityBannerView:OrderBannnerList()
    self:SortBannerList()
    -- self:SetContentWidth()
    self:SetBannerItemPos(true)
end

--设置banner位置和最左/最右
function HallCityBannerView:SetBannerItemPos(isResetPos)
    local upLeftBannerIndex = nil
    local upRightBannerIndex = nil
    local upLeftPosX = nil
    local upRightPosX = nil
    for k , v in pairs(useBannerItemList) do
        -- log.log("顺序队列查找" , v:GetBannerPriority())
        local posX = self:GetBannerItemLocalPosX(k)
        if isResetPos then
            v:SetBannerIndex(k)
            v:SetBannerPosX(posX)
            v:SetInitPosX(posX , isResetPos)
        end
        
        if not upLeftPosX or upLeftPosX > posX then
            upLeftPosX = posX
            upLeftBannerIndex = k
        end

        if not upRightPosX or upRightPosX < posX then
            upRightPosX = posX
            upRightBannerIndex = k
        end

        v:SetBannerIsUpLeft(false)
        v:SetBannerIsUpRight(false)
    end

    if upLeftBannerIndex then
        upLeftIndex = upLeftBannerIndex
        useBannerItemList[upLeftBannerIndex]:SetBannerIsUpLeft(true)
    else
        log.log("错误缺少最左侧的banner")
    end

    if upRightBannerIndex then
        upRightIndex = upRightBannerIndex
        useBannerItemList[upRightBannerIndex]:SetBannerIsUpRight(true)
    else
        log.log("错误缺少最右侧的banner")
    end
end

--设置banner位置和最左/最右
function HallCityBannerView:ResetetBannerBilateral()
    local upLeftBannerIndex = nil
    local upRightBannerIndex = nil
    local upLeftPosX = nil
    local upRightPosX = nil
    for k , v in pairs(useBannerItemList) do
        local posX = v:GetBannerLocalPosX()
        if not upLeftPosX or upLeftPosX > posX then
            upLeftPosX = posX
            upLeftBannerIndex = k
        end
        if not upRightPosX or upRightPosX < posX then
            upRightPosX = posX
            upRightBannerIndex = k
        end
        v:SetBannerIsUpLeft(false)
        v:SetBannerIsUpRight(false)
    end

    if upLeftBannerIndex then
        upLeftIndex = upLeftBannerIndex
        useBannerItemList[upLeftBannerIndex]:SetBannerIsUpLeft(true)
    else
        log.log("错误缺少最左侧的banner")
    end
    if upRightBannerIndex then
        upRightIndex = upRightBannerIndex
        useBannerItemList[upRightBannerIndex]:SetBannerIsUpRight(true)
    else
        log.log("错误缺少最右侧的banner")
    end
end

--获取宽度
function HallCityBannerView:GetTotalWidth()
    local showNum = useBannerNum
    return showNum * bannerItemWidth
end

function HallCityBannerView:GetBannerItemLocalPosX(index)
    local posX = (index - 1) * bannerItemWidth
    return posX
end

--设置Content宽度
function HallCityBannerView:SetContentWidth()
    local width = self:GetTotalWidth()
    self.Content.transform.sizeDelta = Vector3.New(width , contenHeight)
end

--初始设置边界
function HallCityBannerView:InitBilateralPos()
    local cameraObj = fun.GameObject_find("Canvas/Camera")
    if cameraObj then
        camera = fun.get_component(cameraObj, "Camera")
    end
    leftLinePosX = camera:WorldToScreenPoint(self.ctrlDragtestLeft.transform.position).x
    rightLinePosX = camera:WorldToScreenPoint(self.ctrlDragtestRight.transform.position).x
    widthViewPort =  rightLinePosX - leftLinePosX
    log.log("海报状态检查 OnEnable" , widthViewPort)
end

function HallCityBannerView:OnEnable(params) 
    self:CheckLastBannerUse()
    self:InitBilateralPos()
    self:InitUseBannerItemList()
    self:SetMainCanvasGroup()
    self:CreatBannerList()
    self:InitUseToggle()
    self:InitDrag()
    self:EnableToAutoMoveBanne()
    Facade.RegisterView(self)
    log.r("HallCityBannerView HallCityBanner.AddBannerItem")
    Event.AddListener(NotifyName.HallCityBanner.RemoveBannerItem,self.RemoveBannerItem,self)
    Event.AddListener(NotifyName.HallCityBanner.AddBannerItem,self.AddBannerItem,self)
end

--重新打开时 检查上次创建的banner可用
function HallCityBannerView:CheckLastBannerUse()
    local deleteList = {}
    hasCreatUseBannerNum = 0
    for k , v in pairs(useBannerItemList) do
        local bannerId = v:GetBannerId()
        if not self:CheckBannerUse(bannerId)  then
            if bannerId == nil then
                log.r("错误的空bannerId")
            else
                deleteList[bannerId] = true
            end
        else
            hasCreatUseBannerNum = hasCreatUseBannerNum + 1
        end
    end

    log.log("已创建的过期了删除" , deleteList)
    for k , v in pairs(deleteList) do
        self:RemoveBannerItem(k)            
    end
end

function HallCityBannerView:ReopenItemFunc()
    for k ,v in pairs(useBannerItemList) do
        v:ReopenFunc()
    end
end

function HallCityBannerView:OnDestroy()
    isPause = false
    log.log("海报状态检查 OnDestroy" )
    Event.RemoveListener(NotifyName.HallCityBanner.RemoveBannerItem,self.RemoveBannerItem,self)
    Event.RemoveListener(NotifyName.HallCityBanner.AddBannerItem,self.AddBannerItem,self)
    lastUseToggleIndex = 1
    creatInsertBannerId = nil
    hasCreatUseBannerNum = 0
    waitCreatBannerList = {}
    useBannerNum = 0
    self:ChangeIsAutoMoveState(false)
    self:StopAutoMove()
    self:ClearDragEndToAutoMoveBannerTimer()
    self:ClearAutoMoveBannerContinueTimer()
    self:ClearBannerMoveEndOffsetTimer()
    self:DestroyAllBanner()
    Facade.RemoveView(self)
    self:Close()
end

function HallCityBannerView:DestroyAllBanner()
    for k ,v in pairs(useBannerItemList) do
        v:CloseBanner()
    end
    useBannerItemList = {}
end

function HallCityBannerView:OnDisable()
    isPause = true
    self:PauseAutoMove()
    self:ClearDragEndToAutoMoveBannerTimer()
    self:ClearAutoMoveBannerContinueTimer()
    self:ClearBannerMoveEndOffsetTimer()
    -- self:StopAutoMove()
    self:ChangeIsAutoMoveState(false)
end

function HallCityBannerView:CloseBannerView()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function HallCityBannerView:CheckBannerIdExist(bannerId)
    for k ,v in pairs(useBannerItemList) do
        if v:GetBannerId() == bannerId then
            return true
        end
    end
    return false
end

function HallCityBannerView:AddInsertBannerList(bannerId)
    insertBannerList[bannerId] = true
end

function HallCityBannerView:RemoveInsertBannerList(bannerId)
    insertBannerList[bannerId] = nil
end

function HallCityBannerView:GetCreatInsertBannerBannerId()
    local bannerId = nil
    for k ,v in pairs(insertBannerList) do
        bannerId = k
        break
    end
    return bannerId
end

function HallCityBannerView:CheckInsertBannerFinish()
    return GetTableLength(insertBannerList) == 0
end

--添加banner
function HallCityBannerView:AddBannerItem(bannerId)
    if not self.go or fun.get_active_self(self.go) == false then
        log.log("banner不可见 不生成新的" , bannerId)
        return
    end
    if self:CheckBannerIdExist(bannerId) then
        log.log('存在相同的banner 不能重复添加')
        return
    end
    self:AddInsertBannerList(bannerId)
    if creatInsertBannerId then
        --创建中
        return
    end
    self:StartCreatInsertBanner()
end

function HallCityBannerView:StartCreatInsertBanner()
    creatInsertBannerId = self:GetCreatInsertBannerBannerId()
    isLimitDrag = true
    self:StopAutoMove()
    self:ClearResetBannerItemOffset()
    self:ChangeIsAutoMoveState(false)
    self:InitBannerView(creatInsertBannerId , function()
        self:RemoveInsertBannerList(creatInsertBannerId)
        creatInsertBannerId = nil
        if self:CheckInsertBannerFinish() then
            --全部创建完了
            self:ResetUseBanner()
            self:InitUseToggle()
            self:OrderBannnerList()
            self:ChangeIsAutoMoveState(true)
            self:DragEndToAutoMoveBanner()    
            isLimitDrag = false
            self:SetMainCanvasGroup()
        else
            self:StartCreatInsertBanner()
        end
    end)
end


--删除banner
function HallCityBannerView:RemoveBannerItem(bannerId)
    local removeIndex = nil
    for k , v in pairs(useBannerItemList) do
        if v:GetBannerId() == bannerId then
            removeIndex = k
            break
        end
    end
    for k , v in pairs(useBannerItemList) do
        if v:GetBannerId() == nil then
            table.remove(useBannerItemList , k)
        end
    end
    if removeIndex then
        isLimitDrag = true
        self:ClearResetBannerItemOffset()
        self:StopAutoMove()
        self:ChangeIsAutoMoveState(false)
        useBannerItemList[removeIndex]:CloseBanner()
        table.remove(useBannerItemList , removeIndex)
        -- log.log("移除后检查" , removeIndex , useBannerItemList)
        self:ResetUseBanner()
        self:InitUseToggle()
        self:OrderBannnerList()
        self:ChangeIsAutoMoveState(true)
        self:DragEndToAutoMoveBanner()    
        isLimitDrag = false
        self:SetMainCanvasGroup()
    end
end

--取消自动滚动
--如果有插入banner或者删除banner要先使用这个
function HallCityBannerView:StopAutoMove()
    if self.autoMoveFunc then
       -- log.log("自动移动检查 Kill")
        self.autoMoveFunc:Kill()
        self.autoMoveFunc = nil
    end
end

--暂停动画
function HallCityBannerView:PauseAutoMove()
    if self.autoMoveFunc then
     --   log.log("自动移动检查 Pause")
        self.autoMoveFunc:Pause()
    end
end

--继续动画
function HallCityBannerView:PlayAutoMove()
    if isPause and self.autoMoveFunc then
        self:ChangeIsAutoMoveState(true)
        log.log("自动移动检查 Play")
        self.autoMoveFunc:Play()
    end
end

--banner自动移动 玩家点击时取消自动移动
function HallCityBannerView:AutoMoveBanner()
    if not self:CheckBannerNumAllowMove() then
        log.log("自动移动检查 禁止移动")
        return
    end
    if self.autoMoveFunc then
        log.log("自动移动检查 已经在自动滚动")
        return
    end
    self:ChangeIsAutoMoveState(true)
    local distanceStart = 0
    local distanceEnd  = bannerItemWidth  --每次自动切换一个banner宽度
    local moveTime = self:GetBannerAutoMoveUseTime()
    self:StopAutoMove()
    self.autoMoveFunc = Anim.do_smooth_int2_tween(self.textCountDown,distanceStart,distanceEnd,moveTime,DG.Tweening.Ease.InFlash,function(currentDistance)
        if not self:CheckIsAutoMoveState() then
            --打断自动
            log.log("自动移动检查 被打断了")
            self:StopAutoMove()
        else
            self:ResetBannerItemPos(-currentDistance)
            self:CheckResetBilateral()
        end
    end,function()
        if self:CheckIsAutoMoveState() then
            self:ResetBannerItemInitPos()
            self:AutoMoveBannerContinue() --继续下次自动移动
        else
            log.log("自动移动检查 结束 被打断了")
        end
        self:MoveChangeUseToggle()
        self:StopAutoMove()
    end)
end

--自动移动结束一次 继续下一次
function HallCityBannerView:AutoMoveBannerContinue()
    local timeOffset = self:GetBannerAutoMoveIntervalTime()
    self:ClearAutoMoveBannerContinueTimer()
    self.autoMoveBannerContinueTimer = LuaTimer:SetDelayFunction(timeOffset, function()
        if self:CheckIsAutoMoveState() then
            --还是自动移动状态 可以继续
            self:AutoMoveBanner()
        else
            --被打断过
        end
        self:ClearAutoMoveBannerContinueTimer()
    end)
end

function HallCityBannerView:ClearAutoMoveBannerContinueTimer()
    if self.autoMoveBannerContinueTimer then
        LuaTimer:Remove(self.autoMoveBannerContinueTimer)
        self.autoMoveBannerContinueTimer = nil
    end
end

--打开时 检查自动移动
function HallCityBannerView:EnableToAutoMoveBanne()
    if isPause then
        local needWait = true
        if  self.autoMoveFunc then
            needWait = false
            self:ChangeIsAutoMoveState(true)
            log.log("自动移动检查 继续播放动画")
            self.autoMoveFunc:Play()
        end
        for k ,v in pairs(useBannerItemList) do
            v:ReopenFunc()
        end

        if needWait then
            isLimitDrag = true
            local waitTime = self:GetBannerDragToAutoMoveIntervalTime()
            LuaTimer:SetDelayFunction(waitTime, function()
                self:ResetetBannerBilateral()
                self:ResetBannerItemInitPos()
                isLimitDrag = false
                log.log("拖拽禁用中 重新启用")
                self:DragEndToAutoMoveBanner()
                self:ClearBannerMoveEndOffsetTimer()
            end,nil,LuaTimer.TimerType.UI)
        end

    else
        self:CheckToAutoMoveBanner()
    end
end

function HallCityBannerView:CheckToAutoMoveBanner()
    if self:CheckBannerUnEnable() then
        self:DragEndToAutoMoveBanner()
    end
end

--拖拽结束并回弹后 检查自动移动
function HallCityBannerView:DragEndToAutoMoveBanner()
    self:ChangeIsAutoMoveState(true)
    local timeOffset = self:GetBannerDragToAutoMoveIntervalTime()
    self:ClearDragEndToAutoMoveBannerTimer()
    self.dragEndToAutoMoveBannerTimer = LuaTimer:SetDelayFunction(timeOffset, function()
        if self:CheckIsAutoMoveState() then
            --还是自动移动状态 可以继续
            self:AutoMoveBanner()
        else
            --被打断过 取消自动移动
        end
        self:ClearDragEndToAutoMoveBannerTimer()
    end,nil,LuaTimer.TimerType.UI)
end

function HallCityBannerView:ClearDragEndToAutoMoveBannerTimer()
    if self.dragEndToAutoMoveBannerTimer then
        LuaTimer:Remove(self.dragEndToAutoMoveBannerTimer)
        self.dragEndToAutoMoveBannerTimer = nil
    end
end

--banner位移结束 检查自动位移到完整显示最近的banner
function HallCityBannerView:BannerMoveEndOffset()
    local offsetBannerIndex = self:GetUseIndex()
    local bannerItem = useBannerItemList[offsetBannerIndex]
    --- firebase提示的报错
    if  fun.is_null (bannerItem) then
        return
    end
    local distance = bannerItem:GetBannerLocalPosX()
    -- log.log("判断自动补齐数据" , offsetBannerIndex , bannerItem.go.name  , distance  , math.abs(distance) >= offsetDistance)
    local isLeft = distance < 0
    self:ClearBannerMoveEndOffsetTimer()
    if math.abs(distance) >= offsetDistance then
        isLimitDrag = true
        self:MoveChangeUseToggle()
        self:ResetBannerItemOffset(-distance)
        local delayTime = self:GetBannerDragToAutoMoveIntervalTime()
        self.bannerMoveEndOffsetTimer = LuaTimer:SetDelayFunction(delayTime, function()
            self:ResetetBannerBilateral()
            self:ResetBannerItemInitPos()
            isLimitDrag = false
            log.log("拖拽禁用中 重新启用")
            self:DragEndToAutoMoveBanner()
            self:ClearBannerMoveEndOffsetTimer()
        end,nil,LuaTimer.TimerType.UI)
    else
        --距离近 不处理
        self:DragEndToAutoMoveBanner()
        self:MoveChangeUseToggle()
    end
end

function HallCityBannerView:ClearBannerMoveEndOffsetTimer()
    if self.bannerMoveEndOffsetTimer then
        LuaTimer:Remove(self.bannerMoveEndOffsetTimer)
        self.bannerMoveEndOffsetTimer = nil
    end
end

--检查banner数量足够移动
function HallCityBannerView:CheckBannerNumAllowMove()
    if useBannerNum <= 1 then
        return false
    end
    return true
end

--位置变化 修改显示中的toggle
function HallCityBannerView:MoveChangeUseToggle()
    local useIndex = self:GetUseIndex()
   -- log.log("滚动红点使用" , useIndex)
    self:ToggleChange(useIndex)
end

function HallCityBannerView:GetUseIndex()
    local offsetBannerIndex = nil
    local distance = nil
    for k ,v in pairs(useBannerItemList) do
        local posX = v:GetBannerLocalPosX()
        local currentDistance = posX
        if not distance or math.abs(distance) > math.abs(currentDistance) then
            distance = currentDistance
            offsetBannerIndex = k
        end
    end
    return offsetBannerIndex
end

--获取自动切换banner间隔 每X秒移动一次 一次移动一个banner格子的距离 （需要用配置数据）
function HallCityBannerView:GetBannerAutoMoveIntervalTime()
    return 2
end

--拖拽结束后 自动补齐开始到可以拖动时间 自动补齐动画时间是1秒
function HallCityBannerView:GetBannerDragToAutoMoveIntervalTime()
    return 1.5
end

--获取自动切换banner完成一块位移时间
function HallCityBannerView:GetBannerAutoMoveUseTime()
    return 1
end

-- 检查还是否满足互导需求
function HallCityBannerView:CheckBravoGuideCouldPop()
    local groupUser = Csv.GetData("user_group_info",39,"group_id")
    local inGroup = ModelList.PlayerInfoModel:IsGroupId(groupUser)  --测试 --是否在群组中
    local CheckPopTime =  Csv.GetControlByName("diversion_max")[1][1]
    local PopTime = fun.read_value("PopupBravoHelpGuidePosterOrder_Poptime",0); --在当前弹出次数

    if inGroup and PopTime <= CheckPopTime then 
        return true
    end 
    return false 
end 

return this