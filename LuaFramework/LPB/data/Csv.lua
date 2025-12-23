local lua_data = {pay_1_low = {}, pay_2_middle = {}, pay_3_high = {}, pay_4_max = {}, pay_5_super = {}, pay_6_ultra = {}, }

lua_data.achievement = require 'data/achievement'
lua_data.activity = require 'data/activity'
lua_data.activity_round = require 'data/activity_round'
lua_data.admission_pay = require 'data/admission_pay'
lua_data.advertise = require 'data/advertise'
lua_data.appstorepurchaseconfig = require 'data/appstorepurchaseconfig'
lua_data.audio = require 'data/audio'
lua_data.banner_list = require 'data/banner_list'
lua_data.beginner = require 'data/beginner'
lua_data.beginner_card = require 'data/beginner_card'
lua_data.beginner_powerup = require 'data/beginner_powerup'
lua_data.bet_ultra = require 'data/bet_ultra'
lua_data.bingosleft_audio = require 'data/bingosleft_audio'
lua_data.bingosleft_timeline = require 'data/bingosleft_timeline'
lua_data.daub_cover = require 'data/daub_cover'
lua_data.bingo_distribute = require 'data/bingo_distribute'
lua_data.bingo_pay_up = require 'data/bingo_pay_up'
lua_data.bingo_pool = require 'data/bingo_pool'
lua_data.bingo_powerup = require 'data/bingo_powerup'
lua_data.bingo_rank = require 'data/bingo_rank'
lua_data.bingo_reward = require 'data/bingo_reward'
lua_data.bingo_rule = require 'data/bingo_rule'
lua_data.call_number = require 'data/call_number'
lua_data.card_expect = require 'data/card_expect'
lua_data.city = require 'data/city'
lua_data.city_bag = require 'data/city_bag'
lua_data.city_basket = require 'data/city_basket'
lua_data.city_bingorank = require 'data/city_bingorank'
lua_data.city_level = require 'data/city_level'
lua_data.city_message = require 'data/city_message'
lua_data.city_play = require 'data/city_play'
lua_data.city_play_seasoncard = require 'data/city_play_seasoncard'
lua_data.city_play_stage = require 'data/city_play_stage'
lua_data.city_recipe = require 'data/city_recipe'
lua_data.city_star = require 'data/city_star'
lua_data.client_bingo_rule = require 'data/client_bingo_rule'
lua_data.club_ask = require 'data/club_ask'
lua_data.club_default = require 'data/club_default'
lua_data.club_packet = require 'data/club_packet'
lua_data.coin_rank = require 'data/coin_rank'
lua_data.competition = require 'data/competition'
lua_data.competition_bingo = require 'data/competition_bingo'
lua_data.competition_daub = require 'data/competition_daub'
lua_data.competition_racing = require 'data/competition_racing'
lua_data.competition_racing_putin = require 'data/competition_racing_putin'
lua_data.competition_racing_round = require 'data/competition_racing_round'
lua_data.competition_round = require 'data/competition_round'
lua_data.competition_start = require 'data/competition_start'
lua_data.config_bind_bi = require 'data/config_bind_bi'
lua_data.config_system = require 'data/config_system'
lua_data.control = require 'data/control'
lua_data.cookierewardspritename = require 'data/cookierewardspritename'
lua_data.coupon = require 'data/coupon'
lua_data.description = require 'data/description'
lua_data.extra_ball = require 'data/extra_ball'
lua_data.extra_bonus = require 'data/extra_bonus'
lua_data.fame_list = require 'data/fame_list'
lua_data.fame_random = require 'data/fame_random'
lua_data.fame_round = require 'data/fame_round'
lua_data.feature_enter = require 'data/feature_enter'
lua_data.function_icon = require 'data/function_icon'
lua_data.game_battle_module = require 'data/game_battle_module'
lua_data.game_bingo_view = require 'data/game_bingo_view'
lua_data.game_card = require 'data/game_card'
lua_data.game_cell = require 'data/game_cell'
lua_data.game_effect_cache = require 'data/game_effect_cache'
lua_data.game_hall = require 'data/game_hall'
lua_data.game_help_setting = require 'data/game_help_setting'
lua_data.game_joker_setting = require 'data/game_joker_setting'
lua_data.game_mode = require 'data/game_mode'
lua_data.game_music = require 'data/game_music'
lua_data.game_pool_effect = require 'data/game_pool_effect'
lua_data.game_settle = require 'data/game_settle'
lua_data.game_switch_setting = require 'data/game_switch_setting'
lua_data.gift_pack_view_config = require 'data/gift_pack_view_config'
lua_data.goldenmelody = require 'data/goldenmelody'
lua_data.goldenmelody_reward = require 'data/goldenmelody_reward'
lua_data.golden_train_range = require 'data/golden_train_range'
lua_data.grocery = require 'data/grocery'
lua_data.guide_app = require 'data/guide_app'
lua_data.guide_step = require 'data/guide_step'
lua_data.guide_trigger = require 'data/guide_trigger'
lua_data.hitrate = require 'data/hitrate'
lua_data.induced = require 'data/induced'
lua_data.item = require 'data/item'
lua_data.item_synthetic = require 'data/item_synthetic'
lua_data.jackpot = require 'data/jackpot'
lua_data.level = require 'data/level'
lua_data.level_coefficient = require 'data/level_coefficient'
lua_data.level_open = require 'data/level_open'
lua_data.marked_pos_shape = require 'data/marked_pos_shape'
lua_data.minigame = require 'data/minigame'
lua_data.minigame_bet = require 'data/minigame_bet'
lua_data.minigame_box = require 'data/minigame_box'
lua_data.minigame_extra_ball = require 'data/minigame_extra_ball'
lua_data.minigame_moneymansion = require 'data/minigame_moneymansion'
lua_data.minigame_time = require 'data/minigame_time'
lua_data.modular = require 'data/modular'
lua_data.moneymansion = require 'data/moneymansion'
lua_data.moneymansion_show = require 'data/moneymansion_show'
lua_data.new_bingosleft = require 'data/new_bingosleft'
lua_data.new_bingo_reward = require 'data/new_bingo_reward'
lua_data.new_bingo_rule = require 'data/new_bingo_rule'
lua_data.new_chest = require 'data/new_chest'
lua_data.new_chest_putin = require 'data/new_chest_putin'
lua_data.new_city_play = require 'data/new_city_play'
lua_data.new_city_play_bet = require 'data/new_city_play_bet'
lua_data.new_city_play_feature = require 'data/new_city_play_feature'
lua_data.new_city_play_putin = require 'data/new_city_play_putin'
lua_data.new_city_play_scene = require 'data/new_city_play_scene'
lua_data.new_cookie_group = require 'data/new_cookie_group'
lua_data.new_cookie_putin = require 'data/new_cookie_putin'
lua_data.new_cookie_round = require 'data/new_cookie_round'
lua_data.new_function_icon = require 'data/new_function_icon'
lua_data.new_game_battle_module = require 'data/new_game_battle_module'
lua_data.new_game_bingo_view = require 'data/new_game_bingo_view'
lua_data.new_game_card = require 'data/new_game_card'
lua_data.new_game_cell = require 'data/new_game_cell'
lua_data.new_game_effect_cache = require 'data/new_game_effect_cache'
lua_data.new_game_hall = require 'data/new_game_hall'
lua_data.new_game_help_setting = require 'data/new_game_help_setting'
lua_data.new_game_mode = require 'data/new_game_mode'
lua_data.new_game_music = require 'data/new_game_music'
lua_data.new_game_pool_effect = require 'data/new_game_pool_effect'
lua_data.new_game_settle = require 'data/new_game_settle'
lua_data.new_guide_app = require 'data/new_guide_app'
lua_data.new_guide_step = require 'data/new_guide_step'
lua_data.new_guide_trigger = require 'data/new_guide_trigger'
lua_data.new_item = require 'data/new_item'
lua_data.new_item_synthetic = require 'data/new_item_synthetic'
lua_data.new_jackpot = require 'data/new_jackpot'
lua_data.new_level = require 'data/new_level'
lua_data.new_luckybang = require 'data/new_luckybang'
lua_data.new_minigame = require 'data/new_minigame'
lua_data.new_minigame_putin = require 'data/new_minigame_putin'
lua_data.new_pigbank_group = require 'data/new_pigbank_group'
lua_data.new_pigbank_spin = require 'data/new_pigbank_spin'
lua_data.new_pigbank_start = require 'data/new_pigbank_start'
lua_data.new_powerup = require 'data/new_powerup'
lua_data.new_powerup_group = require 'data/new_powerup_group'
lua_data.new_powerup_hit = require 'data/new_powerup_hit'
lua_data.new_powerup_replace = require 'data/new_powerup_replace'
lua_data.new_puzzle_group = require 'data/new_puzzle_group'
lua_data.new_puzzle_putin = require 'data/new_puzzle_putin'
lua_data.new_season_card_putin = require 'data/new_season_card_putin'
lua_data.new_season_pass_putin = require 'data/new_season_pass_putin'
lua_data.new_shop = require 'data/new_shop'
lua_data.new_shop_gift = require 'data/new_shop_gift'
lua_data.new_shop_powerup = require 'data/new_shop_powerup'
lua_data.new_skill = require 'data/new_skill'
lua_data.new_task = require 'data/new_task'
lua_data.new_vip = require 'data/new_vip'
lua_data.new_weeklylist_putin = require 'data/new_weeklylist_putin'
lua_data.personalise_edge = require 'data/personalise_edge'
lua_data.personalise_head = require 'data/personalise_head'
lua_data.pigbank_group = require 'data/pigbank_group'
lua_data.pigbank_spin = require 'data/pigbank_spin'
lua_data.pigbank_start = require 'data/pigbank_start'
lua_data.piggy_bank = require 'data/piggy_bank'
lua_data.piggy_bank_activity = require 'data/piggy_bank_activity'
lua_data.piggy_bank_user = require 'data/piggy_bank_user'
lua_data.play_begin = require 'data/play_begin'
lua_data.pop_up = require 'data/pop_up'
lua_data.pop_up_infinite = require 'data/pop_up_infinite'
lua_data.powerball_bet = require 'data/powerball_bet'
lua_data.powerball_reward = require 'data/powerball_reward'
lua_data.powerball_win = require 'data/powerball_win'
lua_data.powerup_card = require 'data/powerup_card'
lua_data.powerup_card_replace = require 'data/powerup_card_replace'
lua_data.powerup_card_season = require 'data/powerup_card_season'
lua_data.powerup_group = require 'data/powerup_group'
lua_data.powerup_group_lv1 = require 'data/powerup_group_lv1'
lua_data.powerup_group_lv2 = require 'data/powerup_group_lv2'
lua_data.powerup_joker_group = require 'data/powerup_joker_group'
lua_data.powerup_joker_item = require 'data/powerup_joker_item'
lua_data.powerup_novice = require 'data/powerup_novice'
lua_data.powerup_range = require 'data/powerup_range'
lua_data.powerup_range_joker = require 'data/powerup_range_joker'
lua_data.puzzle_card = require 'data/puzzle_card'
lua_data.pu_energy = require 'data/pu_energy'
lua_data.pu_migrate = require 'data/pu_migrate'
lua_data.reddotevent = require 'data/reddotevent'
lua_data.resources = require 'data/resources'
lua_data.reward_recall = require 'data/reward_recall'
lua_data.reward_signin = require 'data/reward_signin'
lua_data.reward_signin_progress = require 'data/reward_signin_progress'
lua_data.reward_sky = require 'data/reward_sky'
lua_data.robot_name = require 'data/robot_name'
lua_data.rocket = require 'data/rocket'
lua_data.rocket_consume = require 'data/rocket_consume'
lua_data.roulette = require 'data/roulette'
lua_data.santa_bingo = require 'data/santa_bingo'
lua_data.scratch_bingo = require 'data/scratch_bingo'
lua_data.season_box_open = require 'data/season_box_open'
lua_data.season_card = require 'data/season_card'
lua_data.season_card_box = require 'data/season_card_box'
lua_data.season_card_exchange = require 'data/season_card_exchange'
lua_data.season_card_group = require 'data/season_card_group'
lua_data.season_card_interval = require 'data/season_card_interval'
lua_data.season_card_time = require 'data/season_card_time'
lua_data.season_pass = require 'data/season_pass'
lua_data.season_pass_booster = require 'data/season_pass_booster'
lua_data.season_pass_pay = require 'data/season_pass_pay'
lua_data.season_pass_short = require 'data/season_pass_short'
lua_data.shop = require 'data/shop'
lua_data.shop_repay = require 'data/shop_repay'
lua_data.skill = require 'data/skill'
lua_data.supermatch_bot_bingo = require 'data/supermatch_bot_bingo'
lua_data.supermatch_smash = require 'data/supermatch_smash'
lua_data.task = require 'data/task'
lua_data.task_pass = require 'data/task_pass'
lua_data.task_pass_pay = require 'data/task_pass_pay'
lua_data.task_pass_roulette = require 'data/task_pass_roulette'
lua_data.task_pass_time = require 'data/task_pass_time'
lua_data.user_group_info = require 'data/user_group_info'
lua_data.user_hierarchy = require 'data/user_hierarchy'
lua_data.user_label = require 'data/user_label'
lua_data.user_layered = require 'data/user_layered'
lua_data.user_return = require 'data/user_return'
lua_data.victorybeats = require 'data/victorybeats'
lua_data.victorybeats_putin = require 'data/victorybeats_putin'
lua_data.victorybeats_revival = require 'data/victorybeats_revival'
lua_data.victorybeats_reward = require 'data/victorybeats_reward'
lua_data.vip = require 'data/vip'
lua_data.vip_description = require 'data/vip_description'
lua_data.volcano_group = require 'data/volcano_group'
lua_data.volcano_putin = require 'data/volcano_putin'
lua_data.volcano_revival = require 'data/volcano_revival'
lua_data.volcano_round = require 'data/volcano_round'
lua_data.webstore = require 'data/webstore'
lua_data.weeklist_bi_level = require 'data/weeklist_bi_level'
lua_data.weeklylist_points_bingo = require 'data/weeklylist_points_bingo'
lua_data.weeklylist_points_daub = require 'data/weeklylist_points_daub'
lua_data.weekly_list = require 'data/weekly_list'
lua_data.weekly_list_main = require 'data/weekly_list_main'
lua_data.weekly_list_new = require 'data/weekly_list_new'
lua_data.weekly_random = require 'data/weekly_random'
lua_data.weekly_round = require 'data/weekly_round'
lua_data.weekly_round_main = require 'data/weekly_round_main'
lua_data.window = require 'data/window'

