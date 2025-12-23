
local DecalsModel = BaseModel:New("DecalsModel")
local this = DecalsModel

local curPhotoId = nil --最大开启的相册id，收集完成并兑换奖励才会开启下一个相册，所以当前id前面的相册都是已经收集完成并兑换奖励了
local curPage = nil
local curState = nil
local photoRewarded = nil
local pageRewarded = nil

local stickerIndex = 1

function DecalsModel:InitData()
end

function DecalsModel:SetLoginData(data)
    this:SetData(data.roleInfo.autoCityPhotoState)
end

function DecalsModel:SetDataUpdate(data,params)
    if params == "roleInfo" then
        this:SetData(data.autoCityPhotoState)
    end
end

function DecalsModel:SetData(data)
    --log.r("===========================>>DecalsModel SetData " .. data.state[1] .. "  " .. data.state[2] .. "  " .. data.state[3] .. "  " .. data.state[4])
    --log.r("==============================>>DecalsModel:SetData data.photoId: " .. data.photoId .. "  data.page: " .. data.page .. " pageRewarded: " .. tostring(data.pageRewarded) .. " photoRewarded: " .. tostring(data.photoRewarded))
    if data then
        curPhotoId = tonumber(data.photoId) or 1
        curPage = tonumber(data.page) or 1
        pageRewarded = data.pageRewarded
        photoRewarded = data.photoRewarded
        curState = data.state or {}
        Facade.SendNotification(NotifyName.DecalsView.DecalsDataRefresh)
    end
end

function DecalsModel:GetCurPhotoId()
    return curPhotoId
end

function DecalsModel:GetCurPage()
    return curPage
end

function DecalsModel:GetProgress()
    local data = Csv.auto_photo
    local total = 1
    for index, value in ipairs(data) do
        if value.photo_id == curPhotoId then
            total = value.total_page
            break
        end
    end
    local statuteNum = 0
    for i = 1, 4 do
        if curState[i] == 0 then
            statuteNum = statuteNum + 1
        end
    end
    return (curPage * 4 - statuteNum) / (total * 4)
end

--相册页是否可以领取奖励
function DecalsModel:CheckClaimReward(photoId,page)
    if photoId == curPhotoId and page == curPage then
        for i = 1, 4 do
            if not this:GetState(photoId,page,i) then
                return false
            end
        end
        if pageRewarded == true and photoRewarded == true then
            return false
        end
        return true
    end
    return false
end

--相册页是否贴满贴纸，并领取过奖励
function DecalsModel:CheckFullStiker(photoId,page)
    if photoId == curPhotoId and page <= curPage then
        for i = 1, 4 do
            if not this:GetState(photoId,page,i) then
                return false
            end
        end
        return true
    end
    return false
end

function DecalsModel:CheckIsCurrentPage(photoId,page)
    return  photoId == curPhotoId and page == curPage
end

function DecalsModel:CheckIsClaimPhotoReward(photoId)
    local data = Csv.auto_photo
    local total = 1
    for index, value in ipairs(data) do
        if value.photo_id == photoId then
            total = value.total_page
            break
        end
    end
    --log.r("======================================================>>DecalsModel:CheckIsClaimPhotoReward " .. curPhotoId .. "  " .. curPage .. "  " .. tostring(pageRewarded) .. tostring(photoRewarded))
    if (curPhotoId == photoId and curPage == total) then
        return pageRewarded == true and photoRewarded == false
    end
    return false
end

function DecalsModel:CheckIsCompletePhotoReward(photoId)
    if (curPhotoId == photoId) then
        local data = Csv.auto_photo
        local total = 1
        for index, value in ipairs(data) do
            if value.photo_id == photoId then
                total = value.total_page
                break
            end
        end
        if curPage == total then
            return pageRewarded == true and photoRewarded == true
        end
    else
        return photoId < curPhotoId --photoid小于当前photoid肯定是领取过相册奖励了，因为前一个相册奖励领取完成才会开启下一个相册
    end
    return false
end

function DecalsModel:GetState(photoId,page,index)
    --log.r("======================================>>GetState " .. type(curPhotoId))
    if curPhotoId > photoId then
        return true
    elseif curPhotoId < photoId then
        return false    
    end
    if curPage > page then
        return true
    elseif curPage < page then
        return false
    end
    --log.r("==================================>>GetState index: " .. index .. " state: " .. curState[index] .. "  " .. type(curState[index]))
    return (tonumber(curState[index]) or 0) == 1
