local FlyRewardEffectsView = require "View/FlyRewardEffectsView/FlyRewardEffectsView"
local FlyOtherEffectsView = FlyRewardEffectsView:New(nil,nil)
local this = FlyOtherEffectsView
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog
this.flyIconList = {}
this.currIndex = 0
local itemCount = 6
this.delay = 0
function FlyOtherEffectsView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FlyOtherEffectsView:SetIcon(icon,iconPar)
    --this.delay = this.delay + 0.5
    for i = 1, itemCount do
        local newIcon = fun.get_instance(icon,iconPar)
        table.insert(this.flyIconList ,newIcon)
        fun.set_same_position_with(newIcon,icon)
    end
end
function FlyOtherEffectsView:OnEnable()

end


function FlyOtherEffectsView:Show()
    self._init = true
    this.currIndex =  this.currIndex
    this.delay = 0
    for i = 1, itemCount do
        local curIndex = this.currIndex + i
        LuaTimer:SetDelayFunction(this.delay,function()
            local startPos = fun.get_gameobject_pos(this.flyIconList[curIndex],false)
            local endPos =  self:GetFlyTargetPos()
            local path = {}
            path[1] = fun.calc_new_position_between(startPos, endPos, 0.65 , 1, 0)
            path[2] = endPos
            fun.set_active(this.flyIconList[curIndex],true)
            Anim.bezier_move(this.flyIconList[curIndex],path,1,0,1,2,function()
                if curIndex%6 == 0 then
                    Cache.load_prefabs(AssetList.FlyRewardhit,"FlyRewardhit",function(obj)
                        local go = fun.get_instance(obj,self.go)
                        local pos = GetShowHeadIconPos()
                        fun.set_gameobject_pos(go,pos.x,pos.y,0,false)
                        Destroy(go,1)
                    end)
                end
                if curIndex == #this.flyIconList then
                    --log.r("FlyOtherEffectsView  Finish")
                    self:Finish()
                    this:OnDisable()
                end
                Destroy(this.flyIconList[curIndex])
            end)
        end)
        this.delay = this.delay + 0.1
    end
    this.currIndex = this.currIndex + itemCount
    log.r("this.currIndex  "..this.currIndex)
end


function FlyOtherEffectsView:GetFlyTargetPos()
    return GetShowHeadIconPos()
end





function FlyOtherEffectsView:OnDisable()
    --log.r("FlyOtherEffectsView  disable")
    this.flyIconList = {}
    this.currIndex = 0
    this.delay = 0
end
return FlyOtherEffectsView