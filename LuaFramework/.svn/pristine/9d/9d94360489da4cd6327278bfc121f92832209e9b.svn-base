--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};



function Command.Execute(giftPackEnterView)
    local view = giftPackEnterView
    local allShowIcons = view:GetShowIcons()

    if(allShowIcons)then 
        for k,v in pairs(allShowIcons) do
            Command.ProcessLimitPackage(v)
        end
    end

end


function Command.ProcessLimitPackage(iconData)
    local id = tonumber(iconData.name)
    if(ModelList.GiftPackModel:IsLimitPack(id))then  
        local xls = Csv.GetData("pop_up",id) 
        local data = iconData.data 
        local sellNum = data.sellNumber
        local canbuyCout = data.canBuyCount
        local str = tostring(canbuyCout)

        if(canbuyCout==0)then 
            return 
        end
        local showParam = xls.sell_number_tips


        if(canbuyCout<showParam[1] and canbuyCout<showParam[2])then 
            Command.ShowBubbleTip(iconData.ob,str,false)
        elseif(canbuyCout<showParam[1])then 
            Command.ShowBubbleTip(iconData.ob,str,true)
        end
    end
end


function Command.ShowBubbleTip(iconObj,des_text,isAutoClose) 
    local params = {
        pos =fun.get_gameobject_pos( iconObj),
        text = des_text,
        offset = Vector3.New(90, 80, 0),
        exclude = {iconObj},
        isAutoClose = isAutoClose,
        parent = iconObj
    }
    Facade.SendNotification(NotifyName.ShowUI, ViewList.GiftPackBubbleTipView, nil, false, params)
end

return Command;