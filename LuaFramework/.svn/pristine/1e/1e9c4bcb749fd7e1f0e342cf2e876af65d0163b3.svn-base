local CouponModel = BaseModel:New("CouponModel")
local this = CouponModel

local couponList = {}

local couponTypeList = nil

local couponActiveList = nil

function CouponModel:InitData()

end

function CouponModel:SetLoginData(data)
    if data then
        this:SetCouponInfo(data.coupon,true,false)
    end
end

function CouponModel:SetDataUpdate(data,params)
    this:SetCouponInfo(data.coupon,data.upcoupon,true)

end

function CouponModel:CreateCouponTypeList(coupon_tpye)
    if couponTypeList == nil then
        couponTypeList = {}
    end
    if couponTypeList[coupon_tpye] == nil then
        couponTypeList[coupon_tpye] = {}
    end
    return couponTypeList[coupon_tpye]
end

function CouponModel:CreatCouponActiveList(coupon_active)
    if couponActiveList ==nil then
        couponActiveList = {}
    end
    if couponActiveList[coupon_active] == nil then
        couponActiveList[coupon_active] = {}
    end
    return couponActiveList[coupon_active]
end

function CouponModel:SetCouponInfo(data,isReplace,raise)
    if data and isReplace then
        couponList= deep_copy(data)
        couponTypeList = nil
        couponActiveList = nil
        if couponList then
            for key, value in pairs(couponList) do
                if value then
                    local coupon_data = Csv.GetData("coupon",value.id)
                    assert(coupon_data ~= nil,"coupon_data is nil id：" .. tostring(value.id))
                    value.cTime = value.cTime + coupon_data.cd
                    for key2, value2 in pairs(coupon_data.new_coupon_type) do
                        table.insert(self:CreateCouponTypeList(value2),value)
                    end
                    table.insert(self:CreatCouponActiveList(coupon_data.item_type),value)
                end
            end
        end
        if raise then
            Event.Brocast(EventName.Event_coupon_change)
        end
    end
end

--获取优惠卷数量
function CouponModel.get_couponCount(couponType)
    local couponCpount = 0
    if couponTypeList and couponTypeList[couponType] then
        for key, value in pairs(couponTypeList[couponType]) do
            if value.cTime - os.time() > 1 then
                couponCpount = couponCpount + 1
            end
        end
    end
    return couponCpount
end


function CouponModel.set_FakeCouponData(type)
    local  data = {{
        cTime =  ModelList.PlayerInfoModel.get_cur_server_time() +1000,
        id=6003,
        table="",
        tableId=0,
    }}
    if type == 1 then 
        data[1].id =6003
    elseif type == 2 then 
        data[1].id =6005
    elseif type == 0 then 
        data = {}
    end 

    CouponModel:SetCouponInfo(data,true,true)
end 

function CouponModel.get_couponCountByActive(activeType)
    local couponCpount = 0
    if couponActiveList and couponActiveList[activeType] then
        for key, value in pairs(couponActiveList[activeType]) do
            if value.cTime - os.time() > 1 then
                couponCpount = couponCpount + 1
            end
        end
    end
    return couponCpount
end

function CouponModel.get_couponCountPowerupFree(isFree)
    local couponCpount = 0
    if couponActiveList and couponActiveList[CouponActiveType.powerup] then
        local coupon_type = {}
        for key, value in pairs(couponActiveList[CouponActiveType.powerup]) do
            if value.cTime - os.time() > 1 then
                local saleoff = Csv.GetData("coupon",value.id,nil)
                if isFree then
                    if saleoff.saleoff == 100 then
                        for key2, value2 in pairs(saleoff.new_coupon_type) do
                            coupon_type[value2] = 1
                        end
                    end
                else
                    for key2, value2 in pairs(saleoff.new_coupon_type) do
                        coupon_type[value2] = 1
                    end
                end
            end
        end
        for key, value in pairs(coupon_type) do
            couponCpount = couponCpount + 1
        end
    end
    return couponCpount
end

function CouponModel.get_currentCoupon(couponType)
    if couponTypeList and couponTypeList[couponType] then
        local coupon = nil
        local temWeights = 0
        for key, value in pairs(couponTypeList[couponType]) do
            if value.cTime - os.time() > 1 then
                local weights = Csv.GetData("coupon",value.id,"weights")
                if weights > temWeights then
                    coupon = value
                    temWeights = weights
                elseif weights == temWeights then
                    if not coupon or value.cTime < coupon.cTime then
                        coupon = value
                    end    
                end
            end
        end
        return coupon
    end    
    return nil
end

