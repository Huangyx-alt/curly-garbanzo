local json = require "cjson"

MachineUtil = {}
MachineUtil.APP_ID = "0"

--//TODO 在设备上运行时机台初始化时将数据读取至Machine保存，避免每次Lua与C#交互
--//为了运行时方便修改，编辑器运行时保持从C#获取数据
MachineUtil.REEL_ANIM_CFG = nil

function MachineUtil.read_machine_version(machine_id)
    local v = MyGame.VersionReader.GetMachineVersion(machine_id)
    if v == 0 then
        return MyGame.VersionReader.GetMachineVersionInPack(machine_id)

    end
    return v
end
function MachineUtil.query_machine_version(machine_id, local_version, callback)
    local version = local_version 
    -- 默认没有下载过的version为0
    if local_version == nil then
        version = 0
    end


    Http.check_machine_version(Http.APP_ID, machine_id, local_version, function(code, message, data)
            if code == RET.RET_SUCCESS then 

                local tmpdata = nil 
                for k,v in pairs(data.moduleList) do
                    if v.moduleId == machine_id then 
                        tmpdata = v;
                        break;
                    end 
                end

                MD5Checker.add_md5_data(tmpdata.resourceInfo.url,tmpdata.resourceInfo.lateset_md5)
                local has_update = tmpdata.version > local_version or false
                if callback then callback(has_update, tmpdata.version, tmpdata)
            end
        end
    end)
end

-- 根据配置表创建转轴元素序列
function MachineUtil.create_col_item_list_for_sample(machineId,sample_items,feature_name)
    local t = {}
    for i, v in ipairs(sample_items) do
        t[i] = {element_id = v, value = ""}
    end
    return MachineUtil.deal_col_item_list(machineId,t,feature_name)
end
function MachineUtil.get_cur_bonus_config(machineId,feature_name)
    local bet_index = BetManager.get_bet_index()
    local bonus_config = StaticData.get_bonus_config(machineId,feature_name,bet_index)
    return bonus_config
end
function MachineUtil.get_random_bonus_value(bonus_config)
    local value = 1
    --total_power权重的总数值，随机[1,total_power]
    local rdm = math.random(bonus_config.total_power)
    --寻找属于权重区间里的数字,一定是有的
    for _,vv in ipairs(bonus_config.bonus_ratio) do
        if rdm >= vv.min and rdm < vv.max then
            value = vv.value
            break
        end
    end
    --强转number失败，表示是特殊字符串"Major"
    local string2Num = tonumber(value)
    local ans = 0
    if string2Num ~= nil then
        --v.value = string2Num
        ans = string2Num *BetManager.get_total_bet()/100 --统一除以100
    else
        --log.r("强转number失败 沒有找到权重区间里的数字: "..rdm)
        ans = value
    end
    return ans
end
function MachineUtil.deal_col_item_list(machineId,col_item_list,feature_name)

    local r = col_item_list
    local bonus_config = MachineUtil.get_cur_bonus_config(machineId,feature_name)
    if bonus_config == nil then
        if(StaticData.is_has_bonus(machineId)) then
            log.r("warning! no find bonus_config of machineId: "..machineId.."feature_name: "..feature_name.." bet_level: "..tostring(bet_index))
            return r
        else
            return r
        end
    end
    for i,v in ipairs(r) do
        v.value = MachineUtil.get_random_bonus_value(bonus_config)
    end
    return r
end

function MachineUtil.replace_items(src_items, target_items, for_replace_items)
    local clone = DeepCopy(src_items)
    if #target_items == 0 or #for_replace_items == 0 then
        return clone 
    end

    for i, src in ipairs(clone) do
        for j, target in ipairs(target_items) do
            if src == target then
                local ramdom = for_replace_items[math.random(1, #for_replace_items)]
                clone[i] = ramdom
                break
            end
        end
    end
    return clone
end


function MachineUtil.remove_elements_mask(elements)
    if elements then
        for _, col in pairs(elements) do
            for _, element in pairs(col) do
                if element.value then
                    local paras = StringUtil.split_string(element.value, ",")
                    if paras and #paras > 0 and paras[1] == "Stack" then
                        if #paras > 1 then
                            element.value = paras[2]
                        else
                            element.value = ""
                        end
                        element.has_mask = false
                        element.mask_prefab = ""
                    end
                end
            end
        end
    end
end