lua_data.pay_1_low.bet_ultra = require 'data/pay_1_low/bet_ultra'
lua_data.pay_1_low.city_play = require 'data/pay_1_low/city_play'
lua_data.pay_1_low.minigame_bet = require 'data/pay_1_low/minigame_bet'
lua_data.pay_1_low.powerup_range = require 'data/pay_1_low/powerup_range'
lua_data.pay_1_low.shop = require 'data/pay_1_low/shop'

lua_data.pay_2_middle.bet_ultra = require 'data/pay_2_middle/bet_ultra'
lua_data.pay_2_middle.city_play = require 'data/pay_2_middle/city_play'
lua_data.pay_2_middle.minigame_bet = require 'data/pay_2_middle/minigame_bet'
lua_data.pay_2_middle.powerup_range = require 'data/pay_2_middle/powerup_range'
lua_data.pay_2_middle.shop = require 'data/pay_2_middle/shop'

lua_data.pay_3_high.bet_ultra = require 'data/pay_3_high/bet_ultra'
lua_data.pay_3_high.city_play = require 'data/pay_3_high/city_play'
lua_data.pay_3_high.minigame_bet = require 'data/pay_3_high/minigame_bet'
lua_data.pay_3_high.powerup_range = require 'data/pay_3_high/powerup_range'
lua_data.pay_3_high.shop = require 'data/pay_3_high/shop'

