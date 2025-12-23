--require "View/CommonView/TopCurrencyView"

local PuzzleOriginalState =  require "State/PuzzleView/PuzzleOriginalState"
local PuzzleEnterState =  require "State/PuzzleView/PuzzleEnterState"
local PuzzleExitState =  require "State/PuzzleView/PuzzleExitState"
local PuzzleAvailableState =  require "State/PuzzleView/PuzzleAvailableState"
local PuzzleDisabledState =  require "State/PuzzleView/PuzzleDisabledState"
local PuzzleAddPiecesState =  require "State/PuzzleView/PuzzleAddPiecesState"
local PuzzleFlyRewardState =  require "State/PuzzleView/PuzzleFlyRewardState"
local PuzzleFlyBigRewardState =  require "State/PuzzleView/PuzzleFlyBigRewardState"

local puzzleCardView = require("View/PuzzleView/PuzzleCardView")
local puzzleCardInstance = nil

local puzzleStageView = require "View/PuzzleView/PuzzleStageView"
local puzzleStageCache = nil

local PuzzleView = TopBarControllerView:New("PuzzleView","PuzzleAtlas")
local this = PuzzleView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog
this.isCleanRes = true
--local _currency = TopCurrencyView:New(nil,nil,"PuzzleView",false,nil,RedDotNode.puzzle_top_shop)
--local rewardItemsCache = nil
local _curPuzzleId = nil
local addpieces_effect = nil

local PuzzleBtnState = {addpieces = 1,playbingo = 2,gameEndShow = 3,gameEndGray = 4}
local buttonState = nil

local waitForServerResphoneTimer = nil
local retryCount = nil

local bigRewardView = nil

this.auto_bind_ui_items = {
    --"topCurrency",
    --"btn_goback",
    --"reward_content",
    --"reward_item",
    "btn_addPieces",
    "item_hook",
    "nopieces",
    "img_background",
    "text_level",
    "text_process",
    "text_num",
    --"text_tip",
    "anima",
    "btn_rewardBox_small",
    "img_AddPieces",
    --"text_playbingotip",
    "btn_continue",
    "picture1",
    "picture2",
    "picture3",
    "picture4",
    "picture5",
    "slider_progress",
    "Toggle_index1",
    "Toggle_index2",
    "Toggle_index3",
    "Toggle_index4",
    "Toggle_index5",
    "rewardBox_big",
    --"drop_anima",
    "slider_pieces",
    "img_reddot",
    "level",   --标题
    "DoubleDayfFlag", --双倍Flag
    "text_level2",
    "hongkuan",   --整个红框
    "btn_speedUp",
    --"anima_bigReward"
}

function PuzzleView:OpenView(callback)
    Facade.SendNotification(NotifyName.ShowUI,this,function()
        if callback then
            callback()
        end
    end)
end

function PuzzleView:CloseView(callback)
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function PuzzleView:HideCoverageEntity()
    self:NotifyHideCoverageEntity()
end

function PuzzleView:ShowCoverageEntity()
    self:NotifyShowCoverageEntity()
end

function PuzzleView:Awake(obj)
    self:on_init()

    --唤醒的时候先隐藏
    fun.set_active(self.hongkuan,false)
    fun.set_active(self.DoubleDayfFlag,false)
end

function PuzzleView:OnEnable(params)
    Facade.RegisterView(self)
    --_currency:SkipLoadShow(self.topCurrency)
    if params then
        self._exit_callback = params
        --_currency:SetActive(false)
        fun.set_active(self.img_background,false,false)
        --fun.set_active(self.btn_goback.transform,false,false)
    end
    self:LoadBigReward(function()
        self:SetButtonShow(true)
        self:CheckPuzzleCard(true)
        self:CheckPuzzleStage()
        self:SetPuzzleInfo()
        self:BuildFsm()
        self._fsm:GetCurState():Change2Enter(self._fsm)
    
        self:RegisterRedDotNode()
    
        this:initSpeedUp()
    end)
end

