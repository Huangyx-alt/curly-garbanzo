HangUpBingoEffectView = BaseChildView:New();
local this = HangUpBingoEffectView;

this.parentObj = nil
this.parent = nil
this.animator = nil

local SHOW_TIME_LONG = 1.5
local SHOW_TIME_SHORT = 0.1
this.currNum =0
this.isPlaying = false
local max_head =1
this.show_time = 1
this.leftTxt = nil
this.Bingosi_txt =  nil

function HangUpBingoEffectView:Init(parent_obj,bingoView,bingofosi)
    this:on_init(parent_obj)
    this.parentObj = parent_obj
    this.parent = bingoView
    local leftObj = fun.find_child( bingofosi,"BingosiLeft")
    this.Bingosi_txt = fun.get_component(leftObj,"Text")
    this.parentObj.gameObject:SetActive(false)
    this.animator = fun.get_component(parent_obj,fun.ANIMATOR)
    local obj_ref = fun.get_component(parent_obj,fun.REFER)
    this.head = obj_ref:Get("Head")
    this.light =  obj_ref:Get("img_light")
    max_head = Csv.GetDataLength("robot_name")
    this.isPlaying = false
    this:Register()
end


function HangUpBingoEffectView:Register()
    Event.AddListener( Notes.QUICK_REDUCE_BINGOSILEFT,self.StartQuickReduceBingosileft)
end

function HangUpBingoEffectView:UnRegisterEvent()
    Event.RemoveListener( Notes.QUICK_REDUCE_BINGOSILEFT,self.StartQuickReduceBingosileft)
end

--初始化多卡牌切换
function HangUpBingoEffectView :SetData (num,next)
    this.currNum = this.currNum + num
    if not next or next < 0 then
        return
    end
    --local ava_time = SHOW_TIME_LONG
    --if this.currNum > 0 then
    --    ava_time = next / this.currNum
    --end
    --if ava_time > SHOW_TIME_LONG then
    --    ava_time = SHOW_TIME_LONG
    --end
    --this.show_time = ava_time
    if this.currNum > 0 and not this.isPlaying then
        this:StartCountdown(num)
    end
end

function HangUpBingoEffectView:StartCountdown(num)
    this:SetHead()
    this.parentObj.gameObject:SetActive(true)
    this.isPlaying = true
    --log.r("this.isPlaying = true "..this.currNum)
    local show_time = this.show_time
    this.timerId_pre = LuaTimer:SetDelayFunction(show_time-0.1, function()
        if this.parentObj  and this.parentObj.gameObject then
            this.animator:Play("bingo_head_fade_out")
        end
    end ,true)

    this.timerId = LuaTimer:SetDelayFunction(show_time, function()
        if this.parentObj  and this.parentObj.gameObject then
            this.parentObj.gameObject:SetActive(false)
            this.currNum = this.currNum -1
            this.isPlaying = false
            --log.r("this.isPlaying = false ")
            if this.currNum ==  0 then
                this:StopCountdown()
            else
                this:StartCountdown()
            end
        else
            this:StopCountdown()
        end

    end ,true)

end

function HangUpBingoEffectView:SetHead()
    --log.r("SetHead   "..this.currNum)
    local ran_index = math.random(1,max_head)
    local data = Csv.GetData("robot_name",ran_index,"icon")
    this.head.sprite = AtlasManager:GetSpriteByName("HeadAtlas",data)
    --UISound.play("bingosleft")
    local normal_speed = 1
    for i = 2, this.currNum do
        normal_speed =  normal_speed +0.3
        if normal_speed >=2 then
            normal_speed =2
            break
        end
    end
    --log.r("Brocast(Notes.REFRSH_BINGOSI_CHANGE")
    --Event.Brocast(Notes.REFRSH_BINGOSI_CHANGE,1)
    Facade.SendNotification(NotifyName.Bingo.REFRSH_BINGOSI_CHANGE,1)

    -- 单独为这个声音加速
    local mana = UnityEngine.GameObject.Find("GameManager")
    if mana then
        local obj = fun.find_child(mana,"bingosleft.mp3")
        if obj then
            local ad = fun.get_component(obj,"AudioSource")
            local a_name = ad.gameObject.name
            if ad  and  StringUtil.contains(a_name,"bingosleft")  then
                ad.pitch = normal_speed
                --log.r(ad.name.."   speed  "..normal_speed)
            end
        end
    end
end

function HangUpBingoEffectView:StopCountdown()
    --log.r("StopCountdown ")
    if this.timerId then
        LuaTimer:Remove(this.timerId)
        this.timerId = nil
    end
end

function HangUpBingoEffectView.OnDisable()
    if   this.timerId then
        LuaTimer:Remove(this.timerId)
    end
    this.parentObj = nil
    this.parent = nil
    this.animator = nil

    this.currNum =0
    this.isPlaying = false
    this.show_time = 1
    this:UnRegisterEvent()
end

function HangUpBingoEffectView:on_x_update()
    --[[
    local active = fun.get_active_self(this.parentObj.gameObject)
    if this.isPlaying  == false  and not active and this.currNum>0 then
        this:StopCountdown()
        this:StartCountdown()
        this.isPlaying = true
        --log.r("this.isPlaying = true ")
    end
    --]]
    if this.light then
        this.light.transform:Rotate(0,0,50*Time.deltaTime)
    end
    if this.quick_reduce_bingoleft then
        this:QuickReduceBingosileft()
    end
end

function HangUpBingoEffectView:QuickReduceBingosileft()
    this.quick_reduce_bingoleft_time = this.quick_reduce_bingoleft_time + UnityEngine.Time.deltaTime
    if this.quick_reduce_bingoleft_time < this.quick_reduce_total_time then
        if this.quick_reduce_bingoleft_time>= this.quick_reduce_time2 then
            this.quick_reduce_time2 = this.quick_reduce_time2 + this.quick_reduce_bingoleft_time_interval

            local number = tonumber(this.Bingosi_txt .text)
            local new_num = math.ceil( number - 1)
            if new_num<= 0 then  new_num = 0 end
            this.Bingosi_txt .text = tostring(new_num)
            --log.r("lefttext "..new_num)
        end
    else
        --log.r("lefttext  00")
        this.Bingosi_txt .text = "0"
        this.quick_reduce_bingoleft = false
    end
end

-- 开始快速减少bingoleft数量
function HangUpBingoEffectView.StartQuickReduceBingosileft()
   -- log.r("QUICK_REDUCE_BINGOSILEFT  222 "..this.currNum .. "    ")
    local leftCount = this.currNum + tonumber(this.Bingosi_txt.text)
    --log.r("StartQuickReduceBingosileft "..leftCount)
    if leftCount >0 then
        this.quick_reduce_bingoleft = true
        this.quick_reduce_total_time = MCT.delay_to_show_settle -0.1
        this.quick_reduce_bingoleft_time =  0
        this.quick_reduce_bingoleft_time_interval =  this.quick_reduce_total_time/leftCount
        this.quick_reduce_time2 =  this.quick_reduce_bingoleft_time_interval
    end
end

return this