local ClubWeekTopInfo = BaseView:New('ClubWeekTopInfo')
local this = ClubWeekTopInfo

function ClubWeekTopInfo:New(Data)
    local o = {};
    setmetatable(o, { __index = this, })
    o._data = Data
    return o
end

this.auto_bind_ui_items = {
    "Package1Text",
    "Package2Text",
    "Package3Text",
    "NameTxt",
    "imgHead"
}

function ClubWeekTopInfo:Awake()
    self:on_init()
end

function ClubWeekTopInfo:OnEnable()
end

function ClubWeekTopInfo:OnDisable()
end

function ClubWeekTopInfo:Updata()
    local clubWeekInfo = ModelList.ClubModel.getWeeklyLeader()

    if clubWeekInfo and #clubWeekInfo >0  then 
        local topInfo = clubWeekInfo[1]
        local pack1 = 0 
        local pack2 = 0 
        local pack3 = 0 
        local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(topInfo.player.avatar)

        for _,v in pairs(topInfo.sendPacket) do
            local itemInfo = Csv.GetData("item",v.id)
            if itemInfo ~= nil then 
                if itemInfo.result[1] == 27 and itemInfo.result[2] == 1 then 
                    pack1 = v.value
                elseif itemInfo.result[1] == 27 and itemInfo.result[2] == 2 then 
                    pack2 =  v.value
                elseif itemInfo.result[1] == 27 and itemInfo.result[2] == 3 then 
                    pack3 =  v.value
                end 
            end 
        end 

        fun.set_active(self.imgHead,true)
        self.Package1Text.text = tostring(pack1)
        self.Package2Text.text = tostring(pack2)
        self.Package3Text.text = tostring(pack3)
        self.NameTxt.text = topInfo.player.nickname 
       -- self.imgHead.sprite = AtlasManager:GetSpriteByName("HeadAtlas",iconSpriteName)
        ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(iconSpriteName, self.imgHead)
    else 
        fun.set_active(self.imgHead,false)
        self.Package1Text.text = "0"
        self.Package2Text.text = "0"
        self.Package3Text.text = "0"
        self.NameTxt.text = ""
    end 
end 

return this