lua_data.pay_4_max.bet_ultra = require 'data/pay_4_max/bet_ultra'
lua_data.pay_4_max.city_play = require 'data/pay_4_max/city_play'
lua_data.pay_4_max.minigame_bet = require 'data/pay_4_max/minigame_bet'
lua_data.pay_4_max.powerup_range = require 'data/pay_4_max/powerup_range'
lua_data.pay_4_max.reward_sky = require 'data/pay_4_max/reward_sky'
lua_data.pay_4_max.shop = require 'data/pay_4_max/shop'

lua_data.pay_5_super.bet_ultra = require 'data/pay_5_super/bet_ultra'
lua_data.pay_5_super.city_play = require 'data/pay_5_super/city_play'
lua_data.pay_5_super.minigame_bet = require 'data/pay_5_super/minigame_bet'
lua_data.pay_5_super.powerup_range = require 'data/pay_5_super/powerup_range'
lua_data.pay_5_super.reward_sky = require 'data/pay_5_super/reward_sky'
lua_data.pay_5_super.shop = require 'data/pay_5_super/shop'

lua_data.pay_6_ultra.bet_ultra = require 'data/pay_6_ultra/bet_ultra'
lua_data.pay_6_ultra.city_play = require 'data/pay_6_ultra/city_play'
lua_data.pay_6_ultra.minigame_bet = require 'data/pay_6_ultra/minigame_bet'
lua_data.pay_6_ultra.powerup_range = require 'data/pay_6_ultra/powerup_range'
lua_data.pay_6_ultra.reward_sky = require 'data/pay_6_ultra/reward_sky'
lua_data.pay_6_ultra.shop = require 'data/pay_6_ultra/shop'