function PuzzleView:LoadBigReward(callback)
    local rewards = ModelList.PuzzleModel:GetPuzzleStageReward()
    local count = #rewards
    Cache.Load_Atlas(AssetList["PuzzleAtlas"],"PuzzleAtlas",function()
        local assetName = string.format("puzzle%sRewards",count)
        Cache.load_prefabs(AssetList["PuzzleView"],assetName,function(obj)
            if obj then
                if bigRewardView then
                    bigRewardView:Destroy()
                end
                local go = fun.get_instance(obj.transform,self.rewardBox_big)
                local view = require "View/PuzzleView/PuzzleViewBigReward"
                bigRewardView = view:New(count)
                bigRewardView:SkipLoadShow(go)
                if puzzleCardView then
                    puzzleCardView:PreloadPuzzleCardRes(callback)
                end
                --
                --if callback then
                --    callback()
                --end
            end
        end)
    end)


end

function PuzzleView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.puzzle_reddot_event,"PuzzleView",self.img_reddot)
end

function PuzzleView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.puzzle_reddot_event,"PuzzleView")
end

function PuzzleView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("PuzzleView",self,{
        PuzzleOriginalState:New(),
        PuzzleEnterState:New(),
        PuzzleExitState:New(),
        PuzzleAvailableState:New(),
        PuzzleDisabledState:New(),
        PuzzleAddPiecesState:New(),
        PuzzleFlyRewardState:New(),
        PuzzleFlyBigRewardState:New()
    })
    self._fsm:StartFsm("PuzzleOriginalState")

    UISound.play("puzzle_open")
end

function PuzzleView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function PuzzleView:CheckPuzzleStage()
    local puzzleStageData = ModelList.PuzzleModel:GetPuzzleStageData()
    local cur_index = ModelList.PuzzleModel:PuzzleStageIndex()
    local pictures = {self.picture1,self.picture2,self.picture3,self.picture4,self.picture5}
    if puzzleStageData then
        puzzleStageCache = puzzleStageCache or {}
        for index, value in ipairs(puzzleStageData) do
            if puzzleStageCache[index] == nil then
                local stageView = puzzleStageView:New(value,index)
                puzzleStageCache[index] = stageView
                stageView:SkipLoadShow(pictures[index],true,nil)
            else
                puzzleStageCache[index]:RefreshData(value,index)
                puzzleStageCache[index]:RefreshShow()
            end
        end
    end
    local toggle_index_list = {self.Toggle_index1,self.Toggle_index2,self.Toggle_index3,self.Toggle_index4,self.Toggle_index5}
    for key, value in pairs(toggle_index_list) do
        value.isOn = key < cur_index
    end

    self.slider_progress.value = (cur_index - 1) / 4
end

function PuzzleView:CheckPuzzleProgress()
    local cur_index = ModelList.PuzzleModel:PuzzleStageIndex()
    if puzzleStageCache then
        puzzleStageCache[cur_index]:CheckFlyStar(bigRewardView:GetBigRewardPos(),function(isFly,isEnd)
            if isFly then
                bigRewardView:PlayBigRewardPosed(function()
                    if isEnd then
                        self:CheckState()
                    end
                end)
            else
                self:CheckState()
            end
        end)
    end
end

function PuzzleView:CheckPuzzleCard(isfirst)
    local puzzleId = ModelList.PuzzleModel:GetPuzzleId()
    --Assert(puzzleId ~= nil, "puzzleid is nil")
    if _curPuzzleId ~= puzzleId then
        _curPuzzleId = puzzleId
        --local puzzle_cards= Csv.GetData("puzzle_card",puzzleId)
        --log.r("====================================>>puzzleId " .. puzzleId)
        local need = Csv.GetData("puzzle_card",puzzleId,"need")
        --Assert(puzzle_res ~= nil,"puzzle_res is nil")
        --local atlas_name = puzzle_res .. "Atlas"
        --Cache.Load_Atlas(AssetList[atlas_name],atlas_name,function()
            local res_name = string.format("Puzzle%sPiece",need)
            Cache.load_prefabs(AssetList[res_name],res_name,function(obj)
                if puzzleCardInstance then
                    puzzleCardInstance:DestroyPuzzleCard()
                end
                local go = fun.get_instance(obj,self.item_hook)
                fun.set_gameobject_pos(go,0,0,0,true)
                puzzleCardInstance = puzzleCardView:New()
                puzzleCardInstance:SkipLoadShow(go,true,nil)
                if not isfirst then
                    self:CheckState()
                end
            end)
        --end)
    elseif puzzleCardInstance then
        puzzleCardInstance:SetState()    
    end
