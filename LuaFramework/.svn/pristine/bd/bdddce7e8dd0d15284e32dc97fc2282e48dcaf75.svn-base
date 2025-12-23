
local PuzzleCardView = BaseView:New()
local this = PuzzleCardView
this.viewType = CanvasSortingOrderManager.LayerType.None

local cache_puzzleStates = nil

local cache_effect_go = nil

this.auto_bind_ui_items = {
    "img_puzzle",
    "puzzle_piece",
    "puzzle_wire_frame"
}

function PuzzleCardView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function PuzzleCardView:Awake()
    self:on_init()
end

function PuzzleCardView:OnEnable()
    self:SetPuzzleCardInfo()
    self:SetState()
end


function PuzzleCardView:OnDisable()
    if cache_effect_go then
        for key, value in pairs(cache_effect_go) do
            Destroy(value.transform)
        end
        cache_effect_go = nil
    end
end

function PuzzleCardView:on_close()

end

function PuzzleCardView:SetState()
    local puzzle_state = ModelList.PuzzleModel:GetCurPuzzleState()
    if puzzle_state then
        local childCount = fun.get_child_count(self.puzzle_piece)
        for key, value in pairs(puzzle_state) do
            if key - 1 < childCount then
                local piece = self:GetPuzzlePiece(key - 1)
                if piece then
                    fun.set_active(piece,value ~= 1)
                end    
            end
        end
    end
end

function PuzzleCardView:SetPuzzleCardInfo()
    local puzzleId = ModelList.PuzzleModel:GetPuzzleId()
    if puzzleId then
        local need = Csv.GetData("puzzle_card",puzzleId,"need")
        local puzzle_res = nil
        if need == 16 then
            puzzle_res = "pPuzzlXianKuang4"
        elseif need == 36 then
            puzzle_res = "pPuzzlXianKuang6"
        elseif need == 100 then
            puzzle_res = "pPuzzlXianKuang10"   
        elseif need == 196 then
            puzzle_res = "pPuzzlXianKuang14"
        elseif need == 256 then
            puzzle_res = "pPuzzlXianKuang16"   
        elseif need == 324 then
            puzzle_res = "pPuzzlXianKuang18"   
        end
        Cache.load_texture_to_sprite(puzzle_res ,  self.puzzle_wire_frame, false)
        
        local icon_name = Csv.GetData("puzzle_card",puzzleId,"res_name")
        Cache.load_texture_to_sprite(icon_name ,  self.img_puzzle, false)
    end
end


function PuzzleCardView:PreloadPuzzleCardRes(callback)
    local puzzleId = ModelList.PuzzleModel:GetPuzzleId()
    if puzzleId then
        local need = Csv.GetData("puzzle_card",puzzleId,"need")
        local puzzle_res = nil
        if need == 16 then
            puzzle_res = "pPuzzlXianKuang4"
        elseif need == 36 then
            puzzle_res = "pPuzzlXianKuang6"
        elseif need == 100 then
            puzzle_res = "pPuzzlXianKuang10"
        elseif need == 196 then
            puzzle_res = "pPuzzlXianKuang14"
        elseif need == 256 then
            puzzle_res = "pPuzzlXianKuang16"
        elseif need == 324 then
            puzzle_res = "pPuzzlXianKuang18"
        end

        Cache.load_texture(puzzle_res, puzzle_res, function(textures)
            local icon_name = Csv.GetData("puzzle_card",puzzleId,"res_name")
            Cache.load_texture(icon_name, icon_name, function(textures)
                if callback then callback() end
            end)
        end)
    else
        if callback then callback() end
    end
end

function PuzzleCardView:CopyPuzzleState()
    cache_puzzleStates = deep_copy(ModelList.PuzzleModel:GetCurPuzzleState())
end

function PuzzleCardView:PlayPuzzleAddPiecesEffect(callback)
    if cache_puzzleStates then
        cache_effect_go = {}
        Cache.load_prefabs(AssetList["efPuzzleRend"],"efPuzzleRend",function(obj)
            if obj then
                local new_puzzleStates = ModelList.PuzzleModel:GetCurPuzzleState()
                for key, value in pairs(new_puzzleStates) do
                    if value == 1 and cache_puzzleStates[key] ~= 1 then
                        local piece = self:GetPuzzlePiece(key - 1)
                        if piece then
                            local go = fun.get_instance(obj,self.go)--加到puzzle_piece下会引起bug
                            table.insert(cache_effect_go,go)
                            fun.set_gameobject_pos(go,piece.position.x,piece.position.y,0,false)
                            Util.PlayParticle(go)
                            UISound.play("puzzle_splicing")
                        end
                    end
                end
                Invoke(function()
                    if cache_effect_go then
                        self:SetState()
                    end
                    if callback then
                        callback()
                    end
                end,0.8,false)
            end
        end)
    end
end

function PuzzleCardView:GetPuzzlePiece(index)
    return fun.get_child(self.puzzle_piece,index)
end

function PuzzleCardView:DestroyPuzzleCard()
    self:Close()
end

return this