-------------------------手动代码请加入虚线之间----------------------
Csv = {}
local this = Csv

local mt = {
    __index = function(t,k)
        local key = ModelList.playerInfoModel.GetAbParamKeyValue(k) or k
        local souceTable = lua_data
        local groupPrefix = ModelList.playerInfoModel:GetGroupPrefix()
        if groupPrefix and lua_data[groupPrefix] and lua_data[groupPrefix][key] then
            souceTable = lua_data[groupPrefix]
        end
        if not souceTable[key] then
            return souceTable[k]
        else
            return souceTable[key]
        end
    end} 
setmetatable(this,mt) 
mt.__metatable = false

function Csv.GetDataNoAbTest(name,id,param)
    if not (lua_data[name] and lua_data[name][id]) then
        return nil
    end
    if param then
        return lua_data[name][id][param]
    else
        return lua_data[name][id]
    end
    return nil
end

function Csv.GetData(name,id,param)
    if not (this[name] and this[name][id]) then
        return nil
    end
    if param then
        return this[name][id][param]
    else
        return this[name][id]
    end
    return nil
end

function Csv.GetItemOrResource(id,param)
    if   ModelList.SeasonCardModel:IsCardPackage(id) then
        local itemInfo = ModelList.SeasonCardModel:GetCardPackageInfo(id)
        if itemInfo and param then
            return itemInfo[param]
        else
            return itemInfo
        end
    else
        return this.GetData("new_item",id,param)
    end