function CouponModel.get_couponAllActive()
    local couponList = {}
    if couponActiveList then
        for key, value in pairs(couponActiveList) do
            local coupon = nil
            local temWeights = 0
            for key1, value1 in pairs(value) do
                if value1.cTime - os.time() > 1 then
                    local weights = Csv.GetData("coupon",value1.id,"weights")
                    if weights > temWeights then
                        coupon = value1
                        temWeights = weights
                    elseif weights == temWeights then
                        if not coupon or value1.cTime < coupon.cTime then
                            coupon = value1
                        end       
                    end
                end
            end
            if coupon then
                table.insert(couponList,coupon)
            end
        end
    end
    return couponList
end

function CouponModel.get_currentCouponByActive(activeType)
    if couponActiveList and couponActiveList[activeType] then
        local coupon = nil
        local temWeights = 0
        for key, value in pairs(couponActiveList[activeType]) do
            if value.cTime - os.time() > 1 then
                local weights = Csv.GetData("coupon",value.id,"weights")
                if weights > temWeights then
                    coupon = value
                    temWeights = weights
                elseif weights == temWeights then
                    if not coupon or value.cTime < coupon.cTime then
                        coupon = value
                    end       
                end
            end
        end
        return coupon
    end
    return nil
end

function CouponModel.get_theLatestCoupon(couponActiveType)
    if couponList then
        local coupon = nil
        couponActiveType = couponActiveType or CouponActiveType.allActive
        for key, value in pairs(couponList) do
            if not coupon or value.cTime > coupon.cTime then
                if value.cTime - os.time() > 1 then
                    local acitveType = Csv.GetData("coupon",value.id,"item_type")
                    if acitveType == couponActiveType or couponActiveType == CouponActiveType.allActive then
                        coupon = value
                    end
                end
            end
        end
        return coupon
    end
    return nil
end

--根据id更新
function CouponModel.getCouponforId(id)
    if couponList then
        local coupon = nil
        for _, value in pairs(couponList) do
            if value.cTime - os.time() > 1 and  value.id ==id then
                coupon = value 
                break;
            end
        end
        return coupon
    end
    return nil
end 

function CouponModel.get_currentCouponId(couponType)
    local coupon = this.get_currentCoupon(couponType)
    if coupon then
        return coupon.id
    end
    return nil
end

function CouponModel.get_currentCouponUseId(couponType)
    local coupon = this.get_currentCoupon(couponType)
    if coupon then
        return coupon.useId
    end
    return nil
end

function CouponModel.get_currentCouponIdByCardNum(cardNum)
    local couponType = CouponType.discount_4card
    if cardNum == CardGenre.onecard then
        couponType = CouponType.discount_1card
    elseif cardNum == CardGenre.twocard then
        couponType = CouponType.discount_2card
    elseif cardNum == CardGenre.fourcard then
        couponType = CouponType.discount_4card
    elseif cardNum == CardGenre.eightcard then
        couponType = CouponType.discount_8card
    elseif cardNum == CardGenre.twelvecard then
        couponType = CouponType.discount_12card
    end
    return this.get_currentCouponId(couponType)
end

function CouponModel.get_currentCouponUseIdByCardNum(cardNum)
    local couponType = CouponType.discount_4card
    if cardNum == CardGenre.onecard then
        couponType = CouponType.discount_1card
    elseif cardNum == CardGenre.twocard then
        couponType = CouponType.discount_2card
    elseif cardNum == CardGenre.fourcard then
        couponType = CouponType.discount_4card
    elseif cardNum == CardGenre.eightcard then
        couponType = CouponType.discount_8card
    elseif cardNum == CardGenre.twelvecard then
        couponType = CouponType.discount_12card
    end
    return this.get_currentCouponUseId(couponType)
end

------------------------------------------折扣券------------------------------

function CouponModel.get_DiscountOfIitem()
    local tmp = {}

    local rocketTb = ModelList.ItemModel:GetItemByType(ItemType.rocket_DisCount)
    local skyTb = ModelList.ItemModel:GetItemByType(ItemType.rofy)
    local coinTb = ModelList.ItemModel:GetItemByType(ItemType.coin_DisCount)
    local PUTb = ModelList.ItemModel:GetItemByType(ItemType.pu_DisCount)
    local TMTb = ModelList.ItemModel:GetItemByType(ItemType.Tournament_DisCount)
    for _,v in ipairs(rocketTb) do 
        table.insert(tmp,v)
    end 

    for _,v in ipairs(skyTb) do 
        table.insert(tmp,v)
    end 

    for _,v in ipairs(coinTb) do 
        table.insert(tmp,v)
    end 

    for _,v in ipairs(PUTb) do 
        table.insert(tmp,v)
    end 

    for _,v in ipairs(TMTb) do 
        table.insert(tmp,v)
    end 

    return tmp 
end

return this