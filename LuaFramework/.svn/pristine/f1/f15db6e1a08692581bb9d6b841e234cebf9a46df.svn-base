HangUpEffectView = BaseChildView:New();
local this = HangUpEffectView;

this.parentObj = nil
this.parent = nil

local SHOW_TIME_LONG = 1
local SHOW_TIME_SHORT = 0.3
this.currNum =0
this.isPlaying = false
local max_head =1

function HangUpEffectView:Init(parent_obj,bingoView)
    this:on_init(cardRef)
    --data  =  ModelList.GameModel:LoadGameData()
    this.parentObj = parent_obj
    this.parent = bingoView
    this.parentObj.gameObject:SetActive(false)
    local obj_ref = fun.get_component(parent_obj,fun.REFER)
    this.head = obj_ref:Get("Head")
    this.light =  obj_ref:Get("img_light")
    max_head = Csv.GetDataLength("robot_name")
    this.isPlaying = false
    --this:InitCardSwitch()
end


--初始化多卡牌切换
function HangUpEffectView :SetData (num)
    this.currNum = this.currNum + num
    if this.currNum >0  and not this.isPlaying then
        this:StartCountdown()
    end
end

function HangUpEffectView:StartCountdown()
    this:SetHead()
    this.parentObj.gameObject:SetActive(true)
    this.isPlaying = true
    --log.r("this.isPlaying = true "..this.currNum)
    local show_time = SHOW_TIME_SHORT
    if this.currNum == 1 then show_time = SHOW_TIME_LONG end
    --log.r("StartCountdown "..show_time)
    this.timerId = LuaTimer:SetDelayFunction(1, function()
        this.parentObj.gameObject:SetActive(false)
        this.currNum = this.currNum -1
        this.isPlaying = false
        --log.r("this.isPlaying = false ")
        if this.currNum ==  0 then
            this:StopCountdown()
        else
           this:StartCountdown()
        end
    end ,true)

end

function HangUpEffectView:SetHead()
        local ran_index = math.random(1,max_head)
        local data = Csv.GetData("robot_name",ran_index,"icon")
    --log.r("SetHead"..data.."   "..max_head)
        this.head.sprite = AtlasManager:GetSpriteByName("HeadAtlas",data)
end

function HangUpEffectView:StopCountdown()
    --log.r("StopCountdown ")
    if this.timerId then
        LuaTimer:Remove(this.timerId)
        this.timerId = nil
    end
end

function HangUpEffectView:on_x_update()
    --[[
    local active = fun.get_active_self(this.parentObj.gameObject)
    if this.isPlaying  == false  and not active and this.currNum>0 then
        this:StopCountdown()
        this:StartCountdown()
        this.isPlaying = true
        --log.r("this.isPlaying = true ")
    end
    --]]
    if fun.is_not_null(this.light) then
        this.light.transform:Rotate(0,0,50*Time.deltaTime)
    end
end

return this