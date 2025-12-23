local BaseRedDot = require("RedDot/CuisinesRedDot")
local OtherCityCuisinesRedDot = Clazz(BaseRedDot,"OtherCityCuisinesRedDot")
local this = OtherCityCuisinesRedDot

function OtherCityCuisinesRedDot:Check(node,param)
    local curCity = ModelList.CityModel:GetCity()
    local maxcity = ModelList.CityModel:GetMaxCity()
    local isActive = false
    for key, value in pairs(Csv.city) do
        if key <= maxcity then
            if node.param == RedDotParam.city_truenpage_left and key < curCity then
                isActive = ModelList.ItemModel:IsCuisinesAvailable(key,nil) 
                or (ModelList.PuzzleModel:GetPuzzlePiecesNum(key) > 0)
            elseif node.param == RedDotParam.city_turnpage_right and key > curCity then
                isActive = ModelList.ItemModel:IsCuisinesAvailable(key,nil) 
                or (ModelList.PuzzleModel:GetPuzzlePiecesNum(key) > 0)
            end
        end
        if isActive then
            break
        end
    end
    this:SetSingleNodeActive(node, isActive)
end

return OtherCityCuisinesRedDot