
local PuzzleModel = BaseModel:New("PuzzleModel")
local this = PuzzleModel

this.openViewType = {
    None = 0,
    settleData= 1,
    IconClick = 2,
}

function PuzzleModel:InitData()
    this.openViewType = 0 
end

function PuzzleModel:SetViewType(type)
    this.openViewType = type
end

function PuzzleModel:GetViewType(type)
    return this.openViewType 
end

function PuzzleModel:GetCurPuzzle(cityId,gameMode)
    return ModelList.CityModel:GetCityPuzzleData(cityId,gameMode)
end

function PuzzleModel:GetPuzzleId()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        local gameMode = ModelList.CityModel:GetEnterGameMode()
        local city = ModelList.CityModel:GetCity()
        local data = Csv.GetCityData(gameMode,city,"puzzle_card")
        if data then
            return data[puzzleData.currentPuzzle + 1]--服务器传过来的下标是从0开始，所以要加1
        end
    end
    return nil
end

function PuzzleModel:GetCurPuzzleIndex()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.currentPuzzle
    end
    return -1
end

function PuzzleModel:GetTotalPuzzleIndex()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.totalPuzzle
    end
    return -1
end

function PuzzleModel:GetCurPuzzlePorcess()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.process
    end
    return 0
end

function PuzzleModel:GetCurPuzzleTarget()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.target
    end
    return -1
end

function PuzzleModel:IsCurPuzzleCompleted()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.completed
    end
    return false
end

function PuzzleModel:IsCurPuzzleRewarded()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.rewarded
    end
    return false
end


function PuzzleModel:GetCurPuzzlePieceId(cityId,gameMode)
    local puzzleData = this:GetCurPuzzle(cityId,gameMode)
    if puzzleData then
        return puzzleData.puzzleItemId
    end
    return -1
end

function PuzzleModel:GetCurPuzzleState()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.state
    end
    return nil
end

function PuzzleModel:GetCurPuzzleReward()
    local puzzleData = this:GetCurPuzzle()
    log.log("puzzleData    ",puzzleData)
    if puzzleData then
        return puzzleData.reward
    end
    return nil
end

function PuzzleModel:GetPuzzleRewarRate()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.pageRewardBet or 1
    end
    return 1
end

function PuzzleModel:GetPuzzlePiecesNum(city,gameMode)
    local piecesId = this:GetCurPuzzlePieceId(city,gameMode)
    return  ModelList.CityModel:GetCityItemNum(piecesId,city)
end

function PuzzleModel:PuzzleStageIndex()
    ----服务端的下标是从0开始的额，所以加1
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.pageCurrentIndex + 1
    end
    return 1
end

function PuzzleModel:IsPuzzleStageCompleted()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.pageCompleted
    end
    return false
end

function PuzzleModel:IsPuzzleStageReward()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.pageRewarded
    end
    return false
end

function PuzzleModel:GetPuzzleStageReward()
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        return puzzleData.pageReward
    end
    return nil
end

function PuzzleModel:GetPuzzleStageData(index)
    local puzzleData = this:GetCurPuzzle()
    if puzzleData then
        if index then
            return puzzleData.pagePuzzle[index]
        else
            return puzzleData.pagePuzzle
        end 
    end
    return nil
end

function PuzzleModel:C2S_Pieces2Puzzle(city,puzzle)
    local gameMode = ModelList.CityModel:GetEnterGameMode()
    this.SendMessage(MSG_ID.MSG_PIECES_TO_PUZZLE,{type = gameMode, city = city, puzzle = puzzle})
end

function PuzzleModel.S2C_Pieces2Puzzle(code,data)
    if code == RET.RET_SUCCESS then

    else
        ModelList.CityModel:SetCityItemInfo(this:GetCurPuzzlePieceId(),0)
    end
    Facade.SendNotification(NotifyName.PuzzleView.AddPiecesResult)
end

function PuzzleModel:C2S_RequestPuzzleAward(city,puzzle)
    local gameMode = ModelList.CityModel:GetEnterGameMode()

    this.SendMessage(MSG_ID.MSG_PUZZLE_RECEIVE_REWARD,{type = gameMode, city = city, puzzle = puzzle})
end

function PuzzleModel.S2C_ResphonePuzzleAward(code,data)
    if code == RET.RET_SUCCESS then
        -- body
    end

    Facade.SendNotification(NotifyName.PuzzleView.ResphonePuzzleReward)
end

function PuzzleModel:C2S_RequestPuzzleStageReward()
    local gameMode = ModelList.CityModel:GetEnterGameMode()
    local city = ModelList.CityModel:GetCity()
    this.SendMessage(MSG_ID.MSG_PUZZLE_PAGE_RECEIVE_REWARD,{type = gameMode, city = city})
end

function PuzzleModel.S2C_ResphonePuzzleStageRward(code,data)
    if code == RET.RET_SUCCESS then
        
    end
    Facade.SendNotification(NotifyName.PuzzleView.ResphonePuzzleReward)
end

this.MsgIdList = 
{
    {msgid = MSG_ID.MSG_PIECES_TO_PUZZLE,func = this.S2C_Pieces2Puzzle},
    {msgid = MSG_ID.MSG_PUZZLE_RECEIVE_REWARD,func = this.S2C_ResphonePuzzleAward},
    {msgid = MSG_ID.MSG_PUZZLE_PAGE_RECEIVE_REWARD,func = this.S2C_ResphonePuzzleStageRward}
}

return this