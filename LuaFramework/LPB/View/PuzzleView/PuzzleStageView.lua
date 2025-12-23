
local PuzzleStageView = BaseView:New()
local this = PuzzleStageView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "Toggle_bg",
    "Toggle_pictrue",
    "img_pictrue",
    "img_cover",
    "anima",
    "star1",
    "star2",
    "star3"
}

function PuzzleStageView:New(stageData,stageIndex)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._stageData = stageData
    o._stageIndex = stageIndex
    return o
end

function PuzzleStageView:Awake()
    self:on_init()
end

function PuzzleStageView:OnEnable()
    self:InitStarsShow()
    self:RefreshShow(true)
end

function PuzzleStageView:OnDisable()
    self._stageData = nil
    self._stageIndex = nil
    self._state_sign = nil
end

function PuzzleStageView:RefreshData(stageData,stageIndex)
    self._stageData = stageData
    self._stageIndex = stageIndex
end

function PuzzleStageView:RefreshShow(isInit)
    local stageComplete = ModelList.PuzzleModel:IsPuzzleStageCompleted()
    local cur_index = ModelList.PuzzleModel:PuzzleStageIndex()
    if cur_index > self._stageIndex then
        if isInit then
            self:PlayPictureComplete()
        end
    elseif cur_index == self._stageIndex then
        if stageComplete then
            self:PlayPictureComplete()
        else
            self:PlayPictureIdle()
        end
    else
        self:PlayPictureLocked()
    end

    Cache.load_texture_to_sprite(self._stageData.icon ,  self.img_pictrue, false)
end

function PuzzleStageView:InitStarsShow()
    local city = ModelList.CityModel:GetCity()
    local rateData = Csv.GetData("city",city,"puzzle_card_coefficient")
    for i = 1, 3 do
        fun.set_active(self[string.format("star%s",i)], (i <= rateData[self._stageIndex] and {true} or {false})[1])
    end
    local cur_index = ModelList.PuzzleModel:PuzzleStageIndex()
    local all = (cur_index > self._stageIndex and {true} or {(cur_index == self._stageIndex and {nil} or {false})[1]})[1]
    if all ~= nil then
        for i = 1, 3 do
            self[string.format("star%s",i)].isOn = all
        end
    else
        -- body
        local curProcess = ModelList.PuzzleModel:GetCurPuzzlePorcess()
        local targetProcess = ModelList.PuzzleModel:GetCurPuzzleTarget()
        local city = ModelList.CityModel:GetCity()
        local rateData = Csv.GetData("city",city,"puzzle_card_coefficient")
        local needPiece = targetProcess / rateData[self._stageIndex]
        for i = 1, 3 do
            self[string.format("star%s",i)].isOn = (curProcess >= math.ceil(needPiece * i) and {true} or {false})[1]
        end
    end
end

function PuzzleStageView:CheckFlyStar(pos,flyCallback)
    local curProcess = ModelList.PuzzleModel:GetCurPuzzlePorcess()
    local targetProcess = ModelList.PuzzleModel:GetCurPuzzleTarget()
    local city = ModelList.CityModel:GetCity()
    local rateData = Csv.GetData("city",city,"puzzle_card_coefficient")
    local needPiece = targetProcess / rateData[self._stageIndex]

    local city = ModelList.CityModel:GetCity()
    local rateData = Csv.GetData("city",city,"puzzle_card_coefficient")
    local count = 0
    local delay = 0.6
    Cache.load_prefabs(AssetList["PuzzleView"],"stars",function(obj)
        if obj then
            for i = 1, rateData[self._stageIndex] do
                local isOn = (curProcess >= math.ceil(needPiece * i) and {true} or {false})[1]
                local toggle = self[string.format("star%s",i)]
                if isOn and not toggle.isOn then
                    count = count + 1
                    self[string.format("star%s",i)].isOn = true
                    local go = fun.get_instance(obj.transform,self.transform.parent.gameObject)
                    local starPos = toggle.transform.position
                    fun.set_gameobject_pos(go,starPos.x,starPos.y,0,false)
                    Util.PlayParticle(go)
                    local path = {}
                    path[1] = fun.calc_new_position_between(starPos, pos, 0.2 , -2, 0)
                    path[2] = pos
        
                    local vLength = pos - starPos
                    --log.r("===================================>>speed " .. vLength.magnitude)
                    local t = 1.05 --math.min(1.5,vLength.magnitude / 4)
                    --log.r("===================================>>time " .. t)
                    Anim.bezier_move(go,path,t,delay,1,1.5,function()
                        fun.set_active(go.transform,false)
                        count = count - 1
                        if flyCallback then
                            flyCallback(true,0 == count)
                        end
                    end):SetEase(DG.Tweening.Ease.Unset)
                    delay = delay + 0.5
                end
            end
        end
    end)
    if 0 == count then
        flyCallback(false)
    end
end

function PuzzleStageView:PlayPictureComplete(callback)
    if self._state_sign ~= 1 then
        self._state_sign = 1
        AnimatorPlayHelper.Play(self.anima,{"finish","picture1finish"},false,function()
            self._state_sign = nil
            if callback then
                callback()
            end
        end)
    end
end

function PuzzleStageView:PlayPictureUnLock(callback)
    if self._state_sign ~= 2 then
        self._state_sign = 2
        AnimatorPlayHelper.Play(self.anima,{"unlock","picture1unlock"},false,function()
            self._state_sign = nil
            if callback then
                callback()
            end
        end)
    end
end

function PuzzleStageView:PlayPictureIdle()
    if self._state_sign ~= 3 then
        self._state_sign = 3
        AnimatorPlayHelper.Play(self.anima,{"idle","picture1idle"},false,function()
            self._state_sign = nil
        end)
    end
end

function PuzzleStageView:PlayPictureLocked()
    if self._state_sign ~= 4 then
        self._state_sign = 4
        AnimatorPlayHelper.Play(self.anima,{"locked","picture1locked"},false,function()
            self._state_sign = nil
        end)
    end
end

return this