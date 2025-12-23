--账号等级展示和加成展示

local base = CommandBase
local CmdLevelAttribute = BaseClass("CmdLevelAttribute", base)
function CmdLevelAttribute:OnCmdExecute(levelAttributeItem , level)
    local ref = fun.get_component(levelAttributeItem , fun.REFER)
    local textLevel = ref:Get("textLevel")
    local textAttribute = ref:Get("textAttribute")
    local data = Csv.GetData("new_level", level)
    textLevel.text = level
    textAttribute.text = string.format("%s%s" ,data.shop_added , "%" )
end

return CmdLevelAttribute