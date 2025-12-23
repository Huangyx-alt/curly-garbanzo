local json = require "cjson"
Util = LuaFramework.Util

log = {}
log.enabled = false -- lua日志开关

--临时加个写文件功能 by LwangZg
-- 在文件开头添加以下配置（放在log定义之后）
log.fileEnabled = false -- 文件日志开关，默认关闭
log.filePath = "G:/lua_log.txt" -- 默认日志文件路径
log.maxFileSizeMB = 10 -- 单个日志文件最大大小(MB)
log.rotationEnabled = true -- 启用日志轮转

-- 新增内部函数：安全写入文件（带错误处理）
local function safeWriteToFile(content)
    -- 使用pcall捕获可能的文件操作错误[6,7](@ref)
    local status, err = pcall(function()
        local file, openErr = io.open(log.filePath, "a")  -- "a"模式追加写入[3,6](@ref)
        if not file then
            error("无法打开日志文件: " .. tostring(openErr))
        end
        
        -- 检查文件大小并处理轮转
        if log.rotationEnabled then
            local currentPos = file:seek("end")  -- 获取当前文件大小
            if currentPos > log.maxFileSizeMB * 1024 * 1024 then
                file:close()
                
                -- 创建带时间戳的新日志文件
                local timestamp = os.date("%Y%m%d_%H%M%S")
                local newPath = log.filePath:gsub(".txt$", "_" .. timestamp .. ".txt")
                os.rename(log.filePath, newPath)
                
                -- 重新打开原文件
                file = io.open(log.filePath, "w")
            end
        end
        
        -- 写入日志内容并关闭文件
        file:write(content)
        file:close()
    end)
    
    -- 处理文件写入错误
    if not status then
        Util.LogError("文件写入失败: " .. tostring(err))
    end
end

--临时加个写文件功能 by LwangZg

-- 颜色标签前缀
local suffix = "</color>"
-- 普通换行符
local space = " "
local enter = "\n"
local enter2 = "\n\n"
local empty_string = ""
local connect_suffix = "</color>\n"
local tab = "     "
local SEGMENT_LENGTH = 15000 -- 日志分段长度

---------------------------------------------------
-- 颜色枚举
local COLORS = {
    NONE = "",
    RED = "<color=#e52e2e>",
    GREEN = "<color=#33800d>", -- "<color=#77b359>",
    YELLOW = "<color=#ffff4c>",
    BLUE = "<color=#3d6dcc>",
    ORANGE = "<color=#e56b2e>",
    PURPLE = "<color=#9932CD>",
}

-- 彩色连字符表
local CONNECT_SUFFIX = {}
local function make_connect_suffix()
    for k,v in pairs(COLORS) do
        CONNECT_SUFFIX[v] = connect_suffix .. v
    end
    CONNECT_SUFFIX[COLORS.NONE] = empty_string
end
make_connect_suffix()
--------------------------------------------------------------
-- table 转 json 字符串 (兼容userdata类型)
--[[
function tojson_old(tbl, indent)
    if not indent then
        if type(tbl) == "userdata" then
            return "(userdata) "..tostring(tbl)
        elseif type(tbl) ~= "table" then
            return tostring(tbl)
        end
        indent = 0
    end
    local tab = string.rep("     ",indent)
    local havetable = false
    local str = "{"
    local sp = "\n"
    if tbl then
        for k, v in pairs(tbl) do
            local key = k            
            if type(key) == "number" then key = '['..key..']' end

            if type(v) == "userdata" then
                str = str..sp..tab..tostring(key).." = (userdata) "..tostring(v)
            elseif type(v) == "table" then
                havetable = true
                if(indent == 0) then
                    str = str..sp..tostring(key).." = "..tojson(v,indent+1)
                else
                    str = str..sp..tab..tostring(key).." = "..tojson(v,indent+1)
                end
            else
                local value = v
                if tostring(value) == "" then
                    value = "\"\""
                elseif type(value) == "string" then
                    value = '"'..value..'"'
                end
                str = str..sp..tab..tostring(key).." = "..tostring(value)
            end
            sp = ",\n"
        end
    end
    if havetable then
        str = str.."\n"..tab.."}"
    else
        str = str.."}"
    end
    return str
end
--]]

