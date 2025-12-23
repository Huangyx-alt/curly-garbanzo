StringUtil = {}

function StringUtil.contains(src, target)
    return nil ~= string.find(src, target)
end
function StringUtil.cancat(array) --字符串连接  只有一次内存创建
    return table.concat(array)
end
--TODO 待优化性能
function StringUtil.start_with(src , target)
    if type(src) ~= 'string' or type(target) ~= 'string' then return false end
    if not src or not target then return false end
    local length = string.len(target)
    if length > string.len(src) then
        return false
    end

    for i=1,length do
        if string.byte(src,i) ~= string.byte(target,i) then return false end
    end
    return true
end

function StringUtil.split_string(content, sep)
    if type(content) == "string" then
        if content == nil or #content == 0 then return nil end
        
        if sep == nil or #sep == 0 then return content end
        
        local text_arr = {}
        local pattern = string.format("([^%s]+)", sep)
        string.gsub(content, pattern, function (c) text_arr[#text_arr + 1] = c end)

        return text_arr
    end
    return ""
end

function StringUtil.is_empty(content)
    if not content then
        return true
    else
        if type(content) == "string" then
            local length = #content
            if length == 0 or content == "" or content == "nil" then
                return true
            end
        else
            return true
        end
    end

    return false
end