end

function Csv.GetControlByName(name)
    for i, v in pairs(this.control) do
        if v.name == name then
            return v.content
        end
    end
    return nil
end

function Csv.GetDataLength(name)
    if not this[name]  then
        return 0
    end
    return #this[name]
end

function Csv.GetAutoPhotoByPage(photoid,page,param)
    for index, value in ipairs(this.auto_photo) do
        if photoid == value.photo_id and page == value.page then
            if param then
                return value[param]
            end
            return value
        end
    end
    return nil
end

function Csv.GetCityLevel(city,level,gameMode)
    local data = this.city_level
    for index, value in ipairs(data) do
        if value.city == city and value.level == level then
            return value
        end
    end
    return nil
end

function Csv.GetPowerupRange()
    local data = this.powerup_range
    local tmp = {}
    for _,v in pairs(data) do
        if not tmp[v.cityid] then 
            tmp[v.cityid] ={}
        end 

        if not tmp[v.cityid][v.level] then 
            tmp[v.cityid][v.level] = {}
        end 
        tmp[v.cityid][v.level] = {
            bet=v.bet,
            range_pay = v.range_pay,
            range_pay_new = v.range_pay_new,
            joker_quantity = v.joker_quantity,
            joker_high_quantity = v.joker_high_quantity,
            range_pay_cutting = v.range_pay_cutting
        }
    end

    return tmp 
end

function Csv.GetfeatureData()
    return this["feature_enter"]
end 

--------获取挂机城市id
local m_autoCity = nil
function Csv.GetAutoCity()
    if m_autoCity then
        return m_autoCity
    else
        for key, value in pairs(this.city) do
            if value.city_type == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
                m_autoCity = value.id
                return m_autoCity
            end
        end
    end
    return 101
