---@class SoundHelper
SoundHelper                    = {}

SoundHelper.sound_track        = {}
SoundHelper.loaded_pack_sum    = 0
SoundHelper.playing_sound_hash = {}
SoundHelper.mix_value          = {}

local successivePlayLsit       = nil
local successiveHash           = nil
local successivePlayIndex      = nil

local previous_bgm             = nil

SOUND_TRACK_GROUP              = {
    BGM = "BGM",
    EffectSound = "EffectSound",
    --Sound100 = "Sound100",
    --Sound50 = "Sound50",
    --Sound0 = "Sound0",
    --AutoFadeTrack = "AutoFadeTrack"
}


function SoundHelper.init_mix_value()
    for i, v in pairs(SOUND_TRACK_GROUP) do
        local value = soundMgr:GetMixerVolume(v)
        SoundHelper.mix_value[i] = value
    end
end

--加载混音器
function SoundHelper.init(callback)
    --if GameUtil.is_windows_editor() then
    --    --部分机器无法启动
    --    callback();
    --    SoundHelper.init_mix_value()
    --else
    local gameAudioMixer = string.gsub(AssetList["GameAudioMixer"], "%.", "/")
    soundMgr:InitAudioMixer(gameAudioMixer, { "GameAudioMixer" },
        function()
            callback()
            SoundHelper.init_mix_value()
        end)
    --end
    soundMgr:RegisterSoundPlayOverCallBack(SoundHelper.on_sound_end)


    SoundHelper.sound_switch = fun.read_value("sound_switch")
    if not SoundHelper.sound_switch then
        SoundHelper.sound_switch = "open" --音乐默认开启
    end

    SoundHelper.music_switch = fun.read_value("music_switch")
    if not SoundHelper.music_switch then
        SoundHelper.music_switch = "open" --音乐默认开启
    end
end

function SoundHelper.PlaySuccessive(sound)
    if successivePlayLsit == nil then
        successivePlayLsit = sound
        successivePlayIndex = 2
        UISound.play(successivePlayLsit[1])
    end
end

function SoundHelper.on_sound_end(hash)
    SoundHelper.playing_sound_hash[hash] = nil
    if successiveHash == hash and successivePlayLsit[successivePlayIndex] then
        successiveHash = UISound.play(successivePlayLsit[successivePlayIndex])
        successivePlayIndex = successivePlayIndex + 1
    else
        successivePlayLsit = nil
        successivePlayIndex = nil
        successiveHash = nil
    end
end

function SoundHelper.load(sound_ab_list, cb)
    local sound_packager_sum = #sound_ab_list
    SoundHelper.loaded_pack_sum = 1
    SoundHelper._load_assets(sound_ab_list, cb)
    -- --1.加载资源，全部加载完成后，统一做一次回调
    -- local function load_cb()
    --     log.r("lxq SoundHelper.load loaded_pack_sum"..tostring(SoundHelper.loaded_pack_sum))
    --     log.r("lxq SoundHelper.load loaded_pack_sum"..tostring(SoundHelper.loaded_pack_sum))
    --     SoundHelper.loaded_pack_sum = SoundHelper.loaded_pack_sum+1
    --     if SoundHelper.loaded_pack_sum>=sound_packager_sum then
    --         if cb then cb() end
    --         Cache.PrintLoadedAsset()
    --     end
    -- end
    -- for i,v in ipairs(sound_ab_list) do
    --     local sound_effect_list = {}
    --     --for k,vv in pairs(SoundMapping) do
    --     --    if v == vv then
    --     --        table.insert(sound_effect_list,k)
    --     --    end
    --     --end
    --     resMgr:LoadAudioClip(v,SoundHelper.get_soud_all_file(v),load_cb)
    -- end
end

function SoundHelper._load_assets(sound_ab_list, cb)
    local sound_key = sound_ab_list[SoundHelper.loaded_pack_sum]

    if sound_key == nil then
        if cb then
            cb()
        else
            log.r("lxq cb is nil ")
        end
        return
    end
    local loadCount = table.length(SoundHelper.get_soud_all_file(sound_key))
    ResourcesManager:LoadAssetAsync(BundleCategory.LPB.Sound, sound_key, typeof(CS.AudioClip),
        function(assetId, err)
            if err or not assetId then
                log.e("音效加载失败,sound_key " .. sound_key.." err "..err)
                cb()
                return
            end
            loadCount = loadCount - 1
            if loadCount == 0 then
                SoundHelper.loaded_pack_sum = SoundHelper.loaded_pack_sum + 1
                SoundHelper._load_assets(sound_ab_list, cb)
            end
        end)



    -- resMgr:LoadAudioClip(sound_key, SoundHelper.get_soud_all_file(sound_key), function()
    --     SoundHelper.loaded_pack_sum = SoundHelper.loaded_pack_sum + 1
    --     SoundHelper._load_assets(sound_ab_list, cb)
    -- end, true)
