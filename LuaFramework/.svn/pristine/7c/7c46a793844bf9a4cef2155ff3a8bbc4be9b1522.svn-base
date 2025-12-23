GameBingoEffectView = BaseChildView:New();
local this = GameBingoEffectView;

this.go = nil
this.parent = nil
this.animator = nil

this.currNum = 0
this.isPlaying = false
local max_head = 1
this.quick_reduce_bingoleft = false
this.quick_reduce_bingoleft_time = 0
this.quick_reduce_time2 = 0
this.quick_reduce_total_time = 0
this.quick_reduce_bingoleft_time_interval = 0

this.leftTxt = nil
local lastBingoTime = 0
local MaxBingoleftCount = 0
local currLeftCount = 0

function GameBingoEffectView:Init(obj, bingoView)
    this:on_init(obj, bingoView)
    this.parent = bingoView
    this.go.gameObject:SetActive(false)
    local obj_ref = fun.get_component(obj, fun.REFER)
    this.head = obj_ref:Get("Head")
    this.imageFrame = obj_ref:Get("imageFrame")

    this.light = obj_ref:Get("img_light")
    max_head = Csv.GetDataLength("robot_name")
    MaxBingoleftCount = #ModelList.BattleModel:GetCurrModel():LoadGameData().bingoLeftTick
    currLeftCount = MaxBingoleftCount
    this.isPlaying = false
    this:Register()
    lastBingoTime = 0
end

function GameBingoEffectView:Register()
    Event.AddListener(Notes.QUICK_REDUCE_BINGOSILEFT, self.StartQuickReduceBingosileft)
    Event.AddListener(EventName.Bingo_Refresh_Other_BingoCount, self.RefreshBingoCount)
end

function GameBingoEffectView:UnRegisterEvent()
    Event.RemoveListener(Notes.QUICK_REDUCE_BINGOSILEFT, self.StartQuickReduceBingosileft)
    Event.RemoveListener(EventName.Bingo_Refresh_Other_BingoCount, self.RefreshBingoCount)
end

function GameBingoEffectView.OnDestroy()
    this.currNum = 0
    lastBingoTime = 0
    this.isPlaying = false
    this.quick_reduce_bingoleft = false
    this.quick_reduce_bingoleft_time = 0
    this.quick_reduce_time2 = 0
    this.quick_reduce_total_time = 0
    this.quick_reduce_bingoleft_time_interval = 0
    this:UnRegisterEvent()
    this:Close()
    this:Destroy()
end

function GameBingoEffectView.RefreshBingoCount(owner, num, next)
    this.currNum = this.currNum + num
    if not next or next < 0 then
        return
    end

    if this.currNum > 0 and not this.isPlaying then
        this:StartCountdown(num)
    end
end

function GameBingoEffectView:StartCountdown(num)
    num = num or 1
    this:SetHead(num)
    this.go.gameObject:SetActive(true)
    currLeftCount = currLeftCount - num
    this:PlayBingosLeftSound()
    this.isPlaying = true
    
    if this.go and this.go.gameObject and currLeftCount > 0 then
        this.go.gameObject:SetActive(false)

        this.currNum = this.currNum - num
        this.isPlaying = false
        if this.currNum > 0 and currLeftCount > 0 then
            this:StartCountdown()
        end
    end
end

function GameBingoEffectView:SetHead(num)
    local ran_index = ModelList.BattleModel:GetCurrModel():GetBingoRobots()
    if ran_index == -1 then
        ran_index = math.random(1, max_head)
    end
    local data = Csv.GetData("robot_name", ran_index, "icon")
    if not ModelList.BattleModel.GetBattleSuperMatch() then
        local model = ModelList.PlayerInfoSysModel
        model:LoadTargetHeadSprite(data, this.head)
        model:LoadRobotTargetFrameSprite(ran_index, this.imageFrame)
    end

    local normal_speed = 1
    for i = 2, this.currNum do
        normal_speed = normal_speed + 0.3
        if normal_speed >= 2 then
            normal_speed = 2
            break
        end
    end

    Facade.SendNotification(NotifyName.Bingo.REFRSH_BINGOSI_CHANGE, num)
    -- 单独为这个声音加速
    local mana = UnityEngine.GameObject.Find("GameManager")
    if mana then
        local obj = fun.find_child(mana, "bingosleft.mp3")
        if obj then
            local ad = fun.get_component(obj, "AudioSource")
            if ad and ad.gameObject.name == "bingosleft.mp3" then
                ad.pitch = normal_speed
                --log.r(ad.name.."   speed  "..normal_speed)
            end
        end
    end
end

return this