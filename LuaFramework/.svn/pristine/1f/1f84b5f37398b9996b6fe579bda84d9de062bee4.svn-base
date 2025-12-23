MD5Checker = Clazz()

local database = nil
local record_cnt = 0

function MD5Checker.init()
    database = {}
end

function MD5Checker.add_md5_data(url, md5)
    if url and md5 and type(md5)=="string" and #url > 0 and #md5 > 0 then
        local key = Util.md5(url)
        database[key] = md5
        fun.save_value("md5_"..key, md5) 
    end
end

function MD5Checker.check_exist_file(dir)
    local files = Util.GetAllFiles(dir)
    for i = 0, files.Length -1 do
        local file_path = files[i]
        if not fun.ends(file_path, "zip") then
            if fun.file_exist(file_path) then
                if not MD5Checker.check(file_path) then
                    fun.remove_file(file_path)
                    log.r(file_path, " not passed md5 check")
                end
            end
        end
    end
end

function  MD5Checker.removeEx(postFixName)
    local idx = postFixName:match(".+()%.%w+$") --获取文件后缀
    local ret = postFixName
    if idx then 
         ret = postFixName:sub(1, idx - 1) 
    end
    return ret 
end


function MD5Checker.check(file)
    local prefix, postfix = fun.split_path(file,"assetsstorage")
    postfix = MD5Checker.removeEx(postfix)
    if fun.file_exist(file) then
        if LuaFramework.Util and LuaFramework.Util.md5file then
            local file_md5 = LuaFramework.Util.md5file(file)
            local md5_in_database = database[postfix]
            if md5_in_database then
                return file_md5 == md5_in_database
            else
                local md5_in_playerprefs = fun.read_value("md5_"..file_md5)
                if md5_in_playerprefs then
                    return file_md5 == md5_in_playerprefs
                else
                    return true
                end
            end
        end
    else
        return false
    end
end

function MD5Checker.parse(str)
    local t = {}
    for chunk in string.gmatch(str, "[^\n\r]+") do
        t[#t+1] = chunk
    end
    return t

end