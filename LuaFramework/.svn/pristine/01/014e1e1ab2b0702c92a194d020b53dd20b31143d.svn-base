require "Common/config"
require "Common/fun"
require "Common/Queue"
require "Common/Panel"

local json = require "cjson"

Net = {}
local this = Net;


this.viewType = {CheckConnection = "CheckConnection" , ReloginTip = "ReloginTip"}
this.viewList = {}
this.viewList[this.viewType.CheckConnection] = {}
this.viewList[this.viewType.ReloginTip] = {}

function Net.GetViewCountByType(viewType)
    return  #this.viewList[viewType]
end

function Net.CloseTipView(view)
    --local hasFind =  false
    for k,v in pairs(this.viewList) do
        if #v >0 then
            for i = #v, 1,-1 do
                if v[i] == view then
                    table.remove(v, i)
                    break
                end
            end
        end
    end
end

function Net.CloseOtherTipView()
    for k,v in pairs(this.viewList) do
        if #v >0 then
            for i = #v, 1,-1 do
                Facade.SendNotification(NotifyName.HideDialog, v[i])
            end
        end
    end
end


function Net.AddTipView(view ,viewType)
    table.insert(this.viewList[viewType],view)
end

function Net.RemoveViewList(view ,viewType)
    table.remove(this.viewList[viewType],view)
end