local levels = 6 -- 限制table嵌套层数
function tojson(tbl, indent)
    if not indent then
        if type(tbl) == "userdata" then
            return "(userdata) " .. (tostring(tbl) or "nil")
        elseif type(tbl) ~= "table" then
            return tostring(tbl)
        end
        indent = 0
    end
    local tab = string.rep("     ",indent)
    local havetable = false
    local str = "{"
    local sp = "\n"
    if tbl then
        for k, v in pairs(tbl) do
            local key = k
            if type(key) == "number" then key = '['..key..']' end

            if type(v) == "userdata" then
                str = str..sp..tab..tostring(key).." = (userdata) "..(tostring(v) or "nil")
            elseif type(v) == "table" then
                havetable = true
                if key == "super" then
                    str = str..sp..tab..tostring(key).." = (省略)"
                elseif key == "__index" then
                    str = str..sp..tab..tostring(key).." = (省略)"
                else
                    if(indent == 0) then
                        str = str..sp..tostring(key).." = "..tojson(v,indent+1)
                    elseif(indent > levels) then
                        str = str..sp..tab..tostring(key).." = "..tostring(v)
                    else
                        str = str..sp..tab..tostring(key).." = "..tojson(v,indent+1)
                    end
                end
            else
                local value = v
                if tostring(value) == "" then
                    value = "\"\""
                elseif type(value) == "string" then
                    value = '"'..value..'"'
                end
                str = str..sp..tab..tostring(key).." = "..tostring(value)
            end
            sp = ",\n"
        end
    end
    if havetable then
        str = str.."\n"..tab.."}"
    else
        str = str.."}"
    end
    return str
end

-- 拆分打印
function log.split(str, color, each)
    
    local suf = suffix -- 颜色尾缀
    color = color or COLORS.NONE -- 颜色
    local connect = CONNECT_SUFFIX[color] -- 彩色连字符
    if color == COLORS.NONE then
        suf = empty_string 
    end
    if each == nil then
        each = SEGMENT_LENGTH -- 每段字符数
    end
    local len = string.len(str) -- 总字符数
    local total = math.ceil(len / each) -- 总段数
    local count = total -- 打印段数
    if count > 5 then
        count = 5
    end
    local traceback = debug.traceback() -- log追迹
    
    for i = 1, count do
        local child = string.sub(str, each*(i-1)+1, each*i)
        local len_child = string.len(child)
        if i == 1 then -- 首条
            child = string.format("%s[%d/%d][%d字] %s\n\n(未完待续)%s\n\n%s\n\n",color,i,count,len,child,suf,traceback)
        elseif i == count then -- 尾条
            child = string.format("%s[%d/%d][%d字] (接续前文)\n\n%s %s\n\n%s\n\n",color,i,count,len,child,suf,traceback)
        else
            child = string.format("%s[%d/%d][%d字] (接续前文)\n\n%s\n\n(未完待续)%s\n\n%s\n\n",color,i,count,len,child,suf,traceback)
        end
        if color ~= COLORS.NONE then
            child = string.gsub(child, enter, connect, 2) -- 确保颜色生效
        end
        Util.Log(child)
    end
    if total > count then -- 打印省略信息
        local others = string.format("%s[%d/%d] ~ [%d/%d] (省略)%s\n\n%s\n\n",color,count+1,total,total,total,suf,traceback)
        Util.Log(others)
    end
end

-- 彩色日志
function log.color(color,...)
    if log.enabled == false then return end
    -- 打印内容列表
    local args = {...}
    for i,s in ipairs(args) do
        args[i] = tojson(s)
    end
    -- 连接打印内容列表
    local ret = table.concat(args,space)
    local len = string.len(ret)
    if len > SEGMENT_LENGTH then
        log.split(ret, color)
        return
    end
    if color and color ~= COLORS.NONE then
        -- 带颜色标签的换行符
        local connect = connect_suffix .. color
        -- 为换行符添加颜色标签(前2个)
        ret = string.gsub(ret, enter, connect, 2)
        ret = string.format("%s[%d字] %s %s\n\n[time] %s\n\n%s\n\n",color,len,ret,suffix,now_millisecond(),debug.traceback())
    else
        ret = string.format("%s[%d字] %s\n\n[time] %s\n\n%s\n\n",color,len,ret,now_millisecond(),debug.traceback())
    end
    
    -- 输出打印LOG
    Util.Log(ret)
    return ret --临时加个写文件功能 by LwangZg
end
------------------------------------------
-- 红色日志
function log.r(...) 
    log.color(COLORS.RED,...)
end

--临时加个写文件功能 by LwangZg
function log.l(...) 
    local s = log.color(COLORS.ORANGE,...)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local fileContent = string.format("[%s] [LwangZg] %s\n", timestamp, s)
    -- safeWriteToFile(fileContent)
end
--临时加个写文件功能 by LwangZg

-- 绿色日志
function log.g(...) 
    log.color(COLORS.GREEN,...)