end

function PuzzleView:CheckState(isEnter)
    local completed = ModelList.PuzzleModel:IsCurPuzzleCompleted()
    local rewarded = ModelList.PuzzleModel:IsCurPuzzleRewarded()
    local piecesNum = ModelList.PuzzleModel:GetPuzzlePiecesNum()

    local stageComplete = ModelList.PuzzleModel:IsPuzzleStageCompleted()
    local stageRewarded = ModelList.PuzzleModel:IsPuzzleStageReward()
    if completed and (not rewarded) then
        self._fsm:GetCurState():Change2FlyReward(self._fsm,isEnter)
    elseif stageComplete and (not stageRewarded) then
        self._fsm:GetCurState():Change2FlyBigReward(self._fsm,isEnter)
    elseif piecesNum > 0 then
        self._fsm:GetCurState():Change2Available(self._fsm,isEnter)
    else
        self._fsm:GetCurState():Change2Disable(self._fsm,isEnter)
    end
end

function PuzzleView:SetPuzzleInfo()
    local puzzleId = ModelList.PuzzleModel:GetPuzzleId()
    local OpenType =  ModelList.PuzzleModel:GetViewType()
    local PuzzleOpen = ModelList.ActivityModel:IsActivityAvailable(ActivityTypes.doublePuzzle) --拼图活动开启
    
    if OpenType == 1 then 
        PuzzleOpen = ModelList.BattleModel.GetBattlePuzzleDouble()
    end 
    
    if puzzleId then
        local curIndex = ModelList.PuzzleModel:GetCurPuzzleIndex()
        --local totalIndex = ModelList.PuzzleModel:GetTotalPuzzleIndex()
       -- self.text_level.text = tostring(curIndex + 1)
        fun.set_active(self.text_level2,false)
        if PuzzleOpen then 
            fun.set_active(self.text_level2,true)
            fun.set_active(self.text_level,false)
            self.text_level2.text = tostring(curIndex + 1)
         --   self.text_level.spriteAsset = resMgr:GetSpriteAsset("luaprefab_fonts_puzzle_font_puzzle","font_puzzle")
        else 
             fun.set_active(self.text_level2,false)
             fun.set_active(self.text_level,true)  
            self.text_level.text = tostring(curIndex + 1)
         --   self.text_level.spriteAsset = resMgr:GetSpriteAsset("luaprefab_fonts_puzzle_font_puzzleDouble","font_puzzleDouble")
            
        end 

        local curProcess = ModelList.PuzzleModel:GetCurPuzzlePorcess()
        local targetProcess = ModelList.PuzzleModel:GetCurPuzzleTarget()
        --self.text_process.text = string.format("%d/%d",curProcess,targetProcess)
        --self.slider_pieces.value = curProcess / targetProcess
        self.text_num.text = tostring(ModelList.PuzzleModel:GetPuzzlePiecesNum())
        Anim.slide_to_num(self.slider_pieces,self.text_process,curProcess,targetProcess,0.35)
    end
  
    if PuzzleOpen then --拼图活动是否开启
       self.level.sprite = AtlasManager:GetSpriteByName("CommonAtlas", "pTitleRed")
    else 
        self.level.sprite = AtlasManager:GetSpriteByName("CommonAtlas", "pTitle")
    end 
end