end
--------获取挂机城市id-------end

function Csv.GetDescription(id)
    return this.GetData("description",id,"description")
end

---根据当前游戏模式获取城市表数据
function Csv.GetCityData(gameMode,id,param)
    return  this.GetData("city",id,param)
end

--得到City play 城市的数据
function Csv.GetCityPlayData(id,param)
    return  this.GetData("city_play",id,param)
end 

--jackPot 废弃代码
function Csv.GetLevelOpenByType(typeId,typeValue)
    for key, value in pairs(this.level_open) do
        if value.typeid == typeId and value.typeid_value == typeValue then
            return value.openlevel
        end
    end
    return 0
end

--jackPot CITY_PLAY 表中，id
function Csv.GetLevelJPOpenById(id,betRate)
    for _,v in pairs(this.city_play) do
        if v.city_id == id and v.default == 1 then
            return type(v.level_open[betRate]) =="table" and v.level_open[betRate][2] or v.level_open[betRate]
        end 
    end
    return 0 -- 默认解锁
end 

--jackPot CITY_PLAY 表中，id
function Csv.GetLevelJPOpenByPlayId(id,betRate)
    for _,v in pairs(this.city_play) do
        if v.id == id  then
            return type(v.level_open[betRate]) =="table" and v.level_open[betRate][2] or v.level_open[betRate]
        end 
    end
    return 0 -- 默认解锁
end 

--jackPot CITY_PLAY 表中，id 付费用户
function Csv.GetLevelJPOpenByPlayIdPay(id,betRate)
    for _,v in pairs(this.city_play) do
        if v.id == id  then
            return type(v.pay_level_open[betRate]) =="table" and v.pay_level_open[betRate][2] or v.pay_level_open[betRate]
        end 
    end
    return 0 -- 默认解锁
end 


--得到city level 默认bet区间
function Csv.GetControlId(id,level)
    if not this.city_play[id] then 
        return 1
    end
    
    for _,v in pairs(this.city_play[id].default_bet) do
        if v[2] <= level and level <= v[3] then 
            return v[1]
        end 
    end 

    return 1 -- 不在区间内，返回1
end

--获取倍数 
function Csv.GetMaxRateOpen(cityid,level)
    local level_open = nil
    local temLevel = 0
    local bateRate = 1
    for _,v in pairs(this.city_play) do
        if v.city_id == cityid and v.default == 1 then
            level_open = v.level_open
            break
        end 
    end
    for _,v in pairs(level_open) do 
        if v[2] <= level and v[2] >= temLevel then
            temLevel = v[2]
            bateRate = v[1]
        end
    end
    return bateRate
end

--获取最大的开放城市
function Csv.GetMaxRateopenCity(level)
    local temLevel = -1
    local tempCityId = 1
    for _,v in pairs(this.city_play) do
        if v.play_type == 1 and v.default == 1 then
             if v.unlock >= temLevel and v.unlock <= level then 
                temLevel = v.unlock;
                tempCityId = v.city_id
             end 
        end 
    end
    return tempCityId
end

--判断是否最大开放
function Csv.GetCityLevelOpen2(cityid,level)
    local unlock = nil
    for _,v in pairs(this.city_play) do
        if v.city_id == cityid and v.default == 1 then
            unlock = v.unlock
            break
        end 
    end
    
    if not unlock then 
        return false 
    end 



    return level>=unlock
end


function Csv.GetRateOpenByCityId(id)
    local level_open = 0 
    for _,v in pairs(this.city_play) do
        if v.id == id then
            level_open = v.unlock
            break
        end 
    end

    return level_open
end 


function Csv.GetMaxRateOpenByPlayid(cityid,level)
    local level_open = this.city_play[cityid] and this.city_play[cityid].level_open or {}
    local temLevel = 0
    local bateRate = 1
    --- data/Csv:435: attempt to compare number with nil currUId 0  线上收集的报错，可能是返回登录界面引起的
    if not level_open or not level then
        return bateRate
    end
    for _,v in pairs(level_open) do 
        if v[2] <= level and v[2] >= temLevel then
            temLevel = v[2]
            bateRate = v[1]
        end
    end
    return bateRate