end

-- 黄色日志
function log.y(...) 
    log.color(COLORS.YELLOW,...)
end

-- 蓝色日志
function log.b(...) 
    log.color(COLORS.BLUE,...)
end

-- 橙色日志
function log.o(...) 
    log.color(COLORS.ORANGE,...)
end

function log.p(...)
    log.color(COLORS.PURPLE,...)
end

-- 普通日志
function log.log(...)
    log.color(COLORS.NONE,...)
end
------------------------------------------

--输出日志--
function log.i(str)
    if log.enabled == false then return end
    str = TableToJson(str)
    local s = "LUAI: " .. tostring(str)
    s = s .. "\n\n" .. debug.traceback()
    s = s .. "\n\n\n"
    Util.Log(s)
end

--错误日志--
function log.e(str)
    if log.enabled == false then return end
    str = TableToJson(str)
    local s = "LUAE: " .. tostring(str)
    s = s .. "\n\n" .. debug.traceback()
    s = s .. "\n\n\n"
	Util.LogError(s)
end

--警告日志--
function log.w(str) 
    if log.enabled == false then return end
    str = TableToJson(str)
    local s = "LUAW: " .. tostring(str)
    s = s .. "\n\n" .. debug.traceback()
    s = s .. "\n\n\n"
	Util.LogWarning(s)
end


function log.data(str)
    if log.enabled == false then return end
	if type(str) == "table" then str = tojson(str) end
	Util.LogError(str)
end

function log.ts(s)
    require("Common.fun")
    local t = now_millisecond() or ""
    log.r(s,os.date("%Y-%m-%d %H:%M:%S", t/1000) .." " .. (t%1000))
end

-- 生成日志内容
function log.connect(...)
    if log.enabled == false then return end
    local args = {...}
    for i,s in ipairs(args) do
        args[i] = tojson(s)
    end
    local ret = table.concat(args,space)
    ret = ret .. enter2 .. debug.traceback() .. enter2
    return ret
end

-- 打印一层
function log.one(_table)
    Util.Log("打印一层"..tostring(_table ~= nil))
    if type(_table) == "table" then
        local str = "{"
        local sp = "\n"
        for k,v in pairs(_table) do
            local key = k
            if type(key) == "number" then key = '['..key..']' end
            if type(v) == "table" then
                str = str..sp..tab..tostring(key).." = ".."table"
            else
                str = str..sp..tab..tostring(key).." = "..(tostring(v) or "nil")
            end
            sp = ",\n"
        end
        str = str..enter.."}"..enter2..debug.traceback() .. enter2
        Util.Log(str)
    end
end

-- 打印两层
function log.two(_table)
    Util.Log("打印两层"..tostring(_table ~= nil))
    if type(_table) == "table" then
        local str = "{"
        local sp = "\n"
        for k,v in pairs(_table) do
            local key = k
            if type(key) == "number" then key = '['..key..']' end
            if type(v) == "table" then
                local _str = tab.."{"
                local _sp = "\n"
                for _k,_v in pairs(v) do
                    local _key = _k
                    if type(_key) == "number" then _key = '['.._key..']' end
                    if type(_v) == "table" then
                        _str = _str.._sp..tab..tab..tostring(_key).." = ".."table"
                    else
                        _str = _str.._sp..tab..tab..tostring(_key).." = "..(tostring(_v) or "nil")
                    end
                end
                str = str..enter..tab.."}"
                str = str..sp..tab..tostring(key).." = ".._str
            else
                str = str..sp..tab..tostring(key).." = "..(tostring(v) or "nil")
            end
            sp = ",\n"
        end
        str = str..enter.."}"..enter2..debug.traceback() .. enter2
        Util.Log(str)
    end
end

-- 打印两层
function log.EditorLog(s)
    if fun.IsEditor() then
        log.y(s)
    end
end

-- -- 普通日志
-- function log.i(...)
--     Util.Log(log.connect(...))
-- end

-- -- 警告日志
-- function log.w(...)
--     Util.LogWarning(log.connect(...))
-- end

-- -- 错误日志
-- function log.r(...)
--     Util.LogError(log.connect(...))
-- end

function log.print_pos(go)
    log.r("打印自己及父级的坐标xxxxxxxxxxxxxxxxxx")
    local parent = go.transform
    while parent do
        log.r({parent.name,parent.localPosition})
        parent = parent.parent
    end
end

-- 用hello world标记日志，方便在Console Pro搜索一系列日志
function log.dump(tbl, desc)
	log.b("hello world " .. tostring(desc), tbl)
end



