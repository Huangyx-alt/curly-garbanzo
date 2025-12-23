--require 'Machine.BigWinView'
PackageLoader = {}

--将机台的类，导入到全局作用域
function PackageLoader.load(machine_id,clazz_list)
    log.r("PackageLoader.load",clazz_list)

    for i,v in ipairs(clazz_list) do
        local s = Split(v,"%.")
        local name = s[#s]   --取最后的 Lua名字 比如  "ModeState.StateHoldSpinFreespin",   name = StateHol1dSpinFreespin
        _G[name] = require("M"..machine_id.."."..v)
    end

    --XXX = require("M10007.XXX")
end




function PackageLoader.unload(machine_id,clazz_list)
    log.r("PackageLoader.unload",machine_id,clazz_list)
    for i,v in ipairs(clazz_list) do
        local s = Split(v,"%.")
        local name = s[#s]   --取最后的 Lua名字 比如  "ModeState.StateHoldSpinFreespin",   name = StateHol1dSpinFreespin
 

        _G[name] = nil
       

        --全局销毁lua脚本 
        local full_name = "M"..tostring(machine_id).."."..v
        if(package.loaded[full_name])then 
            package.loaded[full_name] = nil
        end

 
    end
end