function PuzzleView:SetButtonShow(isInit)
    local pieces = ModelList.PuzzleModel:GetPuzzlePiecesNum()
    if self._exit_callback then
        if pieces <= 0 then
            buttonState = PuzzleBtnState.gameEndGray
            fun.set_active(self.btn_addPieces.transform,false)
            --fun.set_active(self.text_playbingotip,false,false)
            if isInit then
                fun.set_active(self.nopieces.transform,true)
                self:PlayIdle()
            else
                self:playChangeContinu()
            end
        elseif pieces > 0 then
            buttonState = PuzzleBtnState.addpieces
            Cache.SetImageSprite("PuzzleAtlas","pFontAddPieces",self.img_AddPieces)
            fun.set_active(self.nopieces.transform,false)
            --fun.set_active(self.text_playbingotip,false,false)
            self:PlayIdle()
        end
    else
        if pieces <= 0 then
            buttonState = PuzzleBtnState.playbingo
            Cache.SetImageSprite("PuzzleAtlas","pFontplaybingo",self.img_AddPieces)
            --fun.set_active(self.text_playbingotip,true,false)
        elseif pieces > 0 then
            buttonState = PuzzleBtnState.addpieces
            Cache.SetImageSprite("PuzzleAtlas","pFontAddPieces",self.img_AddPieces)
            --fun.set_active(self.text_playbingotip,false,false)
        end
        fun.set_active(self.nopieces,false)
        self:PlayIdle()
    end
end

function PuzzleView:on_btn_rewardBox_small_click()
    --local reward= ModelList.PuzzleModel:GetCurPuzzleReward()
    local puzzleId = ModelList.PuzzleModel:GetPuzzleId()
    local rewards = Csv.GetData("puzzle_card",puzzleId)
    if rewards then
        local params = {
            rewards = rewards.reward, 
            pos = self.btn_rewardBox_small.transform.position, 
            dir = RewardShowTipOrientation.down, 
            offset = Vector3.New(0,130,0),
            exclude = {self.btn_rewardBox_small}
        }
        Facade.SendNotification(NotifyName.ShowUI,ViewList.RewardShowTipView,nil,false,params)
    end
end

function PuzzleView:PlayEnter()
    AnimatorPlayHelper.Play(self.anima,"PuzzleViewenter",false,function()
        self:CheckState()

        local pos = ModelList.CityModel:GetCity()
        local curProcess = ModelList.PuzzleModel:GetCurPuzzlePorcess()
        local targetProcess = ModelList.PuzzleModel:GetCurPuzzleTarget()
        local stage = ModelList.PuzzleModel:GetCurPuzzleIndex() + 1
        local puzzlestocks = ModelList.PuzzleModel:GetPuzzlePiecesNum()
        local data = {pos = pos,stage = stage,progress = string.format("%s/%s",curProcess,targetProcess),puzzlestocks = puzzlestocks }
        local OpenType =  ModelList.PuzzleModel:GetViewType()
        local PuzzleOpen = ModelList.ActivityModel:IsActivityAvailable(ActivityTypes.doublePuzzle) --拼图活动开启
        
        if OpenType == 1 then 
            PuzzleOpen = ModelList.BattleModel.GetBattlePuzzleDouble()
        end 

        SDK.puzzle_open(data)

        if PuzzleOpen then 
            fun.set_active(self.hongkuan,true)
            fun.set_active(self.DoubleDayfFlag,true)
        end 

    end)
end

function PuzzleView:PlayExit()
    self:ShowCoverageEntity()
    AnimatorPlayHelper.Play(self.anima,{"PuzzleViewexit","PuzzleViewexit"},false,function()
        self:CloseView()
        Facade.SendNotification(NotifyName.SceneCity.HomeScene_promotion)
    end)
end

function PuzzleView:ResetAllStage()
    if puzzleStageCache then
        for key, value in pairs(puzzleStageCache) do
            value:InitStarsShow()
        end
    end
end