end

function Csv.GetMaxRateOpenByPlayidPay(cityid,level)
    local level_open = this.new_city_play[cityid] and this.new_city_play[cityid].pay_level_open or {}
    local temLevel = 0
    local bateRate = 1
    
    for _,v in pairs(level_open) do 
        if v[2] <= level and v[2] >= temLevel then
            temLevel = v[2]
            bateRate = v[1]
        end
    end
    return bateRate
end

function Csv.GetMaxBetRate(id)
    local level_open = nil
    local maxRate = 0;
    for _,v in pairs(this.city_play) do
        if v.city_id == id then
            level_open = v.level_open
            break
        end 
    end

    for k,_ in pairs(level_open) do 
        maxRate = maxRate<=k and k or maxRate
    end 
    return maxRate
end 

function Csv.GetPlayIdLevelOpen(id,level)
    local level_open = nil 
    for _,v in pairs(this.city_play) do
        if v.id == id then
            level_open = v.unlock
            break
        end 
    end

    if not level_open then 
        return false;
    end 

    return level < level_open
end 

--获得城市默认得开放等级
function Csv.GetCityLevelOpen(type)
    local data = {}
    for _,v in pairs(this.city_play) do
        if v.play_type ==type then
            data[v.city_id]= v.unlock
        end 
    end
    
    return data
end

function Csv.getCityOpenExtra(CityId,bet)

    for _,v in pairs(this.extra_bonus) do
        if v.city_play ==CityId and bet then
            return true
        end 
    end

    return false,false
end 

