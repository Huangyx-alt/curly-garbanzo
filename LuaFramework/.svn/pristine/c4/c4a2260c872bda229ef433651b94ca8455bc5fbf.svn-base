CountDownType = {
    cdt1 = "OnTimerCall_Cdt1",
    cdt2 = "OnTimerCall_Cdt2",
    cdt3 = "OnTimerCall_Cdt3",
    cdt4 = "OnTimerCall_Cdt4",
    cdt5 = "OnTimerCall_Cdt5",
    cdt6 = "OnTimerCall_Cdt6",
    cdt7 = "OnTimerCall_Cdt7",
    cdt8 = "OnTimerCall_Cdt8",
}

RemainTimeCountDown = {}

function RemainTimeCountDown:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function RemainTimeCountDown:StopTimer()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function RemainTimeCountDown:StopTimerAndCheckCallBack()
    self:StopTimer()
    if self._timeOutCallback then
        self._timeOutCallback()
    end
end

function RemainTimeCountDown:FrameCall()
    if self._frameCallback then
        self._frameCallback()
    end
end

function RemainTimeCountDown:StopCountDown()
    self:StopTimer()
    self._text_countdown = nil
    self._timeOutCallback = nil
    self._frameCallback = nil
    self._remainTime = nil
end

function RemainTimeCountDown:UpdateRemainTime(remainTime)
    if self._timer then
        self._remainTime = remainTime
    end
end

function RemainTimeCountDown:IsWorking()
    return self._timer ~= nil
end

function RemainTimeCountDown:StartCountDown(countDownType, remainTime,text_countdown,timeOutCallback,frameCallback)
    if remainTime and remainTime > 1 then
        self._text_countdown = text_countdown
        self._timeOutCallback = timeOutCallback
        self._frameCallback = frameCallback
        self._remainTime = remainTime
        self:StopTimer()
        self._timer = Timer.New(function()
            if fun.is_not_null(self._text_countdown) then
                self[countDownType](self,true)
            end
        end,1,-1)
        self._timer:Start()
        self[countDownType](self)
    else
        if timeOutCallback then
            timeOutCallback()
        end
    end
end

function RemainTimeCountDown:GetRemainTimeFormat1(sub)
    if self._remainTime and self._remainTime > 0 then
        if sub then
            self._remainTime = math.max(0,self._remainTime - 1)
        end

        local d = math.floor(self._remainTime/60/60/24)
        local h = math.floor(self._remainTime/60/60%24)
        local m = math.floor(self._remainTime/60%60)
        local s = math.floor(self._remainTime%60)
        if d > 0 then
            if d > 1 and h > 1 then
                return string.format("%s Days %s Hours %02d:%02d",d,h,m,s)
            elseif d > 1 and h == 1 then
                return string.format("%s Days %s Hour %02d:%02d",d,h,m,s)
            elseif d > 1 and h == 0 then
                return string.format("%s Days %02d:%02d",d,m,s)
            elseif d == 1 and h > 1 then
                return string.format("%s Day %s Hours %02d:%02d",d,h,m,s)
            elseif d == 1 and h == 1 then
                return string.format("%s Day %s Hour %02d:%02d",d,h,m,s)
            elseif d == 1 and h > 1 then
                return string.format("%s Day %s Hours %02d:%02d",d,h,m,s)
            end
        elseif h > 1 then
            return string.format("%s Hours %02d:%02d",h,m,s)
        elseif h == 1 then
            return string.format("%s Hour %02d:%02d",h,m,s)
        else
            return string.format("%02d:%02d",m,s)
        end    
    end
end

function RemainTimeCountDown:GetRemainTimeFormat2(sub)
    if self._remainTime and self._remainTime > 0 then
        if sub then
            self._remainTime = math.max(0, self._remainTime - 1)
        end

        local d = math.floor(self._remainTime / 60 / 60 / 24)
        local h = math.floor(self._remainTime / 60 / 60 % 24)
        local m = math.floor(self._remainTime / 60 % 60)
        local s = math.floor(self._remainTime % 60)
        if d > 0 then
            return string.format("%sd:%02dh", d, h)
            
        elseif h >= 1 then
            return string.format("%sh:%02dm", h, m)
        else
            return string.format("%02d:%02d", m, s)
        end
    end
end

function RemainTimeCountDown:OnTimerCall_Cdt1(sub)
    if self._remainTime and self._remainTime > 0 then
        self._text_countdown.text = self:GetRemainTimeFormat1(sub)
    else
        self:StopTimerAndCheckCallBack()
    end
end

function RemainTimeCountDown:OnTimerCall_Cdt2(sub)
    if fun.is_null(self._text_countdown) then
        self:StopTimer()
        return
    end
    if self._remainTime and self._remainTime > 0 then
        if sub then
            self._remainTime = math.max(0,self._remainTime - 1)
        end

        local t = math.floor(self._remainTime/60/60/24/30)
        if t > 0 then
            self._text_countdown.text = string.format("%smonth",t)
        else
            t = self._remainTime/60/60/24
            -- if t > 5 then
            --     self._text_countdown.text = string.format("%sd",math.floor(t))
            -- else
            if t > 1 then
                local t2 = math.floor(self._remainTime/60/60%24)
                self._text_countdown.text = string.format("%sd:%sh",math.floor(t),t2)
            else
                t = math.floor(self._remainTime/60/60)
                if t > 0 then
                    local t2 = math.floor(self._remainTime/60%60)
                    self._text_countdown.text = string.format("%sh:%sm",t,t2)
                else
                    self._text_countdown.text = string.format("%02d:%02d",math.floor(self._remainTime/60),math.floor(self._remainTime%60))
                end   
            end
        end
        self:FrameCall()
    else
        self:StopTimerAndCheckCallBack()
    end
end

function RemainTimeCountDown:OnTimerCall_Cdt3(sub)
    if self._remainTime and self._remainTime > 0 then
        if sub then
            self._remainTime = math.max(0,self._remainTime - 1)
        end
        self._text_countdown.text = fun.format_time(self._remainTime)
        self:FrameCall()
    else
        self:StopTimerAndCheckCallBack()
    end
end

function RemainTimeCountDown:OnTimerCall_Cdt4(sub)
    if self._remainTime and self._remainTime > 0 then
        if sub then
            self._remainTime = math.max(0,self._remainTime - 1)
        end
        self._text_countdown.text = fun.format_time(self._remainTime)
        self:FrameCall()
    else
        self._text_countdown.text = "00:00"
        self:StopTimerAndCheckCallBack()
    end
end

function RemainTimeCountDown:OnTimerCall_Cdt5(sub)
    if self._remainTime and self._remainTime > 0 then
        self._text_countdown.text = string.format(Csv.GetData("description",8032,"description"),self:GetRemainTimeFormat1(sub))
    else
        self:StopTimerAndCheckCallBack()
    end
end

function RemainTimeCountDown:OnTimerCall_Cdt6(sub)

end

function RemainTimeCountDown:OnTimerCall_Cdt7(sub)
    if self._remainTime and self._remainTime > 0 then
        self._text_countdown.text = self:GetRemainTimeFormat2(sub)
    else
        self:StopTimerAndCheckCallBack()
    end
end

function RemainTimeCountDown:OnTimerCall_Cdt8(sub)
    if self._remainTime and self._remainTime > 0 then
        if sub then
            self._remainTime = math.max(0,self._remainTime - 1)
        end
        self._text_countdown.text = fun.SecondToStrFormat(self._remainTime)
        self:FrameCall()
    else
        self:StopTimerAndCheckCallBack()
    end
end