function PuzzleView:PlayTurnPage(isStage)
    local func = function()
        self:LoadBigReward(function()
            AnimatorPlayHelper.Play(self.anima,"PuzzleViewtrun",false,0.15,function()
                UISound.play("puzzle_next")
                self:CheckPuzzleCard(true)
                self:SetPuzzleInfo()
            end,function()
                self:CheckState()
            end)
        end)
    end
    if isStage then
        AnimatorPlayHelper.Play(self.anima,{"dropChange","dropChange"},false,0.2,function()
            self:CheckPuzzleStage()
            self:ResetAllStage()
            bigRewardView:PlayBingRewardRaw()
        end,function()
            func()
        end)
    else
        local cur_index = ModelList.PuzzleModel:PuzzleStageIndex()
        if puzzleStageCache[cur_index - 1] then
            puzzleStageCache[cur_index - 1]:PlayPictureComplete()
        end
        if puzzleStageCache[cur_index] then
            puzzleStageCache[cur_index]:PlayPictureUnLock(function()
                self:CheckPuzzleStage()
            end)
        else
            self:CheckPuzzleStage()    
        end
        func()
    end
end

function PuzzleView:PlayTurnStagePage()
    puzzleStageCache[5]:PlayPictureComplete(function()
        self:CheckState()
    end)
    self:CheckPuzzleStage()
end

function PuzzleView:PlayIdle()
    AnimatorPlayHelper.Play(self.anima,"PuzzleViewenteridle",false,nil)
end

function PuzzleView:PlayNone()
    AnimatorPlayHelper.Play(self.anima,"PuzzleViewNone",false,nil)
end

function PuzzleView:playChangeContinu()
    AnimatorPlayHelper.Play(self.anima,"PuzzleViewenterChange",false,nil)
end

function PuzzleView:playChangeContinuIdle()
    AnimatorPlayHelper.Play(self.anima,"PuzzleViewChangeidle",false,nil)
end

function PuzzleView:SetDisable(isEnter)
    self:CheckPuzzleCard()
    self:SetPuzzleInfo()
    self:SetButtonShow(isEnter)
    bigRewardView:PlayBingRewardRaw()
end

function PuzzleView:SetAvailable(isEnter)
    self:CheckPuzzleCard()
    self:SetPuzzleInfo()
    self:SetButtonShow(isEnter)
    fun.set_active(self.nopieces,false)
    Util.SetUIImageGray(this.btn_addPieces, false)
    bigRewardView:PlayBingRewardRaw()
end

function PuzzleView:SetFlyReward(isEnter)
    self:CheckPuzzleCard()
    self:SetPuzzleInfo()
    self:PopupClaimReward()
end

function PuzzleView:ShowOrHide(flag)
    fun.set_active(self.btn_rewardBox_small,flag)
end

function PuzzleView:SetFlyStageReward(isEnter)
    self:CheckPuzzleCard()
    self:SetPuzzleInfo()
    bigRewardView:PlayBigRwardMature(function()
        self:PopupStageReward()
    end)
end

function PuzzleView:OnDisable()
    Facade.RemoveView(self)
    if CityHomeScene then
        CityHomeScene:SetEnterHallFromUI(true)
    end
    --rewardItemsCache = nil
    _curPuzzleId = nil
    addpieces_effect = nil
    buttonState = nil
    puzzleStageCache = nil
    retryCount = nil
    puzzleCardInstance = nil
    bigRewardView = nil
    self._exit_callback = nil
    self:StopWaitTimer()
    self:UnRegisterRedDotNode()
    if ModelList.PuzzleModel:GetViewType() == 1 then 
        UnityEngine.Time.timeScale = 1
    end 
    ModelList.PuzzleModel:SetViewType(0)
    -- 停止 结算bgm
    UISound.stop_loop("settlement_bgm")
    AssetManager.unload_ab(
            {AssetList["Puzzle16Piece"],
            AssetList["Puzzle36Piece"],
            AssetList["Puzzle100Piece"],
            AssetList["Puzzle196Piece"],
            AssetList["Puzzle256Piece"],
            AssetList["Puzzle324Piece"],
            })
end

function PuzzleView:on_close()
    --rewardItemsCache = nil
    self._exit_callback = nil
end

function PuzzleView:StopWaitTimer()
    if waitForServerResphoneTimer then
        waitForServerResphoneTimer:Stop()
        waitForServerResphoneTimer = nil
    end
