require "Common.fun"
-- require "Logic.My"

UserData = {}
UserData.cache = {}
UserData.uid = ""

function UserData.set_uid(uid)
    UserData.uid = uid
    log.r("=========================================>>uid " .. uid)
end

-- 序列化(带缓存)
function UserData.set_global(key,value)
    key = key
    --log.g("保存用户数据...",key,value)
    UserData.cache[key] = value
    if type(value) == "table" then
        local s = TableToJson({v = value})
        UnityEngine.PlayerPrefs.SetString(key,s)
    else
        UnityEngine.PlayerPrefs.SetString(key,tostring(value))
    end

end

function UserData.get_global(key,default)
    key = key
    local value = UserData.cache[key]
    if value == nil then
        local s = UnityEngine.PlayerPrefs.GetString(key)
        if s == "" then
            s = nil
        else
            s = JsonToTable(s)
        end
        if type(s) == "table" then
            value = s.v
        else
            value = s
        end
        value = value or default
        UserData.cache[key] = value
    end
    return value
end
function UserData.set(key,value)
    key = key .. UserData.uid
    --log.g("保存用户数据...",key,value)
    UserData.cache[key] = value
    --log.g("...保存成功!",key,value)
    local s = TableToJson({v = value})
    UnityEngine.PlayerPrefs.SetString(key,s)
end

-- 反序列化(带缓存)
function UserData.get(key,default)
    key = key .. UserData.uid
    local value = UserData.cache[key]
    if value == nil then
        local s = UnityEngine.PlayerPrefs.GetString(key)
        if s == "" then
            s = nil
        else
            s = JsonToTable(s)
        end
        if type(s) == "table" then
            value = s.v
        else
            value = s
        end
        value = value or default
        UserData.cache[key] = value
    end
    return value
end

-- 清空缓存
function UserData.clear()
    UserData.cache = {}
end


--- 内部集成uid 不带缓存
function UserData.set_nocache(key,value)
    key = key .. UserData.uid
    fun.save_value(key,value)
end

--- 内部集成uid 不带缓存
function UserData.read_nocache(key,default)
    key = key .. UserData.uid
    local l_value = fun.read_value(key) or default
    return l_value
end

--- 内部集成uid 不带缓存
function UserData.delete_nocache(key)
    key = key .. UserData.uid
    fun.delete_value(key)
end

