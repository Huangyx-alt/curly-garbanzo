--[[
Descripttion:
version: 1.0.0
Author: LwangZg
email: 1123525779@qq.com
Date: 2025-08-14 12:27:44
LastEditors: LwangZg
LastEditTime: 2025-08-19 11:05:56
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local pb = require "pb"
local protoc = require "3rd.lua-protobuf.protoc"
local log = log
---@class ProtoLoader BaseClass使用不对,换静态类
local ProtoLoader = BaseClass("ProtoLoader")
local pb_files = require("Net.config.PbFilesDefine")
local msgIDMap = require("Net.config.MsgIDMap");
function ProtoLoader:Load()
    self:register()
end

function ProtoLoader.encode(msg_id, pack)
    local msg_template = msgIDMap[msg_id];
    if not msg_template then
        -- print("Proto.encode 请求 协议不存在 msg_id=" .. msg_id)
        return nil
    end
    if (pack and GetTableLength(pack) == 0) then
        return ""
    end
    local req_msgid = msg_template .. "_Req"
    return pb.encode(req_msgid, pack) --64位so 暂时没有编译进去
end

function ProtoLoader.decode(msg_id, pack)
    local msg_template = msgIDMap[tonumber(msg_id)];
    if not msg_template then
        -- print("Proto.decode 响应 协议不存在 msg_id=" .. msg_id)
        return nil
    end
    local res_msgid = msg_template .. "_Res"
    local code, err = pb.decode(res_msgid, pack)
    return code
end

--开发期间可以这样解析
function ProtoLoader:register()
    for _, filename in ipairs(pb_files) do
        local pbfile = GlobalConfig.Debug and AppConst.ExternalinkRoot .. "/Lua" .. "/Net/proto/" .. filename .. ".pb" or
            Util.DataPath .. "lua/Lua" .. "/Net/proto/" .. filename .. ".pb"
        assert(pb.loadfile(pbfile))
    end
end

return ProtoLoader