end

function PuzzleView:CloseTopBarParent()
    if self and self._fsm then
        self._fsm:GetCurState():Goback(function()
            if self._exit_callback then
                self._exit_callback()
                self._exit_callback = nil
            else
                self._fsm:GetCurState():Change2Exit(self._fsm)
            end
        end)
    end
end

function PuzzleView:on_btn_addPieces_click()
    if buttonState == PuzzleBtnState.addpieces then
        self._fsm:GetCurState():AddPieces(self._fsm)
    elseif buttonState==PuzzleBtnState.gameEndGray then
        self:CloseTopBarParent()
    elseif buttonState == PuzzleBtnState.playbingo then 
        self:CloseView()
        if CityHomeScene:IsSelectCity() then   
            Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter)
        else
            Facade.SendNotification(NotifyName.SceneCity.HomeScene_promotion)
        end
       
    else 
        self:CloseView()
    end
end

function PuzzleView:on_btn_continue_click()
    self:CloseTopBarParent()
end

function PuzzleView:OnAddPieces()
    Util.SetUIImageGray(self.btn_addPieces, true)
    local city = ModelList.CityModel:GetCity()
    local puzzleIndex = ModelList.PuzzleModel:GetCurPuzzleIndex()
    puzzleCardInstance:CopyPuzzleState()
    ModelList.PuzzleModel:C2S_Pieces2Puzzle(city,puzzleIndex)
    self:PlayNone()
end

function PuzzleView.OnAddPiecesResult()
    this._fsm:GetCurState():ServerRespone()
    
    local addPieces = function()
        Util.PlayParticle(addpieces_effect)
        UISound.play("puzzle_use")
        this:register_invoke(function()
            if puzzleCardInstance then
                fun.set_active(addpieces_effect.transform, false, false)
                puzzleCardInstance:PlayPuzzleAddPiecesEffect(function()
                    Util.SetUIImageGray(this.btn_addPieces, false)
                    RedDotManager:Refresh(RedDotEvent.puzzle_reddot_event)
                    this._fsm:GetCurState():AddPiecesResult(this._fsm)
                end)
            end
        end, 2)
    end

    if addpieces_effect == nil then
        Cache.load_prefabs(AssetList["puzzleAddPieces"],"puzzleAddPieces",function(obj)
            if obj then
                addpieces_effect = fun.get_instance(obj)
                if addpieces_effect then
                    fun.set_parent(addpieces_effect,this.btn_addPieces,true)
                    addPieces()
                end
            end
        end)
    else
        addPieces()
    end
end

function PuzzleView:PopupClaimReward()
    local puzzleId = ModelList.PuzzleModel:GetPuzzleId()
    local rewards = Csv.GetData("puzzle_card",puzzleId)
    if rewards then
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.claimReward,rewards.reward,self.Tap2ClaimCallback,nil,ClaimRewardAnimation.puzzle)
    end
end

function PuzzleView:PopupStageReward()
    --[[
    AnimatorPlayHelper.Play(this.anima,{"dropFly","dropFly"},false,function()
        local rewards = ModelList.PuzzleModel:GetPuzzleStageReward()
        if rewards then
            Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.claimRewardBox,rewards,self.Tap2ClaimStageRewardCallback,nil,ClaimRewardAnimation.puzzleStage)
        end
    end)
    --]]
    local rewards = ModelList.PuzzleModel:GetPuzzleStageReward()
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,rewards,function()
        self.Tap2ClaimStageRewardCallback()
    end)
end

function PuzzleView.Tap2ClaimCallback()
    this:SetServerResphoneTimeOutBehavior()
    local city = ModelList.CityModel:GetCity()
    local puzzleIndex = ModelList.PuzzleModel:GetCurPuzzleIndex()
    ModelList.PuzzleModel:C2S_RequestPuzzleAward(city,puzzleIndex)
end

function PuzzleView.Tap2ClaimStageRewardCallback()
    this:SetServerResphoneTimeOutBehavior()
    ModelList.PuzzleModel:C2S_RequestPuzzleStageReward()
