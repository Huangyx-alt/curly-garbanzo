--[[
Descripttion: 提取proto枚举类
version: 1.0.0
Author: LwangZg
email: 1123525779@qq.com
Date: 2025-08-20 10:54:33
LastEditors: LwangZg
LastEditTime: 2025-08-20 10:54:37
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]
local pb = require("pb")

function GetProtoEnum(name,key)
    if type(key) == "number" then
        Log.Error("enum error : key is number {0} {1}",name,key)
        return key
    end
    local t = pb.enum("GPBClass.Enum."..name,key)
    return t;
end

ProtobufEnum = {}
ProtobufEnum_Meta = {}
ProtobufEnum_Meta.__index = function(t,k)
    if not rawget(t,k) then
        local new_table = {}
        local meta_table = {}
        meta_table.__index = function(t2,k2)
            if not rawget(t2,k2) then
                rawset(t2,k2,GetProtoEnum(k,k2))
            end
            return rawget(t2,k2)
        end
        setmetatable(new_table,meta_table)
        rawset(t,k,new_table)
    end
    return rawget(t,k)
end

setmetatable(ProtobufEnum,ProtobufEnum_Meta)