function Csv.getSGPRecommd()
    local tb = {}
    for _,v in pairs(this.feature_enter) do 
        if v.featured_banner > 0 then
            table.insert(tb,v.id)
        end 
    end 

    if #tb <= 0 then 
        return nil
    end
    table.sort(tb)
    return tb[#tb]
end 

function Csv.getSGPEntrance()
    local tb = {}
    for _,v in pairs(this.feature_enter) do 
        if v.featured_entrance == 1 then 
            table.insert(tb,v.id)
        end 
    end 

    if #tb <= 0 then 
        return nil
    end 

    return tb[math.random(1,#tb)] 
end

function Csv.getSGPPop()
    local tb = {}
    for _,v in pairs(this.feature_enter) do 
        if v.featured_pop == 1 then 
            table.insert(tb,v.id)
        end 
    end 

    if #tb <= 0 then 
        return nil
    end 

    return tb[math.random(1,#tb)] 
end


function Csv.isTraceID(id,guideId)

    if id == -1 then  --说明步骤已完成
        return true 
    end 

    if not this.new_guide_step[id] or this.new_guide_step[id].guideid ~= guideId then 
       return false 
    end 

    return true 

end

local MaxCollectiveCount = {}
--- @param tier : 阶段数据(矿工玩法)
function Csv.GetCollectiveMaxCount(collectiveType, playIdHold, tier)
    local playId = ModelList.CityModel.GetPlayIdByCity()
    MaxCollectiveCount[playId] = {}
    local ruleId = Csv.GetData("new_city_play", playId, "bingo_rule_id")[tier and tier or 1]
    if not ruleId then
        log.log("Csv.GetCollectiveMaxCount Error ruleId is nil ", collectiveType, tier, playId)
    end

    local ruleData = Csv.GetData("new_bingo_rule",ruleId[1],"params")
    for index, value in ipairs(ruleData) do
        table.insert(MaxCollectiveCount[playId],value[2])
    end

    return MaxCollectiveCount[playId][collectiveType] or 1
end

function Csv.CheckIsNormalPlayType(playid)
    if not this.city_play[playid] then 
        return false
    end 

    if this.city_play[playid].play_type == 1  then 
        return true
    else 
        return false
    end
end

--获得某卡单bingo价值
function Csv.GetBingoRewardOfPlayid(playid,bingo)
    local tmp = nil
    for _,v in pairs(this.bingo_reward) do
        if v.bingo == bingo and v.city_play_id == playid then
            tmp = v.bingo_reward
        end
    end
    return tmp
end

--获得某卡4Bingo价值
function Csv.GetBingo4RewardOfPlayid(playid)
    local tmp = nil
    for _,v in pairs(this.bingo_reward) do
        if v.bingo == 4 and v.city_play_id == playid then
            tmp = v.bingo_reward
        end
    end
    return tmp
end

--获得礼盒 数据 根据等级
function Csv.GetRewardShowForId(level)
    if not level then
        return nil 
    end 
    local tb = nil 
    for _,v in pairs(this.club_packet) do
        if v.packet_level == level then 
            tb = v
            break;
        end 
    end 

    return tb ;
end 

--判断礼盒是否属于某个等级
function Csv.GetRewardisLevel(itemId,level)
   
    local data  = this.item[itemId]

    if not data or not level then 
        return false
    end 
    
    local tmpData =  this.GetData("item",itemId,"result")
    if not tmpData[2]  then 
        return false
    end 

    return tmpData[2] == level
end 


--获得某个等级得 城市bet系数
function Csv.GetCityUtlaBet(playid,UtlraLevel,bet)
    local tmp = nil 

    if this.bet_ultra[playid] and this.bet_ultra[playid].ultra_bet[UtlraLevel] and this.bet_ultra[playid].ultra_bet[UtlraLevel][bet] then 
        tmp = this.bet_ultra[playid].ultra_bet[UtlraLevel][bet]
    end 

    return tmp 
    
end

--获得某个等级得 城市钻石消耗
function Csv.GetCityUtlaCost(playid,UtlraLevel,cardNum)
    local tmp = nil
    if this.bet_ultra[playid] and this.bet_ultra[playid].range_pay_cutting[UtlraLevel] then
        tmp = this.bet_ultra[playid].range_pay_cutting[UtlraLevel]
    end
    if tmp then
        local cardCost = tmp[1]
        for i = 1, #tmp do
            if fun.starts(tmp[i][1], tostring(cardNum)) then
                cardCost = tmp[i]
                break
            end
        end
        tmp = {
            tonumber(string.sub(cardCost[1], 3)), --1档
            tonumber(cardCost[2]), --2档
            tonumber(cardCost[3]), --3档
        }
    end
    return tmp
end

function Csv.GetCityBingoPoints(cityId,bingoType,typeCount)
	for k, v in pairs(this.weeklylist_points_bingo) do
		if v.city_id[1] == cityId and v.bingo_type == bingoType and v.type_count == typeCount then
			return v.bingo_points;
		end
	end
	
	return nil;
end

function Csv.getPopInfiniteForId(giftId)
    local tmpdata = {}
    if not this.pop_up_infinite  then 
        return tmpdata 
    end 

    for k,v in pairs(this.pop_up_infinite) do
        if v.gift_id == giftId then 
            table.insert( tmpdata, v)
        end 
    end 
    
    return tmpdata
end

---根据机台倍率，取玩法购买的pu中小丑卡总数量以及其中黑卡的数量
function Csv.GetPlayJokerCardsInfo(cityPlayID, bet)
    cityPlayID = cityPlayID or ModelList.CityModel.GetPlayIdByCity()
    
    bet = bet or ModelList.CityModel:GetBetRate()
    if ModelList.UltraBetModel:IsActivityValidForCurPlay() then
        bet = MaxBatRate()
    end
    
    local cfg = table.find(Csv["powerup_range"], function(k, v)
        if v.cityid == cityPlayID then
            local checkBet = v.bet[1] <= bet and bet <= v.bet[2]
            return checkBet
        end
    end)
    if cfg then
        return cfg.joker_high_quantity, cfg.joker_quantity
    end
end

---去某个玩法的小丑卡数量
function Csv.GetPlayJokerCardsNum(cityPlayID)
    cityPlayID = cityPlayID or ModelList.CityModel.GetPlayIdByCity()
    
    local temp = 0
    table.each(Csv["powerup_range"], function(v, k)
        if v.cityid == cityPlayID then
            if v.joker_quantity > temp then
                temp =  v.joker_quantity
            end
        end
    end)
    
    return temp
end

--获取icon对应的礼包view参数，iconName对应popu里面的icon
function Csv.GetGiftDataByIconName(iconName)
    for k,v in pairs(lua_data.gift_pack_view_config) do
        if(v.icon==iconName)then 
            return v
        end
    end
    return nil 
end




-------------------------手动代码请加入虚线之间----------------------

return this
