--vip等级图标展示和vip加成展示

local base = CommandBase
local CmdVipAttribute = BaseClass("CmdVipAttribute", base)
function CmdVipAttribute:OnCmdExecute(vipAttributeItem , vipLevel)
    local ref = fun.get_component(vipAttributeItem , fun.REFER)
    local vipIcon = ref:Get("vipIcon")
    local textAttribute = ref:Get("textAttribute")
    vipIcon.sprite = AtlasManager:GetSpriteByName("VipAtlas", "VIP" .. vipLevel)
    local vipInfo = Csv.GetData("new_vip", vipLevel)
    textAttribute.text = string.format("%s%s%s", "+" ,vipInfo.shop_added , "%" )
end

return CmdVipAttribute