end

function PuzzleView:SetServerResphoneTimeOutBehavior()
    waitForServerResphoneTimer = Invoke(function()
        if (retryCount or 0) < 2  then
            retryCount = (retryCount or 0) + 1
            this:CheckState(false)
        else
            this._fsm:GetCurState():Change2Disable(this._fsm,false)
        end
    end,3)
end

function PuzzleView.OnResphonePuzzleReward()
    this:StopWaitTimer()
    this._fsm:GetCurState():ClaimRewardResult(this._fsm)
end

function PuzzleView:OnClaimRewardResult(isStage)
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.claimReward)
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectReward)
    local isComplete = ModelList.PuzzleModel:IsPuzzleStageCompleted()
    local isRewarded = ModelList.PuzzleModel:IsPuzzleStageReward()
    if isComplete and (not isRewarded) then
        self:PlayTurnStagePage()   
    else
        local cur_index = ModelList.PuzzleModel:PuzzleStageIndex()
        local over = string.format("over%s", cur_index - 1)

        AnimatorPlayHelper.SetAnimationEvent(this.anima,over,function()
            if isStage then
                self:PlayTurnPage(isStage)
            else
                Anim.slide_to(self.slider_progress,nil, ((cur_index - 1) / 4) * 100,1,function()
                    self:PlayTurnPage(isStage)
                end)
            end
        end)
        if cur_index == 1 then
            over = "over0None"
        end
        AnimatorPlayHelper.Play(this.anima,over,false,function()
            if isStage then
                self:PlayTurnPage(isStage)
            else
                Anim.slide_to(self.slider_progress,nil, ((cur_index - 1) / 4) * 100,1,function()
                    self:PlayTurnPage(isStage)
                end)
            end
        end)
        UISound.play("puzzle_finish")
    end
end

function PuzzleView.OpenShopView()
    if this._fsm then
        this._fsm:GetCurState():OpenShopView(this._fsm)
    end
end

function PuzzleView:OnOpenShopView()
    Facade.SendNotification(NotifyName.ShopView.PopupShop,PopupViewType.show,nil,nil,nil)
end

function PuzzleView:initSpeedUp()

    if ModelList.GuideModel.IsFirstBattle() then 
        fun.set_active(self.btn_speedUp,false)
        return 
    end 

    if ModelList.PuzzleModel:GetViewType() == 1 then 
        fun.set_active(self.btn_speedUp,true)

        local flag = UnityEngine.Time.timeScale== 1

        local on = fun.find_child(self.btn_speedUp,"on")
        local off =  fun.find_child(self.btn_speedUp,"off")
        if flag == false then --加速状态
            fun.set_active(on,true)
            fun.set_active(off,false)
            UnityEngine.Time.timeScale = 1.5 
        end 
    else
        fun.set_active(self.btn_speedUp,false)

    end 

end


function PuzzleView:on_btn_speedUp_click()
    local flag =  UnityEngine.Time.timeScale== 1
    local on = fun.find_child(self.btn_speedUp,"on")
    local off =  fun.find_child(self.btn_speedUp,"off")

    if flag then  -- 置为加速状
        UnityEngine.Time.timeScale = 1.5
        ModelList.BattleModel.setGameSpeed(1.5)
    else 
        UnityEngine.Time.timeScale = 1
        ModelList.BattleModel.setGameSpeed(1)
    end 

    if UnityEngine.Time.timeScale == 1 then 
        fun.set_active(on,false)
        fun.set_active(off,true)
    else 
        fun.set_active(on,true)
        fun.set_active(off,false)
    end 

end

this.NotifyList = 
{
    {notifyName = NotifyName.ShopView.OpenShopView, func = this.OpenShopView},
    {notifyName = NotifyName.PuzzleView.AddPiecesResult,func = this.OnAddPiecesResult},
    {notifyName = NotifyName.PuzzleView.ResphonePuzzleReward,func = this.OnResphonePuzzleReward}
}

return this
