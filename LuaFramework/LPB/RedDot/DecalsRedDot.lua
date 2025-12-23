local BaseRedDot = require("RedDot/BaseRedDot")
local DecalsRedDot = Clazz(BaseRedDot,"DecalsRedDot")

local decals_cache_data = nil
local isDecalsRedDot = false

function DecalsRedDot:Check(node,param)
    if decals_cache_data == nil then
        decals_cache_data = {false,false,false,false}
        local curPhoto = ModelList.DecalsModel:GetCurPhotoId()
        local curPage = ModelList.DecalsModel:GetCurPage()
        local claimPhotoReward = ModelList.DecalsModel:CheckIsClaimPhotoReward(curPhoto)
        local completePhotoReward = ModelList.DecalsModel:CheckIsCompletePhotoReward(curPhoto)
        if not claimPhotoReward and not completePhotoReward then
            local indexList = DecalsRedDot:GetDecalsNoExchange(curPhoto,curPage)
            local sticker = nil
            for key, value in pairs(Csv.auto_photo) do
                if value.photo_id == curPhoto and curPage == value.page then
                    sticker = value.sticker
                    break;
                end
            end
            assert(sticker ~= nil)
            for key, value in pairs(indexList) do
                if value then
                    local itemsNum = ModelList.ItemModel:GetItemNumById(sticker[value][1])
                    if itemsNum == 0 then
                        local resNum = ModelList.ItemModel.getResourceNumByType(sticker[value][2])
                        if resNum >= sticker[value][3] then
                            decals_cache_data[value] = true
                            isDecalsRedDot = true
                        end
                    end
                end
            end
        end
    end
    if node.param == nil then
        DecalsRedDot:SetSingleNodeActive(node,isDecalsRedDot)
    else
        DecalsRedDot:SetSingleNodeActive(node,decals_cache_data[node.param])
    end
end

function DecalsRedDot:Refresh(nodeList,param)
    decals_cache_data = nil
    isDecalsRedDot = false
    for key, value in pairs(nodeList) do
        DecalsRedDot:Check(value,param)
    end
end

function DecalsRedDot:GetDecalsNoExchange(photoId,page)
    local stateList = {}
    for i = 1, 4 do
        if not ModelList.DecalsModel:GetState(photoId,page,i) then
            table.insert(stateList,i)
        end
    end
    return stateList
end

return DecalsRedDot