end

--请求兑换
function DecalsModel.C2S_ExchangeDecals(itemId,type,city)
    --Http.req_exchange_decals(itemId,type,city)
    --log.r("=====================================================>>req_exchange_decals " .. itemId .. " " .. type .. " " .. city)
    this.SendMessage(MSG_ID.MSG_EXCHANGE,{itemId = itemId, type = type, city = city})
end

--兑换返回
function DecalsModel.S2C_ExchangeDecals(code,data)
        --log.r("=============================================================>>S2C_ExchangeDecals1 " .. code)
    if code == RET.RET_SUCCESS then
        if data then
            --log.r("===============================================>>S2C_ExchangeDecals2 " .. data.itemId)
            Facade.SendNotification(NotifyName.DecalsView.ExchangeSucceed,data.itemId)
        else
            log.r("S2C_ExchangeIngredient数据为nil")
        end
    elseif code == RET.RET_EXCHNAGE_CITY_RECIPE_NOT_IN then
    
    elseif code == RET.RET_EXCHNAGE_NOT_ENOUGH then
    
    elseif code == RET.RET_EXCHNAGE_CITY_RECIPE_NOT_CURRENT then
    
    elseif code == RET.RET_EXCHNAGE_CITY_RECIPE_OWNED then
            
    end
end

--贴纸粘贴到相册
function DecalsModel.C2S_Sticker2Photo(stickerId,photoId,page,city,index)
    --Http.req_Sticker2Photo(stickerId,photoId,page,city)
    --log.r("====================================>>C2S_Sticker2Photo " .. stickerId .. "  " .. photoId .. "  " .. page .. "  " .. city)
    stickerIndex = index
    curState[stickerIndex] = 1
    this.SendMessage(MSG_ID.MSG_STICKER_TO_PHOTO,{stickerId = stickerId,photoId = photoId,page = page,city = city})
end

--贴纸粘贴到相册结果
function DecalsModel.S2C_Sticker2Photo(code,data)
    if code == RET.RET_SUCCESS and data then
        --log.r("====================================>>S2C_Sticker2Photo " .. data.stickerId .. "  " .. data.photoId .. "  " .. data.page .. "  " .. data.city)
        curPhotoId = data.photoId
        curPage = data.page
        curState[stickerIndex] = 1
        Facade.SendNotification(NotifyName.DecalsView.Sticker2PhotoSucceed)
    end
end

--领取完成页的奖励
function DecalsModel.C2S_RequestAward(city,photoId,page)
    --Http.req_decals_awards(city,photoId,page)
    --log.r("==========================================>>DecalsModel.C2S_RequestAward " .. city .. "  " .. photoId .. "  " .. page)
    this.SendMessage(MSG_ID.MSG_CITY_PHOTO_PAGE_RECEIVE_REWARD,{city = city,photoId = photoId,page = page})
end

--领取完成页奖励结果
function DecalsModel.S2C_ReceiveAward(code,data)
    --log.r("==============================================>>DecalsModel.S2C_ReceiveAward  " .. code)
    if code == RET.RET_SUCCESS and data then
        Facade.SendNotification(NotifyName.DecalsView.ClaimReward)
    end
end

--领取相册奖励
function DecalsModel.C2S_RequestPhotoAward(city,photoId)
    --log.r("==========================================>>DecalsModel.C2S_RequestPhotoAward " .. city .. "  " .. photoId)
    this.SendMessage(MSG_ID.MSG_CITY_PHOTO_RECEIVE_REWARD,{city = city,photoId = photoId})
end

--领取相册奖励结果
function DecalsModel.S2C_RequestPhotoAward(code,data)
    --log.r("==============================================>>DecalsModel.S2C_RequestPhotoAward  " .. code)
    if code == RET.RET_SUCCESS and data then
        Facade.SendNotification(NotifyName.DecalsView.ClaimReward_photo)
    end
end

this.MsgIdList = 
{
    {msgid = MSG_ID.MSG_EXCHANGE,func = this.S2C_ExchangeDecals},
    {msgid = MSG_ID.MSG_STICKER_TO_PHOTO,func = this.S2C_Sticker2Photo},
    {msgid = MSG_ID.MSG_CITY_PHOTO_PAGE_RECEIVE_REWARD,func = this.S2C_ReceiveAward},
    {msgid = MSG_ID.MSG_CITY_PHOTO_RECEIVE_REWARD,func = this.S2C_RequestPhotoAward}
}

return this