end

function SoundHelper.get_soud_all_file(ab_name)
    local ret = {}
    for k, v in pairs(Csv.audio) do
        if (v.asset_path == ab_name) then
            ret[#ret + 1] = v.file_name
        end
    end
    return ret
end

--第一次进入机台，如果播放bgm被拦截，此时打开声音需要重新再次播放一遍
function SoundHelper.resume_bgm()
    if previous_bgm then
        SoundHelper.fade_in_bgm(previous_bgm[1], previous_bgm[2])
    end
end

--播放bgm
function SoundHelper.play_bgm(ab_name, bg_name, is_fading_bgm)
    log.r("播放bgm ab_path " .. ab_name .. " bg_name " .. bg_name .. "is_fading_bgm " .. tostring(is_fading_bgm))
    if SoundHelper.music_switch == "close" then
        return
    end
    if not soundMgr:IsBGMPlaying(bg_name) then
        SoundHelper.stop_bgm()
        SoundHelper.saved_bgm = { ab_name, bg_name }
        --SoundHelper.mix_fade_in_bgm()
        --TODO 音效资源问题 by LwangZg
        local split_result = StringUtil.split_string(bg_name, ".")
        local extension = (split_result and split_result[2]) or "ogg"
        soundMgr:PlayBackSound(ab_name, bg_name, SOUND_TRACK_GROUP.BGM, extension)
    end
end

function SoundHelper.set_bgm_volume(targetVolume)
    -- log.r("SoundHelper.set_bgm_volume()")
    return soundMgr:SetBgmVolume(targetVolume)
end

function SoundHelper.tween_out_bgm(delta)
    soundMgr:TweenOutBGM(delta, nil)
end

function SoundHelper.tween_in_bgm(delta)
    if SoundHelper.music_switch == "close" then
        return
    end
    soundMgr:TweenInBGM(delta, nil)
end

function SoundHelper.mix_fade_in_effect(fadein_time, callback)
    -- log.r("SoundHelper.mix_fade_in_effect()")
    local effectValue = SoundHelper.get_defalut_effect_value()
    --local effect_cur_value = SoundHelper.get_cur_effect_value()
    SoundHelper.TweenMixerVolumeByType(SOUND_TRACK_GROUP.EffectSound, -80, effectValue, fadein_time, function()
        if (callback) then
            callback()
        end
    end)
end

function SoundHelper.mix_fade_in_bgm(fadein_time, callback)
    -- log.r("SoundHelper.mix_fade_in_bgm()")
    local bgmValue = SoundHelper.get_defalut_bg_value()
    local bgm_cur_value = SoundHelper.get_cur_bg_value()
    SoundHelper.TweenMixerVolumeByType(SOUND_TRACK_GROUP.BGM, bgm_cur_value, bgmValue, fadein_time, function()
        if (callback) then
            callback()
        end
    end)
end

function SoundHelper.mix_fade_out_bgm(delta_time, callback)
    -- log.r("SoundHelper.mix_fade_in_and_resume_bgm()")
    --local bgmValue =SoundHelper.get_defalut_bg_value()
    local bgm_cur_value = SoundHelper.get_cur_bg_value()
    SoundHelper.TweenMixerVolumeByType(SOUND_TRACK_GROUP.BGM, bgm_cur_value, -40, delta_time, function()
        if (callback) then
            callback()
        end
    end)
end

--淡入一个bgm
function SoundHelper.fade_in_bgm(ab_path, bg_name)
    log.r("淡入一个bgm ab_path " .. ab_path .. " bg_name " .. bg_name)
    if SoundHelper.music_switch == "close" then
        previous_bgm = { ab_path, bg_name }
        return
    end

    if not soundMgr:IsBGMPlaying(bg_name) then
        SoundHelper.stop_bgm()
        SoundHelper.saved_bgm = { ab_path, bg_name }
        --TODO 音效资源问题 by LwangZg
        local split_result = StringUtil.split_string(bg_name, ".")
        local extension = (split_result and split_result[2]) or "ogg"
        soundMgr:PlayBackSoundFadeIn(ab_path, bg_name, SOUND_TRACK_GROUP.BGM, extension)
    end
end

--停止播放bgm
function SoundHelper.stop_bgm()
    log.r("SoundHelper stop_bgm")
    previous_bgm = SoundHelper.saved_bgm
    SoundHelper.saved_bgm = nil
    soundMgr:StopBackSound()
end

function SoundHelper.is_bgm_playing()
    return soundMgr:IsBGMPlaying()
end

--播放音效
function SoundHelper.play(ab_name, sound_effect_name, sound_name, sound_track, volume)
    log.r("播放音效 ab_name " .. ab_name .. " sound_effect_name " .. sound_effect_name .. " sound_name " .. sound_name)
    --log.y("sound_effect_name:",sound_effect_name)
    -- log.r("SoundHelper.play()")
    if SoundHelper.sound_switch == "close" then return 0 end
    --log.y("PlaySound",sound_effect_name,ab_name)
    if nil == volume then
        volume = -1
    end
    local split_result = StringUtil.split_string(sound_effect_name, ".")
    local extension = (split_result and split_result[2]) or "ogg"
    --TODO 音效资源问题 by LwangZg
    local hash = soundMgr:PlaySound(ab_name, sound_effect_name, sound_track or SOUND_TRACK_GROUP.EffectSound, extension,
        UnityEngine.Vector3.zero, volume)
    SoundHelper.playing_sound_hash[hash] = { name = sound_name, frame = Time.frameCount }
    return hash
end

--音频是否在同一步，要播放中
function SoundHelper.is_playing(fid, sound_effect_name)
    for k, v in pairs(SoundHelper.playing_sound_hash) do
        if v.name == sound_effect_name and v.fid then
            if fid == v.fid then
                return true
            else
                --log.r(fid,v.fid)
            end
        end
    end
    return false
end

--播放一个loop音效
function SoundHelper.play_loop(sound_name, ab_name, sound_effect_name, sound_track)
    -- log.r("播放一个loop音效 sound_name " ..
    --     sound_name ..
    --     " ab_name " .. ab_name .. "sound_effect_name " .. sound_effect_name .. " sound_track " .. sound_track)
    -- log.r("SoundHelper.play_loop()")
    if SoundHelper.sound_switch == "close" then return end
    --TODO 音效资源问题 by LwangZg
    local split_result = StringUtil.split_string(sound_effect_name, ".")
    local extension = (split_result and split_result[2]) or "ogg"
    local hash = soundMgr:PlaySoundLoop(ab_name, sound_effect_name,
        sound_track and sound_track or SOUND_TRACK_GROUP.EffectSound, extension)
    SoundHelper.playing_sound_hash[hash] = { name = sound_name }
    return hash
end

--播放一个loop音效，并且设置音量
function SoundHelper.play_loop_with_volume(sound_name, ab_name, sound_effect_name, sound_track, volume)
    if SoundHelper.sound_switch == "close" then return end
    local pos = Vector3.New(0, 0, 0)
    local hash = soundMgr:PlaySoundLoop(ab_name, sound_effect_name,
        sound_track and sound_track or SOUND_TRACK_GROUP.EffectSound, pos, volume)
    SoundHelper.playing_sound_hash[hash] = { name = sound_name }
    return hash
end

function SoundHelper.stop_sound_by_name(sound_effect_name)
    --local isfind = false
    for k, v in pairs(SoundHelper.playing_sound_hash) do
        if v.name == sound_effect_name then
            SoundHelper.stop_by_hash(k)
            isfind = true
        end
    end
    --if(not isfind)then
    --   log.r("stop sound fail  "..sound_effect_name)
    --end
end

--停止音效
function SoundHelper.stop_by_hash(sound_hash)
    if not sound_hash then return end
    soundMgr:RemoveSound(sound_hash)
end

--切换场景时，关闭所有音效
function SoundHelper.UnloadAllAudio()
    SoundHelper.stop_bgm()
    soundMgr:UnloadAllAudio()
end

function SoundHelper.pause_all_sound()
    soundMgr:PauseBackSound()
    soundMgr:PauseAllSound()
end

function SoundHelper.resume_all_sound()
    soundMgr:ResumeBackSound()
    soundMgr:ResumeAllSound()
end

function SoundHelper.TweenMixerVolumeByType(mix_type, sourceVolume, targetVolume, time, callback)
    soundMgr:TweenMixerVolumeByType(mix_type, sourceVolume, targetVolume, time, callback)
end

function SoundHelper.get_sound_by_hash(hash)
    return soundMgr:GetSoundByHash(hash)
end

function SoundHelper.get_defalut_bg_value()
    -- log.r("SoundHelper.get_defalut_bg_value()")
    return SoundHelper.mix_value[SOUND_TRACK_GROUP.BGM]
end

function SoundHelper.get_defalut_effect_value()
    -- log.r("SoundHelper.get_defalut_effect_value()")
    return SoundHelper.mix_value[SOUND_TRACK_GROUP.EffectSound]
end

function SoundHelper.get_cur_effect_value()
    -- log.r("SoundHelper.get_cur_effect_value()")
    return soundMgr:GetMixerVolume(SOUND_TRACK_GROUP.EffectSound)
end

function SoundHelper.get_cur_bg_value()
    -- log.r("SoundHelper.get_cur_bg_value()")
    return soundMgr:GetMixerVolume(SOUND_TRACK_GROUP.BGM)
end

function SoundHelper.TweenOutMusic(sound_full_name, time, source_volume, target_volume, call_back)
    soundMgr:TweenOutMusic(sound_full_name, time, source_volume, target_volume, call_back)
end
