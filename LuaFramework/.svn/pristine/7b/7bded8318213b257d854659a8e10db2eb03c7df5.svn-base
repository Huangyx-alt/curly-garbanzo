---使用这个类要注意小心，必须要在销毁Animator之前释放掉AnimatorPlayer，要不就会报错
AnimatorPlayer = {}

function AnimatorPlayer:New()
    local o = {}
    setmetatable(o,{__index = AnimatorPlayer})
    return o
end

---使用这个类要注意小心，必须要在销毁Animator之前释放掉AnimatorPlayer，要不就会报错
function AnimatorPlayer.Creat(owner)
    if owner then
        AnimatorPlayer.Release(owner)
        owner.animatorPlayer = AnimatorPlayer:New()
        owner.animatorPlayer:Start()
    end
end

---使用这个类要注意小心，必须要在销毁Animator之前释放掉AnimatorPlayer，要不就会报错
function AnimatorPlayer.Release(owner)
    if owner and owner.animatorPlayer then
        owner.animatorPlayer:Dispose()
        owner.animatorPlayer = nil
    end
end

function AnimatorPlayer:Start()
    self._acount = 0
    self._animatorList = {}
    self.temAnimator = nil
    self.temTime = nil
    self.handle = UpdateBeat:CreateListener(self.Update, self)
    UpdateBeat:AddListener(self.handle)
end

function AnimatorPlayer:Update()
    xpcall(
        function()
            if self._acount == nil or self._acount <= 0 then
                return
            end
            --self._acount = #self._animatorList
            for key, value in pairs(self._animatorList) do
                self.temAnimator = value --self._animatorList[i]
                if self.temAnimator then
                    if self.temAnimator.duration == nil then
                        local stateInfo = self.temAnimator.animtor:GetCurrentAnimatorStateInfo(0)
                        if stateInfo and stateInfo:IsName(self.temAnimator.action) then
                            self.temAnimator.duration = stateInfo.length + 0.1
                            --log.r("====================================>>temAnimator.duration1 " .. self.temAnimator.action .. "     " .. stateInfo.length)
                            self.temAnimator.start = UnityEngine.Time.time + UnityEngine.Time.deltaTime
                            if self.temAnimator.scbTime then
                                self.temAnimator.scbTime = math.min(self.temAnimator.duration, self.temAnimator.scbTime)
                            end
                        end
                    else
                        if self.temAnimator.genre == 1 then
                            self.temTime = (UnityEngine.Time.time + UnityEngine.Time.deltaTime)  - self.temAnimator.start
                            if self.temAnimator.scbTime then
                                if self.temTime >= self.temAnimator.scbTime then
                                    if self.temAnimator.cb_offset then
                                        self.temAnimator.cb_offset()
                                        self.temAnimator.cb_offset = nil
                                        self.temAnimator.scbTime = nil
                                    end
                                end
                            end
                            if self.temTime >= self.temAnimator.duration then
                                --table.remove(self._animatorList,key)
                                self._animatorList[key] = nil
                                self._acount = self._acount - 1
                                if self.temAnimator.finishDisable == nil or self.temAnimator.finishDisable then
                                    self.temAnimator.animtor.enabled = false
                                end
                                if self.temAnimator.cb then
                                    self.temAnimator.cb()
                                end

                                local stateInfo = self.temAnimator.animtor:GetCurrentAnimatorStateInfo(0)
                            end
                        elseif self.temAnimator.genre == 2 then
                            if (UnityEngine.Time.time + UnityEngine.Time.deltaTime) - self.temAnimator.start >= self.temAnimator.delay  then
                                self:Play(self.temAnimator.animtor,self.temAnimator.action,self.temAnimator.duration)
                                --table.remove(self._animatorList,key)
                                self._animatorList[key] = nil
                                self._acount = self._acount - 1
                            end
                        end
                    end
                else
                    --table.remove(self._animatorList,key)
                    self._animatorList[key] = nil
                    self._acount = self._acount - 1
                end
                self.temAnimator = nil
            end
        end,
        __G__TRACKBACK__
        )
end

function AnimatorPlayer:Stop()
    if self.handle then
        UpdateBeat:RemoveListener(self.handle)
        self.handle = nil
    end
end

---使用这个类要注意小心，必须要在销毁Animator之前释放掉AnimatorPlayer，要不就会报错
function AnimatorPlayer:Play(animator,action,duration,callback,finishDisable)
    ---[[
    if animator == nil or action == nil then
        return
    end
    animator.enabled = true
    animator:Play(action,0,0)
    local info = {}
    info.duration = nil
    info.animtor = animator
    info.action = action
    info.start = nil -- UnityEngine.Time.time + UnityEngine.Time.deltaTime
    info.genre = 1
    info.cb = callback
    info.finishDisable = finishDisable
    table.insert(self._animatorList,info)
    self._acount = self._acount + 1
    --]]
end

---使用这个类要注意小心，必须要在销毁Animator之前释放掉AnimatorPlayer，要不就会报错
--动画未播完就回调，offsetTime设置提前的时间值
function AnimatorPlayer:PlayCallBackSpecified(animator,action,offsetTime,callback1,callback2,finishDisable)
    if animator == nil or action == nil then
        return
    end
    animator.enabled = true
    animator:Play(action,0,0)
    local info = {}
    info.duration = nil
    info.scbTime =  offsetTime --math.max(0.1,dura - offsetTime)
    info.animtor = animator
    info.action = action
    info.start = nil
    info.genre = 1
    info.cb_offset= callback1
    info.cb = callback2
    info.finishDisable = finishDisable
    table.insert(self._animatorList,info)
    self._acount = self._acount + 1
end

---使用这个类要注意小心，必须要在销毁Animator之前释放掉AnimatorPlayer，要不就会报错
function AnimatorPlayer:DelayPlay(animator,action,delay,duration)
    if animator == nil or action == nil then
        return
    end
    if delay > 0 then
        local info = {}
        info.animtor = animator
        info.start = UnityEngine.Time.time + UnityEngine.Time.deltaTime
        info.delay = delay
        info.duration = duration
        info.action = action
        info.genre = 2
        table.insert(self._animatorList,info)
        self._acount = self._acount + 1
    else
        self:Play(animator,action,duration)
    end
end

function AnimatorPlayer:Dispose()
    self:Stop()
    self._acount = nil
    self._animatorList = nil
    self.temAnimator = nil
    self.temTime = nil
end