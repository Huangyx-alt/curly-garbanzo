require "M1.PackageLoader"
--require "Scene.SceneGame"
local Command = {};

function Command.Execute(notifyName, ...)

    --local entermachineModel, args = HandleNotifyParams(...);
    local f = function()
        local machine_id = 1
        local package = require("M"..machine_id..".Package")
--[[        Command.registerSound(entermachineModel,machine_id)]]
        PackageLoader.load(machine_id,package.clazz_list) --将机台的类，导入到全局作用域
       -- Command.initGlobalDataInSceneGame(entermachineModel,machine_id,package.effect_list)  --在SceneGame中创建需要全局访问的类
 
    end
    xpcall(f,__G__TRACKBACK__)

end

--[[
    @desc: 
    author:{author}
    time:2020-11-12 16:09:04
    --@entermachineModel:存放进机台前的一些数据,比如初始排名,jackpot等
	--@machine_id:机台id
	--@preload_effect_list: 需要提前加载的特效
    @return:
]]
function Command.initGlobalDataInSceneGame(entermachineModel,machine_id,preload_effect_list)
    --加载机台音频
    -- if(SceneGame ==nil) then SceneGame = {} end 
    --SceneGame.MachineView,SceneGame.MachineModel,SceneGame.MachineControl = Command.registerMachine(machine_id)
    --SceneGame.CM = Command.registerCellManager(entermachineModel,machine_id,preload_effect_list)
print("=============================================>>initGlobalDataInSceneGame " .. machine_id )
end



--[[
    @desc: 
    author:{author}
    time:2020-11-12 16:08:29
    --@entermachineModel:存放进机台前的一些数据,比如初始排名,jackpot等
	--@machine_id:机台id
	--@preload_effect_list: 需要提前加载的特效
    @return:
]]
function Command.registerCellManager(entermachineModel,machine_id,preload_effect_list)
    local cm = CellManager:new()
    cm:init(machine_id,preload_effect_list)
    cm:preload_res( 
            function()
                -- 结束回调
            
                entermachineModel:set_finish()
            end)
    return cm
end

function Command.registerMachine(machine_id)
    local viewName = "MachineM"..machine_id.."View"
    local modelName = "MachineM"..machine_id.."Model"
    local controlName = "MachineM"..machine_id.."Control"
    return  _G[viewName],_G[modelName],_G[controlName]
end
return Command;