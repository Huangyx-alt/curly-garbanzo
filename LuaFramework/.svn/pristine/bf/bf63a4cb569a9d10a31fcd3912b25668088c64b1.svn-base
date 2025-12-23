---@class NotExportType @表明该类型未导出

---@class NotExportEnum @表明该枚举未导出

---@class LuaInterface.LuaInjectionStation : System.Object
---@field NOT_INJECTION_FLAG number
---@field INVALID_INJECTION_FLAG number
local LuaInterface_LuaInjectionStation = {}
---@return LuaInterface.LuaInjectionStation
function LuaInterface_LuaInjectionStation.New() end
---@param index number
---@param injectFlag number
---@param func fun()
function LuaInterface_LuaInjectionStation.CacheInjectFunction(index, injectFlag, func) end
function LuaInterface_LuaInjectionStation.Clear() end

---@class System.Object
local System_Object = {}
---@return System.Object
function System_Object.New() end
---@overload fun(objA : System.Object, objB : System.Object) : boolean
---@param obj System.Object
---@return boolean
function System_Object:Equals(obj) end
---@param objA System.Object
---@param objB System.Object
---@return boolean
function System_Object.ReferenceEquals(objA, objB) end
---@return number
function System_Object:GetHashCode() end
---@return System.Type
function System_Object:GetType() end
---@return string
function System_Object:ToString() end

---@class LuaInterface.InjectType
---@field None LuaInterface.InjectType
---@field After LuaInterface.InjectType
---@field Before LuaInterface.InjectType
---@field Replace LuaInterface.InjectType
---@field ReplaceWithPreInvokeBase LuaInterface.InjectType
---@field ReplaceWithPostInvokeBase LuaInterface.InjectType
local LuaInterface_InjectType = {}

---@class LuaInterface.Debugger : System.Object
---@field useLog boolean
---@field threadStack string
---@field logger NotExportType
local LuaInterface_Debugger = {}
---@overload fun(str : string)
---@overload fun(message : System.Object)
---@overload fun(str : string, arg0 : System.Object)
---@overload fun(str : string, arg0 : System.Object, arg1 : System.Object)
---@overload fun(str : string, arg0 : System.Object, arg1 : System.Object, arg2 : System.Object)
---@param str string
---@param param NotExportType
function LuaInterface_Debugger.Log(str, param) end
---@overload fun(str : string)
---@overload fun(message : System.Object)
---@overload fun(str : string, arg0 : System.Object)
---@overload fun(str : string, arg0 : System.Object, arg1 : System.Object)
---@overload fun(str : string, arg0 : System.Object, arg1 : System.Object, arg2 : System.Object)
---@param str string
---@param param NotExportType
function LuaInterface_Debugger.LogWarning(str, param) end
---@overload fun(str : string)
---@overload fun(message : System.Object)
---@overload fun(str : string, arg0 : System.Object)
---@overload fun(str : string, arg0 : System.Object, arg1 : System.Object)
---@overload fun(str : string, arg0 : System.Object, arg1 : System.Object, arg2 : System.Object)
---@param str string
---@param param NotExportType
function LuaInterface_Debugger.LogError(str, param) end
---@overload fun(e : NotExportType)
---@param str string
---@param e NotExportType
function LuaInterface_Debugger.LogException(str, e) end

---@class DG.Tweening.DOTween : System.Object
---@field Version string
---@field useSafeMode boolean
---@field safeModeLogBehaviour NotExportEnum
---@field nestedTweenFailureBehaviour NotExportEnum
---@field showUnityEditorReport boolean
---@field timeScale number
---@field unscaledTimeScale number
---@field useSmoothDeltaTime boolean
---@field maxSmoothUnscaledTime number
---@field onWillLog NotExportType
---@field drawGizmos boolean
---@field debugMode boolean
---@field defaultUpdateType NotExportEnum
---@field defaultTimeScaleIndependent boolean
---@field defaultAutoPlay NotExportEnum
---@field defaultAutoKill boolean
---@field defaultLoopType DG.Tweening.LoopType
---@field defaultRecyclable boolean
---@field defaultEaseType DG.Tweening.Ease
---@field defaultEaseOvershootOrAmplitude number
---@field defaultEasePeriod number
---@field instance NotExportType
---@field logBehaviour NotExportEnum
---@field debugStoreTargetId boolean
local DG_Tweening_DOTween = {}
---@return DG.Tweening.DOTween
function DG_Tweening_DOTween.New() end
---@param recycleAllByDefault NotExportType
---@param useSafeMode NotExportType
---@param logBehaviour NotExportType
---@return NotExportType
function DG_Tweening_DOTween.Init(recycleAllByDefault, useSafeMode, logBehaviour) end
---@param tweenersCapacity number
---@param sequencesCapacity number
function DG_Tweening_DOTween.SetTweensCapacity(tweenersCapacity, sequencesCapacity) end
---@param destroy boolean
function DG_Tweening_DOTween.Clear(destroy) end
function DG_Tweening_DOTween.ClearCachedTweens() end
---@return number
function DG_Tweening_DOTween.Validate() end
---@param deltaTime number
---@param unscaledDeltaTime number
function DG_Tweening_DOTween.ManualUpdate(deltaTime, unscaledDeltaTime) end
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : number, duration : number) : DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : number, duration : number) : NotExportType
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : number, duration : number) : DG.Tweening.Core.TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : number, duration : number) : NotExportType
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : number, duration : number) : NotExportType
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : number, duration : number) : NotExportType
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : string, duration : number) : NotExportType
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : UnityEngine.Vector2, duration : number) : NotExportType
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : UnityEngine.Vector3, duration : number) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : NotExportType, duration : number) : NotExportType
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : UnityEngine.Vector3, duration : number) : DG.Tweening.Core.TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : UnityEngine.Color, duration : number) : DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : UnityEngine.Rect, duration : number) : NotExportType
---@overload fun(getter : NotExportType, setter : NotExportType, endValue : UnityEngine.RectOffset, duration : number) : DG.Tweening.Tweener
---@param setter NotExportType
---@param startValue number
---@param endValue number
---@param duration number
---@return DG.Tweening.Tweener
function DG_Tweening_DOTween.To(setter, startValue, endValue, duration) end
---@param getter NotExportType
---@param setter NotExportType
---@param endValue number
---@param duration number
---@param axisConstraint NotExportEnum
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function DG_Tweening_DOTween.ToAxis(getter, setter, endValue, duration, axisConstraint) end
---@param getter NotExportType
---@param setter NotExportType
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function DG_Tweening_DOTween.ToAlpha(getter, setter, endValue, duration) end
---@param getter NotExportType
---@param setter NotExportType
---@param direction UnityEngine.Vector3
---@param duration number
---@param vibrato number
---@param elasticity number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType
function DG_Tweening_DOTween.Punch(getter, setter, direction, duration, vibrato, elasticity) end
---@overload fun(getter : NotExportType, setter : NotExportType, duration : number, strength : number, vibrato : number, randomness : number, ignoreZAxis : boolean, fadeOut : boolean, randomnessMode : NotExportEnum) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType
---@param getter NotExportType
---@param setter NotExportType
---@param duration number
---@param strength UnityEngine.Vector3
---@param vibrato number
---@param randomness number
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType
function DG_Tweening_DOTween.Shake(getter, setter, duration, strength, vibrato, randomness, fadeOut, randomnessMode) end
---@param getter NotExportType
---@param setter NotExportType
---@param endValues NotExportType
---@param durations NotExportType
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType
function DG_Tweening_DOTween.ToArray(getter, setter, endValues, durations) end
---@overload fun() : DG.Tweening.Sequence
---@param target System.Object
---@return DG.Tweening.Sequence
function DG_Tweening_DOTween.Sequence(target) end
---@param withCallbacks boolean
---@return number
function DG_Tweening_DOTween.CompleteAll(withCallbacks) end
---@param targetOrId System.Object
---@param withCallbacks boolean
---@return number
function DG_Tweening_DOTween.Complete(targetOrId, withCallbacks) end
---@return number
function DG_Tweening_DOTween.FlipAll() end
---@param targetOrId System.Object
---@return number
function DG_Tweening_DOTween.Flip(targetOrId) end
---@param to number
---@param andPlay boolean
---@return number
function DG_Tweening_DOTween.GotoAll(to, andPlay) end
---@param targetOrId System.Object
---@param to number
---@param andPlay boolean
---@return number
function DG_Tweening_DOTween.Goto(targetOrId, to, andPlay) end
---@overload fun(complete : boolean) : number
---@param complete boolean
---@param idsOrTargetsToExclude NotExportType
---@return number
function DG_Tweening_DOTween.KillAll(complete, idsOrTargetsToExclude) end
---@overload fun(targetOrId : System.Object, complete : boolean) : number
---@param target System.Object
---@param id System.Object
---@param complete boolean
---@return number
function DG_Tweening_DOTween.Kill(target, id, complete) end
---@return number
function DG_Tweening_DOTween.PauseAll() end
---@param targetOrId System.Object
---@return number
function DG_Tweening_DOTween.Pause(targetOrId) end
---@return number
function DG_Tweening_DOTween.PlayAll() end
---@overload fun(targetOrId : System.Object) : number
---@param target System.Object
---@param id System.Object
---@return number
function DG_Tweening_DOTween.Play(target, id) end
---@return number
function DG_Tweening_DOTween.PlayBackwardsAll() end
---@overload fun(targetOrId : System.Object) : number
---@param target System.Object
---@param id System.Object
---@return number
function DG_Tweening_DOTween.PlayBackwards(target, id) end
---@return number
function DG_Tweening_DOTween.PlayForwardAll() end
---@overload fun(targetOrId : System.Object) : number
---@param target System.Object
---@param id System.Object
---@return number
function DG_Tweening_DOTween.PlayForward(target, id) end
---@param includeDelay boolean
---@return number
function DG_Tweening_DOTween.RestartAll(includeDelay) end
---@overload fun(targetOrId : System.Object, includeDelay : boolean, changeDelayTo : number) : number
---@param target System.Object
---@param id System.Object
---@param includeDelay boolean
---@param changeDelayTo number
---@return number
function DG_Tweening_DOTween.Restart(target, id, includeDelay, changeDelayTo) end
---@param includeDelay boolean
---@return number
function DG_Tweening_DOTween.RewindAll(includeDelay) end
---@param targetOrId System.Object
---@param includeDelay boolean
---@return number
function DG_Tweening_DOTween.Rewind(targetOrId, includeDelay) end
---@return number
function DG_Tweening_DOTween.SmoothRewindAll() end
---@param targetOrId System.Object
---@return number
function DG_Tweening_DOTween.SmoothRewind(targetOrId) end
---@return number
function DG_Tweening_DOTween.TogglePauseAll() end
---@param targetOrId System.Object
---@return number
function DG_Tweening_DOTween.TogglePause(targetOrId) end
---@param targetOrId System.Object
---@param alsoCheckIfIsPlaying boolean
---@return boolean
function DG_Tweening_DOTween.IsTweening(targetOrId, alsoCheckIfIsPlaying) end
---@return number
function DG_Tweening_DOTween.TotalActiveTweens() end
---@return number
function DG_Tweening_DOTween.TotalActiveTweeners() end
---@return number
function DG_Tweening_DOTween.TotalActiveSequences() end
---@return number
function DG_Tweening_DOTween.TotalPlayingTweens() end
---@param id System.Object
---@param playingOnly boolean
---@return number
function DG_Tweening_DOTween.TotalTweensById(id, playingOnly) end
---@param fillableList NotExportType
---@return NotExportType
function DG_Tweening_DOTween.PlayingTweens(fillableList) end
---@param fillableList NotExportType
---@return NotExportType
function DG_Tweening_DOTween.PausedTweens(fillableList) end
---@param id System.Object
---@param playingOnly boolean
---@param fillableList NotExportType
---@return NotExportType
function DG_Tweening_DOTween.TweensById(id, playingOnly, fillableList) end
---@param target System.Object
---@param playingOnly boolean
---@param fillableList NotExportType
---@return NotExportType
function DG_Tweening_DOTween.TweensByTarget(target, playingOnly, fillableList) end

---@class DG.Tweening.Plugins.Options.ColorOptions : System.ValueType
---@field alphaOnly boolean
local DG_Tweening_Plugins_Options_ColorOptions = {}
function DG_Tweening_Plugins_Options_ColorOptions:Reset() end

---@class System.ValueType : System.Object
local System_ValueType = {}
---@param obj System.Object
---@return boolean
function System_ValueType:Equals(obj) end
---@return number
function System_ValueType:GetHashCode() end
---@return string
function System_ValueType:ToString() end

---@class DG.Tweening.Plugins.Options.PathOptions : System.ValueType
---@field mode DG.Tweening.PathMode
---@field orientType NotExportEnum
---@field lockPositionAxis NotExportEnum
---@field lockRotationAxis NotExportEnum
---@field isClosedPath boolean
---@field lookAtPosition UnityEngine.Vector3
---@field lookAtTransform UnityEngine.Transform
---@field lookAhead number
---@field hasCustomForwardDirection boolean
---@field forward UnityEngine.Quaternion
---@field useLocalPosition boolean
---@field parent UnityEngine.Transform
---@field isRigidbody boolean
---@field isRigidbody2D boolean
---@field stableZRotation boolean
local DG_Tweening_Plugins_Options_PathOptions = {}
function DG_Tweening_Plugins_Options_PathOptions:Reset() end

---@class DG.Tweening.Plugins.Options.NoOptions : System.ValueType
local DG_Tweening_Plugins_Options_NoOptions = {}
function DG_Tweening_Plugins_Options_NoOptions:Reset() end

---@class DG.Tweening.Plugins.Options.FloatOptions : System.ValueType
---@field snapping boolean
local DG_Tweening_Plugins_Options_FloatOptions = {}
function DG_Tweening_Plugins_Options_FloatOptions:Reset() end

---@class DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType : DG.Tweening.Tweener
---@field startValue UnityEngine.Vector3
---@field endValue UnityEngine.Vector3
---@field changeValue UnityEngine.Vector3
---@field plugOptions NotExportType
---@field getter NotExportType
---@field setter NotExportType
local DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType = {}
---@overload fun(newStartValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue UnityEngine.Vector3
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType:ChangeStartValue(newStartValue, newDuration) end
---@overload fun(newEndValue : System.Object, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : System.Object, newDuration : number, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : UnityEngine.Vector3, snapStartValue : boolean) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
---@param newEndValue UnityEngine.Vector3
---@param newDuration number
---@param snapStartValue boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType:ChangeEndValue(newEndValue, newDuration, snapStartValue) end
---@overload fun(newStartValue : System.Object, newEndValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue UnityEngine.Vector3
---@param newEndValue UnityEngine.Vector3
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType:ChangeValues(newStartValue, newEndValue, newDuration) end
---@param fromValue number
---@param setImmediately boolean
---@param isRelative boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType:From(fromValue, setImmediately, isRelative) end
---@param snapping boolean
---@return DG.Tweening.Tweener
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType:SetOptions(snapping) end
---@param axisConstraint NotExportEnum
---@param snapping boolean
---@return DG.Tweening.Tweener
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType:SetOptions(axisConstraint, snapping) end

---@class DG.Tweening.Tweener : DG.Tweening.Tween
local DG_Tweening_Tweener = {}
---@param newStartValue System.Object
---@param newDuration number
---@return DG.Tweening.Tweener
function DG_Tweening_Tweener:ChangeStartValue(newStartValue, newDuration) end
---@overload fun(newEndValue : System.Object, newDuration : number, snapStartValue : boolean) : DG.Tweening.Tweener
---@param newEndValue System.Object
---@param snapStartValue boolean
---@return DG.Tweening.Tweener
function DG_Tweening_Tweener:ChangeEndValue(newEndValue, snapStartValue) end
---@param newStartValue System.Object
---@param newEndValue System.Object
---@param newDuration number
---@return DG.Tweening.Tweener
function DG_Tweening_Tweener:ChangeValues(newStartValue, newEndValue, newDuration) end

---@class DG.Tweening.Tween : DG.Tweening.Core.ABSSequentiable
---@field timeScale number
---@field isBackwards boolean
---@field id System.Object
---@field stringId string
---@field intId number
---@field target System.Object
---@field onPlay NotExportType
---@field onPause NotExportType
---@field onRewind NotExportType
---@field onUpdate NotExportType
---@field onStepComplete NotExportType
---@field onComplete NotExportType
---@field onKill NotExportType
---@field onWaypointChange NotExportType
---@field easeOvershootOrAmplitude number
---@field easePeriod number
---@field debugTargetId string
---@field isRelative boolean
---@field active boolean
---@field fullPosition number
---@field hasLoops boolean
---@field playedOnce boolean
---@field position number
local DG_Tweening_Tween = {}
function DG_Tweening_Tween:Complete() end
---@param withCallbacks boolean
function DG_Tweening_Tween:Complete(withCallbacks) end
function DG_Tweening_Tween:Flip() end
function DG_Tweening_Tween:ForceInit() end
---@param to number
---@param andPlay boolean
function DG_Tweening_Tween:Goto(to, andPlay) end
---@param to number
---@param andPlay boolean
function DG_Tweening_Tween:GotoWithCallbacks(to, andPlay) end
---@param complete boolean
function DG_Tweening_Tween:Kill(complete) end
---@param deltaTime number
---@param unscaledDeltaTime number
function DG_Tweening_Tween:ManualUpdate(deltaTime, unscaledDeltaTime) end
function DG_Tweening_Tween:PlayBackwards() end
function DG_Tweening_Tween:PlayForward() end
---@param includeDelay boolean
---@param changeDelayTo number
function DG_Tweening_Tween:Restart(includeDelay, changeDelayTo) end
---@param includeDelay boolean
function DG_Tweening_Tween:Rewind(includeDelay) end
function DG_Tweening_Tween:SmoothRewind() end
function DG_Tweening_Tween:TogglePause() end
---@param waypointIndex number
---@param andPlay boolean
function DG_Tweening_Tween:GotoWaypoint(waypointIndex, andPlay) end
---@return UnityEngine.YieldInstruction
function DG_Tweening_Tween:WaitForCompletion() end
---@return UnityEngine.YieldInstruction
function DG_Tweening_Tween:WaitForRewind() end
---@return UnityEngine.YieldInstruction
function DG_Tweening_Tween:WaitForKill() end
---@param elapsedLoops number
---@return UnityEngine.YieldInstruction
function DG_Tweening_Tween:WaitForElapsedLoops(elapsedLoops) end
---@param position number
---@return UnityEngine.YieldInstruction
function DG_Tweening_Tween:WaitForPosition(position) end
---@return UnityEngine.Coroutine
function DG_Tweening_Tween:WaitForStart() end
---@return number
function DG_Tweening_Tween:CompletedLoops() end
---@return number
function DG_Tweening_Tween:Delay() end
---@return number
function DG_Tweening_Tween:ElapsedDelay() end
---@param includeLoops boolean
---@return number
function DG_Tweening_Tween:Duration(includeLoops) end
---@param includeLoops boolean
---@return number
function DG_Tweening_Tween:Elapsed(includeLoops) end
---@param includeLoops boolean
---@return number
function DG_Tweening_Tween:ElapsedPercentage(includeLoops) end
---@return number
function DG_Tweening_Tween:ElapsedDirectionalPercentage() end
---@return boolean
function DG_Tweening_Tween:IsActive() end
---@return boolean
function DG_Tweening_Tween:IsBackwards() end
---@return boolean
function DG_Tweening_Tween:IsLoopingOrExecutingBackwards() end
---@return boolean
function DG_Tweening_Tween:IsComplete() end
---@return boolean
function DG_Tweening_Tween:IsInitialized() end
---@return boolean
function DG_Tweening_Tween:IsPlaying() end
---@return number
function DG_Tweening_Tween:Loops() end
---@param pathPercentage number
---@return UnityEngine.Vector3
function DG_Tweening_Tween:PathGetPoint(pathPercentage) end
---@param subdivisionsXSegment number
---@return NotExportType
function DG_Tweening_Tween:PathGetDrawPoints(subdivisionsXSegment) end
---@return number
function DG_Tweening_Tween:PathLength() end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function DG_Tweening_Tween:DOTimeScale(endValue, duration) end

---@class DG.Tweening.Core.ABSSequentiable : System.Object
local DG_Tweening_Core_ABSSequentiable = {}

---@class DG.Tweening.Core.TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions : DG.Tweening.Tweener
---@field startValue number
---@field endValue number
---@field changeValue number
---@field plugOptions DG.Tweening.Plugins.Options.NoOptions
---@field getter NotExportType
---@field setter NotExportType
local DG_Tweening_Core_TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions = {}
---@overload fun(newStartValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue number
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions
function DG_Tweening_Core_TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions:ChangeStartValue(newStartValue, newDuration) end
---@overload fun(newEndValue : System.Object, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : System.Object, newDuration : number, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : number, snapStartValue : boolean) : DG.Tweening.Core.TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions
---@param newEndValue number
---@param newDuration number
---@param snapStartValue boolean
---@return DG.Tweening.Core.TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions
function DG_Tweening_Core_TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions:ChangeEndValue(newEndValue, newDuration, snapStartValue) end
---@overload fun(newStartValue : System.Object, newEndValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue number
---@param newEndValue number
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions
function DG_Tweening_Core_TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions:ChangeValues(newStartValue, newEndValue, newDuration) end

---@class DG.Tweening.Core.TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType : DG.Tweening.Tweener
---@field startValue UnityEngine.Vector3
---@field endValue UnityEngine.Vector3
---@field changeValue UnityEngine.Vector3
---@field plugOptions NotExportType
---@field getter NotExportType
---@field setter NotExportType
local DG_Tweening_Core_TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType = {}
---@overload fun(newStartValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue UnityEngine.Vector3
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType
function DG_Tweening_Core_TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType:ChangeStartValue(newStartValue, newDuration) end
---@overload fun(newEndValue : System.Object, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : System.Object, newDuration : number, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : UnityEngine.Vector3, snapStartValue : boolean) : DG.Tweening.Core.TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType
---@param newEndValue UnityEngine.Vector3
---@param newDuration number
---@param snapStartValue boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType
function DG_Tweening_Core_TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType:ChangeEndValue(newEndValue, newDuration, snapStartValue) end
---@overload fun(newStartValue : System.Object, newEndValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue UnityEngine.Vector3
---@param newEndValue UnityEngine.Vector3
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType
function DG_Tweening_Core_TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType:ChangeValues(newStartValue, newEndValue, newDuration) end
---@param useShortest360Route boolean
---@return DG.Tweening.Tweener
function DG_Tweening_Core_TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType:SetOptions(useShortest360Route) end

---@class DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions : DG.Tweening.Tweener
---@field startValue NotExportType
---@field endValue NotExportType
---@field changeValue NotExportType
---@field plugOptions DG.Tweening.Plugins.Options.PathOptions
---@field getter NotExportType
---@field setter NotExportType
local DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions = {}
---@overload fun(newStartValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue NotExportType
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions:ChangeStartValue(newStartValue, newDuration) end
---@overload fun(newEndValue : System.Object, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : System.Object, newDuration : number, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : NotExportType, snapStartValue : boolean) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
---@param newEndValue NotExportType
---@param newDuration number
---@param snapStartValue boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions:ChangeEndValue(newEndValue, newDuration, snapStartValue) end
---@overload fun(newStartValue : System.Object, newEndValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue NotExportType
---@param newEndValue NotExportType
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions:ChangeValues(newStartValue, newEndValue, newDuration) end
---@param lockPosition NotExportEnum
---@param lockRotation NotExportEnum
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions:SetOptions(lockPosition, lockRotation) end
---@param closePath boolean
---@param lockPosition NotExportEnum
---@param lockRotation NotExportEnum
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions:SetOptions(closePath, lockPosition, lockRotation) end
---@param lookAtPosition UnityEngine.Vector3
---@param forwardDirection NotExportType
---@param up NotExportType
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions:SetLookAt(lookAtPosition, forwardDirection, up) end
---@param lookAtPosition UnityEngine.Vector3
---@param stableZRotation boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions:SetLookAt(lookAtPosition, stableZRotation) end
---@param lookAtTransform UnityEngine.Transform
---@param forwardDirection NotExportType
---@param up NotExportType
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions:SetLookAt(lookAtTransform, forwardDirection, up) end
---@param lookAtTransform UnityEngine.Transform
---@param stableZRotation boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions:SetLookAt(lookAtTransform, stableZRotation) end
---@param lookAhead number
---@param forwardDirection NotExportType
---@param up NotExportType
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions:SetLookAt(lookAhead, forwardDirection, up) end
---@param lookAhead number
---@param stableZRotation boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions:SetLookAt(lookAhead, stableZRotation) end

---@class DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions : DG.Tweening.Tweener
---@field startValue UnityEngine.Color
---@field endValue UnityEngine.Color
---@field changeValue UnityEngine.Color
---@field plugOptions DG.Tweening.Plugins.Options.ColorOptions
---@field getter NotExportType
---@field setter NotExportType
local DG_Tweening_Core_TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions = {}
---@overload fun(newStartValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue UnityEngine.Color
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions:ChangeStartValue(newStartValue, newDuration) end
---@overload fun(newEndValue : System.Object, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : System.Object, newDuration : number, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : UnityEngine.Color, snapStartValue : boolean) : DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
---@param newEndValue UnityEngine.Color
---@param newDuration number
---@param snapStartValue boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions:ChangeEndValue(newEndValue, newDuration, snapStartValue) end
---@overload fun(newStartValue : System.Object, newEndValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue UnityEngine.Color
---@param newEndValue UnityEngine.Color
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions:ChangeValues(newStartValue, newEndValue, newDuration) end
---@param fromAlphaValue number
---@param setImmediately boolean
---@param isRelative boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function DG_Tweening_Core_TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions:From(fromAlphaValue, setImmediately, isRelative) end
---@param alphaOnly boolean
---@return DG.Tweening.Tweener
function DG_Tweening_Core_TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions:SetOptions(alphaOnly) end

---@class DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions : DG.Tweening.Tweener
---@field startValue number
---@field endValue number
---@field changeValue number
---@field plugOptions DG.Tweening.Plugins.Options.FloatOptions
---@field getter NotExportType
---@field setter NotExportType
local DG_Tweening_Core_TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions = {}
---@overload fun(newStartValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue number
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function DG_Tweening_Core_TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions:ChangeStartValue(newStartValue, newDuration) end
---@overload fun(newEndValue : System.Object, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : System.Object, newDuration : number, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : number, snapStartValue : boolean) : DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
---@param newEndValue number
---@param newDuration number
---@param snapStartValue boolean
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function DG_Tweening_Core_TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions:ChangeEndValue(newEndValue, newDuration, snapStartValue) end
---@overload fun(newStartValue : System.Object, newEndValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue number
---@param newEndValue number
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function DG_Tweening_Core_TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions:ChangeValues(newStartValue, newEndValue, newDuration) end
---@param snapping boolean
---@return DG.Tweening.Tweener
function DG_Tweening_Core_TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions:SetOptions(snapping) end

---@class DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType : DG.Tweening.Tweener
---@field startValue NotExportType
---@field endValue NotExportType
---@field changeValue NotExportType
---@field plugOptions NotExportType
---@field getter NotExportType
---@field setter NotExportType
local DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType = {}
---@overload fun(newStartValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue NotExportType
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType:ChangeStartValue(newStartValue, newDuration) end
---@overload fun(newEndValue : System.Object, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : System.Object, newDuration : number, snapStartValue : boolean) : DG.Tweening.Tweener
---@overload fun(newEndValue : NotExportType, snapStartValue : boolean) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType
---@param newEndValue NotExportType
---@param newDuration number
---@param snapStartValue boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType:ChangeEndValue(newEndValue, newDuration, snapStartValue) end
---@overload fun(newStartValue : System.Object, newEndValue : System.Object, newDuration : number) : DG.Tweening.Tweener
---@param newStartValue NotExportType
---@param newEndValue NotExportType
---@param newDuration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType:ChangeValues(newStartValue, newEndValue, newDuration) end
---@param snapping boolean
---@return DG.Tweening.Tweener
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType:SetOptions(snapping) end
---@param axisConstraint NotExportEnum
---@param snapping boolean
---@return DG.Tweening.Tweener
function DG_Tweening_Core_TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType:SetOptions(axisConstraint, snapping) end

---@class DG.Tweening.TweenExtensions : System.Object
local DG_Tweening_TweenExtensions = {}
---@overload fun(t : DG.Tweening.Tween)
---@param t DG.Tweening.Tween
---@param withCallbacks boolean
function DG_Tweening_TweenExtensions.Complete(t, withCallbacks) end
---@param t DG.Tweening.Tween
function DG_Tweening_TweenExtensions.Flip(t) end
---@param t DG.Tweening.Tween
function DG_Tweening_TweenExtensions.ForceInit(t) end
---@param t DG.Tweening.Tween
---@param to number
---@param andPlay boolean
function DG_Tweening_TweenExtensions.Goto(t, to, andPlay) end
---@param t DG.Tweening.Tween
---@param to number
---@param andPlay boolean
function DG_Tweening_TweenExtensions.GotoWithCallbacks(t, to, andPlay) end
---@param t DG.Tweening.Tween
---@param complete boolean
function DG_Tweening_TweenExtensions.Kill(t, complete) end
---@param t DG.Tweening.Tween
---@param deltaTime number
---@param unscaledDeltaTime number
function DG_Tweening_TweenExtensions.ManualUpdate(t, deltaTime, unscaledDeltaTime) end
---@param t DG.Tweening.Tween
function DG_Tweening_TweenExtensions.PlayBackwards(t) end
---@param t DG.Tweening.Tween
function DG_Tweening_TweenExtensions.PlayForward(t) end
---@param t DG.Tweening.Tween
---@param includeDelay boolean
---@param changeDelayTo number
function DG_Tweening_TweenExtensions.Restart(t, includeDelay, changeDelayTo) end
---@param t DG.Tweening.Tween
---@param includeDelay boolean
function DG_Tweening_TweenExtensions.Rewind(t, includeDelay) end
---@param t DG.Tweening.Tween
function DG_Tweening_TweenExtensions.SmoothRewind(t) end
---@param t DG.Tweening.Tween
function DG_Tweening_TweenExtensions.TogglePause(t) end
---@param t DG.Tweening.Tween
---@param waypointIndex number
---@param andPlay boolean
function DG_Tweening_TweenExtensions.GotoWaypoint(t, waypointIndex, andPlay) end
---@param t DG.Tweening.Tween
---@return UnityEngine.YieldInstruction
function DG_Tweening_TweenExtensions.WaitForCompletion(t) end
---@param t DG.Tweening.Tween
---@return UnityEngine.YieldInstruction
function DG_Tweening_TweenExtensions.WaitForRewind(t) end
---@param t DG.Tweening.Tween
---@return UnityEngine.YieldInstruction
function DG_Tweening_TweenExtensions.WaitForKill(t) end
---@param t DG.Tweening.Tween
---@param elapsedLoops number
---@return UnityEngine.YieldInstruction
function DG_Tweening_TweenExtensions.WaitForElapsedLoops(t, elapsedLoops) end
---@param t DG.Tweening.Tween
---@param position number
---@return UnityEngine.YieldInstruction
function DG_Tweening_TweenExtensions.WaitForPosition(t, position) end
---@param t DG.Tweening.Tween
---@return UnityEngine.Coroutine
function DG_Tweening_TweenExtensions.WaitForStart(t) end
---@param t DG.Tweening.Tween
---@return number
function DG_Tweening_TweenExtensions.CompletedLoops(t) end
---@param t DG.Tweening.Tween
---@return number
function DG_Tweening_TweenExtensions.Delay(t) end
---@param t DG.Tweening.Tween
---@return number
function DG_Tweening_TweenExtensions.ElapsedDelay(t) end
---@param t DG.Tweening.Tween
---@param includeLoops boolean
---@return number
function DG_Tweening_TweenExtensions.Duration(t, includeLoops) end
---@param t DG.Tweening.Tween
---@param includeLoops boolean
---@return number
function DG_Tweening_TweenExtensions.Elapsed(t, includeLoops) end
---@param t DG.Tweening.Tween
---@param includeLoops boolean
---@return number
function DG_Tweening_TweenExtensions.ElapsedPercentage(t, includeLoops) end
---@param t DG.Tweening.Tween
---@return number
function DG_Tweening_TweenExtensions.ElapsedDirectionalPercentage(t) end
---@param t DG.Tweening.Tween
---@return boolean
function DG_Tweening_TweenExtensions.IsActive(t) end
---@param t DG.Tweening.Tween
---@return boolean
function DG_Tweening_TweenExtensions.IsBackwards(t) end
---@param t DG.Tweening.Tween
---@return boolean
function DG_Tweening_TweenExtensions.IsLoopingOrExecutingBackwards(t) end
---@param t DG.Tweening.Tween
---@return boolean
function DG_Tweening_TweenExtensions.IsComplete(t) end
---@param t DG.Tweening.Tween
---@return boolean
function DG_Tweening_TweenExtensions.IsInitialized(t) end
---@param t DG.Tweening.Tween
---@return boolean
function DG_Tweening_TweenExtensions.IsPlaying(t) end
---@param t DG.Tweening.Tween
---@return number
function DG_Tweening_TweenExtensions.Loops(t) end
---@param t DG.Tweening.Tween
---@param pathPercentage number
---@return UnityEngine.Vector3
function DG_Tweening_TweenExtensions.PathGetPoint(t, pathPercentage) end
---@param t DG.Tweening.Tween
---@param subdivisionsXSegment number
---@return NotExportType
function DG_Tweening_TweenExtensions.PathGetDrawPoints(t, subdivisionsXSegment) end
---@param t DG.Tweening.Tween
---@return number
function DG_Tweening_TweenExtensions.PathLength(t) end

---@class DG.Tweening.Sequence : DG.Tweening.Tween
local DG_Tweening_Sequence = {}
---@param t DG.Tweening.Tween
---@return DG.Tweening.Sequence
function DG_Tweening_Sequence:Append(t) end
---@param t DG.Tweening.Tween
---@return DG.Tweening.Sequence
function DG_Tweening_Sequence:Prepend(t) end
---@param t DG.Tweening.Tween
---@return DG.Tweening.Sequence
function DG_Tweening_Sequence:Join(t) end
---@param atPosition number
---@param t DG.Tweening.Tween
---@return DG.Tweening.Sequence
function DG_Tweening_Sequence:Insert(atPosition, t) end
---@param interval number
---@return DG.Tweening.Sequence
function DG_Tweening_Sequence:AppendInterval(interval) end
---@param interval number
---@return DG.Tweening.Sequence
function DG_Tweening_Sequence:PrependInterval(interval) end
---@param callback NotExportType
---@return DG.Tweening.Sequence
function DG_Tweening_Sequence:AppendCallback(callback) end
---@param callback NotExportType
---@return DG.Tweening.Sequence
function DG_Tweening_Sequence:PrependCallback(callback) end
---@param atPosition number
---@param callback NotExportType
---@return DG.Tweening.Sequence
function DG_Tweening_Sequence:InsertCallback(atPosition, callback) end

---@class DG.Tweening.TweenSettingsExtensions : System.Object
local DG_Tweening_TweenSettingsExtensions = {}
---@param s DG.Tweening.Sequence
---@param t DG.Tweening.Tween
---@return DG.Tweening.Sequence
function DG_Tweening_TweenSettingsExtensions.Append(s, t) end
---@param s DG.Tweening.Sequence
---@param t DG.Tweening.Tween
---@return DG.Tweening.Sequence
function DG_Tweening_TweenSettingsExtensions.Prepend(s, t) end
---@param s DG.Tweening.Sequence
---@param t DG.Tweening.Tween
---@return DG.Tweening.Sequence
function DG_Tweening_TweenSettingsExtensions.Join(s, t) end
---@param s DG.Tweening.Sequence
---@param atPosition number
---@param t DG.Tweening.Tween
---@return DG.Tweening.Sequence
function DG_Tweening_TweenSettingsExtensions.Insert(s, atPosition, t) end
---@param s DG.Tweening.Sequence
---@param interval number
---@return DG.Tweening.Sequence
function DG_Tweening_TweenSettingsExtensions.AppendInterval(s, interval) end
---@param s DG.Tweening.Sequence
---@param interval number
---@return DG.Tweening.Sequence
function DG_Tweening_TweenSettingsExtensions.PrependInterval(s, interval) end
---@param s DG.Tweening.Sequence
---@param callback NotExportType
---@return DG.Tweening.Sequence
function DG_Tweening_TweenSettingsExtensions.AppendCallback(s, callback) end
---@param s DG.Tweening.Sequence
---@param callback NotExportType
---@return DG.Tweening.Sequence
function DG_Tweening_TweenSettingsExtensions.PrependCallback(s, callback) end
---@param s DG.Tweening.Sequence
---@param atPosition number
---@param callback NotExportType
---@return DG.Tweening.Sequence
function DG_Tweening_TweenSettingsExtensions.InsertCallback(s, atPosition, callback) end
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions, fromAlphaValue : number, setImmediately : boolean, isRelative : boolean) : DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType, fromValue : number, setImmediately : boolean, isRelative : boolean) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
---@param t NotExportType
---@param fromValueDegrees number
---@param setImmediately boolean
---@param isRelative boolean
---@return NotExportType
function DG_Tweening_TweenSettingsExtensions.From(t, fromValueDegrees, setImmediately, isRelative) end
---@overload fun(t : DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions, snapping : boolean) : DG.Tweening.Tweener
---@overload fun(t : NotExportType, snapping : boolean) : DG.Tweening.Tweener
---@overload fun(t : NotExportType, axisConstraint : NotExportEnum, snapping : boolean) : DG.Tweening.Tweener
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType, snapping : boolean) : DG.Tweening.Tweener
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType, axisConstraint : NotExportEnum, snapping : boolean) : DG.Tweening.Tweener
---@overload fun(t : NotExportType, snapping : boolean) : DG.Tweening.Tweener
---@overload fun(t : NotExportType, axisConstraint : NotExportEnum, snapping : boolean) : DG.Tweening.Tweener
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType, useShortest360Route : boolean) : DG.Tweening.Tweener
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions, alphaOnly : boolean) : DG.Tweening.Tweener
---@overload fun(t : NotExportType, snapping : boolean) : DG.Tweening.Tweener
---@overload fun(t : NotExportType, richTextEnabled : boolean, scrambleMode : NotExportEnum, scrambleChars : string) : DG.Tweening.Tweener
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType, snapping : boolean) : DG.Tweening.Tweener
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_NotExportType, axisConstraint : NotExportEnum, snapping : boolean) : DG.Tweening.Tweener
---@overload fun(t : NotExportType, endValueDegrees : number, relativeCenter : boolean, snapping : boolean) : DG.Tweening.Tweener
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions, lockPosition : NotExportEnum, lockRotation : NotExportEnum) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
---@param t DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
---@param closePath boolean
---@param lockPosition NotExportEnum
---@param lockRotation NotExportEnum
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_TweenSettingsExtensions.SetOptions(t, closePath, lockPosition, lockRotation) end
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions, lookAtPosition : UnityEngine.Vector3, forwardDirection : NotExportType, up : NotExportType) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions, lookAtPosition : UnityEngine.Vector3, stableZRotation : boolean) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions, lookAtTransform : UnityEngine.Transform, forwardDirection : NotExportType, up : NotExportType) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions, lookAtTransform : UnityEngine.Transform, stableZRotation : boolean) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
---@overload fun(t : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions, lookAhead : number, forwardDirection : NotExportType, up : NotExportType) : DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
---@param t DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
---@param lookAhead number
---@param stableZRotation boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function DG_Tweening_TweenSettingsExtensions.SetLookAt(t, lookAhead, stableZRotation) end

---@class DG.Tweening.LoopType
---@field Restart DG.Tweening.LoopType
---@field Yoyo DG.Tweening.LoopType
---@field Incremental DG.Tweening.LoopType
local DG_Tweening_LoopType = {}

---@class DG.Tweening.PathMode
---@field Ignore DG.Tweening.PathMode
---@field Full3D DG.Tweening.PathMode
---@field TopDown2D DG.Tweening.PathMode
---@field Sidescroller2D DG.Tweening.PathMode
local DG_Tweening_PathMode = {}

---@class DG.Tweening.PathType
---@field Linear DG.Tweening.PathType
---@field CatmullRom DG.Tweening.PathType
---@field CubicBezier DG.Tweening.PathType
local DG_Tweening_PathType = {}

---@class DG.Tweening.RotateMode
---@field Fast DG.Tweening.RotateMode
---@field FastBeyond360 DG.Tweening.RotateMode
---@field WorldAxisAdd DG.Tweening.RotateMode
---@field LocalAxisAdd DG.Tweening.RotateMode
local DG_Tweening_RotateMode = {}

---@class DG.Tweening.Ease
---@field Unset DG.Tweening.Ease
---@field Linear DG.Tweening.Ease
---@field InSine DG.Tweening.Ease
---@field OutSine DG.Tweening.Ease
---@field InOutSine DG.Tweening.Ease
---@field InQuad DG.Tweening.Ease
---@field OutQuad DG.Tweening.Ease
---@field InOutQuad DG.Tweening.Ease
---@field InCubic DG.Tweening.Ease
---@field OutCubic DG.Tweening.Ease
---@field InOutCubic DG.Tweening.Ease
---@field InQuart DG.Tweening.Ease
---@field OutQuart DG.Tweening.Ease
---@field InOutQuart DG.Tweening.Ease
---@field InQuint DG.Tweening.Ease
---@field OutQuint DG.Tweening.Ease
---@field InOutQuint DG.Tweening.Ease
---@field InExpo DG.Tweening.Ease
---@field OutExpo DG.Tweening.Ease
---@field InOutExpo DG.Tweening.Ease
---@field InCirc DG.Tweening.Ease
---@field OutCirc DG.Tweening.Ease
---@field InOutCirc DG.Tweening.Ease
---@field InElastic DG.Tweening.Ease
---@field OutElastic DG.Tweening.Ease
---@field InOutElastic DG.Tweening.Ease
---@field InBack DG.Tweening.Ease
---@field OutBack DG.Tweening.Ease
---@field InOutBack DG.Tweening.Ease
---@field InBounce DG.Tweening.Ease
---@field OutBounce DG.Tweening.Ease
---@field InOutBounce DG.Tweening.Ease
---@field Flash DG.Tweening.Ease
---@field InFlash DG.Tweening.Ease
---@field OutFlash DG.Tweening.Ease
---@field InOutFlash DG.Tweening.Ease
---@field INTERNAL_Zero DG.Tweening.Ease
---@field INTERNAL_Custom DG.Tweening.Ease
local DG_Tweening_Ease = {}

---@class UnityEngine.Component : UnityEngine.Object
---@field transform UnityEngine.Transform
---@field gameObject UnityEngine.GameObject
---@field tag string
local UnityEngine_Component = {}
---@return UnityEngine.Component
function UnityEngine_Component.New() end
---@overload fun(type : System.Type) : UnityEngine.Component
---@param type string
---@return UnityEngine.Component
function UnityEngine_Component:GetComponent(type) end
---@param type System.Type
---@param out_component UnityEngine.Component
---@return boolean,UnityEngine.Component
function UnityEngine_Component:TryGetComponent(type, out_component) end
---@overload fun(t : System.Type, includeInactive : boolean) : UnityEngine.Component
---@param t System.Type
---@return UnityEngine.Component
function UnityEngine_Component:GetComponentInChildren(t) end
---@overload fun(t : System.Type, includeInactive : boolean) : NotExportType
---@param t System.Type
---@return NotExportType
function UnityEngine_Component:GetComponentsInChildren(t) end
---@overload fun(t : System.Type, includeInactive : boolean) : UnityEngine.Component
---@param t System.Type
---@return UnityEngine.Component
function UnityEngine_Component:GetComponentInParent(t) end
---@overload fun(t : System.Type, includeInactive : boolean) : NotExportType
---@param t System.Type
---@return NotExportType
function UnityEngine_Component:GetComponentsInParent(t) end
---@overload fun(type : System.Type) : NotExportType
---@param type System.Type
---@param results NotExportType
function UnityEngine_Component:GetComponents(type, results) end
---@return number
function UnityEngine_Component:GetComponentIndex() end
---@param tag string
---@return boolean
function UnityEngine_Component:CompareTag(tag) end
---@overload fun(methodName : string, value : System.Object, options : NotExportEnum)
---@overload fun(methodName : string, value : System.Object)
---@overload fun(methodName : string)
---@param methodName string
---@param options NotExportEnum
function UnityEngine_Component:SendMessageUpwards(methodName, options) end
---@overload fun(methodName : string, value : System.Object)
---@overload fun(methodName : string)
---@overload fun(methodName : string, value : System.Object, options : NotExportEnum)
---@param methodName string
---@param options NotExportEnum
function UnityEngine_Component:SendMessage(methodName, options) end
---@overload fun(methodName : string, parameter : System.Object, options : NotExportEnum)
---@overload fun(methodName : string, parameter : System.Object)
---@overload fun(methodName : string)
---@param methodName string
---@param options NotExportEnum
function UnityEngine_Component:BroadcastMessage(methodName, options) end
---@param withCallbacks boolean
---@return number
function UnityEngine_Component:DOComplete(withCallbacks) end
---@param complete boolean
---@return number
function UnityEngine_Component:DOKill(complete) end
---@return number
function UnityEngine_Component:DOFlip() end
---@param to number
---@param andPlay boolean
---@return number
function UnityEngine_Component:DOGoto(to, andPlay) end
---@return number
function UnityEngine_Component:DOPause() end
---@return number
function UnityEngine_Component:DOPlay() end
---@return number
function UnityEngine_Component:DOPlayBackwards() end
---@return number
function UnityEngine_Component:DOPlayForward() end
---@param includeDelay boolean
---@return number
function UnityEngine_Component:DORestart(includeDelay) end
---@param includeDelay boolean
---@return number
function UnityEngine_Component:DORewind(includeDelay) end
---@return number
function UnityEngine_Component:DOSmoothRewind() end
---@return number
function UnityEngine_Component:DOTogglePause() end

---@class UnityEngine.Object : System.Object
---@field name string
---@field hideFlags NotExportEnum
local UnityEngine_Object = {}
---@return UnityEngine.Object
function UnityEngine_Object.New() end
---@overload fun(original : UnityEngine.Object, position : UnityEngine.Vector3, rotation : UnityEngine.Quaternion) : UnityEngine.Object
---@overload fun(original : UnityEngine.Object, position : UnityEngine.Vector3, rotation : UnityEngine.Quaternion, parent : UnityEngine.Transform) : UnityEngine.Object
---@overload fun(original : UnityEngine.Object) : UnityEngine.Object
---@overload fun(original : UnityEngine.Object, scene : UnityEngine.SceneManagement.Scene) : UnityEngine.Object
---@overload fun(original : UnityEngine.Object, parent : UnityEngine.Transform) : UnityEngine.Object
---@param original UnityEngine.Object
---@param parent UnityEngine.Transform
---@param instantiateInWorldSpace boolean
---@return UnityEngine.Object
function UnityEngine_Object.Instantiate(original, parent, instantiateInWorldSpace) end
---@overload fun(obj : UnityEngine.Object, t : number)
---@param obj UnityEngine.Object
function UnityEngine_Object.Destroy(obj) end
---@overload fun(obj : UnityEngine.Object, allowDestroyingAssets : boolean)
---@param obj UnityEngine.Object
function UnityEngine_Object.DestroyImmediate(obj) end
---@overload fun(type : System.Type) : NotExportType
---@param type System.Type
---@param includeInactive boolean
---@return NotExportType
function UnityEngine_Object.FindObjectsOfType(type, includeInactive) end
---@overload fun(type : System.Type, sortMode : NotExportEnum) : NotExportType
---@param type System.Type
---@param findObjectsInactive NotExportEnum
---@param sortMode NotExportEnum
---@return NotExportType
function UnityEngine_Object.FindObjectsByType(type, findObjectsInactive, sortMode) end
---@param target UnityEngine.Object
function UnityEngine_Object.DontDestroyOnLoad(target) end
---@overload fun(type : System.Type) : UnityEngine.Object
---@param type System.Type
---@param includeInactive boolean
---@return UnityEngine.Object
function UnityEngine_Object.FindObjectOfType(type, includeInactive) end
---@overload fun(type : System.Type) : UnityEngine.Object
---@param type System.Type
---@param findObjectsInactive NotExportEnum
---@return UnityEngine.Object
function UnityEngine_Object.FindFirstObjectByType(type, findObjectsInactive) end
---@overload fun(type : System.Type) : UnityEngine.Object
---@param type System.Type
---@param findObjectsInactive NotExportEnum
---@return UnityEngine.Object
function UnityEngine_Object.FindAnyObjectByType(type, findObjectsInactive) end
---@return number
function UnityEngine_Object:GetInstanceID() end
---@return number
function UnityEngine_Object:GetHashCode() end
---@param other System.Object
---@return boolean
function UnityEngine_Object:Equals(other) end
---@return string
function UnityEngine_Object:ToString() end

---@class UnityEngine.Transform : UnityEngine.Component
---@field position UnityEngine.Vector3
---@field localPosition UnityEngine.Vector3
---@field eulerAngles UnityEngine.Vector3
---@field localEulerAngles UnityEngine.Vector3
---@field right UnityEngine.Vector3
---@field up UnityEngine.Vector3
---@field forward UnityEngine.Vector3
---@field rotation UnityEngine.Quaternion
---@field localRotation UnityEngine.Quaternion
---@field localScale UnityEngine.Vector3
---@field parent UnityEngine.Transform
---@field worldToLocalMatrix NotExportType
---@field localToWorldMatrix NotExportType
---@field root UnityEngine.Transform
---@field childCount number
---@field lossyScale UnityEngine.Vector3
---@field hasChanged boolean
---@field hierarchyCapacity number
---@field hierarchyCount number
local UnityEngine_Transform = {}
---@overload fun(p : UnityEngine.Transform)
---@param parent UnityEngine.Transform
---@param worldPositionStays boolean
function UnityEngine_Transform:SetParent(parent, worldPositionStays) end
---@param position UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
function UnityEngine_Transform:SetPositionAndRotation(position, rotation) end
---@param localPosition UnityEngine.Vector3
---@param localRotation UnityEngine.Quaternion
function UnityEngine_Transform:SetLocalPositionAndRotation(localPosition, localRotation) end
---@param out_position UnityEngine.Vector3
---@param out_rotation UnityEngine.Quaternion
---@return ,UnityEngine.Vector3,UnityEngine.Quaternion
function UnityEngine_Transform:GetPositionAndRotation(out_position, out_rotation) end
---@param out_localPosition UnityEngine.Vector3
---@param out_localRotation UnityEngine.Quaternion
---@return ,UnityEngine.Vector3,UnityEngine.Quaternion
function UnityEngine_Transform:GetLocalPositionAndRotation(out_localPosition, out_localRotation) end
---@overload fun(translation : UnityEngine.Vector3, relativeTo : UnityEngine.Space)
---@overload fun(translation : UnityEngine.Vector3)
---@overload fun(x : number, y : number, z : number, relativeTo : UnityEngine.Space)
---@overload fun(x : number, y : number, z : number)
---@overload fun(translation : UnityEngine.Vector3, relativeTo : UnityEngine.Transform)
---@param x number
---@param y number
---@param z number
---@param relativeTo UnityEngine.Transform
function UnityEngine_Transform:Translate(x, y, z, relativeTo) end
---@overload fun(eulers : UnityEngine.Vector3, relativeTo : UnityEngine.Space)
---@overload fun(eulers : UnityEngine.Vector3)
---@overload fun(xAngle : number, yAngle : number, zAngle : number, relativeTo : UnityEngine.Space)
---@overload fun(xAngle : number, yAngle : number, zAngle : number)
---@overload fun(axis : UnityEngine.Vector3, angle : number, relativeTo : UnityEngine.Space)
---@param axis UnityEngine.Vector3
---@param angle number
function UnityEngine_Transform:Rotate(axis, angle) end
---@param point UnityEngine.Vector3
---@param axis UnityEngine.Vector3
---@param angle number
function UnityEngine_Transform:RotateAround(point, axis, angle) end
---@overload fun(target : UnityEngine.Transform, worldUp : UnityEngine.Vector3)
---@overload fun(target : UnityEngine.Transform)
---@overload fun(worldPosition : UnityEngine.Vector3, worldUp : UnityEngine.Vector3)
---@param worldPosition UnityEngine.Vector3
function UnityEngine_Transform:LookAt(worldPosition) end
---@overload fun(direction : UnityEngine.Vector3) : UnityEngine.Vector3
---@param x number
---@param y number
---@param z number
---@return UnityEngine.Vector3
function UnityEngine_Transform:TransformDirection(x, y, z) end
---@overload fun(directions : NotExportType, transformedDirections : NotExportType)
---@param directions NotExportType
function UnityEngine_Transform:TransformDirections(directions) end
---@overload fun(direction : UnityEngine.Vector3) : UnityEngine.Vector3
---@param x number
---@param y number
---@param z number
---@return UnityEngine.Vector3
function UnityEngine_Transform:InverseTransformDirection(x, y, z) end
---@overload fun(directions : NotExportType, transformedDirections : NotExportType)
---@param directions NotExportType
function UnityEngine_Transform:InverseTransformDirections(directions) end
---@overload fun(vector : UnityEngine.Vector3) : UnityEngine.Vector3
---@param x number
---@param y number
---@param z number
---@return UnityEngine.Vector3
function UnityEngine_Transform:TransformVector(x, y, z) end
---@overload fun(vectors : NotExportType, transformedVectors : NotExportType)
---@param vectors NotExportType
function UnityEngine_Transform:TransformVectors(vectors) end
---@overload fun(vector : UnityEngine.Vector3) : UnityEngine.Vector3
---@param x number
---@param y number
---@param z number
---@return UnityEngine.Vector3
function UnityEngine_Transform:InverseTransformVector(x, y, z) end
---@overload fun(vectors : NotExportType, transformedVectors : NotExportType)
---@param vectors NotExportType
function UnityEngine_Transform:InverseTransformVectors(vectors) end
---@overload fun(position : UnityEngine.Vector3) : UnityEngine.Vector3
---@param x number
---@param y number
---@param z number
---@return UnityEngine.Vector3
function UnityEngine_Transform:TransformPoint(x, y, z) end
---@overload fun(positions : NotExportType, transformedPositions : NotExportType)
---@param positions NotExportType
function UnityEngine_Transform:TransformPoints(positions) end
---@overload fun(position : UnityEngine.Vector3) : UnityEngine.Vector3
---@param x number
---@param y number
---@param z number
---@return UnityEngine.Vector3
function UnityEngine_Transform:InverseTransformPoint(x, y, z) end
---@overload fun(positions : NotExportType, transformedPositions : NotExportType)
---@param positions NotExportType
function UnityEngine_Transform:InverseTransformPoints(positions) end
function UnityEngine_Transform:DetachChildren() end
function UnityEngine_Transform:SetAsFirstSibling() end
function UnityEngine_Transform:SetAsLastSibling() end
---@param index number
function UnityEngine_Transform:SetSiblingIndex(index) end
---@return number
function UnityEngine_Transform:GetSiblingIndex() end
---@param n string
---@return UnityEngine.Transform
function UnityEngine_Transform:Find(n) end
---@param parent UnityEngine.Transform
---@return boolean
function UnityEngine_Transform:IsChildOf(parent) end
---@return System.Collections.IEnumerator
function UnityEngine_Transform:GetEnumerator() end
---@param index number
---@return UnityEngine.Transform
function UnityEngine_Transform:GetChild(index) end
---@param endValue UnityEngine.Vector3
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOMove(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOMoveX(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOMoveY(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOMoveZ(endValue, duration, snapping) end
---@param endValue UnityEngine.Vector3
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOLocalMove(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOLocalMoveX(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOLocalMoveY(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOLocalMoveZ(endValue, duration, snapping) end
---@param endValue UnityEngine.Vector3
---@param duration number
---@param mode DG.Tweening.RotateMode
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DORotate(endValue, duration, mode) end
---@param endValue UnityEngine.Quaternion
---@param duration number
---@return NotExportType
function UnityEngine_Transform:DORotateQuaternion(endValue, duration) end
---@param endValue UnityEngine.Vector3
---@param duration number
---@param mode DG.Tweening.RotateMode
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Quaternion_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOLocalRotate(endValue, duration, mode) end
---@param endValue UnityEngine.Quaternion
---@param duration number
---@return NotExportType
function UnityEngine_Transform:DOLocalRotateQuaternion(endValue, duration) end
---@param endValue UnityEngine.Vector3
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOScale(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOScale(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOScaleX(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOScaleY(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_Transform:DOScaleZ(endValue, duration) end
---@param towards UnityEngine.Vector3
---@param duration number
---@param axisConstraint NotExportEnum
---@param up NotExportType
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOLookAt(towards, duration, axisConstraint, up) end
---@param towards UnityEngine.Vector3
---@param duration number
---@param axisConstraint NotExportEnum
---@param up NotExportType
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DODynamicLookAt(towards, duration, axisConstraint, up) end
---@param punch UnityEngine.Vector3
---@param duration number
---@param vibrato number
---@param elasticity number
---@param snapping boolean
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOPunchPosition(punch, duration, vibrato, elasticity, snapping) end
---@param punch UnityEngine.Vector3
---@param duration number
---@param vibrato number
---@param elasticity number
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOPunchScale(punch, duration, vibrato, elasticity) end
---@param punch UnityEngine.Vector3
---@param duration number
---@param vibrato number
---@param elasticity number
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOPunchRotation(punch, duration, vibrato, elasticity) end
---@param duration number
---@param strength number
---@param vibrato number
---@param randomness number
---@param snapping boolean
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOShakePosition(duration, strength, vibrato, randomness, snapping, fadeOut, randomnessMode) end
---@param duration number
---@param strength UnityEngine.Vector3
---@param vibrato number
---@param randomness number
---@param snapping boolean
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOShakePosition(duration, strength, vibrato, randomness, snapping, fadeOut, randomnessMode) end
---@param duration number
---@param strength number
---@param vibrato number
---@param randomness number
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOShakeRotation(duration, strength, vibrato, randomness, fadeOut, randomnessMode) end
---@param duration number
---@param strength UnityEngine.Vector3
---@param vibrato number
---@param randomness number
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOShakeRotation(duration, strength, vibrato, randomness, fadeOut, randomnessMode) end
---@param duration number
---@param strength number
---@param vibrato number
---@param randomness number
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOShakeScale(duration, strength, vibrato, randomness, fadeOut, randomnessMode) end
---@param duration number
---@param strength UnityEngine.Vector3
---@param vibrato number
---@param randomness number
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOShakeScale(duration, strength, vibrato, randomness, fadeOut, randomnessMode) end
---@param endValue UnityEngine.Vector3
---@param jumpPower number
---@param numJumps number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Sequence
function UnityEngine_Transform:DOJump(endValue, jumpPower, numJumps, duration, snapping) end
---@param endValue UnityEngine.Vector3
---@param jumpPower number
---@param numJumps number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Sequence
function UnityEngine_Transform:DOLocalJump(endValue, jumpPower, numJumps, duration, snapping) end
---@param path NotExportType
---@param duration number
---@param pathType DG.Tweening.PathType
---@param pathMode DG.Tweening.PathMode
---@param resolution number
---@param gizmoColor NotExportType
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function UnityEngine_Transform:DOPath(path, duration, pathType, pathMode, resolution, gizmoColor) end
---@param path NotExportType
---@param duration number
---@param pathType DG.Tweening.PathType
---@param pathMode DG.Tweening.PathMode
---@param resolution number
---@param gizmoColor NotExportType
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function UnityEngine_Transform:DOLocalPath(path, duration, pathType, pathMode, resolution, gizmoColor) end
---@param path NotExportType
---@param duration number
---@param pathMode DG.Tweening.PathMode
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function UnityEngine_Transform:DOPath(path, duration, pathMode) end
---@param path NotExportType
---@param duration number
---@param pathMode DG.Tweening.PathMode
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_NotExportType_DG_Tweening_Plugins_Options_PathOptions
function UnityEngine_Transform:DOLocalPath(path, duration, pathMode) end
---@param byValue UnityEngine.Vector3
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOBlendableMoveBy(byValue, duration, snapping) end
---@param byValue UnityEngine.Vector3
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOBlendableLocalMoveBy(byValue, duration, snapping) end
---@param byValue UnityEngine.Vector3
---@param duration number
---@param mode DG.Tweening.RotateMode
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOBlendableRotateBy(byValue, duration, mode) end
---@param byValue UnityEngine.Vector3
---@param duration number
---@param mode DG.Tweening.RotateMode
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOBlendableLocalRotateBy(byValue, duration, mode) end
---@param punch UnityEngine.Vector3
---@param duration number
---@param vibrato number
---@param elasticity number
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOBlendablePunchRotation(punch, duration, vibrato, elasticity) end
---@param byValue UnityEngine.Vector3
---@param duration number
---@return DG.Tweening.Tweener
function UnityEngine_Transform:DOBlendableScaleBy(byValue, duration) end

---@class UnityEngine.Light : UnityEngine.Behaviour
---@field type UnityEngine.LightType
---@field shape NotExportEnum
---@field spotAngle number
---@field innerSpotAngle number
---@field color UnityEngine.Color
---@field colorTemperature number
---@field useColorTemperature boolean
---@field intensity number
---@field bounceIntensity number
---@field useBoundingSphereOverride boolean
---@field boundingSphereOverride NotExportType
---@field useViewFrustumForShadowCasterCull boolean
---@field shadowCustomResolution number
---@field shadowBias number
---@field shadowNormalBias number
---@field shadowNearPlane number
---@field useShadowMatrixOverride boolean
---@field shadowMatrixOverride NotExportType
---@field range number
---@field flare NotExportType
---@field bakingOutput NotExportType
---@field cullingMask number
---@field renderingLayerMask number
---@field lightShadowCasterMode NotExportEnum
---@field shadows NotExportEnum
---@field shadowStrength number
---@field shadowResolution NotExportEnum
---@field layerShadowCullDistances NotExportType
---@field cookieSize number
---@field cookie UnityEngine.Texture
---@field renderMode NotExportEnum
---@field commandBufferCount number
local UnityEngine_Light = {}
---@return UnityEngine.Light
function UnityEngine_Light.New() end
function UnityEngine_Light:Reset() end
---@overload fun(evt : NotExportEnum, buffer : NotExportType)
---@param evt NotExportEnum
---@param buffer NotExportType
---@param shadowPassMask NotExportEnum
function UnityEngine_Light:AddCommandBuffer(evt, buffer, shadowPassMask) end
---@overload fun(evt : NotExportEnum, buffer : NotExportType, queueType : NotExportEnum)
---@param evt NotExportEnum
---@param buffer NotExportType
---@param shadowPassMask NotExportEnum
---@param queueType NotExportEnum
function UnityEngine_Light:AddCommandBufferAsync(evt, buffer, shadowPassMask, queueType) end
---@param evt NotExportEnum
---@param buffer NotExportType
function UnityEngine_Light:RemoveCommandBuffer(evt, buffer) end
---@param evt NotExportEnum
function UnityEngine_Light:RemoveCommandBuffers(evt) end
function UnityEngine_Light:RemoveAllCommandBuffers() end
---@param evt NotExportEnum
---@return NotExportType
function UnityEngine_Light:GetCommandBuffers(evt) end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_Light:DOColor(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_Light:DOIntensity(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_Light:DOShadowStrength(endValue, duration) end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Tweener
function UnityEngine_Light:DOBlendableColor(endValue, duration) end

---@class UnityEngine.Behaviour : UnityEngine.Component
---@field enabled boolean
---@field isActiveAndEnabled boolean
local UnityEngine_Behaviour = {}
---@return UnityEngine.Behaviour
function UnityEngine_Behaviour.New() end

---@class UnityEngine.Material : UnityEngine.Object
---@field shader UnityEngine.Shader
---@field color UnityEngine.Color
---@field mainTexture UnityEngine.Texture
---@field mainTextureOffset UnityEngine.Vector2
---@field mainTextureScale UnityEngine.Vector2
---@field renderQueue number
---@field enabledKeywords NotExportType
---@field globalIlluminationFlags NotExportEnum
---@field doubleSidedGI boolean
---@field enableInstancing boolean
---@field passCount number
---@field shaderKeywords NotExportType
local UnityEngine_Material = {}
---@overload fun(shader : UnityEngine.Shader) : UnityEngine.Material
---@overload fun(source : UnityEngine.Material) : UnityEngine.Material
---@param contents string
---@return UnityEngine.Material
function UnityEngine_Material.New(contents) end
---@overload fun(nameID : number) : boolean
---@param name string
---@return boolean
function UnityEngine_Material:HasProperty(name) end
---@overload fun(name : string) : boolean
---@param nameID number
---@return boolean
function UnityEngine_Material:HasFloat(nameID) end
---@overload fun(name : string) : boolean
---@param nameID number
---@return boolean
function UnityEngine_Material:HasInt(nameID) end
---@overload fun(name : string) : boolean
---@param nameID number
---@return boolean
function UnityEngine_Material:HasInteger(nameID) end
---@overload fun(name : string) : boolean
---@param nameID number
---@return boolean
function UnityEngine_Material:HasTexture(nameID) end
---@overload fun(name : string) : boolean
---@param nameID number
---@return boolean
function UnityEngine_Material:HasMatrix(nameID) end
---@overload fun(name : string) : boolean
---@param nameID number
---@return boolean
function UnityEngine_Material:HasVector(nameID) end
---@overload fun(name : string) : boolean
---@param nameID number
---@return boolean
function UnityEngine_Material:HasColor(nameID) end
---@overload fun(name : string) : boolean
---@param nameID number
---@return boolean
function UnityEngine_Material:HasBuffer(nameID) end
---@overload fun(name : string) : boolean
---@param nameID number
---@return boolean
function UnityEngine_Material:HasConstantBuffer(nameID) end
---@overload fun(keyword : string)
---@param ref_keyword NotExportType
---@return ,NotExportType
function UnityEngine_Material:EnableKeyword(ref_keyword) end
---@overload fun(keyword : string)
---@param ref_keyword NotExportType
---@return ,NotExportType
function UnityEngine_Material:DisableKeyword(ref_keyword) end
---@overload fun(keyword : string) : boolean
---@param ref_keyword NotExportType
---@return boolean,NotExportType
function UnityEngine_Material:IsKeywordEnabled(ref_keyword) end
---@param ref_keyword NotExportType
---@param value boolean
---@return ,NotExportType
function UnityEngine_Material:SetKeyword(ref_keyword, value) end
---@param passName string
---@param enabled boolean
function UnityEngine_Material:SetShaderPassEnabled(passName, enabled) end
---@param passName string
---@return boolean
function UnityEngine_Material:GetShaderPassEnabled(passName) end
---@param pass number
---@return string
function UnityEngine_Material:GetPassName(pass) end
---@param passName string
---@return number
function UnityEngine_Material:FindPass(passName) end
---@param tag string
---@param val string
function UnityEngine_Material:SetOverrideTag(tag, val) end
---@overload fun(tag : string, searchFallbacks : boolean, defaultValue : string) : string
---@param tag string
---@param searchFallbacks boolean
---@return string
function UnityEngine_Material:GetTag(tag, searchFallbacks) end
---@param start UnityEngine.Material
---@param _end UnityEngine.Material
---@param t number
function UnityEngine_Material:Lerp(start, _end, t) end
---@param pass number
---@return boolean
function UnityEngine_Material:SetPass(pass) end
---@param mat UnityEngine.Material
function UnityEngine_Material:CopyPropertiesFromMaterial(mat) end
---@param mat UnityEngine.Material
function UnityEngine_Material:CopyMatchingPropertiesFromMaterial(mat) end
---@return number
function UnityEngine_Material:ComputeCRC() end
---@overload fun() : NotExportType
---@param outNames NotExportType
function UnityEngine_Material:GetTexturePropertyNames(outNames) end
---@overload fun() : NotExportType
---@param outNames NotExportType
function UnityEngine_Material:GetTexturePropertyNameIDs(outNames) end
---@overload fun(name : string, value : number)
---@param nameID number
---@param value number
function UnityEngine_Material:SetInt(nameID, value) end
---@overload fun(name : string, value : number)
---@param nameID number
---@param value number
function UnityEngine_Material:SetFloat(nameID, value) end
---@overload fun(name : string, value : number)
---@param nameID number
---@param value number
function UnityEngine_Material:SetInteger(nameID, value) end
---@overload fun(name : string, value : UnityEngine.Color)
---@param nameID number
---@param value UnityEngine.Color
function UnityEngine_Material:SetColor(nameID, value) end
---@overload fun(name : string, value : NotExportType)
---@param nameID number
---@param value NotExportType
function UnityEngine_Material:SetVector(nameID, value) end
---@overload fun(name : string, value : NotExportType)
---@param nameID number
---@param value NotExportType
function UnityEngine_Material:SetMatrix(nameID, value) end
---@overload fun(name : string, value : UnityEngine.Texture)
---@overload fun(nameID : number, value : UnityEngine.Texture)
---@overload fun(name : string, value : NotExportType, element : NotExportEnum)
---@param nameID number
---@param value NotExportType
---@param element NotExportEnum
function UnityEngine_Material:SetTexture(nameID, value, element) end
---@overload fun(name : string, value : NotExportType)
---@overload fun(nameID : number, value : NotExportType)
---@overload fun(name : string, value : NotExportType)
---@param nameID number
---@param value NotExportType
function UnityEngine_Material:SetBuffer(nameID, value) end
---@overload fun(name : string, value : NotExportType, offset : number, size : number)
---@overload fun(nameID : number, value : NotExportType, offset : number, size : number)
---@overload fun(name : string, value : NotExportType, offset : number, size : number)
---@param nameID number
---@param value NotExportType
---@param offset number
---@param size number
function UnityEngine_Material:SetConstantBuffer(nameID, value, offset, size) end
---@overload fun(name : string, values : NotExportType)
---@overload fun(nameID : number, values : NotExportType)
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Material:SetFloatArray(nameID, values) end
---@overload fun(name : string, values : NotExportType)
---@overload fun(nameID : number, values : NotExportType)
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Material:SetColorArray(nameID, values) end
---@overload fun(name : string, values : NotExportType)
---@overload fun(nameID : number, values : NotExportType)
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Material:SetVectorArray(nameID, values) end
---@overload fun(name : string, values : NotExportType)
---@overload fun(nameID : number, values : NotExportType)
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Material:SetMatrixArray(nameID, values) end
---@overload fun(name : string) : number
---@param nameID number
---@return number
function UnityEngine_Material:GetInt(nameID) end
---@overload fun(name : string) : number
---@param nameID number
---@return number
function UnityEngine_Material:GetFloat(nameID) end
---@overload fun(name : string) : number
---@param nameID number
---@return number
function UnityEngine_Material:GetInteger(nameID) end
---@overload fun(name : string) : UnityEngine.Color
---@param nameID number
---@return UnityEngine.Color
function UnityEngine_Material:GetColor(nameID) end
---@overload fun(name : string) : NotExportType
---@param nameID number
---@return NotExportType
function UnityEngine_Material:GetVector(nameID) end
---@overload fun(name : string) : NotExportType
---@param nameID number
---@return NotExportType
function UnityEngine_Material:GetMatrix(nameID) end
---@overload fun(name : string) : UnityEngine.Texture
---@param nameID number
---@return UnityEngine.Texture
function UnityEngine_Material:GetTexture(nameID) end
---@param name string
---@return NotExportType
function UnityEngine_Material:GetBuffer(name) end
---@param name string
---@return NotExportType
function UnityEngine_Material:GetConstantBuffer(name) end
---@overload fun(name : string) : NotExportType
---@overload fun(nameID : number) : NotExportType
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Material:GetFloatArray(nameID, values) end
---@overload fun(name : string) : NotExportType
---@overload fun(nameID : number) : NotExportType
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Material:GetColorArray(nameID, values) end
---@overload fun(name : string) : NotExportType
---@overload fun(nameID : number) : NotExportType
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Material:GetVectorArray(nameID, values) end
---@overload fun(name : string) : NotExportType
---@overload fun(nameID : number) : NotExportType
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Material:GetMatrixArray(nameID, values) end
---@overload fun(name : string, value : UnityEngine.Vector2)
---@param nameID number
---@param value UnityEngine.Vector2
function UnityEngine_Material:SetTextureOffset(nameID, value) end
---@overload fun(name : string, value : UnityEngine.Vector2)
---@param nameID number
---@param value UnityEngine.Vector2
function UnityEngine_Material:SetTextureScale(nameID, value) end
---@overload fun(name : string) : UnityEngine.Vector2
---@param nameID number
---@return UnityEngine.Vector2
function UnityEngine_Material:GetTextureOffset(nameID) end
---@overload fun(name : string) : UnityEngine.Vector2
---@param nameID number
---@return UnityEngine.Vector2
function UnityEngine_Material:GetTextureScale(nameID) end
---@param type NotExportEnum
---@return NotExportType
function UnityEngine_Material:GetPropertyNames(type) end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_Material:DOColor(endValue, duration) end
---@param endValue UnityEngine.Color
---@param property string
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_Material:DOColor(endValue, property, duration) end
---@param endValue UnityEngine.Color
---@param propertyID number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_Material:DOColor(endValue, propertyID, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_Material:DOFade(endValue, duration) end
---@param endValue number
---@param property string
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_Material:DOFade(endValue, property, duration) end
---@param endValue number
---@param propertyID number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_Material:DOFade(endValue, propertyID, duration) end
---@param endValue number
---@param property string
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_Material:DOFloat(endValue, property, duration) end
---@param endValue number
---@param propertyID number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_Material:DOFloat(endValue, propertyID, duration) end
---@param endValue UnityEngine.Vector2
---@param duration number
---@return NotExportType
function UnityEngine_Material:DOOffset(endValue, duration) end
---@param endValue UnityEngine.Vector2
---@param property string
---@param duration number
---@return NotExportType
function UnityEngine_Material:DOOffset(endValue, property, duration) end
---@param endValue UnityEngine.Vector2
---@param duration number
---@return NotExportType
function UnityEngine_Material:DOTiling(endValue, duration) end
---@param endValue UnityEngine.Vector2
---@param property string
---@param duration number
---@return NotExportType
function UnityEngine_Material:DOTiling(endValue, property, duration) end
---@param endValue NotExportType
---@param property string
---@param duration number
---@return NotExportType
function UnityEngine_Material:DOVector(endValue, property, duration) end
---@param endValue NotExportType
---@param propertyID number
---@param duration number
---@return NotExportType
function UnityEngine_Material:DOVector(endValue, propertyID, duration) end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Tweener
function UnityEngine_Material:DOBlendableColor(endValue, duration) end
---@param endValue UnityEngine.Color
---@param property string
---@param duration number
---@return DG.Tweening.Tweener
function UnityEngine_Material:DOBlendableColor(endValue, property, duration) end
---@param endValue UnityEngine.Color
---@param propertyID number
---@param duration number
---@return DG.Tweening.Tweener
function UnityEngine_Material:DOBlendableColor(endValue, propertyID, duration) end
---@param withCallbacks boolean
---@return number
function UnityEngine_Material:DOComplete(withCallbacks) end
---@param complete boolean
---@return number
function UnityEngine_Material:DOKill(complete) end
---@return number
function UnityEngine_Material:DOFlip() end
---@param to number
---@param andPlay boolean
---@return number
function UnityEngine_Material:DOGoto(to, andPlay) end
---@return number
function UnityEngine_Material:DOPause() end
---@return number
function UnityEngine_Material:DOPlay() end
---@return number
function UnityEngine_Material:DOPlayBackwards() end
---@return number
function UnityEngine_Material:DOPlayForward() end
---@param includeDelay boolean
---@return number
function UnityEngine_Material:DORestart(includeDelay) end
---@param includeDelay boolean
---@return number
function UnityEngine_Material:DORewind(includeDelay) end
---@return number
function UnityEngine_Material:DOSmoothRewind() end
---@return number
function UnityEngine_Material:DOTogglePause() end

---@class UnityEngine.Rigidbody : UnityEngine.Component
---@field velocity UnityEngine.Vector3
---@field angularVelocity UnityEngine.Vector3
---@field drag number
---@field angularDrag number
---@field mass number
---@field useGravity boolean
---@field maxDepenetrationVelocity number
---@field isKinematic boolean
---@field freezeRotation boolean
---@field constraints NotExportEnum
---@field collisionDetectionMode NotExportEnum
---@field automaticCenterOfMass boolean
---@field centerOfMass UnityEngine.Vector3
---@field worldCenterOfMass UnityEngine.Vector3
---@field automaticInertiaTensor boolean
---@field inertiaTensorRotation UnityEngine.Quaternion
---@field inertiaTensor UnityEngine.Vector3
---@field detectCollisions boolean
---@field position UnityEngine.Vector3
---@field rotation UnityEngine.Quaternion
---@field interpolation NotExportEnum
---@field solverIterations number
---@field sleepThreshold number
---@field maxAngularVelocity number
---@field maxLinearVelocity number
---@field solverVelocityIterations number
---@field excludeLayers UnityEngine.LayerMask
---@field includeLayers UnityEngine.LayerMask
local UnityEngine_Rigidbody = {}
---@return UnityEngine.Rigidbody
function UnityEngine_Rigidbody.New() end
---@param density number
function UnityEngine_Rigidbody:SetDensity(density) end
---@param position UnityEngine.Vector3
function UnityEngine_Rigidbody:MovePosition(position) end
---@param rot UnityEngine.Quaternion
function UnityEngine_Rigidbody:MoveRotation(rot) end
---@param position UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
function UnityEngine_Rigidbody:Move(position, rotation) end
function UnityEngine_Rigidbody:Sleep() end
---@return boolean
function UnityEngine_Rigidbody:IsSleeping() end
function UnityEngine_Rigidbody:WakeUp() end
function UnityEngine_Rigidbody:ResetCenterOfMass() end
function UnityEngine_Rigidbody:ResetInertiaTensor() end
---@param relativePoint UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Rigidbody:GetRelativePointVelocity(relativePoint) end
---@param worldPoint UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Rigidbody:GetPointVelocity(worldPoint) end
---@overload fun(step : number) : UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Rigidbody:GetAccumulatedForce() end
---@overload fun(step : number) : UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Rigidbody:GetAccumulatedTorque() end
---@overload fun(force : UnityEngine.Vector3, mode : NotExportEnum)
---@overload fun(force : UnityEngine.Vector3)
---@overload fun(x : number, y : number, z : number, mode : NotExportEnum)
---@param x number
---@param y number
---@param z number
function UnityEngine_Rigidbody:AddForce(x, y, z) end
---@overload fun(force : UnityEngine.Vector3, mode : NotExportEnum)
---@overload fun(force : UnityEngine.Vector3)
---@overload fun(x : number, y : number, z : number, mode : NotExportEnum)
---@param x number
---@param y number
---@param z number
function UnityEngine_Rigidbody:AddRelativeForce(x, y, z) end
---@overload fun(torque : UnityEngine.Vector3, mode : NotExportEnum)
---@overload fun(torque : UnityEngine.Vector3)
---@overload fun(x : number, y : number, z : number, mode : NotExportEnum)
---@param x number
---@param y number
---@param z number
function UnityEngine_Rigidbody:AddTorque(x, y, z) end
---@overload fun(torque : UnityEngine.Vector3, mode : NotExportEnum)
---@overload fun(torque : UnityEngine.Vector3)
---@overload fun(x : number, y : number, z : number, mode : NotExportEnum)
---@param x number
---@param y number
---@param z number
function UnityEngine_Rigidbody:AddRelativeTorque(x, y, z) end
---@overload fun(force : UnityEngine.Vector3, position : UnityEngine.Vector3, mode : NotExportEnum)
---@param force UnityEngine.Vector3
---@param position UnityEngine.Vector3
function UnityEngine_Rigidbody:AddForceAtPosition(force, position) end
---@overload fun(explosionForce : number, explosionPosition : UnityEngine.Vector3, explosionRadius : number, upwardsModifier : number, mode : NotExportEnum)
---@overload fun(explosionForce : number, explosionPosition : UnityEngine.Vector3, explosionRadius : number, upwardsModifier : number)
---@param explosionForce number
---@param explosionPosition UnityEngine.Vector3
---@param explosionRadius number
function UnityEngine_Rigidbody:AddExplosionForce(explosionForce, explosionPosition, explosionRadius) end
---@param position UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Rigidbody:ClosestPointOnBounds(position) end
---@overload fun(direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number, queryTriggerInteraction : NotExportEnum) : boolean, UnityEngine.RaycastHit
---@overload fun(direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number) : boolean, UnityEngine.RaycastHit
---@param direction UnityEngine.Vector3
---@param out_hitInfo UnityEngine.RaycastHit
---@return boolean,UnityEngine.RaycastHit
function UnityEngine_Rigidbody:SweepTest(direction, out_hitInfo) end
---@overload fun(direction : UnityEngine.Vector3, maxDistance : number, queryTriggerInteraction : NotExportEnum) : NotExportType
---@overload fun(direction : UnityEngine.Vector3, maxDistance : number) : NotExportType
---@param direction UnityEngine.Vector3
---@return NotExportType
function UnityEngine_Rigidbody:SweepTestAll(direction) end

---@class UnityEngine.Camera : UnityEngine.Behaviour
---@field kMinAperture number
---@field kMaxAperture number
---@field kMinBladeCount number
---@field kMaxBladeCount number
---@field onPreCull NotExportType
---@field onPreRender NotExportType
---@field onPostRender NotExportType
---@field main UnityEngine.Camera
---@field current UnityEngine.Camera
---@field allCamerasCount number
---@field allCameras NotExportType
---@field nearClipPlane number
---@field farClipPlane number
---@field fieldOfView number
---@field renderingPath NotExportEnum
---@field actualRenderingPath NotExportEnum
---@field allowHDR boolean
---@field allowMSAA boolean
---@field allowDynamicResolution boolean
---@field forceIntoRenderTexture boolean
---@field orthographicSize number
---@field orthographic boolean
---@field opaqueSortMode NotExportEnum
---@field transparencySortMode NotExportEnum
---@field transparencySortAxis UnityEngine.Vector3
---@field depth number
---@field aspect number
---@field velocity UnityEngine.Vector3
---@field cullingMask number
---@field eventMask number
---@field layerCullSpherical boolean
---@field cameraType NotExportEnum
---@field overrideSceneCullingMask number
---@field layerCullDistances NotExportType
---@field useOcclusionCulling boolean
---@field cullingMatrix NotExportType
---@field backgroundColor UnityEngine.Color
---@field clearFlags UnityEngine.CameraClearFlags
---@field depthTextureMode NotExportEnum
---@field clearStencilAfterLightingPass boolean
---@field usePhysicalProperties boolean
---@field iso number
---@field shutterSpeed number
---@field aperture number
---@field focusDistance number
---@field focalLength number
---@field bladeCount number
---@field curvature UnityEngine.Vector2
---@field barrelClipping number
---@field anamorphism number
---@field sensorSize UnityEngine.Vector2
---@field lensShift UnityEngine.Vector2
---@field gateFit NotExportEnum
---@field rect UnityEngine.Rect
---@field pixelRect UnityEngine.Rect
---@field pixelWidth number
---@field pixelHeight number
---@field scaledPixelWidth number
---@field scaledPixelHeight number
---@field targetTexture NotExportType
---@field activeTexture NotExportType
---@field targetDisplay number
---@field cameraToWorldMatrix NotExportType
---@field worldToCameraMatrix NotExportType
---@field projectionMatrix NotExportType
---@field nonJitteredProjectionMatrix NotExportType
---@field useJitteredProjectionMatrixForTransparentRendering boolean
---@field previousViewProjectionMatrix NotExportType
---@field scene UnityEngine.SceneManagement.Scene
---@field stereoEnabled boolean
---@field stereoSeparation number
---@field stereoConvergence number
---@field areVRStereoViewMatricesWithinSingleCullTolerance boolean
---@field stereoTargetEye NotExportEnum
---@field stereoActiveEye NotExportEnum
---@field sceneViewFilterMode NotExportEnum
---@field commandBufferCount number
local UnityEngine_Camera = {}
---@return UnityEngine.Camera
function UnityEngine_Camera.New() end
---@param out_output NotExportType
---@param focalLength number
---@param sensorSize UnityEngine.Vector2
---@param lensShift UnityEngine.Vector2
---@param nearClip number
---@param farClip number
---@param gateFitParameters NotExportType
---@return ,NotExportType
function UnityEngine_Camera.CalculateProjectionMatrixFromPhysicalProperties(out_output, focalLength, sensorSize, lensShift, nearClip, farClip, gateFitParameters) end
---@param focalLength number
---@param sensorSize number
---@return number
function UnityEngine_Camera.FocalLengthToFieldOfView(focalLength, sensorSize) end
---@param fieldOfView number
---@param sensorSize number
---@return number
function UnityEngine_Camera.FieldOfViewToFocalLength(fieldOfView, sensorSize) end
---@param horizontalFieldOfView number
---@param aspectRatio number
---@return number
function UnityEngine_Camera.HorizontalToVerticalFieldOfView(horizontalFieldOfView, aspectRatio) end
---@param verticalFieldOfView number
---@param aspectRatio number
---@return number
function UnityEngine_Camera.VerticalToHorizontalFieldOfView(verticalFieldOfView, aspectRatio) end
---@param cameras NotExportType
---@return number
function UnityEngine_Camera.GetAllCameras(cameras) end
---@param cur UnityEngine.Camera
function UnityEngine_Camera.SetupCurrent(cur) end
function UnityEngine_Camera:Reset() end
function UnityEngine_Camera:ResetTransparencySortSettings() end
function UnityEngine_Camera:ResetAspect() end
function UnityEngine_Camera:ResetCullingMatrix() end
---@param shader UnityEngine.Shader
---@param replacementTag string
function UnityEngine_Camera:SetReplacementShader(shader, replacementTag) end
function UnityEngine_Camera:ResetReplacementShader() end
---@return number
function UnityEngine_Camera:GetGateFittedFieldOfView() end
---@return UnityEngine.Vector2
function UnityEngine_Camera:GetGateFittedLensShift() end
---@overload fun(colorBuffer : NotExportType, depthBuffer : NotExportType)
---@param colorBuffer NotExportType
---@param depthBuffer NotExportType
function UnityEngine_Camera:SetTargetBuffers(colorBuffer, depthBuffer) end
function UnityEngine_Camera:ResetWorldToCameraMatrix() end
function UnityEngine_Camera:ResetProjectionMatrix() end
---@param clipPlane NotExportType
---@return NotExportType
function UnityEngine_Camera:CalculateObliqueMatrix(clipPlane) end
---@overload fun(position : UnityEngine.Vector3, eye : NotExportEnum) : UnityEngine.Vector3
---@param position UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Camera:WorldToScreenPoint(position) end
---@overload fun(position : UnityEngine.Vector3, eye : NotExportEnum) : UnityEngine.Vector3
---@param position UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Camera:WorldToViewportPoint(position) end
---@overload fun(position : UnityEngine.Vector3, eye : NotExportEnum) : UnityEngine.Vector3
---@param position UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Camera:ViewportToWorldPoint(position) end
---@overload fun(position : UnityEngine.Vector3, eye : NotExportEnum) : UnityEngine.Vector3
---@param position UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Camera:ScreenToWorldPoint(position) end
---@param position UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Camera:ScreenToViewportPoint(position) end
---@param position UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Camera:ViewportToScreenPoint(position) end
---@overload fun(pos : UnityEngine.Vector3, eye : NotExportEnum) : UnityEngine.Ray
---@param pos UnityEngine.Vector3
---@return UnityEngine.Ray
function UnityEngine_Camera:ViewportPointToRay(pos) end
---@overload fun(pos : UnityEngine.Vector3, eye : NotExportEnum) : UnityEngine.Ray
---@param pos UnityEngine.Vector3
---@return UnityEngine.Ray
function UnityEngine_Camera:ScreenPointToRay(pos) end
---@param viewport UnityEngine.Rect
---@param z number
---@param eye NotExportEnum
---@param outCorners NotExportType
function UnityEngine_Camera:CalculateFrustumCorners(viewport, z, eye, outCorners) end
---@param eye NotExportEnum
---@return NotExportType
function UnityEngine_Camera:GetStereoNonJitteredProjectionMatrix(eye) end
---@param eye NotExportEnum
---@return NotExportType
function UnityEngine_Camera:GetStereoViewMatrix(eye) end
---@param eye NotExportEnum
function UnityEngine_Camera:CopyStereoDeviceProjectionMatrixToNonJittered(eye) end
---@param eye NotExportEnum
---@return NotExportType
function UnityEngine_Camera:GetStereoProjectionMatrix(eye) end
---@param eye NotExportEnum
---@param matrix NotExportType
function UnityEngine_Camera:SetStereoProjectionMatrix(eye, matrix) end
function UnityEngine_Camera:ResetStereoProjectionMatrices() end
---@param eye NotExportEnum
---@param matrix NotExportType
function UnityEngine_Camera:SetStereoViewMatrix(eye, matrix) end
function UnityEngine_Camera:ResetStereoViewMatrices() end
---@overload fun(cubemap : NotExportType, faceMask : number) : boolean
---@overload fun(cubemap : NotExportType) : boolean
---@overload fun(cubemap : NotExportType, faceMask : number) : boolean
---@overload fun(cubemap : NotExportType) : boolean
---@param cubemap NotExportType
---@param faceMask number
---@param stereoEye NotExportEnum
---@return boolean
function UnityEngine_Camera:RenderToCubemap(cubemap, faceMask, stereoEye) end
function UnityEngine_Camera:Render() end
---@param shader UnityEngine.Shader
---@param replacementTag string
function UnityEngine_Camera:RenderWithShader(shader, replacementTag) end
function UnityEngine_Camera:RenderDontRestore() end
---@param other UnityEngine.Camera
function UnityEngine_Camera:CopyFrom(other) end
---@param evt NotExportEnum
function UnityEngine_Camera:RemoveCommandBuffers(evt) end
function UnityEngine_Camera:RemoveAllCommandBuffers() end
---@param evt NotExportEnum
---@param buffer NotExportType
function UnityEngine_Camera:AddCommandBuffer(evt, buffer) end
---@param evt NotExportEnum
---@param buffer NotExportType
---@param queueType NotExportEnum
function UnityEngine_Camera:AddCommandBufferAsync(evt, buffer, queueType) end
---@param evt NotExportEnum
---@param buffer NotExportType
function UnityEngine_Camera:RemoveCommandBuffer(evt, buffer) end
---@param evt NotExportEnum
---@return NotExportType
function UnityEngine_Camera:GetCommandBuffers(evt) end
---@overload fun(out_cullingParameters : NotExportType) : boolean, NotExportType
---@param stereoAware boolean
---@param out_cullingParameters NotExportType
---@return boolean,NotExportType
function UnityEngine_Camera:TryGetCullingParameters(stereoAware, out_cullingParameters) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_Camera:DOAspect(endValue, duration) end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_Camera:DOColor(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_Camera:DOFarClipPlane(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_Camera:DOFieldOfView(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_Camera:DONearClipPlane(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_Camera:DOOrthoSize(endValue, duration) end
---@param endValue UnityEngine.Rect
---@param duration number
---@return NotExportType
function UnityEngine_Camera:DOPixelRect(endValue, duration) end
---@param endValue UnityEngine.Rect
---@param duration number
---@return NotExportType
function UnityEngine_Camera:DORect(endValue, duration) end
---@param duration number
---@param strength number
---@param vibrato number
---@param randomness number
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_Camera:DOShakePosition(duration, strength, vibrato, randomness, fadeOut, randomnessMode) end
---@param duration number
---@param strength UnityEngine.Vector3
---@param vibrato number
---@param randomness number
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_Camera:DOShakePosition(duration, strength, vibrato, randomness, fadeOut, randomnessMode) end
---@param duration number
---@param strength number
---@param vibrato number
---@param randomness number
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_Camera:DOShakeRotation(duration, strength, vibrato, randomness, fadeOut, randomnessMode) end
---@param duration number
---@param strength UnityEngine.Vector3
---@param vibrato number
---@param randomness number
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_Camera:DOShakeRotation(duration, strength, vibrato, randomness, fadeOut, randomnessMode) end

---@class UnityEngine.AudioSource : UnityEngine.AudioBehaviour
---@field volume number
---@field pitch number
---@field time number
---@field timeSamples number
---@field clip UnityEngine.AudioClip
---@field outputAudioMixerGroup NotExportType
---@field isPlaying boolean
---@field isVirtual boolean
---@field loop boolean
---@field ignoreListenerVolume boolean
---@field playOnAwake boolean
---@field ignoreListenerPause boolean
---@field velocityUpdateMode NotExportEnum
---@field panStereo number
---@field spatialBlend number
---@field spatialize boolean
---@field spatializePostEffects boolean
---@field reverbZoneMix number
---@field bypassEffects boolean
---@field bypassListenerEffects boolean
---@field bypassReverbZones boolean
---@field dopplerLevel number
---@field spread number
---@field priority number
---@field mute boolean
---@field minDistance number
---@field maxDistance number
---@field rolloffMode NotExportEnum
local UnityEngine_AudioSource = {}
---@return UnityEngine.AudioSource
function UnityEngine_AudioSource.New() end
---@overload fun(clip : UnityEngine.AudioClip, position : UnityEngine.Vector3)
---@param clip UnityEngine.AudioClip
---@param position UnityEngine.Vector3
---@param volume number
function UnityEngine_AudioSource.PlayClipAtPoint(clip, position, volume) end
---@overload fun()
---@param delay number
function UnityEngine_AudioSource:Play(delay) end
---@param delay number
function UnityEngine_AudioSource:PlayDelayed(delay) end
---@param time number
function UnityEngine_AudioSource:PlayScheduled(time) end
---@overload fun(clip : UnityEngine.AudioClip)
---@param clip UnityEngine.AudioClip
---@param volumeScale number
function UnityEngine_AudioSource:PlayOneShot(clip, volumeScale) end
---@param time number
function UnityEngine_AudioSource:SetScheduledStartTime(time) end
---@param time number
function UnityEngine_AudioSource:SetScheduledEndTime(time) end
function UnityEngine_AudioSource:Stop() end
function UnityEngine_AudioSource:Pause() end
function UnityEngine_AudioSource:UnPause() end
---@param type NotExportEnum
---@param curve UnityEngine.AnimationCurve
function UnityEngine_AudioSource:SetCustomCurve(type, curve) end
---@param type NotExportEnum
---@return UnityEngine.AnimationCurve
function UnityEngine_AudioSource:GetCustomCurve(type) end
---@param samples NotExportType
---@param channel number
function UnityEngine_AudioSource:GetOutputData(samples, channel) end
---@param samples NotExportType
---@param channel number
---@param window NotExportEnum
function UnityEngine_AudioSource:GetSpectrumData(samples, channel, window) end
---@param index number
---@param value number
---@return boolean
function UnityEngine_AudioSource:SetSpatializerFloat(index, value) end
---@param index number
---@param out_value number
---@return boolean,number
function UnityEngine_AudioSource:GetSpatializerFloat(index, out_value) end
---@param index number
---@param out_value number
---@return boolean,number
function UnityEngine_AudioSource:GetAmbisonicDecoderFloat(index, out_value) end
---@param index number
---@param value number
---@return boolean
function UnityEngine_AudioSource:SetAmbisonicDecoderFloat(index, value) end

---@class UnityEngine.AudioBehaviour : UnityEngine.Behaviour
local UnityEngine_AudioBehaviour = {}
---@return UnityEngine.AudioBehaviour
function UnityEngine_AudioBehaviour.New() end

---@class UnityEngine.UI.Outline : UnityEngine.UI.Shadow
local UnityEngine_UI_Outline = {}
---@param vh NotExportType
function UnityEngine_UI_Outline:ModifyMesh(vh) end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_UI_Outline:DOColor(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_UI_Outline:DOFade(endValue, duration) end
---@param endValue UnityEngine.Vector2
---@param duration number
---@return NotExportType
function UnityEngine_UI_Outline:DOScale(endValue, duration) end

---@class UnityEngine.UI.Shadow : UnityEngine.UI.BaseMeshEffect
---@field effectColor UnityEngine.Color
---@field effectDistance UnityEngine.Vector2
---@field useGraphicAlpha boolean
local UnityEngine_UI_Shadow = {}
---@param vh NotExportType
function UnityEngine_UI_Shadow:ModifyMesh(vh) end

---@class UnityEngine.UI.BaseMeshEffect : UnityEngine.EventSystems.UIBehaviour
local UnityEngine_UI_BaseMeshEffect = {}
---@overload fun(mesh : NotExportType)
---@param vh NotExportType
function UnityEngine_UI_BaseMeshEffect:ModifyMesh(vh) end

---@class UnityEngine.EventSystems.UIBehaviour : UnityEngine.MonoBehaviour
local UnityEngine_EventSystems_UIBehaviour = {}
---@return boolean
function UnityEngine_EventSystems_UIBehaviour:IsActive() end
---@return boolean
function UnityEngine_EventSystems_UIBehaviour:IsDestroyed() end

---@class UnityEngine.MonoBehaviour : UnityEngine.Behaviour
---@field destroyCancellationToken NotExportType
---@field useGUILayout boolean
local UnityEngine_MonoBehaviour = {}
---@param message System.Object
function UnityEngine_MonoBehaviour.print(message) end
---@overload fun() : boolean
---@param methodName string
---@return boolean
function UnityEngine_MonoBehaviour:IsInvoking(methodName) end
---@overload fun()
---@param methodName string
function UnityEngine_MonoBehaviour:CancelInvoke(methodName) end
---@param methodName string
---@param time number
function UnityEngine_MonoBehaviour:Invoke(methodName, time) end
---@param methodName string
---@param time number
---@param repeatRate number
function UnityEngine_MonoBehaviour:InvokeRepeating(methodName, time, repeatRate) end
---@overload fun(methodName : string) : UnityEngine.Coroutine
---@overload fun(methodName : string, value : System.Object) : UnityEngine.Coroutine
---@param routine System.Collections.IEnumerator
---@return UnityEngine.Coroutine
function UnityEngine_MonoBehaviour:StartCoroutine(routine) end
---@overload fun(routine : System.Collections.IEnumerator)
---@overload fun(routine : UnityEngine.Coroutine)
---@param methodName string
function UnityEngine_MonoBehaviour:StopCoroutine(methodName) end
function UnityEngine_MonoBehaviour:StopAllCoroutines() end

---@class DG.Tweening.DOTweenModuleUI : System.Object
local DG_Tweening_DOTweenModuleUI = {}
---@overload fun(target : UnityEngine.CanvasGroup, endValue : number, duration : number) : DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
---@overload fun(target : UnityEngine.UI.Graphic, endValue : number, duration : number) : DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
---@overload fun(target : UnityEngine.UI.Image, endValue : number, duration : number) : DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
---@overload fun(target : UnityEngine.UI.Outline, endValue : number, duration : number) : DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
---@param target UnityEngine.UI.Text
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function DG_Tweening_DOTweenModuleUI.DOFade(target, endValue, duration) end
---@overload fun(target : UnityEngine.UI.Graphic, endValue : UnityEngine.Color, duration : number) : DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
---@overload fun(target : UnityEngine.UI.Image, endValue : UnityEngine.Color, duration : number) : DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
---@overload fun(target : UnityEngine.UI.Outline, endValue : UnityEngine.Color, duration : number) : DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
---@param target UnityEngine.UI.Text
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function DG_Tweening_DOTweenModuleUI.DOColor(target, endValue, duration) end
---@param target UnityEngine.UI.Image
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function DG_Tweening_DOTweenModuleUI.DOFillAmount(target, endValue, duration) end
---@param target UnityEngine.UI.Image
---@param gradient NotExportType
---@param duration number
---@return DG.Tweening.Sequence
function DG_Tweening_DOTweenModuleUI.DOGradientColor(target, gradient, duration) end
---@param target NotExportType
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOFlexibleSize(target, endValue, duration, snapping) end
---@param target NotExportType
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOMinSize(target, endValue, duration, snapping) end
---@param target NotExportType
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOPreferredSize(target, endValue, duration, snapping) end
---@param target UnityEngine.UI.Outline
---@param endValue UnityEngine.Vector2
---@param duration number
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOScale(target, endValue, duration) end
---@param target UnityEngine.RectTransform
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOAnchorPos(target, endValue, duration, snapping) end
---@param target UnityEngine.RectTransform
---@param endValue number
---@param duration number
---@param snapping boolean
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOAnchorPosX(target, endValue, duration, snapping) end
---@param target UnityEngine.RectTransform
---@param endValue number
---@param duration number
---@param snapping boolean
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOAnchorPosY(target, endValue, duration, snapping) end
---@param target UnityEngine.RectTransform
---@param endValue UnityEngine.Vector3
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function DG_Tweening_DOTweenModuleUI.DOAnchorPos3D(target, endValue, duration, snapping) end
---@param target UnityEngine.RectTransform
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function DG_Tweening_DOTweenModuleUI.DOAnchorPos3DX(target, endValue, duration, snapping) end
---@param target UnityEngine.RectTransform
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function DG_Tweening_DOTweenModuleUI.DOAnchorPos3DY(target, endValue, duration, snapping) end
---@param target UnityEngine.RectTransform
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function DG_Tweening_DOTweenModuleUI.DOAnchorPos3DZ(target, endValue, duration, snapping) end
---@param target UnityEngine.RectTransform
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOAnchorMax(target, endValue, duration, snapping) end
---@param target UnityEngine.RectTransform
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOAnchorMin(target, endValue, duration, snapping) end
---@param target UnityEngine.RectTransform
---@param endValue UnityEngine.Vector2
---@param duration number
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOPivot(target, endValue, duration) end
---@param target UnityEngine.RectTransform
---@param endValue number
---@param duration number
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOPivotX(target, endValue, duration) end
---@param target UnityEngine.RectTransform
---@param endValue number
---@param duration number
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOPivotY(target, endValue, duration) end
---@param target UnityEngine.RectTransform
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOSizeDelta(target, endValue, duration, snapping) end
---@param target UnityEngine.RectTransform
---@param punch UnityEngine.Vector2
---@param duration number
---@param vibrato number
---@param elasticity number
---@param snapping boolean
---@return DG.Tweening.Tweener
function DG_Tweening_DOTweenModuleUI.DOPunchAnchorPos(target, punch, duration, vibrato, elasticity, snapping) end
---@overload fun(target : UnityEngine.RectTransform, duration : number, strength : number, vibrato : number, randomness : number, snapping : boolean, fadeOut : boolean, randomnessMode : NotExportEnum) : DG.Tweening.Tweener
---@param target UnityEngine.RectTransform
---@param duration number
---@param strength UnityEngine.Vector2
---@param vibrato number
---@param randomness number
---@param snapping boolean
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function DG_Tweening_DOTweenModuleUI.DOShakeAnchorPos(target, duration, strength, vibrato, randomness, snapping, fadeOut, randomnessMode) end
---@param target UnityEngine.RectTransform
---@param endValue UnityEngine.Vector2
---@param jumpPower number
---@param numJumps number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Sequence
function DG_Tweening_DOTweenModuleUI.DOJumpAnchorPos(target, endValue, jumpPower, numJumps, duration, snapping) end
---@param target UnityEngine.UI.ScrollRect
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Tweener
function DG_Tweening_DOTweenModuleUI.DONormalizedPos(target, endValue, duration, snapping) end
---@param target UnityEngine.UI.ScrollRect
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Tweener
function DG_Tweening_DOTweenModuleUI.DOHorizontalNormalizedPos(target, endValue, duration, snapping) end
---@param target UnityEngine.UI.ScrollRect
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Tweener
function DG_Tweening_DOTweenModuleUI.DOVerticalNormalizedPos(target, endValue, duration, snapping) end
---@param target UnityEngine.UI.Slider
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function DG_Tweening_DOTweenModuleUI.DOValue(target, endValue, duration, snapping) end
---@param target UnityEngine.UI.Text
---@param fromValue number
---@param endValue number
---@param duration number
---@param addThousandsSeparator boolean
---@param culture NotExportType
---@return DG.Tweening.Core.TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions
function DG_Tweening_DOTweenModuleUI.DOCounter(target, fromValue, endValue, duration, addThousandsSeparator, culture) end
---@param target UnityEngine.UI.Text
---@param endValue string
---@param duration number
---@param richTextEnabled boolean
---@param scrambleMode NotExportEnum
---@param scrambleChars string
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOText(target, endValue, duration, richTextEnabled, scrambleMode, scrambleChars) end
---@overload fun(target : UnityEngine.UI.Graphic, endValue : UnityEngine.Color, duration : number) : DG.Tweening.Tweener
---@overload fun(target : UnityEngine.UI.Image, endValue : UnityEngine.Color, duration : number) : DG.Tweening.Tweener
---@param target UnityEngine.UI.Text
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Tweener
function DG_Tweening_DOTweenModuleUI.DOBlendableColor(target, endValue, duration) end
---@param target UnityEngine.RectTransform
---@param center UnityEngine.Vector2
---@param endValueDegrees number
---@param duration number
---@param relativeCenter boolean
---@param snapping boolean
---@return NotExportType
function DG_Tweening_DOTweenModuleUI.DOShapeCircle(target, center, endValueDegrees, duration, relativeCenter, snapping) end

---@class UnityEngine.UI.InputField : UnityEngine.UI.Selectable
---@field shouldHideMobileInput boolean
---@field shouldActivateOnSelect boolean
---@field text string
---@field isFocused boolean
---@field caretBlinkRate number
---@field caretWidth number
---@field textComponent UnityEngine.UI.Text
---@field placeholder UnityEngine.UI.Graphic
---@field caretColor UnityEngine.Color
---@field customCaretColor boolean
---@field selectionColor UnityEngine.Color
---@field onEndEdit NotExportType
---@field onSubmit UnityEngine.UI.InputField.SubmitEvent
---@field onValueChanged UnityEngine.UI.InputField.OnChangeEvent
---@field onValidateInput NotExportType
---@field characterLimit number
---@field contentType NotExportEnum
---@field lineType NotExportEnum
---@field inputType NotExportEnum
---@field touchScreenKeyboard NotExportType
---@field keyboardType NotExportEnum
---@field characterValidation NotExportEnum
---@field readOnly boolean
---@field multiLine boolean
---@field asteriskChar NotExportType
---@field wasCanceled boolean
---@field caretPosition number
---@field selectionAnchorPosition number
---@field selectionFocusPosition number
---@field minWidth number
---@field preferredWidth number
---@field flexibleWidth number
---@field minHeight number
---@field preferredHeight number
---@field flexibleHeight number
---@field layoutPriority number
local UnityEngine_UI_InputField = {}
---@param input string
function UnityEngine_UI_InputField:SetTextWithoutNotify(input) end
---@param shift boolean
function UnityEngine_UI_InputField:MoveTextEnd(shift) end
---@param shift boolean
function UnityEngine_UI_InputField:MoveTextStart(shift) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_InputField:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_InputField:OnDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_InputField:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_InputField:OnPointerDown(eventData) end
---@param e NotExportType
function UnityEngine_UI_InputField:ProcessEvent(e) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function UnityEngine_UI_InputField:OnUpdateSelected(eventData) end
function UnityEngine_UI_InputField:ForceLabelUpdate() end
---@param update NotExportEnum
function UnityEngine_UI_InputField:Rebuild(update) end
function UnityEngine_UI_InputField:LayoutComplete() end
function UnityEngine_UI_InputField:GraphicUpdateComplete() end
function UnityEngine_UI_InputField:ActivateInputField() end
---@param eventData UnityEngine.EventSystems.BaseEventData
function UnityEngine_UI_InputField:OnSelect(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_InputField:OnPointerClick(eventData) end
function UnityEngine_UI_InputField:DeactivateInputField() end
---@param eventData UnityEngine.EventSystems.BaseEventData
function UnityEngine_UI_InputField:OnDeselect(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function UnityEngine_UI_InputField:OnSubmit(eventData) end
function UnityEngine_UI_InputField:CalculateLayoutInputHorizontal() end
function UnityEngine_UI_InputField:CalculateLayoutInputVertical() end

---@class UnityEngine.UI.Selectable : UnityEngine.EventSystems.UIBehaviour
---@field allSelectablesArray NotExportType
---@field allSelectableCount number
---@field navigation NotExportType
---@field transition NotExportEnum
---@field colors NotExportType
---@field spriteState NotExportType
---@field animationTriggers NotExportType
---@field targetGraphic UnityEngine.UI.Graphic
---@field interactable boolean
---@field image UnityEngine.UI.Image
---@field animator UnityEngine.Animator
local UnityEngine_UI_Selectable = {}
---@param selectables NotExportType
---@return number
function UnityEngine_UI_Selectable.AllSelectablesNoAlloc(selectables) end
---@return boolean
function UnityEngine_UI_Selectable:IsInteractable() end
---@param dir UnityEngine.Vector3
---@return UnityEngine.UI.Selectable
function UnityEngine_UI_Selectable:FindSelectable(dir) end
---@return UnityEngine.UI.Selectable
function UnityEngine_UI_Selectable:FindSelectableOnLeft() end
---@return UnityEngine.UI.Selectable
function UnityEngine_UI_Selectable:FindSelectableOnRight() end
---@return UnityEngine.UI.Selectable
function UnityEngine_UI_Selectable:FindSelectableOnUp() end
---@return UnityEngine.UI.Selectable
function UnityEngine_UI_Selectable:FindSelectableOnDown() end
---@param eventData NotExportType
function UnityEngine_UI_Selectable:OnMove(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_Selectable:OnPointerDown(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_Selectable:OnPointerUp(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_Selectable:OnPointerEnter(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_Selectable:OnPointerExit(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function UnityEngine_UI_Selectable:OnSelect(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function UnityEngine_UI_Selectable:OnDeselect(eventData) end
function UnityEngine_UI_Selectable:Select() end

---@class UnityEngine.WWWForm : System.Object
---@field headers NotExportType
---@field data NotExportType
local UnityEngine_WWWForm = {}
---@return UnityEngine.WWWForm
function UnityEngine_WWWForm.New() end
---@overload fun(fieldName : string, value : string)
---@overload fun(fieldName : string, value : string, e : NotExportType)
---@param fieldName string
---@param i number
function UnityEngine_WWWForm:AddField(fieldName, i) end
---@overload fun(fieldName : string, contents : NotExportType)
---@overload fun(fieldName : string, contents : NotExportType, fileName : string)
---@param fieldName string
---@param contents NotExportType
---@param fileName string
---@param mimeType string
function UnityEngine_WWWForm:AddBinaryData(fieldName, contents, fileName, mimeType) end

---@class UnityEngine.Networking.UnityWebRequest : System.Object
---@field kHttpVerbGET string
---@field kHttpVerbHEAD string
---@field kHttpVerbPOST string
---@field kHttpVerbPUT string
---@field kHttpVerbCREATE string
---@field kHttpVerbDELETE string
---@field disposeCertificateHandlerOnDispose boolean
---@field disposeDownloadHandlerOnDispose boolean
---@field disposeUploadHandlerOnDispose boolean
---@field method string
---@field error string
---@field useHttpContinue boolean
---@field url string
---@field uri NotExportType
---@field responseCode number
---@field uploadProgress number
---@field isModifiable boolean
---@field isDone boolean
---@field result NotExportEnum
---@field downloadProgress number
---@field uploadedBytes number
---@field downloadedBytes number
---@field redirectLimit number
---@field uploadHandler NotExportType
---@field downloadHandler NotExportType
---@field certificateHandler NotExportType
---@field timeout number
local UnityEngine_Networking_UnityWebRequest = {}
---@overload fun() : UnityEngine.Networking.UnityWebRequest
---@overload fun(url : string) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : NotExportType) : UnityEngine.Networking.UnityWebRequest
---@overload fun(url : string, method : string) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : NotExportType, method : string) : UnityEngine.Networking.UnityWebRequest
---@overload fun(url : string, method : string, downloadHandler : NotExportType, uploadHandler : NotExportType) : UnityEngine.Networking.UnityWebRequest
---@param uri NotExportType
---@param method string
---@param downloadHandler NotExportType
---@param uploadHandler NotExportType
---@return UnityEngine.Networking.UnityWebRequest
function UnityEngine_Networking_UnityWebRequest.New(uri, method, downloadHandler, uploadHandler) end
---@overload fun()
---@param uri NotExportType
function UnityEngine_Networking_UnityWebRequest.ClearCookieCache(uri) end
---@overload fun(uri : string) : UnityEngine.Networking.UnityWebRequest
---@param uri NotExportType
---@return UnityEngine.Networking.UnityWebRequest
function UnityEngine_Networking_UnityWebRequest.Get(uri) end
---@overload fun(uri : string) : UnityEngine.Networking.UnityWebRequest
---@param uri NotExportType
---@return UnityEngine.Networking.UnityWebRequest
function UnityEngine_Networking_UnityWebRequest.Delete(uri) end
---@overload fun(uri : string) : UnityEngine.Networking.UnityWebRequest
---@param uri NotExportType
---@return UnityEngine.Networking.UnityWebRequest
function UnityEngine_Networking_UnityWebRequest.Head(uri) end
---@overload fun(uri : string, bodyData : NotExportType) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : NotExportType, bodyData : NotExportType) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : string, bodyData : string) : UnityEngine.Networking.UnityWebRequest
---@param uri NotExportType
---@param bodyData string
---@return UnityEngine.Networking.UnityWebRequest
function UnityEngine_Networking_UnityWebRequest.Put(uri, bodyData) end
---@overload fun(uri : string, form : string) : UnityEngine.Networking.UnityWebRequest
---@param uri NotExportType
---@param form string
---@return UnityEngine.Networking.UnityWebRequest
function UnityEngine_Networking_UnityWebRequest.PostWwwForm(uri, form) end
---@overload fun(uri : string, postData : string, contentType : string) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : NotExportType, postData : string, contentType : string) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : string, formData : UnityEngine.WWWForm) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : NotExportType, formData : UnityEngine.WWWForm) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : string, multipartFormSections : NotExportType) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : NotExportType, multipartFormSections : NotExportType) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : string, multipartFormSections : NotExportType, boundary : NotExportType) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : NotExportType, multipartFormSections : NotExportType, boundary : NotExportType) : UnityEngine.Networking.UnityWebRequest
---@overload fun(uri : string, formFields : NotExportType) : UnityEngine.Networking.UnityWebRequest
---@param uri NotExportType
---@param formFields NotExportType
---@return UnityEngine.Networking.UnityWebRequest
function UnityEngine_Networking_UnityWebRequest.Post(uri, formFields) end
---@overload fun(s : string) : string
---@param s string
---@param e NotExportType
---@return string
function UnityEngine_Networking_UnityWebRequest.EscapeURL(s, e) end
---@overload fun(s : string) : string
---@param s string
---@param e NotExportType
---@return string
function UnityEngine_Networking_UnityWebRequest.UnEscapeURL(s, e) end
---@param multipartFormSections NotExportType
---@param boundary NotExportType
---@return NotExportType
function UnityEngine_Networking_UnityWebRequest.SerializeFormSections(multipartFormSections, boundary) end
---@return NotExportType
function UnityEngine_Networking_UnityWebRequest.GenerateBoundary() end
---@param formFields NotExportType
---@return NotExportType
function UnityEngine_Networking_UnityWebRequest.SerializeSimpleForm(formFields) end
function UnityEngine_Networking_UnityWebRequest:Dispose() end
---@return NotExportType
function UnityEngine_Networking_UnityWebRequest:SendWebRequest() end
function UnityEngine_Networking_UnityWebRequest:Abort() end
---@param name string
---@return string
function UnityEngine_Networking_UnityWebRequest:GetRequestHeader(name) end
---@param name string
---@param value string
function UnityEngine_Networking_UnityWebRequest:SetRequestHeader(name, value) end
---@param name string
---@return string
function UnityEngine_Networking_UnityWebRequest:GetResponseHeader(name) end
---@return NotExportType
function UnityEngine_Networking_UnityWebRequest:GetResponseHeaders() end

---@class UnityEngine.PlayerPrefs : System.Object
local UnityEngine_PlayerPrefs = {}
---@return UnityEngine.PlayerPrefs
function UnityEngine_PlayerPrefs.New() end
---@param key string
---@param value number
function UnityEngine_PlayerPrefs.SetInt(key, value) end
---@overload fun(key : string, defaultValue : number) : number
---@param key string
---@return number
function UnityEngine_PlayerPrefs.GetInt(key) end
---@param key string
---@param value number
function UnityEngine_PlayerPrefs.SetFloat(key, value) end
---@overload fun(key : string, defaultValue : number) : number
---@param key string
---@return number
function UnityEngine_PlayerPrefs.GetFloat(key) end
---@param key string
---@param value string
function UnityEngine_PlayerPrefs.SetString(key, value) end
---@overload fun(key : string, defaultValue : string) : string
---@param key string
---@return string
function UnityEngine_PlayerPrefs.GetString(key) end
---@param key string
---@return boolean
function UnityEngine_PlayerPrefs.HasKey(key) end
---@param key string
function UnityEngine_PlayerPrefs.DeleteKey(key) end
function UnityEngine_PlayerPrefs.DeleteAll() end
function UnityEngine_PlayerPrefs.Save() end

---@class UnityEngine.GameObject : UnityEngine.Object
---@field transform UnityEngine.Transform
---@field layer number
---@field activeSelf boolean
---@field activeInHierarchy boolean
---@field isStatic boolean
---@field tag string
---@field scene UnityEngine.SceneManagement.Scene
---@field sceneCullingMask number
---@field gameObject UnityEngine.GameObject
local UnityEngine_GameObject = {}
---@overload fun(name : string) : UnityEngine.GameObject
---@overload fun() : UnityEngine.GameObject
---@param name string
---@param components NotExportType
---@return UnityEngine.GameObject
function UnityEngine_GameObject.New(name, components) end
---@param type NotExportEnum
---@return UnityEngine.GameObject
function UnityEngine_GameObject.CreatePrimitive(type) end
---@param tag string
---@return UnityEngine.GameObject
function UnityEngine_GameObject.FindWithTag(tag) end
---@param tag string
---@return UnityEngine.GameObject
function UnityEngine_GameObject.FindGameObjectWithTag(tag) end
---@param tag string
---@return NotExportType
function UnityEngine_GameObject.FindGameObjectsWithTag(tag) end
---@param name string
---@return UnityEngine.GameObject
function UnityEngine_GameObject.Find(name) end
---@overload fun(instanceIDs : NotExportType, active : boolean)
---@param instanceIDs NotExportType
---@param active boolean
function UnityEngine_GameObject.SetGameObjectsActive(instanceIDs, active) end
---@param sourceInstanceID number
---@param count number
---@param newInstanceIDs NotExportType
---@param newTransformInstanceIDs NotExportType
---@param destinationScene UnityEngine.SceneManagement.Scene
function UnityEngine_GameObject.InstantiateGameObjects(sourceInstanceID, count, newInstanceIDs, newTransformInstanceIDs, destinationScene) end
---@param instanceID number
---@return UnityEngine.SceneManagement.Scene
function UnityEngine_GameObject.GetScene(instanceID) end
---@overload fun(type : System.Type) : UnityEngine.Component
---@param type string
---@return UnityEngine.Component
function UnityEngine_GameObject:GetComponent(type) end
---@overload fun(type : System.Type, includeInactive : boolean) : UnityEngine.Component
---@param type System.Type
---@return UnityEngine.Component
function UnityEngine_GameObject:GetComponentInChildren(type) end
---@overload fun(type : System.Type, includeInactive : boolean) : UnityEngine.Component
---@param type System.Type
---@return UnityEngine.Component
function UnityEngine_GameObject:GetComponentInParent(type) end
---@overload fun(type : System.Type) : NotExportType
---@param type System.Type
---@param results NotExportType
function UnityEngine_GameObject:GetComponents(type, results) end
---@overload fun(type : System.Type) : NotExportType
---@param type System.Type
---@param includeInactive boolean
---@return NotExportType
function UnityEngine_GameObject:GetComponentsInChildren(type, includeInactive) end
---@overload fun(type : System.Type) : NotExportType
---@param type System.Type
---@param includeInactive boolean
---@return NotExportType
function UnityEngine_GameObject:GetComponentsInParent(type, includeInactive) end
---@param type System.Type
---@param out_component UnityEngine.Component
---@return boolean,UnityEngine.Component
function UnityEngine_GameObject:TryGetComponent(type, out_component) end
---@overload fun(methodName : string, options : NotExportEnum)
---@overload fun(methodName : string, value : System.Object, options : NotExportEnum)
---@overload fun(methodName : string, value : System.Object)
---@param methodName string
function UnityEngine_GameObject:SendMessageUpwards(methodName) end
---@overload fun(methodName : string, options : NotExportEnum)
---@overload fun(methodName : string, value : System.Object, options : NotExportEnum)
---@overload fun(methodName : string, value : System.Object)
---@param methodName string
function UnityEngine_GameObject:SendMessage(methodName) end
---@overload fun(methodName : string, options : NotExportEnum)
---@overload fun(methodName : string, parameter : System.Object, options : NotExportEnum)
---@overload fun(methodName : string, parameter : System.Object)
---@param methodName string
function UnityEngine_GameObject:BroadcastMessage(methodName) end
---@param componentType System.Type
---@return UnityEngine.Component
function UnityEngine_GameObject:AddComponent(componentType) end
---@return number
function UnityEngine_GameObject:GetComponentCount() end
---@param index number
---@return UnityEngine.Component
function UnityEngine_GameObject:GetComponentAtIndex(index) end
---@param component UnityEngine.Component
---@return number
function UnityEngine_GameObject:GetComponentIndex(component) end
---@param value boolean
function UnityEngine_GameObject:SetActive(value) end
---@param tag string
---@return boolean
function UnityEngine_GameObject:CompareTag(tag) end

---@class UnityEngine.TrackedReference : System.Object
local UnityEngine_TrackedReference = {}
---@param o System.Object
---@return boolean
function UnityEngine_TrackedReference:Equals(o) end
---@return number
function UnityEngine_TrackedReference:GetHashCode() end

---@class UnityEngine.Application : System.Object
---@field isPlaying boolean
---@field isFocused boolean
---@field buildGUID string
---@field runInBackground boolean
---@field isBatchMode boolean
---@field dataPath string
---@field streamingAssetsPath string
---@field persistentDataPath string
---@field temporaryCachePath string
---@field absoluteURL string
---@field unityVersion string
---@field version string
---@field installerName string
---@field identifier string
---@field installMode NotExportEnum
---@field sandboxType NotExportEnum
---@field productName string
---@field companyName string
---@field cloudProjectId string
---@field targetFrameRate number
---@field consoleLogPath string
---@field backgroundLoadingPriority NotExportEnum
---@field genuine boolean
---@field genuineCheckAvailable boolean
---@field platform UnityEngine.RuntimePlatform
---@field isMobilePlatform boolean
---@field isConsolePlatform boolean
---@field systemLanguage NotExportEnum
---@field internetReachability UnityEngine.NetworkReachability
---@field exitCancellationToken NotExportType
---@field isEditor boolean
local UnityEngine_Application = {}
---@return UnityEngine.Application
function UnityEngine_Application.New() end
---@overload fun(exitCode : number)
function UnityEngine_Application.Quit() end
function UnityEngine_Application.Unload() end
---@overload fun(levelIndex : number) : boolean
---@param levelName string
---@return boolean
function UnityEngine_Application.CanStreamedLevelBeLoaded(levelName) end
---@param obj UnityEngine.Object
---@return boolean
function UnityEngine_Application.IsPlaying(obj) end
---@return boolean
function UnityEngine_Application.HasProLicense() end
---@param delegateMethod NotExportType
---@return boolean
function UnityEngine_Application.RequestAdvertisingIdentifierAsync(delegateMethod) end
---@param url string
function UnityEngine_Application.OpenURL(url) end
---@param logType UnityEngine.LogType
---@return NotExportEnum
function UnityEngine_Application.GetStackTraceLogType(logType) end
---@param logType UnityEngine.LogType
---@param stackTraceType NotExportEnum
function UnityEngine_Application.SetStackTraceLogType(logType, stackTraceType) end
---@param mode NotExportEnum
---@return UnityEngine.AsyncOperation
function UnityEngine_Application.RequestUserAuthorization(mode) end
---@param mode NotExportEnum
---@return boolean
function UnityEngine_Application.HasUserAuthorization(mode) end

---@class UnityEngine.Physics : System.Object
---@field IgnoreRaycastLayer number
---@field DefaultRaycastLayers number
---@field AllLayers number
---@field gravity UnityEngine.Vector3
---@field defaultContactOffset number
---@field sleepThreshold number
---@field queriesHitTriggers boolean
---@field queriesHitBackfaces boolean
---@field bounceThreshold number
---@field defaultMaxDepenetrationVelocity number
---@field defaultSolverIterations number
---@field defaultSolverVelocityIterations number
---@field simulationMode NotExportEnum
---@field defaultMaxAngularSpeed number
---@field improvedPatchFriction boolean
---@field invokeCollisionCallbacks boolean
---@field defaultPhysicsScene NotExportType
---@field autoSyncTransforms boolean
---@field reuseCollisionCallbacks boolean
---@field interCollisionDistance number
---@field interCollisionStiffness number
---@field interCollisionSettingsToggle boolean
---@field clothGravity UnityEngine.Vector3
local UnityEngine_Physics = {}
---@return UnityEngine.Physics
function UnityEngine_Physics.New() end
---@overload fun(collider1 : UnityEngine.Collider, collider2 : UnityEngine.Collider, ignore : boolean)
---@param collider1 UnityEngine.Collider
---@param collider2 UnityEngine.Collider
function UnityEngine_Physics.IgnoreCollision(collider1, collider2) end
---@overload fun(layer1 : number, layer2 : number, ignore : boolean)
---@param layer1 number
---@param layer2 number
function UnityEngine_Physics.IgnoreLayerCollision(layer1, layer2) end
---@param layer1 number
---@param layer2 number
---@return boolean
function UnityEngine_Physics.GetIgnoreLayerCollision(layer1, layer2) end
---@param collider1 UnityEngine.Collider
---@param collider2 UnityEngine.Collider
---@return boolean
function UnityEngine_Physics.GetIgnoreCollision(collider1, collider2) end
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, maxDistance : number, layerMask : number) : boolean
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, maxDistance : number) : boolean
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3) : boolean
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean, UnityEngine.RaycastHit
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number, layerMask : number) : boolean, UnityEngine.RaycastHit
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number) : boolean, UnityEngine.RaycastHit
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit) : boolean, UnityEngine.RaycastHit
---@overload fun(ray : UnityEngine.Ray, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean
---@overload fun(ray : UnityEngine.Ray, maxDistance : number, layerMask : number) : boolean
---@overload fun(ray : UnityEngine.Ray, maxDistance : number) : boolean
---@overload fun(ray : UnityEngine.Ray) : boolean
---@overload fun(ray : UnityEngine.Ray, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean, UnityEngine.RaycastHit
---@overload fun(ray : UnityEngine.Ray, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number, layerMask : number) : boolean, UnityEngine.RaycastHit
---@overload fun(ray : UnityEngine.Ray, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number) : boolean, UnityEngine.RaycastHit
---@param ray UnityEngine.Ray
---@param out_hitInfo UnityEngine.RaycastHit
---@return boolean,UnityEngine.RaycastHit
function UnityEngine_Physics.Raycast(ray, out_hitInfo) end
---@overload fun(start : UnityEngine.Vector3, _end : UnityEngine.Vector3, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean
---@overload fun(start : UnityEngine.Vector3, _end : UnityEngine.Vector3, layerMask : number) : boolean
---@overload fun(start : UnityEngine.Vector3, _end : UnityEngine.Vector3) : boolean
---@overload fun(start : UnityEngine.Vector3, _end : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean, UnityEngine.RaycastHit
---@overload fun(start : UnityEngine.Vector3, _end : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, layerMask : number) : boolean, UnityEngine.RaycastHit
---@param start UnityEngine.Vector3
---@param _end UnityEngine.Vector3
---@param out_hitInfo UnityEngine.RaycastHit
---@return boolean,UnityEngine.RaycastHit
function UnityEngine_Physics.Linecast(start, _end, out_hitInfo) end
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, maxDistance : number, layerMask : number) : boolean
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, maxDistance : number) : boolean
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3) : boolean
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean, UnityEngine.RaycastHit
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number, layerMask : number) : boolean, UnityEngine.RaycastHit
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number) : boolean, UnityEngine.RaycastHit
---@param point1 UnityEngine.Vector3
---@param point2 UnityEngine.Vector3
---@param radius number
---@param direction UnityEngine.Vector3
---@param out_hitInfo UnityEngine.RaycastHit
---@return boolean,UnityEngine.RaycastHit
function UnityEngine_Physics.CapsuleCast(point1, point2, radius, direction, out_hitInfo) end
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean, UnityEngine.RaycastHit
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number, layerMask : number) : boolean, UnityEngine.RaycastHit
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number) : boolean, UnityEngine.RaycastHit
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit) : boolean, UnityEngine.RaycastHit
---@overload fun(ray : UnityEngine.Ray, radius : number, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean
---@overload fun(ray : UnityEngine.Ray, radius : number, maxDistance : number, layerMask : number) : boolean
---@overload fun(ray : UnityEngine.Ray, radius : number, maxDistance : number) : boolean
---@overload fun(ray : UnityEngine.Ray, radius : number) : boolean
---@overload fun(ray : UnityEngine.Ray, radius : number, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean, UnityEngine.RaycastHit
---@overload fun(ray : UnityEngine.Ray, radius : number, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number, layerMask : number) : boolean, UnityEngine.RaycastHit
---@overload fun(ray : UnityEngine.Ray, radius : number, out_hitInfo : UnityEngine.RaycastHit, maxDistance : number) : boolean, UnityEngine.RaycastHit
---@param ray UnityEngine.Ray
---@param radius number
---@param out_hitInfo UnityEngine.RaycastHit
---@return boolean,UnityEngine.RaycastHit
function UnityEngine_Physics.SphereCast(ray, radius, out_hitInfo) end
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, orientation : UnityEngine.Quaternion, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, orientation : UnityEngine.Quaternion, maxDistance : number, layerMask : number) : boolean
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, orientation : UnityEngine.Quaternion, maxDistance : number) : boolean
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, orientation : UnityEngine.Quaternion) : boolean
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3) : boolean
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, orientation : UnityEngine.Quaternion, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean, UnityEngine.RaycastHit
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, orientation : UnityEngine.Quaternion, maxDistance : number, layerMask : number) : boolean, UnityEngine.RaycastHit
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, orientation : UnityEngine.Quaternion, maxDistance : number) : boolean, UnityEngine.RaycastHit
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, out_hitInfo : UnityEngine.RaycastHit, orientation : UnityEngine.Quaternion) : boolean, UnityEngine.RaycastHit
---@param center UnityEngine.Vector3
---@param halfExtents UnityEngine.Vector3
---@param direction UnityEngine.Vector3
---@param out_hitInfo UnityEngine.RaycastHit
---@return boolean,UnityEngine.RaycastHit
function UnityEngine_Physics.BoxCast(center, halfExtents, direction, out_hitInfo) end
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : NotExportType
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, maxDistance : number, layerMask : number) : NotExportType
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, maxDistance : number) : NotExportType
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3) : NotExportType
---@overload fun(ray : UnityEngine.Ray, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : NotExportType
---@overload fun(ray : UnityEngine.Ray, maxDistance : number, layerMask : number) : NotExportType
---@overload fun(ray : UnityEngine.Ray, maxDistance : number) : NotExportType
---@param ray UnityEngine.Ray
---@return NotExportType
function UnityEngine_Physics.RaycastAll(ray) end
---@overload fun(ray : UnityEngine.Ray, results : NotExportType, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : number
---@overload fun(ray : UnityEngine.Ray, results : NotExportType, maxDistance : number, layerMask : number) : number
---@overload fun(ray : UnityEngine.Ray, results : NotExportType, maxDistance : number) : number
---@overload fun(ray : UnityEngine.Ray, results : NotExportType) : number
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, results : NotExportType, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : number
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, results : NotExportType, maxDistance : number, layerMask : number) : number
---@overload fun(origin : UnityEngine.Vector3, direction : UnityEngine.Vector3, results : NotExportType, maxDistance : number) : number
---@param origin UnityEngine.Vector3
---@param direction UnityEngine.Vector3
---@param results NotExportType
---@return number
function UnityEngine_Physics.RaycastNonAlloc(origin, direction, results) end
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : NotExportType
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, maxDistance : number, layerMask : number) : NotExportType
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, maxDistance : number) : NotExportType
---@param point1 UnityEngine.Vector3
---@param point2 UnityEngine.Vector3
---@param radius number
---@param direction UnityEngine.Vector3
---@return NotExportType
function UnityEngine_Physics.CapsuleCastAll(point1, point2, radius, direction) end
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : NotExportType
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, maxDistance : number, layerMask : number) : NotExportType
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, maxDistance : number) : NotExportType
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3) : NotExportType
---@overload fun(ray : UnityEngine.Ray, radius : number, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : NotExportType
---@overload fun(ray : UnityEngine.Ray, radius : number, maxDistance : number, layerMask : number) : NotExportType
---@overload fun(ray : UnityEngine.Ray, radius : number, maxDistance : number) : NotExportType
---@param ray UnityEngine.Ray
---@param radius number
---@return NotExportType
function UnityEngine_Physics.SphereCastAll(ray, radius) end
---@overload fun(point0 : UnityEngine.Vector3, point1 : UnityEngine.Vector3, radius : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : NotExportType
---@overload fun(point0 : UnityEngine.Vector3, point1 : UnityEngine.Vector3, radius : number, layerMask : number) : NotExportType
---@param point0 UnityEngine.Vector3
---@param point1 UnityEngine.Vector3
---@param radius number
---@return NotExportType
function UnityEngine_Physics.OverlapCapsule(point0, point1, radius) end
---@overload fun(position : UnityEngine.Vector3, radius : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : NotExportType
---@overload fun(position : UnityEngine.Vector3, radius : number, layerMask : number) : NotExportType
---@param position UnityEngine.Vector3
---@param radius number
---@return NotExportType
function UnityEngine_Physics.OverlapSphere(position, radius) end
---@param step number
function UnityEngine_Physics.Simulate(step) end
function UnityEngine_Physics.SyncTransforms() end
---@param colliderA UnityEngine.Collider
---@param positionA UnityEngine.Vector3
---@param rotationA UnityEngine.Quaternion
---@param colliderB UnityEngine.Collider
---@param positionB UnityEngine.Vector3
---@param rotationB UnityEngine.Quaternion
---@param out_direction UnityEngine.Vector3
---@param out_distance number
---@return boolean,UnityEngine.Vector3,number
function UnityEngine_Physics.ComputePenetration(colliderA, positionA, rotationA, colliderB, positionB, rotationB, out_direction, out_distance) end
---@param point UnityEngine.Vector3
---@param collider UnityEngine.Collider
---@param position UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
---@return UnityEngine.Vector3
function UnityEngine_Physics.ClosestPoint(point, collider, position, rotation) end
---@overload fun(position : UnityEngine.Vector3, radius : number, results : NotExportType, layerMask : number, queryTriggerInteraction : NotExportEnum) : number
---@overload fun(position : UnityEngine.Vector3, radius : number, results : NotExportType, layerMask : number) : number
---@param position UnityEngine.Vector3
---@param radius number
---@param results NotExportType
---@return number
function UnityEngine_Physics.OverlapSphereNonAlloc(position, radius, results) end
---@overload fun(position : UnityEngine.Vector3, radius : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean
---@overload fun(position : UnityEngine.Vector3, radius : number, layerMask : number) : boolean
---@param position UnityEngine.Vector3
---@param radius number
---@return boolean
function UnityEngine_Physics.CheckSphere(position, radius) end
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, results : NotExportType, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : number
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, results : NotExportType, maxDistance : number, layerMask : number) : number
---@overload fun(point1 : UnityEngine.Vector3, point2 : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, results : NotExportType, maxDistance : number) : number
---@param point1 UnityEngine.Vector3
---@param point2 UnityEngine.Vector3
---@param radius number
---@param direction UnityEngine.Vector3
---@param results NotExportType
---@return number
function UnityEngine_Physics.CapsuleCastNonAlloc(point1, point2, radius, direction, results) end
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, results : NotExportType, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : number
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, results : NotExportType, maxDistance : number, layerMask : number) : number
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, results : NotExportType, maxDistance : number) : number
---@overload fun(origin : UnityEngine.Vector3, radius : number, direction : UnityEngine.Vector3, results : NotExportType) : number
---@overload fun(ray : UnityEngine.Ray, radius : number, results : NotExportType, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : number
---@overload fun(ray : UnityEngine.Ray, radius : number, results : NotExportType, maxDistance : number, layerMask : number) : number
---@overload fun(ray : UnityEngine.Ray, radius : number, results : NotExportType, maxDistance : number) : number
---@param ray UnityEngine.Ray
---@param radius number
---@param results NotExportType
---@return number
function UnityEngine_Physics.SphereCastNonAlloc(ray, radius, results) end
---@overload fun(start : UnityEngine.Vector3, _end : UnityEngine.Vector3, radius : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : boolean
---@overload fun(start : UnityEngine.Vector3, _end : UnityEngine.Vector3, radius : number, layerMask : number) : boolean
---@param start UnityEngine.Vector3
---@param _end UnityEngine.Vector3
---@param radius number
---@return boolean
function UnityEngine_Physics.CheckCapsule(start, _end, radius) end
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, orientation : UnityEngine.Quaternion, layermask : number, queryTriggerInteraction : NotExportEnum) : boolean
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, orientation : UnityEngine.Quaternion, layerMask : number) : boolean
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, orientation : UnityEngine.Quaternion) : boolean
---@param center UnityEngine.Vector3
---@param halfExtents UnityEngine.Vector3
---@return boolean
function UnityEngine_Physics.CheckBox(center, halfExtents) end
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, orientation : UnityEngine.Quaternion, layerMask : number, queryTriggerInteraction : NotExportEnum) : NotExportType
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, orientation : UnityEngine.Quaternion, layerMask : number) : NotExportType
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, orientation : UnityEngine.Quaternion) : NotExportType
---@param center UnityEngine.Vector3
---@param halfExtents UnityEngine.Vector3
---@return NotExportType
function UnityEngine_Physics.OverlapBox(center, halfExtents) end
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, results : NotExportType, orientation : UnityEngine.Quaternion, mask : number, queryTriggerInteraction : NotExportEnum) : number
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, results : NotExportType, orientation : UnityEngine.Quaternion, mask : number) : number
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, results : NotExportType, orientation : UnityEngine.Quaternion) : number
---@param center UnityEngine.Vector3
---@param halfExtents UnityEngine.Vector3
---@param results NotExportType
---@return number
function UnityEngine_Physics.OverlapBoxNonAlloc(center, halfExtents, results) end
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, results : NotExportType, orientation : UnityEngine.Quaternion, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : number
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, results : NotExportType, orientation : UnityEngine.Quaternion) : number
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, results : NotExportType, orientation : UnityEngine.Quaternion, maxDistance : number) : number
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, results : NotExportType, orientation : UnityEngine.Quaternion, maxDistance : number, layerMask : number) : number
---@param center UnityEngine.Vector3
---@param halfExtents UnityEngine.Vector3
---@param direction UnityEngine.Vector3
---@param results NotExportType
---@return number
function UnityEngine_Physics.BoxCastNonAlloc(center, halfExtents, direction, results) end
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, orientation : UnityEngine.Quaternion, maxDistance : number, layerMask : number, queryTriggerInteraction : NotExportEnum) : NotExportType
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, orientation : UnityEngine.Quaternion, maxDistance : number, layerMask : number) : NotExportType
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, orientation : UnityEngine.Quaternion, maxDistance : number) : NotExportType
---@overload fun(center : UnityEngine.Vector3, halfExtents : UnityEngine.Vector3, direction : UnityEngine.Vector3, orientation : UnityEngine.Quaternion) : NotExportType
---@param center UnityEngine.Vector3
---@param halfExtents UnityEngine.Vector3
---@param direction UnityEngine.Vector3
---@return NotExportType
function UnityEngine_Physics.BoxCastAll(center, halfExtents, direction) end
---@overload fun(point0 : UnityEngine.Vector3, point1 : UnityEngine.Vector3, radius : number, results : NotExportType, layerMask : number, queryTriggerInteraction : NotExportEnum) : number
---@overload fun(point0 : UnityEngine.Vector3, point1 : UnityEngine.Vector3, radius : number, results : NotExportType, layerMask : number) : number
---@param point0 UnityEngine.Vector3
---@param point1 UnityEngine.Vector3
---@param radius number
---@param results NotExportType
---@return number
function UnityEngine_Physics.OverlapCapsuleNonAlloc(point0, point1, radius, results) end
---@param worldBounds UnityEngine.Bounds
---@param subdivisions number
function UnityEngine_Physics.RebuildBroadphaseRegions(worldBounds, subdivisions) end
---@overload fun(meshID : number, convex : boolean, cookingOptions : NotExportEnum)
---@param meshID number
---@param convex boolean
function UnityEngine_Physics.BakeMesh(meshID, convex) end

---@class UnityEngine.Collider : UnityEngine.Component
---@field enabled boolean
---@field attachedRigidbody UnityEngine.Rigidbody
---@field attachedArticulationBody NotExportType
---@field isTrigger boolean
---@field contactOffset number
---@field bounds UnityEngine.Bounds
---@field hasModifiableContacts boolean
---@field providesContacts boolean
---@field layerOverridePriority number
---@field excludeLayers UnityEngine.LayerMask
---@field includeLayers UnityEngine.LayerMask
---@field sharedMaterial NotExportType
---@field material NotExportType
local UnityEngine_Collider = {}
---@return UnityEngine.Collider
function UnityEngine_Collider.New() end
---@param position UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Collider:ClosestPoint(position) end
---@param ray UnityEngine.Ray
---@param out_hitInfo UnityEngine.RaycastHit
---@param maxDistance number
---@return boolean,UnityEngine.RaycastHit
function UnityEngine_Collider:Raycast(ray, out_hitInfo, maxDistance) end
---@param position UnityEngine.Vector3
---@return UnityEngine.Vector3
function UnityEngine_Collider:ClosestPointOnBounds(position) end

---@class UnityEngine.Texture : UnityEngine.Object
---@field GenerateAllMips number
---@field anisotropicFiltering NotExportEnum
---@field totalTextureMemory number
---@field desiredTextureMemory number
---@field targetTextureMemory number
---@field currentTextureMemory number
---@field nonStreamingTextureMemory number
---@field streamingMipmapUploadCount number
---@field streamingRendererCount number
---@field streamingTextureCount number
---@field nonStreamingTextureCount number
---@field streamingTexturePendingLoadCount number
---@field streamingTextureLoadingCount number
---@field streamingTextureForceLoadAll boolean
---@field streamingTextureDiscardUnusedMips boolean
---@field allowThreadedTextureCreation boolean
---@field mipmapCount number
---@field graphicsFormat NotExportEnum
---@field width number
---@field height number
---@field dimension NotExportEnum
---@field isReadable boolean
---@field wrapMode NotExportEnum
---@field wrapModeU NotExportEnum
---@field wrapModeV NotExportEnum
---@field wrapModeW NotExportEnum
---@field filterMode NotExportEnum
---@field anisoLevel number
---@field mipMapBias number
---@field texelSize UnityEngine.Vector2
---@field updateCount number
---@field isDataSRGB boolean
local UnityEngine_Texture = {}
---@param forcedMin number
---@param globalMax number
function UnityEngine_Texture.SetGlobalAnisotropicFilteringLimits(forcedMin, globalMax) end
function UnityEngine_Texture.SetStreamingTextureMaterialDebugProperties() end
---@return NotExportType
function UnityEngine_Texture:GetNativeTexturePtr() end
function UnityEngine_Texture:IncrementUpdateCount() end

---@class UnityEngine.Texture2D : UnityEngine.Texture
---@field whiteTexture UnityEngine.Texture2D
---@field blackTexture UnityEngine.Texture2D
---@field redTexture UnityEngine.Texture2D
---@field grayTexture UnityEngine.Texture2D
---@field linearGrayTexture UnityEngine.Texture2D
---@field normalTexture UnityEngine.Texture2D
---@field format NotExportEnum
---@field ignoreMipmapLimit boolean
---@field mipmapLimitGroup string
---@field activeMipmapLimit number
---@field isReadable boolean
---@field vtOnly boolean
---@field streamingMipmaps boolean
---@field streamingMipmapsPriority number
---@field requestedMipmapLevel number
---@field minimumMipmapLevel number
---@field calculatedMipmapLevel number
---@field desiredMipmapLevel number
---@field loadingMipmapLevel number
---@field loadedMipmapLevel number
local UnityEngine_Texture2D = {}
---@overload fun(width : number, height : number, format : NotExportEnum, flags : NotExportEnum) : UnityEngine.Texture2D
---@overload fun(width : number, height : number, format : NotExportEnum, mipCount : number, flags : NotExportEnum) : UnityEngine.Texture2D
---@overload fun(width : number, height : number, format : NotExportEnum, mipCount : number, mipmapLimitGroupName : string, flags : NotExportEnum) : UnityEngine.Texture2D
---@overload fun(width : number, height : number, format : NotExportEnum, flags : NotExportEnum) : UnityEngine.Texture2D
---@overload fun(width : number, height : number, format : NotExportEnum, mipCount : number, flags : NotExportEnum) : UnityEngine.Texture2D
---@overload fun(width : number, height : number, format : NotExportEnum, mipCount : number, mipmapLimitGroupName : string, flags : NotExportEnum) : UnityEngine.Texture2D
---@overload fun(width : number, height : number, textureFormat : NotExportEnum, mipCount : number, linear : boolean) : UnityEngine.Texture2D
---@overload fun(width : number, height : number, textureFormat : NotExportEnum, mipCount : number, linear : boolean, createUninitialized : boolean) : UnityEngine.Texture2D
---@overload fun(width : number, height : number, textureFormat : NotExportEnum, mipCount : number, linear : boolean, createUninitialized : boolean, ignoreMipmapLimit : boolean, mipmapLimitGroupName : string) : UnityEngine.Texture2D
---@overload fun(width : number, height : number, textureFormat : NotExportEnum, mipChain : boolean, linear : boolean) : UnityEngine.Texture2D
---@overload fun(width : number, height : number, textureFormat : NotExportEnum, mipChain : boolean, linear : boolean, createUninitialized : boolean) : UnityEngine.Texture2D
---@overload fun(width : number, height : number, textureFormat : NotExportEnum, mipChain : boolean) : UnityEngine.Texture2D
---@param width number
---@param height number
---@return UnityEngine.Texture2D
function UnityEngine_Texture2D.New(width, height) end
---@param width number
---@param height number
---@param format NotExportEnum
---@param mipChain boolean
---@param linear boolean
---@param nativeTex NotExportType
---@return UnityEngine.Texture2D
function UnityEngine_Texture2D.CreateExternalTexture(width, height, format, mipChain, linear, nativeTex) end
---@param sizes NotExportType
---@param padding number
---@param atlasSize number
---@param results NotExportType
---@return boolean
function UnityEngine_Texture2D.GenerateAtlas(sizes, padding, atlasSize, results) end
---@param highQuality boolean
function UnityEngine_Texture2D:Compress(highQuality) end
function UnityEngine_Texture2D:ClearRequestedMipmapLevel() end
---@return boolean
function UnityEngine_Texture2D:IsRequestedMipmapLevelLoaded() end
function UnityEngine_Texture2D:ClearMinimumMipmapLevel() end
---@param nativeTex NotExportType
function UnityEngine_Texture2D:UpdateExternalTexture(nativeTex) end
---@return NotExportType
function UnityEngine_Texture2D:GetRawTextureData() end
---@overload fun(x : number, y : number, blockWidth : number, blockHeight : number, miplevel : number) : NotExportType
---@overload fun(x : number, y : number, blockWidth : number, blockHeight : number) : NotExportType
---@overload fun(miplevel : number) : NotExportType
---@return NotExportType
function UnityEngine_Texture2D:GetPixels() end
---@overload fun(miplevel : number) : NotExportType
---@return NotExportType
function UnityEngine_Texture2D:GetPixels32() end
---@overload fun(textures : NotExportType, padding : number, maximumAtlasSize : number, makeNoLongerReadable : boolean) : NotExportType
---@overload fun(textures : NotExportType, padding : number, maximumAtlasSize : number) : NotExportType
---@param textures NotExportType
---@param padding number
---@return NotExportType
function UnityEngine_Texture2D:PackTextures(textures, padding) end
---@overload fun(x : number, y : number, color : UnityEngine.Color)
---@param x number
---@param y number
---@param color UnityEngine.Color
---@param mipLevel number
function UnityEngine_Texture2D:SetPixel(x, y, color, mipLevel) end
---@overload fun(x : number, y : number, blockWidth : number, blockHeight : number, colors : NotExportType, miplevel : number)
---@overload fun(x : number, y : number, blockWidth : number, blockHeight : number, colors : NotExportType)
---@overload fun(colors : NotExportType, miplevel : number)
---@param colors NotExportType
function UnityEngine_Texture2D:SetPixels(colors) end
---@overload fun(x : number, y : number) : UnityEngine.Color
---@param x number
---@param y number
---@param mipLevel number
---@return UnityEngine.Color
function UnityEngine_Texture2D:GetPixel(x, y, mipLevel) end
---@overload fun(u : number, v : number) : UnityEngine.Color
---@param u number
---@param v number
---@param mipLevel number
---@return UnityEngine.Color
function UnityEngine_Texture2D:GetPixelBilinear(u, v, mipLevel) end
---@overload fun(data : NotExportType, size : number)
---@param data NotExportType
function UnityEngine_Texture2D:LoadRawTextureData(data) end
---@overload fun(updateMipmaps : boolean, makeNoLongerReadable : boolean)
---@overload fun(updateMipmaps : boolean)
function UnityEngine_Texture2D:Apply() end
---@overload fun(width : number, height : number) : boolean
---@overload fun(width : number, height : number, format : NotExportEnum, hasMipMap : boolean) : boolean
---@param width number
---@param height number
---@param format NotExportEnum
---@param hasMipMap boolean
---@return boolean
function UnityEngine_Texture2D:Reinitialize(width, height, format, hasMipMap) end
---@overload fun(source : UnityEngine.Rect, destX : number, destY : number, recalculateMipMaps : boolean)
---@param source UnityEngine.Rect
---@param destX number
---@param destY number
function UnityEngine_Texture2D:ReadPixels(source, destX, destY) end
---@overload fun(colors : NotExportType, miplevel : number)
---@overload fun(colors : NotExportType)
---@overload fun(x : number, y : number, blockWidth : number, blockHeight : number, colors : NotExportType, miplevel : number)
---@param x number
---@param y number
---@param blockWidth number
---@param blockHeight number
---@param colors NotExportType
function UnityEngine_Texture2D:SetPixels32(x, y, blockWidth, blockHeight, colors) end

---@class UnityEngine.Shader : UnityEngine.Object
---@field maximumChunksOverride number
---@field globalMaximumLOD number
---@field globalRenderPipeline string
---@field enabledGlobalKeywords NotExportType
---@field globalKeywords NotExportType
---@field maximumLOD number
---@field isSupported boolean
---@field keywordSpace NotExportType
---@field renderQueue number
---@field passCount number
---@field subshaderCount number
local UnityEngine_Shader = {}
---@param name string
---@return UnityEngine.Shader
function UnityEngine_Shader.Find(name) end
---@overload fun(keyword : string)
---@param ref_keyword NotExportType
---@return ,NotExportType
function UnityEngine_Shader.EnableKeyword(ref_keyword) end
---@overload fun(keyword : string)
---@param ref_keyword NotExportType
---@return ,NotExportType
function UnityEngine_Shader.DisableKeyword(ref_keyword) end
---@overload fun(keyword : string) : boolean
---@param ref_keyword NotExportType
---@return boolean,NotExportType
function UnityEngine_Shader.IsKeywordEnabled(ref_keyword) end
---@param ref_keyword NotExportType
---@param value boolean
---@return ,NotExportType
function UnityEngine_Shader.SetKeyword(ref_keyword, value) end
function UnityEngine_Shader.WarmupAllShaders() end
---@param name string
---@return number
function UnityEngine_Shader.PropertyToID(name) end
---@overload fun(name : string, value : number)
---@param nameID number
---@param value number
function UnityEngine_Shader.SetGlobalInt(nameID, value) end
---@overload fun(name : string, value : number)
---@param nameID number
---@param value number
function UnityEngine_Shader.SetGlobalFloat(nameID, value) end
---@overload fun(name : string, value : number)
---@param nameID number
---@param value number
function UnityEngine_Shader.SetGlobalInteger(nameID, value) end
---@overload fun(name : string, value : NotExportType)
---@param nameID number
---@param value NotExportType
function UnityEngine_Shader.SetGlobalVector(nameID, value) end
---@overload fun(name : string, value : UnityEngine.Color)
---@param nameID number
---@param value UnityEngine.Color
function UnityEngine_Shader.SetGlobalColor(nameID, value) end
---@overload fun(name : string, value : NotExportType)
---@param nameID number
---@param value NotExportType
function UnityEngine_Shader.SetGlobalMatrix(nameID, value) end
---@overload fun(name : string, value : UnityEngine.Texture)
---@overload fun(nameID : number, value : UnityEngine.Texture)
---@overload fun(name : string, value : NotExportType, element : NotExportEnum)
---@param nameID number
---@param value NotExportType
---@param element NotExportEnum
function UnityEngine_Shader.SetGlobalTexture(nameID, value, element) end
---@overload fun(name : string, value : NotExportType)
---@overload fun(nameID : number, value : NotExportType)
---@overload fun(name : string, value : NotExportType)
---@param nameID number
---@param value NotExportType
function UnityEngine_Shader.SetGlobalBuffer(nameID, value) end
---@overload fun(name : string, value : NotExportType, offset : number, size : number)
---@overload fun(nameID : number, value : NotExportType, offset : number, size : number)
---@overload fun(name : string, value : NotExportType, offset : number, size : number)
---@param nameID number
---@param value NotExportType
---@param offset number
---@param size number
function UnityEngine_Shader.SetGlobalConstantBuffer(nameID, value, offset, size) end
---@overload fun(name : string, values : NotExportType)
---@overload fun(nameID : number, values : NotExportType)
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Shader.SetGlobalFloatArray(nameID, values) end
---@overload fun(name : string, values : NotExportType)
---@overload fun(nameID : number, values : NotExportType)
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Shader.SetGlobalVectorArray(nameID, values) end
---@overload fun(name : string, values : NotExportType)
---@overload fun(nameID : number, values : NotExportType)
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Shader.SetGlobalMatrixArray(nameID, values) end
---@overload fun(name : string) : number
---@param nameID number
---@return number
function UnityEngine_Shader.GetGlobalInt(nameID) end
---@overload fun(name : string) : number
---@param nameID number
---@return number
function UnityEngine_Shader.GetGlobalFloat(nameID) end
---@overload fun(name : string) : number
---@param nameID number
---@return number
function UnityEngine_Shader.GetGlobalInteger(nameID) end
---@overload fun(name : string) : NotExportType
---@param nameID number
---@return NotExportType
function UnityEngine_Shader.GetGlobalVector(nameID) end
---@overload fun(name : string) : UnityEngine.Color
---@param nameID number
---@return UnityEngine.Color
function UnityEngine_Shader.GetGlobalColor(nameID) end
---@overload fun(name : string) : NotExportType
---@param nameID number
---@return NotExportType
function UnityEngine_Shader.GetGlobalMatrix(nameID) end
---@overload fun(name : string) : UnityEngine.Texture
---@param nameID number
---@return UnityEngine.Texture
function UnityEngine_Shader.GetGlobalTexture(nameID) end
---@overload fun(name : string) : NotExportType
---@overload fun(nameID : number) : NotExportType
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Shader.GetGlobalFloatArray(nameID, values) end
---@overload fun(name : string) : NotExportType
---@overload fun(nameID : number) : NotExportType
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Shader.GetGlobalVectorArray(nameID, values) end
---@overload fun(name : string) : NotExportType
---@overload fun(nameID : number) : NotExportType
---@overload fun(name : string, values : NotExportType)
---@param nameID number
---@param values NotExportType
function UnityEngine_Shader.GetGlobalMatrixArray(nameID, values) end
---@param name string
---@return UnityEngine.Shader
function UnityEngine_Shader:GetDependency(name) end
---@param subshaderIndex number
---@return number
function UnityEngine_Shader:GetPassCountInSubshader(subshaderIndex) end
---@overload fun(passIndex : number, tagName : NotExportType) : NotExportType
---@param subshaderIndex number
---@param passIndex number
---@param tagName NotExportType
---@return NotExportType
function UnityEngine_Shader:FindPassTagValue(subshaderIndex, passIndex, tagName) end
---@param subshaderIndex number
---@param tagName NotExportType
---@return NotExportType
function UnityEngine_Shader:FindSubshaderTagValue(subshaderIndex, tagName) end
---@return number
function UnityEngine_Shader:GetPropertyCount() end
---@param propertyName string
---@return number
function UnityEngine_Shader:FindPropertyIndex(propertyName) end
---@param propertyIndex number
---@return string
function UnityEngine_Shader:GetPropertyName(propertyIndex) end
---@param propertyIndex number
---@return number
function UnityEngine_Shader:GetPropertyNameId(propertyIndex) end
---@param propertyIndex number
---@return NotExportEnum
function UnityEngine_Shader:GetPropertyType(propertyIndex) end
---@param propertyIndex number
---@return string
function UnityEngine_Shader:GetPropertyDescription(propertyIndex) end
---@param propertyIndex number
---@return NotExportEnum
function UnityEngine_Shader:GetPropertyFlags(propertyIndex) end
---@param propertyIndex number
---@return NotExportType
function UnityEngine_Shader:GetPropertyAttributes(propertyIndex) end
---@param propertyIndex number
---@return number
function UnityEngine_Shader:GetPropertyDefaultFloatValue(propertyIndex) end
---@param propertyIndex number
---@return NotExportType
function UnityEngine_Shader:GetPropertyDefaultVectorValue(propertyIndex) end
---@param propertyIndex number
---@return UnityEngine.Vector2
function UnityEngine_Shader:GetPropertyRangeLimits(propertyIndex) end
---@param propertyIndex number
---@return number
function UnityEngine_Shader:GetPropertyDefaultIntValue(propertyIndex) end
---@param propertyIndex number
---@return NotExportEnum
function UnityEngine_Shader:GetPropertyTextureDimension(propertyIndex) end
---@param propertyIndex number
---@return string
function UnityEngine_Shader:GetPropertyTextureDefaultName(propertyIndex) end
---@param propertyIndex number
---@param out_stackName string
---@param out_layerIndex number
---@return boolean,string,number
function UnityEngine_Shader:FindTextureStack(propertyIndex, out_stackName, out_layerIndex) end

---@class UnityEngine.Renderer : UnityEngine.Component
---@field bounds UnityEngine.Bounds
---@field localBounds UnityEngine.Bounds
---@field enabled boolean
---@field isVisible boolean
---@field shadowCastingMode NotExportEnum
---@field receiveShadows boolean
---@field forceRenderingOff boolean
---@field staticShadowCaster boolean
---@field motionVectorGenerationMode NotExportEnum
---@field lightProbeUsage NotExportEnum
---@field reflectionProbeUsage NotExportEnum
---@field renderingLayerMask number
---@field rendererPriority number
---@field rayTracingMode NotExportEnum
---@field sortingLayerName string
---@field sortingLayerID number
---@field sortingOrder number
---@field allowOcclusionWhenDynamic boolean
---@field isPartOfStaticBatch boolean
---@field worldToLocalMatrix NotExportType
---@field localToWorldMatrix NotExportType
---@field lightProbeProxyVolumeOverride UnityEngine.GameObject
---@field probeAnchor UnityEngine.Transform
---@field lightmapIndex number
---@field realtimeLightmapIndex number
---@field lightmapScaleOffset NotExportType
---@field realtimeLightmapScaleOffset NotExportType
---@field materials NotExportType
---@field material UnityEngine.Material
---@field sharedMaterial UnityEngine.Material
---@field sharedMaterials NotExportType
local UnityEngine_Renderer = {}
---@return UnityEngine.Renderer
function UnityEngine_Renderer.New() end
function UnityEngine_Renderer:ResetBounds() end
function UnityEngine_Renderer:ResetLocalBounds() end
---@return boolean
function UnityEngine_Renderer:HasPropertyBlock() end
---@overload fun(properties : NotExportType)
---@param properties NotExportType
---@param materialIndex number
function UnityEngine_Renderer:SetPropertyBlock(properties, materialIndex) end
---@overload fun(properties : NotExportType)
---@param properties NotExportType
---@param materialIndex number
function UnityEngine_Renderer:GetPropertyBlock(properties, materialIndex) end
---@param m NotExportType
function UnityEngine_Renderer:GetMaterials(m) end
---@param materials NotExportType
function UnityEngine_Renderer:SetSharedMaterials(materials) end
---@param materials NotExportType
function UnityEngine_Renderer:SetMaterials(materials) end
---@param m NotExportType
function UnityEngine_Renderer:GetSharedMaterials(m) end
---@param result NotExportType
function UnityEngine_Renderer:GetClosestReflectionProbes(result) end

---@class UnityEngine.WWW : UnityEngine.CustomYieldInstruction
---@field assetBundle UnityEngine.AssetBundle
---@field bytes NotExportType
---@field bytesDownloaded number
---@field error string
---@field isDone boolean
---@field progress number
---@field responseHeaders NotExportType
---@field text string
---@field texture UnityEngine.Texture2D
---@field textureNonReadable UnityEngine.Texture2D
---@field threadPriority NotExportEnum
---@field uploadProgress number
---@field url string
---@field keepWaiting boolean
local UnityEngine_WWW = {}
---@overload fun(url : string) : UnityEngine.WWW
---@overload fun(url : string, form : UnityEngine.WWWForm) : UnityEngine.WWW
---@overload fun(url : string, postData : NotExportType) : UnityEngine.WWW
---@overload fun(url : string, postData : NotExportType, headers : NotExportType) : UnityEngine.WWW
---@param url string
---@param postData NotExportType
---@param headers NotExportType
---@return UnityEngine.WWW
function UnityEngine_WWW.New(url, postData, headers) end
---@overload fun(s : string) : string
---@param s string
---@param e NotExportType
---@return string
function UnityEngine_WWW.EscapeURL(s, e) end
---@overload fun(s : string) : string
---@param s string
---@param e NotExportType
---@return string
function UnityEngine_WWW.UnEscapeURL(s, e) end
---@overload fun(url : string, version : number) : UnityEngine.WWW
---@overload fun(url : string, version : number, crc : number) : UnityEngine.WWW
---@overload fun(url : string, hash : NotExportType) : UnityEngine.WWW
---@overload fun(url : string, hash : NotExportType, crc : number) : UnityEngine.WWW
---@param url string
---@param cachedBundle NotExportType
---@param crc number
---@return UnityEngine.WWW
function UnityEngine_WWW.LoadFromCacheOrDownload(url, cachedBundle, crc) end
---@param texture UnityEngine.Texture2D
function UnityEngine_WWW:LoadImageIntoTexture(texture) end
function UnityEngine_WWW:Dispose() end
---@overload fun() : UnityEngine.AudioClip
---@overload fun(threeD : boolean) : UnityEngine.AudioClip
---@overload fun(threeD : boolean, stream : boolean) : UnityEngine.AudioClip
---@param threeD boolean
---@param stream boolean
---@param audioType NotExportEnum
---@return UnityEngine.AudioClip
function UnityEngine_WWW:GetAudioClip(threeD, stream, audioType) end
---@overload fun() : UnityEngine.AudioClip
---@overload fun(threeD : boolean) : UnityEngine.AudioClip
---@param threeD boolean
---@param audioType NotExportEnum
---@return UnityEngine.AudioClip
function UnityEngine_WWW:GetAudioClipCompressed(threeD, audioType) end

---@class UnityEngine.CustomYieldInstruction : System.Object
---@field keepWaiting boolean
---@field Current System.Object
local UnityEngine_CustomYieldInstruction = {}
---@return boolean
function UnityEngine_CustomYieldInstruction:MoveNext() end
function UnityEngine_CustomYieldInstruction:Reset() end

---@class UnityEngine.Screen : System.Object
---@field width number
---@field height number
---@field dpi number
---@field currentResolution NotExportType
---@field resolutions NotExportType
---@field fullScreen boolean
---@field fullScreenMode NotExportEnum
---@field safeArea UnityEngine.Rect
---@field cutouts NotExportType
---@field autorotateToPortrait boolean
---@field autorotateToPortraitUpsideDown boolean
---@field autorotateToLandscapeLeft boolean
---@field autorotateToLandscapeRight boolean
---@field orientation UnityEngine.ScreenOrientation
---@field sleepTimeout number
---@field brightness number
---@field mainWindowPosition NotExportType
---@field mainWindowDisplayInfo NotExportType
local UnityEngine_Screen = {}
---@return UnityEngine.Screen
function UnityEngine_Screen.New() end
---@overload fun(width : number, height : number, fullscreenMode : NotExportEnum, preferredRefreshRate : NotExportType)
---@overload fun(width : number, height : number, fullscreenMode : NotExportEnum)
---@param width number
---@param height number
---@param fullscreen boolean
function UnityEngine_Screen.SetResolution(width, height, fullscreen) end
---@param displayLayout NotExportType
function UnityEngine_Screen.GetDisplayLayout(displayLayout) end
---@param ref_display NotExportType
---@param position NotExportType
---@return UnityEngine.AsyncOperation,NotExportType
function UnityEngine_Screen.MoveMainWindowTo(ref_display, position) end

---@class UnityEngine.ScreenOrientation
---@field Portrait UnityEngine.ScreenOrientation
---@field PortraitUpsideDown UnityEngine.ScreenOrientation
---@field LandscapeLeft UnityEngine.ScreenOrientation
---@field LandscapeRight UnityEngine.ScreenOrientation
---@field AutoRotation UnityEngine.ScreenOrientation
local UnityEngine_ScreenOrientation = {}

---@class System.Collections.ArrayList : System.Object
---@field Capacity number
---@field Count number
---@field IsFixedSize boolean
---@field IsReadOnly boolean
---@field IsSynchronized boolean
---@field SyncRoot System.Object
---@field Item System.Object
local System_Collections_ArrayList = {}
---@overload fun() : System.Collections.ArrayList
---@overload fun(capacity : number) : System.Collections.ArrayList
---@param c NotExportType
---@return System.Collections.ArrayList
function System_Collections_ArrayList.New(c) end
---@param list NotExportType
---@return System.Collections.ArrayList
function System_Collections_ArrayList.Adapter(list) end
---@overload fun(list : NotExportType) : NotExportType
---@param list System.Collections.ArrayList
---@return System.Collections.ArrayList
function System_Collections_ArrayList.FixedSize(list) end
---@overload fun(list : NotExportType) : NotExportType
---@param list System.Collections.ArrayList
---@return System.Collections.ArrayList
function System_Collections_ArrayList.ReadOnly(list) end
---@param value System.Object
---@param count number
---@return System.Collections.ArrayList
function System_Collections_ArrayList.Repeat(value, count) end
---@overload fun(list : NotExportType) : NotExportType
---@param list System.Collections.ArrayList
---@return System.Collections.ArrayList
function System_Collections_ArrayList.Synchronized(list) end
---@param value System.Object
---@return number
function System_Collections_ArrayList:Add(value) end
---@param c NotExportType
function System_Collections_ArrayList:AddRange(c) end
---@overload fun(index : number, count : number, value : System.Object, comparer : NotExportType) : number
---@overload fun(value : System.Object) : number
---@param value System.Object
---@param comparer NotExportType
---@return number
function System_Collections_ArrayList:BinarySearch(value, comparer) end
function System_Collections_ArrayList:Clear() end
---@return System.Object
function System_Collections_ArrayList:Clone() end
---@param item System.Object
---@return boolean
function System_Collections_ArrayList:Contains(item) end
---@overload fun(array : System.Array)
---@overload fun(array : System.Array, arrayIndex : number)
---@param index number
---@param array System.Array
---@param arrayIndex number
---@param count number
function System_Collections_ArrayList:CopyTo(index, array, arrayIndex, count) end
---@overload fun() : System.Collections.IEnumerator
---@param index number
---@param count number
---@return System.Collections.IEnumerator
function System_Collections_ArrayList:GetEnumerator(index, count) end
---@overload fun(value : System.Object) : number
---@overload fun(value : System.Object, startIndex : number) : number
---@param value System.Object
---@param startIndex number
---@param count number
---@return number
function System_Collections_ArrayList:IndexOf(value, startIndex, count) end
---@param index number
---@param value System.Object
function System_Collections_ArrayList:Insert(index, value) end
---@param index number
---@param c NotExportType
function System_Collections_ArrayList:InsertRange(index, c) end
---@overload fun(value : System.Object) : number
---@overload fun(value : System.Object, startIndex : number) : number
---@param value System.Object
---@param startIndex number
---@param count number
---@return number
function System_Collections_ArrayList:LastIndexOf(value, startIndex, count) end
---@param obj System.Object
function System_Collections_ArrayList:Remove(obj) end
---@param index number
function System_Collections_ArrayList:RemoveAt(index) end
---@param index number
---@param count number
function System_Collections_ArrayList:RemoveRange(index, count) end
---@overload fun()
---@param index number
---@param count number
function System_Collections_ArrayList:Reverse(index, count) end
---@param index number
---@param c NotExportType
function System_Collections_ArrayList:SetRange(index, c) end
---@param index number
---@param count number
---@return System.Collections.ArrayList
function System_Collections_ArrayList:GetRange(index, count) end
---@overload fun()
---@overload fun(comparer : NotExportType)
---@param index number
---@param count number
---@param comparer NotExportType
function System_Collections_ArrayList:Sort(index, count, comparer) end
---@overload fun() : NotExportType
---@param type System.Type
---@return System.Array
function System_Collections_ArrayList:ToArray(type) end
function System_Collections_ArrayList:TrimToSize() end

---@class UnityEngine.CameraClearFlags
---@field Skybox UnityEngine.CameraClearFlags
---@field Color UnityEngine.CameraClearFlags
---@field SolidColor UnityEngine.CameraClearFlags
---@field Depth UnityEngine.CameraClearFlags
---@field Nothing UnityEngine.CameraClearFlags
local UnityEngine_CameraClearFlags = {}

---@class UnityEngine.AudioClip : UnityEngine.Object
---@field length number
---@field samples number
---@field channels number
---@field frequency number
---@field loadType NotExportEnum
---@field preloadAudioData boolean
---@field ambisonic boolean
---@field loadInBackground boolean
---@field loadState NotExportEnum
local UnityEngine_AudioClip = {}
---@overload fun(name : string, lengthSamples : number, channels : number, frequency : number, stream : boolean) : UnityEngine.AudioClip
---@overload fun(name : string, lengthSamples : number, channels : number, frequency : number, stream : boolean, pcmreadercallback : NotExportType) : UnityEngine.AudioClip
---@param name string
---@param lengthSamples number
---@param channels number
---@param frequency number
---@param stream boolean
---@param pcmreadercallback NotExportType
---@param pcmsetpositioncallback NotExportType
---@return UnityEngine.AudioClip
function UnityEngine_AudioClip.Create(name, lengthSamples, channels, frequency, stream, pcmreadercallback, pcmsetpositioncallback) end
---@return boolean
function UnityEngine_AudioClip:LoadAudioData() end
---@return boolean
function UnityEngine_AudioClip:UnloadAudioData() end
---@param data NotExportType
---@param offsetSamples number
---@return boolean
function UnityEngine_AudioClip:GetData(data, offsetSamples) end
---@param data NotExportType
---@param offsetSamples number
---@return boolean
function UnityEngine_AudioClip:SetData(data, offsetSamples) end

---@class UnityEngine.AssetBundle : UnityEngine.Object
---@field memoryBudgetKB number
---@field isStreamedSceneAssetBundle boolean
local UnityEngine_AssetBundle = {}
---@param unloadAllObjects boolean
function UnityEngine_AssetBundle.UnloadAllAssetBundles(unloadAllObjects) end
---@return NotExportType
function UnityEngine_AssetBundle.GetAllLoadedAssetBundles() end
---@overload fun(path : string) : NotExportType
---@overload fun(path : string, crc : number) : NotExportType
---@param path string
---@param crc number
---@param offset number
---@return NotExportType
function UnityEngine_AssetBundle.LoadFromFileAsync(path, crc, offset) end
---@overload fun(path : string) : UnityEngine.AssetBundle
---@overload fun(path : string, crc : number) : UnityEngine.AssetBundle
---@param path string
---@param crc number
---@param offset number
---@return UnityEngine.AssetBundle
function UnityEngine_AssetBundle.LoadFromFile(path, crc, offset) end
---@overload fun(binary : NotExportType) : NotExportType
---@param binary NotExportType
---@param crc number
---@return NotExportType
function UnityEngine_AssetBundle.LoadFromMemoryAsync(binary, crc) end
---@overload fun(binary : NotExportType) : UnityEngine.AssetBundle
---@param binary NotExportType
---@param crc number
---@return UnityEngine.AssetBundle
function UnityEngine_AssetBundle.LoadFromMemory(binary, crc) end
---@overload fun(stream : NotExportType, crc : number, managedReadBufferSize : number) : NotExportType
---@overload fun(stream : NotExportType, crc : number) : NotExportType
---@param stream NotExportType
---@return NotExportType
function UnityEngine_AssetBundle.LoadFromStreamAsync(stream) end
---@overload fun(stream : NotExportType, crc : number, managedReadBufferSize : number) : UnityEngine.AssetBundle
---@overload fun(stream : NotExportType, crc : number) : UnityEngine.AssetBundle
---@param stream NotExportType
---@return UnityEngine.AssetBundle
function UnityEngine_AssetBundle.LoadFromStream(stream) end
---@param inputPath string
---@param outputPath string
---@param method NotExportType
---@param expectedCRC number
---@param priority NotExportEnum
---@return NotExportType
function UnityEngine_AssetBundle.RecompressAssetBundleAsync(inputPath, outputPath, method, expectedCRC, priority) end
---@param name string
---@return boolean
function UnityEngine_AssetBundle:Contains(name) end
---@overload fun(name : string) : UnityEngine.Object
---@param name string
---@param type System.Type
---@return UnityEngine.Object
function UnityEngine_AssetBundle:LoadAsset(name, type) end
---@overload fun(name : string) : NotExportType
---@param name string
---@param type System.Type
---@return NotExportType
function UnityEngine_AssetBundle:LoadAssetAsync(name, type) end
---@overload fun(name : string) : NotExportType
---@param name string
---@param type System.Type
---@return NotExportType
function UnityEngine_AssetBundle:LoadAssetWithSubAssets(name, type) end
---@overload fun(name : string) : NotExportType
---@param name string
---@param type System.Type
---@return NotExportType
function UnityEngine_AssetBundle:LoadAssetWithSubAssetsAsync(name, type) end
---@overload fun() : NotExportType
---@param type System.Type
---@return NotExportType
function UnityEngine_AssetBundle:LoadAllAssets(type) end
---@overload fun() : NotExportType
---@param type System.Type
---@return NotExportType
function UnityEngine_AssetBundle:LoadAllAssetsAsync(type) end
---@param unloadAllLoadedObjects boolean
function UnityEngine_AssetBundle:Unload(unloadAllLoadedObjects) end
---@param unloadAllLoadedObjects boolean
---@return NotExportType
function UnityEngine_AssetBundle:UnloadAsync(unloadAllLoadedObjects) end
---@return NotExportType
function UnityEngine_AssetBundle:GetAllAssetNames() end
---@return NotExportType
function UnityEngine_AssetBundle:GetAllScenePaths() end

---@class UnityEngine.ParticleSystem : UnityEngine.Component
---@field isPlaying boolean
---@field isEmitting boolean
---@field isStopped boolean
---@field isPaused boolean
---@field particleCount number
---@field time number
---@field totalTime number
---@field randomSeed number
---@field useAutoRandomSeed boolean
---@field proceduralSimulationSupported boolean
---@field has3DParticleRotations boolean
---@field hasNonUniformParticleSizes boolean
---@field main NotExportType
---@field emission NotExportType
---@field shape NotExportType
---@field velocityOverLifetime NotExportType
---@field limitVelocityOverLifetime NotExportType
---@field inheritVelocity NotExportType
---@field lifetimeByEmitterSpeed NotExportType
---@field forceOverLifetime NotExportType
---@field colorOverLifetime NotExportType
---@field colorBySpeed NotExportType
---@field sizeOverLifetime NotExportType
---@field sizeBySpeed NotExportType
---@field rotationOverLifetime NotExportType
---@field rotationBySpeed NotExportType
---@field externalForces NotExportType
---@field noise NotExportType
---@field collision NotExportType
---@field trigger NotExportType
---@field textureSheetAnimation NotExportType
---@field lights NotExportType
---@field trails NotExportType
---@field customData NotExportType
local UnityEngine_ParticleSystem = {}
---@return UnityEngine.ParticleSystem
function UnityEngine_ParticleSystem.New() end
function UnityEngine_ParticleSystem.ResetPreMappedBufferMemory() end
---@param vertexBuffersCount number
---@param indexBuffersCount number
function UnityEngine_ParticleSystem.SetMaximumPreMappedBufferCounts(vertexBuffersCount, indexBuffersCount) end
---@param customData NotExportType
---@param streamIndex NotExportEnum
function UnityEngine_ParticleSystem:SetCustomParticleData(customData, streamIndex) end
---@param customData NotExportType
---@param streamIndex NotExportEnum
---@return number
function UnityEngine_ParticleSystem:GetCustomParticleData(customData, streamIndex) end
---@return NotExportType
function UnityEngine_ParticleSystem:GetPlaybackState() end
---@param playbackState NotExportType
function UnityEngine_ParticleSystem:SetPlaybackState(playbackState) end
---@overload fun() : NotExportType
---@param ref_trailData NotExportType
---@return number,NotExportType
function UnityEngine_ParticleSystem:GetTrails(ref_trailData) end
---@param trailData NotExportType
function UnityEngine_ParticleSystem:SetTrails(trailData) end
---@overload fun(t : number, withChildren : boolean, restart : boolean, fixedTimeStep : boolean)
---@overload fun(t : number, withChildren : boolean, restart : boolean)
---@overload fun(t : number, withChildren : boolean)
---@param t number
function UnityEngine_ParticleSystem:Simulate(t) end
---@overload fun(withChildren : boolean)
function UnityEngine_ParticleSystem:Play() end
---@overload fun(withChildren : boolean)
function UnityEngine_ParticleSystem:Pause() end
---@overload fun(withChildren : boolean, stopBehavior : NotExportEnum)
---@overload fun(withChildren : boolean)
function UnityEngine_ParticleSystem:Stop() end
---@overload fun(withChildren : boolean)
function UnityEngine_ParticleSystem:Clear() end
---@overload fun(withChildren : boolean) : boolean
---@return boolean
function UnityEngine_ParticleSystem:IsAlive() end
---@overload fun(count : number)
---@param emitParams NotExportType
---@param count number
function UnityEngine_ParticleSystem:Emit(emitParams, count) end
---@overload fun(subEmitterIndex : number)
---@overload fun(subEmitterIndex : number, ref_particle : NotExportType) : NotExportType
---@param subEmitterIndex number
---@param particles NotExportType
function UnityEngine_ParticleSystem:TriggerSubEmitter(subEmitterIndex, particles) end
function UnityEngine_ParticleSystem:AllocateAxisOfRotationAttribute() end
function UnityEngine_ParticleSystem:AllocateMeshIndexAttribute() end
---@param stream NotExportEnum
function UnityEngine_ParticleSystem:AllocateCustomDataAttribute(stream) end

---@class UnityEngine.AsyncOperation : UnityEngine.YieldInstruction
---@field isDone boolean
---@field progress number
---@field priority number
---@field allowSceneActivation boolean
local UnityEngine_AsyncOperation = {}
---@return UnityEngine.AsyncOperation
function UnityEngine_AsyncOperation.New() end

---@class UnityEngine.YieldInstruction : System.Object
local UnityEngine_YieldInstruction = {}
---@return UnityEngine.YieldInstruction
function UnityEngine_YieldInstruction.New() end

---@class UnityEngine.LightType
---@field Spot UnityEngine.LightType
---@field Directional UnityEngine.LightType
---@field Point UnityEngine.LightType
---@field Area UnityEngine.LightType
---@field Rectangle UnityEngine.LightType
---@field Disc UnityEngine.LightType
local UnityEngine_LightType = {}

---@class UnityEngine.SleepTimeout : System.Object
---@field NeverSleep number
---@field SystemSetting number
local UnityEngine_SleepTimeout = {}
---@return UnityEngine.SleepTimeout
function UnityEngine_SleepTimeout.New() end

---@class UnityEngine.Animator : UnityEngine.Behaviour
---@field isOptimizable boolean
---@field isHuman boolean
---@field hasRootMotion boolean
---@field humanScale number
---@field isInitialized boolean
---@field deltaPosition UnityEngine.Vector3
---@field deltaRotation UnityEngine.Quaternion
---@field velocity UnityEngine.Vector3
---@field angularVelocity UnityEngine.Vector3
---@field rootPosition UnityEngine.Vector3
---@field rootRotation UnityEngine.Quaternion
---@field applyRootMotion boolean
---@field updateMode NotExportEnum
---@field hasTransformHierarchy boolean
---@field gravityWeight number
---@field bodyPosition UnityEngine.Vector3
---@field bodyRotation UnityEngine.Quaternion
---@field stabilizeFeet boolean
---@field layerCount number
---@field parameters NotExportType
---@field parameterCount number
---@field feetPivotActive number
---@field pivotWeight number
---@field pivotPosition UnityEngine.Vector3
---@field isMatchingTarget boolean
---@field speed number
---@field targetPosition UnityEngine.Vector3
---@field targetRotation UnityEngine.Quaternion
---@field avatarRoot UnityEngine.Transform
---@field cullingMode NotExportEnum
---@field playbackTime number
---@field recorderStartTime number
---@field recorderStopTime number
---@field recorderMode NotExportEnum
---@field runtimeAnimatorController UnityEngine.RuntimeAnimatorController
---@field hasBoundPlayables boolean
---@field avatar NotExportType
---@field playableGraph NotExportType
---@field layersAffectMassCenter boolean
---@field leftFeetBottomHeight number
---@field rightFeetBottomHeight number
---@field logWarnings boolean
---@field fireEvents boolean
---@field keepAnimatorStateOnDisable boolean
---@field writeDefaultValuesOnDisable boolean
local UnityEngine_Animator = {}
---@return UnityEngine.Animator
function UnityEngine_Animator.New() end
---@param name string
---@return number
function UnityEngine_Animator.StringToHash(name) end
---@overload fun(name : string) : number
---@param id number
---@return number
function UnityEngine_Animator:GetFloat(id) end
---@overload fun(name : string, value : number)
---@overload fun(name : string, value : number, dampTime : number, deltaTime : number)
---@overload fun(id : number, value : number)
---@param id number
---@param value number
---@param dampTime number
---@param deltaTime number
function UnityEngine_Animator:SetFloat(id, value, dampTime, deltaTime) end
---@overload fun(name : string) : boolean
---@param id number
---@return boolean
function UnityEngine_Animator:GetBool(id) end
---@overload fun(name : string, value : boolean)
---@param id number
---@param value boolean
function UnityEngine_Animator:SetBool(id, value) end
---@overload fun(name : string) : number
---@param id number
---@return number
function UnityEngine_Animator:GetInteger(id) end
---@overload fun(name : string, value : number)
---@param id number
---@param value number
function UnityEngine_Animator:SetInteger(id, value) end
---@overload fun(name : string)
---@param id number
function UnityEngine_Animator:SetTrigger(id) end
---@overload fun(name : string)
---@param id number
function UnityEngine_Animator:ResetTrigger(id) end
---@overload fun(name : string) : boolean
---@param id number
---@return boolean
function UnityEngine_Animator:IsParameterControlledByCurve(id) end
---@param goal NotExportEnum
---@return UnityEngine.Vector3
function UnityEngine_Animator:GetIKPosition(goal) end
---@param goal NotExportEnum
---@param goalPosition UnityEngine.Vector3
function UnityEngine_Animator:SetIKPosition(goal, goalPosition) end
---@param goal NotExportEnum
---@return UnityEngine.Quaternion
function UnityEngine_Animator:GetIKRotation(goal) end
---@param goal NotExportEnum
---@param goalRotation UnityEngine.Quaternion
function UnityEngine_Animator:SetIKRotation(goal, goalRotation) end
---@param goal NotExportEnum
---@return number
function UnityEngine_Animator:GetIKPositionWeight(goal) end
---@param goal NotExportEnum
---@param value number
function UnityEngine_Animator:SetIKPositionWeight(goal, value) end
---@param goal NotExportEnum
---@return number
function UnityEngine_Animator:GetIKRotationWeight(goal) end
---@param goal NotExportEnum
---@param value number
function UnityEngine_Animator:SetIKRotationWeight(goal, value) end
---@param hint NotExportEnum
---@return UnityEngine.Vector3
function UnityEngine_Animator:GetIKHintPosition(hint) end
---@param hint NotExportEnum
---@param hintPosition UnityEngine.Vector3
function UnityEngine_Animator:SetIKHintPosition(hint, hintPosition) end
---@param hint NotExportEnum
---@return number
function UnityEngine_Animator:GetIKHintPositionWeight(hint) end
---@param hint NotExportEnum
---@param value number
function UnityEngine_Animator:SetIKHintPositionWeight(hint, value) end
---@param lookAtPosition UnityEngine.Vector3
function UnityEngine_Animator:SetLookAtPosition(lookAtPosition) end
---@overload fun(weight : number)
---@overload fun(weight : number, bodyWeight : number)
---@overload fun(weight : number, bodyWeight : number, headWeight : number)
---@overload fun(weight : number, bodyWeight : number, headWeight : number, eyesWeight : number)
---@param weight number
---@param bodyWeight number
---@param headWeight number
---@param eyesWeight number
---@param clampWeight number
function UnityEngine_Animator:SetLookAtWeight(weight, bodyWeight, headWeight, eyesWeight, clampWeight) end
---@param humanBoneId NotExportEnum
---@param rotation UnityEngine.Quaternion
function UnityEngine_Animator:SetBoneLocalRotation(humanBoneId, rotation) end
---@param fullPathHash number
---@param layerIndex number
---@return NotExportType
function UnityEngine_Animator:GetBehaviours(fullPathHash, layerIndex) end
---@param layerIndex number
---@return string
function UnityEngine_Animator:GetLayerName(layerIndex) end
---@param layerName string
---@return number
function UnityEngine_Animator:GetLayerIndex(layerName) end
---@param layerIndex number
---@return number
function UnityEngine_Animator:GetLayerWeight(layerIndex) end
---@param layerIndex number
---@param weight number
function UnityEngine_Animator:SetLayerWeight(layerIndex, weight) end
---@param layerIndex number
---@return UnityEngine.AnimatorStateInfo
function UnityEngine_Animator:GetCurrentAnimatorStateInfo(layerIndex) end
---@param layerIndex number
---@return UnityEngine.AnimatorStateInfo
function UnityEngine_Animator:GetNextAnimatorStateInfo(layerIndex) end
---@param layerIndex number
---@return NotExportType
function UnityEngine_Animator:GetAnimatorTransitionInfo(layerIndex) end
---@param layerIndex number
---@return number
function UnityEngine_Animator:GetCurrentAnimatorClipInfoCount(layerIndex) end
---@param layerIndex number
---@return number
function UnityEngine_Animator:GetNextAnimatorClipInfoCount(layerIndex) end
---@overload fun(layerIndex : number) : NotExportType
---@param layerIndex number
---@param clips NotExportType
function UnityEngine_Animator:GetCurrentAnimatorClipInfo(layerIndex, clips) end
---@overload fun(layerIndex : number) : NotExportType
---@param layerIndex number
---@param clips NotExportType
function UnityEngine_Animator:GetNextAnimatorClipInfo(layerIndex, clips) end
---@param layerIndex number
---@return boolean
function UnityEngine_Animator:IsInTransition(layerIndex) end
---@param index number
---@return NotExportType
function UnityEngine_Animator:GetParameter(index) end
---@overload fun(matchPosition : UnityEngine.Vector3, matchRotation : UnityEngine.Quaternion, targetBodyPart : NotExportEnum, weightMask : NotExportType, startNormalizedTime : number)
---@overload fun(matchPosition : UnityEngine.Vector3, matchRotation : UnityEngine.Quaternion, targetBodyPart : NotExportEnum, weightMask : NotExportType, startNormalizedTime : number, targetNormalizedTime : number)
---@param matchPosition UnityEngine.Vector3
---@param matchRotation UnityEngine.Quaternion
---@param targetBodyPart NotExportEnum
---@param weightMask NotExportType
---@param startNormalizedTime number
---@param targetNormalizedTime number
---@param completeMatch boolean
function UnityEngine_Animator:MatchTarget(matchPosition, matchRotation, targetBodyPart, weightMask, startNormalizedTime, targetNormalizedTime, completeMatch) end
---@overload fun()
---@param completeMatch boolean
function UnityEngine_Animator:InterruptMatchTarget(completeMatch) end
---@overload fun(stateName : string, fixedTransitionDuration : number)
---@overload fun(stateName : string, fixedTransitionDuration : number, layer : number)
---@overload fun(stateName : string, fixedTransitionDuration : number, layer : number, fixedTimeOffset : number)
---@overload fun(stateName : string, fixedTransitionDuration : number, layer : number, fixedTimeOffset : number, normalizedTransitionTime : number)
---@overload fun(stateHashName : number, fixedTransitionDuration : number, layer : number, fixedTimeOffset : number)
---@overload fun(stateHashName : number, fixedTransitionDuration : number, layer : number)
---@overload fun(stateHashName : number, fixedTransitionDuration : number)
---@param stateHashName number
---@param fixedTransitionDuration number
---@param layer number
---@param fixedTimeOffset number
---@param normalizedTransitionTime number
function UnityEngine_Animator:CrossFadeInFixedTime(stateHashName, fixedTransitionDuration, layer, fixedTimeOffset, normalizedTransitionTime) end
function UnityEngine_Animator:WriteDefaultValues() end
---@overload fun(stateName : string, normalizedTransitionDuration : number, layer : number, normalizedTimeOffset : number)
---@overload fun(stateName : string, normalizedTransitionDuration : number, layer : number)
---@overload fun(stateName : string, normalizedTransitionDuration : number)
---@overload fun(stateName : string, normalizedTransitionDuration : number, layer : number, normalizedTimeOffset : number, normalizedTransitionTime : number)
---@overload fun(stateHashName : number, normalizedTransitionDuration : number, layer : number, normalizedTimeOffset : number, normalizedTransitionTime : number)
---@overload fun(stateHashName : number, normalizedTransitionDuration : number, layer : number, normalizedTimeOffset : number)
---@overload fun(stateHashName : number, normalizedTransitionDuration : number, layer : number)
---@param stateHashName number
---@param normalizedTransitionDuration number
function UnityEngine_Animator:CrossFade(stateHashName, normalizedTransitionDuration) end
---@overload fun(stateName : string, layer : number)
---@overload fun(stateName : string)
---@overload fun(stateName : string, layer : number, fixedTime : number)
---@overload fun(stateNameHash : number, layer : number, fixedTime : number)
---@overload fun(stateNameHash : number, layer : number)
---@param stateNameHash number
function UnityEngine_Animator:PlayInFixedTime(stateNameHash) end
---@overload fun(stateName : string, layer : number)
---@overload fun(stateName : string)
---@overload fun(stateName : string, layer : number, normalizedTime : number)
---@overload fun(stateNameHash : number, layer : number, normalizedTime : number)
---@overload fun(stateNameHash : number, layer : number)
---@param stateNameHash number
function UnityEngine_Animator:Play(stateNameHash) end
---@param targetIndex NotExportEnum
---@param targetNormalizedTime number
function UnityEngine_Animator:SetTarget(targetIndex, targetNormalizedTime) end
---@param humanBoneId NotExportEnum
---@return UnityEngine.Transform
function UnityEngine_Animator:GetBoneTransform(humanBoneId) end
function UnityEngine_Animator:StartPlayback() end
function UnityEngine_Animator:StopPlayback() end
---@param frameCount number
function UnityEngine_Animator:StartRecording(frameCount) end
function UnityEngine_Animator:StopRecording() end
---@param layerIndex number
---@param stateID number
---@return boolean
function UnityEngine_Animator:HasState(layerIndex, stateID) end
---@param deltaTime number
function UnityEngine_Animator:Update(deltaTime) end
function UnityEngine_Animator:Rebind() end
function UnityEngine_Animator:ApplyBuiltinRootMotion() end

---@class UnityEngine.AnimatorStateInfo : System.ValueType
---@field fullPathHash number
---@field shortNameHash number
---@field normalizedTime number
---@field length number
---@field speed number
---@field speedMultiplier number
---@field tagHash number
---@field loop boolean
local UnityEngine_AnimatorStateInfo = {}
---@param name string
---@return boolean
function UnityEngine_AnimatorStateInfo:IsName(name) end
---@param tag string
---@return boolean
function UnityEngine_AnimatorStateInfo:IsTag(tag) end

---@class UnityEngine.Sprite : UnityEngine.Object
---@field bounds UnityEngine.Bounds
---@field rect UnityEngine.Rect
---@field border NotExportType
---@field texture UnityEngine.Texture2D
---@field pixelsPerUnit number
---@field spriteAtlasTextureScale number
---@field associatedAlphaSplitTexture UnityEngine.Texture2D
---@field pivot UnityEngine.Vector2
---@field packed boolean
---@field packingMode NotExportEnum
---@field packingRotation NotExportEnum
---@field textureRect UnityEngine.Rect
---@field textureRectOffset UnityEngine.Vector2
---@field vertices NotExportType
---@field triangles NotExportType
---@field uv NotExportType
local UnityEngine_Sprite = {}
---@overload fun(texture : UnityEngine.Texture2D, rect : UnityEngine.Rect, pivot : UnityEngine.Vector2, pixelsPerUnit : number, extrude : number, meshType : NotExportEnum, border : NotExportType, generateFallbackPhysicsShape : boolean) : UnityEngine.Sprite
---@overload fun(texture : UnityEngine.Texture2D, rect : UnityEngine.Rect, pivot : UnityEngine.Vector2, pixelsPerUnit : number, extrude : number, meshType : NotExportEnum, border : NotExportType, generateFallbackPhysicsShape : boolean, secondaryTextures : NotExportType) : UnityEngine.Sprite
---@overload fun(texture : UnityEngine.Texture2D, rect : UnityEngine.Rect, pivot : UnityEngine.Vector2, pixelsPerUnit : number, extrude : number, meshType : NotExportEnum, border : NotExportType) : UnityEngine.Sprite
---@overload fun(texture : UnityEngine.Texture2D, rect : UnityEngine.Rect, pivot : UnityEngine.Vector2, pixelsPerUnit : number, extrude : number, meshType : NotExportEnum) : UnityEngine.Sprite
---@overload fun(texture : UnityEngine.Texture2D, rect : UnityEngine.Rect, pivot : UnityEngine.Vector2, pixelsPerUnit : number, extrude : number) : UnityEngine.Sprite
---@overload fun(texture : UnityEngine.Texture2D, rect : UnityEngine.Rect, pivot : UnityEngine.Vector2, pixelsPerUnit : number) : UnityEngine.Sprite
---@param texture UnityEngine.Texture2D
---@param rect UnityEngine.Rect
---@param pivot UnityEngine.Vector2
---@return UnityEngine.Sprite
function UnityEngine_Sprite.Create(texture, rect, pivot) end
---@return number
function UnityEngine_Sprite:GetSecondaryTextureCount() end
---@param secondaryTexture NotExportType
---@return number
function UnityEngine_Sprite:GetSecondaryTextures(secondaryTexture) end
---@return number
function UnityEngine_Sprite:GetPhysicsShapeCount() end
---@param shapeIdx number
---@return number
function UnityEngine_Sprite:GetPhysicsShapePointCount(shapeIdx) end
---@param shapeIdx number
---@param physicsShape NotExportType
---@return number
function UnityEngine_Sprite:GetPhysicsShape(shapeIdx, physicsShape) end
---@param physicsShapes NotExportType
function UnityEngine_Sprite:OverridePhysicsShape(physicsShapes) end
---@param vertices NotExportType
---@param triangles NotExportType
function UnityEngine_Sprite:OverrideGeometry(vertices, triangles) end

---@class UnityEngine.UI.Image : UnityEngine.UI.MaskableGraphic
---@field defaultETC1GraphicMaterial UnityEngine.Material
---@field sprite UnityEngine.Sprite
---@field overrideSprite UnityEngine.Sprite
---@field type NotExportEnum
---@field preserveAspect boolean
---@field fillCenter boolean
---@field fillMethod NotExportEnum
---@field fillAmount number
---@field fillClockwise boolean
---@field fillOrigin number
---@field alphaHitTestMinimumThreshold number
---@field useSpriteMesh boolean
---@field mainTexture UnityEngine.Texture
---@field hasBorder boolean
---@field pixelsPerUnitMultiplier number
---@field pixelsPerUnit number
---@field material UnityEngine.Material
---@field minWidth number
---@field preferredWidth number
---@field flexibleWidth number
---@field minHeight number
---@field preferredHeight number
---@field flexibleHeight number
---@field layoutPriority number
local UnityEngine_UI_Image = {}
function UnityEngine_UI_Image:DisableSpriteOptimizations() end
function UnityEngine_UI_Image:OnBeforeSerialize() end
function UnityEngine_UI_Image:OnAfterDeserialize() end
function UnityEngine_UI_Image:SetNativeSize() end
function UnityEngine_UI_Image:CalculateLayoutInputHorizontal() end
function UnityEngine_UI_Image:CalculateLayoutInputVertical() end
---@param screenPoint UnityEngine.Vector2
---@param eventCamera UnityEngine.Camera
---@return boolean
function UnityEngine_UI_Image:IsRaycastLocationValid(screenPoint, eventCamera) end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_UI_Image:DOColor(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_UI_Image:DOFade(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_UI_Image:DOFillAmount(endValue, duration) end
---@param gradient NotExportType
---@param duration number
---@return DG.Tweening.Sequence
function UnityEngine_UI_Image:DOGradientColor(gradient, duration) end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Tweener
function UnityEngine_UI_Image:DOBlendableColor(endValue, duration) end

---@class UnityEngine.UI.MaskableGraphic : UnityEngine.UI.Graphic
---@field onCullStateChanged NotExportType
---@field maskable boolean
---@field isMaskingGraphic boolean
local UnityEngine_UI_MaskableGraphic = {}
---@param baseMaterial UnityEngine.Material
---@return UnityEngine.Material
function UnityEngine_UI_MaskableGraphic:GetModifiedMaterial(baseMaterial) end
---@param clipRect UnityEngine.Rect
---@param validRect boolean
function UnityEngine_UI_MaskableGraphic:Cull(clipRect, validRect) end
---@param clipRect UnityEngine.Rect
---@param validRect boolean
function UnityEngine_UI_MaskableGraphic:SetClipRect(clipRect, validRect) end
---@param clipSoftness UnityEngine.Vector2
function UnityEngine_UI_MaskableGraphic:SetClipSoftness(clipSoftness) end
function UnityEngine_UI_MaskableGraphic:RecalculateClipping() end
function UnityEngine_UI_MaskableGraphic:RecalculateMasking() end

---@class UnityEngine.UI.Graphic : UnityEngine.EventSystems.UIBehaviour
---@field defaultGraphicMaterial UnityEngine.Material
---@field color UnityEngine.Color
---@field raycastTarget boolean
---@field raycastPadding NotExportType
---@field depth number
---@field rectTransform UnityEngine.RectTransform
---@field canvas UnityEngine.Canvas
---@field canvasRenderer UnityEngine.CanvasRenderer
---@field defaultMaterial UnityEngine.Material
---@field material UnityEngine.Material
---@field materialForRendering UnityEngine.Material
---@field mainTexture UnityEngine.Texture
local UnityEngine_UI_Graphic = {}
function UnityEngine_UI_Graphic:SetAllDirty() end
function UnityEngine_UI_Graphic:SetLayoutDirty() end
function UnityEngine_UI_Graphic:SetVerticesDirty() end
function UnityEngine_UI_Graphic:SetMaterialDirty() end
function UnityEngine_UI_Graphic:SetRaycastDirty() end
function UnityEngine_UI_Graphic:OnCullingChanged() end
---@param update NotExportEnum
function UnityEngine_UI_Graphic:Rebuild(update) end
function UnityEngine_UI_Graphic:LayoutComplete() end
function UnityEngine_UI_Graphic:GraphicUpdateComplete() end
function UnityEngine_UI_Graphic:SetNativeSize() end
---@param sp UnityEngine.Vector2
---@param eventCamera UnityEngine.Camera
---@return boolean
function UnityEngine_UI_Graphic:Raycast(sp, eventCamera) end
---@param point UnityEngine.Vector2
---@return UnityEngine.Vector2
function UnityEngine_UI_Graphic:PixelAdjustPoint(point) end
---@return UnityEngine.Rect
function UnityEngine_UI_Graphic:GetPixelAdjustedRect() end
---@overload fun(targetColor : UnityEngine.Color, duration : number, ignoreTimeScale : boolean, useAlpha : boolean)
---@param targetColor UnityEngine.Color
---@param duration number
---@param ignoreTimeScale boolean
---@param useAlpha boolean
---@param useRGB boolean
function UnityEngine_UI_Graphic:CrossFadeColor(targetColor, duration, ignoreTimeScale, useAlpha, useRGB) end
---@param alpha number
---@param duration number
---@param ignoreTimeScale boolean
function UnityEngine_UI_Graphic:CrossFadeAlpha(alpha, duration, ignoreTimeScale) end
---@param action NotExportType
function UnityEngine_UI_Graphic:RegisterDirtyLayoutCallback(action) end
---@param action NotExportType
function UnityEngine_UI_Graphic:UnregisterDirtyLayoutCallback(action) end
---@param action NotExportType
function UnityEngine_UI_Graphic:RegisterDirtyVerticesCallback(action) end
---@param action NotExportType
function UnityEngine_UI_Graphic:UnregisterDirtyVerticesCallback(action) end
---@param action NotExportType
function UnityEngine_UI_Graphic:RegisterDirtyMaterialCallback(action) end
---@param action NotExportType
function UnityEngine_UI_Graphic:UnregisterDirtyMaterialCallback(action) end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_UI_Graphic:DOColor(endValue, duration) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_UI_Graphic:DOFade(endValue, duration) end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Tweener
function UnityEngine_UI_Graphic:DOBlendableColor(endValue, duration) end

---@class UnityEngine.UI.Text : UnityEngine.UI.MaskableGraphic
---@field cachedTextGenerator NotExportType
---@field cachedTextGeneratorForLayout NotExportType
---@field mainTexture UnityEngine.Texture
---@field font NotExportType
---@field text string
---@field supportRichText boolean
---@field resizeTextForBestFit boolean
---@field resizeTextMinSize number
---@field resizeTextMaxSize number
---@field alignment NotExportEnum
---@field alignByGeometry boolean
---@field fontSize number
---@field horizontalOverflow NotExportEnum
---@field verticalOverflow NotExportEnum
---@field lineSpacing number
---@field fontStyle NotExportEnum
---@field pixelsPerUnit number
---@field minWidth number
---@field preferredWidth number
---@field flexibleWidth number
---@field minHeight number
---@field preferredHeight number
---@field flexibleHeight number
---@field layoutPriority number
local UnityEngine_UI_Text = {}
---@param anchor NotExportEnum
---@return UnityEngine.Vector2
function UnityEngine_UI_Text.GetTextAnchorPivot(anchor) end
function UnityEngine_UI_Text:FontTextureChanged() end
---@param extents UnityEngine.Vector2
---@return NotExportType
function UnityEngine_UI_Text:GetGenerationSettings(extents) end
function UnityEngine_UI_Text:CalculateLayoutInputHorizontal() end
function UnityEngine_UI_Text:CalculateLayoutInputVertical() end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_UI_Text:DOColor(endValue, duration) end
---@param fromValue number
---@param endValue number
---@param duration number
---@param addThousandsSeparator boolean
---@param culture NotExportType
---@return DG.Tweening.Core.TweenerCore_int_int_DG_Tweening_Plugins_Options_NoOptions
function UnityEngine_UI_Text:DOCounter(fromValue, endValue, duration, addThousandsSeparator, culture) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Color_UnityEngine_Color_DG_Tweening_Plugins_Options_ColorOptions
function UnityEngine_UI_Text:DOFade(endValue, duration) end
---@param endValue string
---@param duration number
---@param richTextEnabled boolean
---@param scrambleMode NotExportEnum
---@param scrambleChars string
---@return NotExportType
function UnityEngine_UI_Text:DOText(endValue, duration, richTextEnabled, scrambleMode, scrambleChars) end
---@param endValue UnityEngine.Color
---@param duration number
---@return DG.Tweening.Tweener
function UnityEngine_UI_Text:DOBlendableColor(endValue, duration) end

---@class UnityEngine.RectTransform : UnityEngine.Transform
---@field rect UnityEngine.Rect
---@field anchorMin UnityEngine.Vector2
---@field anchorMax UnityEngine.Vector2
---@field anchoredPosition UnityEngine.Vector2
---@field sizeDelta UnityEngine.Vector2
---@field pivot UnityEngine.Vector2
---@field anchoredPosition3D UnityEngine.Vector3
---@field offsetMin UnityEngine.Vector2
---@field offsetMax UnityEngine.Vector2
---@field drivenByObject UnityEngine.Object
local UnityEngine_RectTransform = {}
---@return UnityEngine.RectTransform
function UnityEngine_RectTransform.New() end
function UnityEngine_RectTransform:ForceUpdateRectTransforms() end
---@param fourCornersArray NotExportType
function UnityEngine_RectTransform:GetLocalCorners(fourCornersArray) end
---@param fourCornersArray NotExportType
function UnityEngine_RectTransform:GetWorldCorners(fourCornersArray) end
---@param edge NotExportEnum
---@param inset number
---@param size number
function UnityEngine_RectTransform:SetInsetAndSizeFromParentEdge(edge, inset, size) end
---@param axis NotExportEnum
---@param size number
function UnityEngine_RectTransform:SetSizeWithCurrentAnchors(axis, size) end
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return NotExportType
function UnityEngine_RectTransform:DOAnchorPos(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return NotExportType
function UnityEngine_RectTransform:DOAnchorPosX(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return NotExportType
function UnityEngine_RectTransform:DOAnchorPosY(endValue, duration, snapping) end
---@param endValue UnityEngine.Vector3
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_RectTransform:DOAnchorPos3D(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_RectTransform:DOAnchorPos3DX(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_RectTransform:DOAnchorPos3DY(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_UnityEngine_Vector3_UnityEngine_Vector3_NotExportType
function UnityEngine_RectTransform:DOAnchorPos3DZ(endValue, duration, snapping) end
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return NotExportType
function UnityEngine_RectTransform:DOAnchorMax(endValue, duration, snapping) end
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return NotExportType
function UnityEngine_RectTransform:DOAnchorMin(endValue, duration, snapping) end
---@param endValue UnityEngine.Vector2
---@param duration number
---@return NotExportType
function UnityEngine_RectTransform:DOPivot(endValue, duration) end
---@param endValue number
---@param duration number
---@return NotExportType
function UnityEngine_RectTransform:DOPivotX(endValue, duration) end
---@param endValue number
---@param duration number
---@return NotExportType
function UnityEngine_RectTransform:DOPivotY(endValue, duration) end
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return NotExportType
function UnityEngine_RectTransform:DOSizeDelta(endValue, duration, snapping) end
---@param punch UnityEngine.Vector2
---@param duration number
---@param vibrato number
---@param elasticity number
---@param snapping boolean
---@return DG.Tweening.Tweener
function UnityEngine_RectTransform:DOPunchAnchorPos(punch, duration, vibrato, elasticity, snapping) end
---@param duration number
---@param strength number
---@param vibrato number
---@param randomness number
---@param snapping boolean
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_RectTransform:DOShakeAnchorPos(duration, strength, vibrato, randomness, snapping, fadeOut, randomnessMode) end
---@param duration number
---@param strength UnityEngine.Vector2
---@param vibrato number
---@param randomness number
---@param snapping boolean
---@param fadeOut boolean
---@param randomnessMode NotExportEnum
---@return DG.Tweening.Tweener
function UnityEngine_RectTransform:DOShakeAnchorPos(duration, strength, vibrato, randomness, snapping, fadeOut, randomnessMode) end
---@param endValue UnityEngine.Vector2
---@param jumpPower number
---@param numJumps number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Sequence
function UnityEngine_RectTransform:DOJumpAnchorPos(endValue, jumpPower, numJumps, duration, snapping) end
---@param center UnityEngine.Vector2
---@param endValueDegrees number
---@param duration number
---@param relativeCenter boolean
---@param snapping boolean
---@return NotExportType
function UnityEngine_RectTransform:DOShapeCircle(center, endValueDegrees, duration, relativeCenter, snapping) end

---@class UnityEngine.Input : System.Object
---@field simulateMouseWithTouches boolean
---@field anyKey boolean
---@field anyKeyDown boolean
---@field inputString string
---@field mousePosition UnityEngine.Vector3
---@field mouseScrollDelta UnityEngine.Vector2
---@field imeCompositionMode NotExportEnum
---@field compositionString string
---@field imeIsSelected boolean
---@field compositionCursorPos UnityEngine.Vector2
---@field mousePresent boolean
---@field penEventCount number
---@field touchCount number
---@field touchPressureSupported boolean
---@field stylusTouchSupported boolean
---@field touchSupported boolean
---@field multiTouchEnabled boolean
---@field deviceOrientation NotExportEnum
---@field acceleration UnityEngine.Vector3
---@field compensateSensors boolean
---@field accelerationEventCount number
---@field backButtonLeavesApp boolean
---@field location NotExportType
---@field compass NotExportType
---@field gyro NotExportType
---@field touches NotExportType
---@field accelerationEvents NotExportType
local UnityEngine_Input = {}
---@return UnityEngine.Input
function UnityEngine_Input.New() end
---@param axisName string
---@return number
function UnityEngine_Input.GetAxis(axisName) end
---@param axisName string
---@return number
function UnityEngine_Input.GetAxisRaw(axisName) end
---@param buttonName string
---@return boolean
function UnityEngine_Input.GetButton(buttonName) end
---@param buttonName string
---@return boolean
function UnityEngine_Input.GetButtonDown(buttonName) end
---@param buttonName string
---@return boolean
function UnityEngine_Input.GetButtonUp(buttonName) end
---@param button number
---@return boolean
function UnityEngine_Input.GetMouseButton(button) end
---@param button number
---@return boolean
function UnityEngine_Input.GetMouseButtonDown(button) end
---@param button number
---@return boolean
function UnityEngine_Input.GetMouseButtonUp(button) end
function UnityEngine_Input.ResetInputAxes() end
---@return NotExportType
function UnityEngine_Input.GetJoystickNames() end
---@param index number
---@return UnityEngine.Touch
function UnityEngine_Input.GetTouch(index) end
---@param index number
---@return NotExportType
function UnityEngine_Input.GetPenEvent(index) end
---@return NotExportType
function UnityEngine_Input.GetLastPenContactEvent() end
function UnityEngine_Input.ResetPenEvents() end
function UnityEngine_Input.ClearLastPenContactEvent() end
---@param index number
---@return NotExportType
function UnityEngine_Input.GetAccelerationEvent(index) end
---@overload fun(key : UnityEngine.KeyCode) : boolean
---@param name string
---@return boolean
function UnityEngine_Input.GetKey(name) end
---@overload fun(key : UnityEngine.KeyCode) : boolean
---@param name string
---@return boolean
function UnityEngine_Input.GetKeyUp(name) end
---@overload fun(key : UnityEngine.KeyCode) : boolean
---@param name string
---@return boolean
function UnityEngine_Input.GetKeyDown(name) end

---@class UnityEngine.KeyCode
---@field None UnityEngine.KeyCode
---@field Backspace UnityEngine.KeyCode
---@field Delete UnityEngine.KeyCode
---@field Tab UnityEngine.KeyCode
---@field Clear UnityEngine.KeyCode
---@field Return UnityEngine.KeyCode
---@field Pause UnityEngine.KeyCode
---@field Escape UnityEngine.KeyCode
---@field Space UnityEngine.KeyCode
---@field Keypad0 UnityEngine.KeyCode
---@field Keypad1 UnityEngine.KeyCode
---@field Keypad2 UnityEngine.KeyCode
---@field Keypad3 UnityEngine.KeyCode
---@field Keypad4 UnityEngine.KeyCode
---@field Keypad5 UnityEngine.KeyCode
---@field Keypad6 UnityEngine.KeyCode
---@field Keypad7 UnityEngine.KeyCode
---@field Keypad8 UnityEngine.KeyCode
---@field Keypad9 UnityEngine.KeyCode
---@field KeypadPeriod UnityEngine.KeyCode
---@field KeypadDivide UnityEngine.KeyCode
---@field KeypadMultiply UnityEngine.KeyCode
---@field KeypadMinus UnityEngine.KeyCode
---@field KeypadPlus UnityEngine.KeyCode
---@field KeypadEnter UnityEngine.KeyCode
---@field KeypadEquals UnityEngine.KeyCode
---@field UpArrow UnityEngine.KeyCode
---@field DownArrow UnityEngine.KeyCode
---@field RightArrow UnityEngine.KeyCode
---@field LeftArrow UnityEngine.KeyCode
---@field Insert UnityEngine.KeyCode
---@field Home UnityEngine.KeyCode
---@field End UnityEngine.KeyCode
---@field PageUp UnityEngine.KeyCode
---@field PageDown UnityEngine.KeyCode
---@field F1 UnityEngine.KeyCode
---@field F2 UnityEngine.KeyCode
---@field F3 UnityEngine.KeyCode
---@field F4 UnityEngine.KeyCode
---@field F5 UnityEngine.KeyCode
---@field F6 UnityEngine.KeyCode
---@field F7 UnityEngine.KeyCode
---@field F8 UnityEngine.KeyCode
---@field F9 UnityEngine.KeyCode
---@field F10 UnityEngine.KeyCode
---@field F11 UnityEngine.KeyCode
---@field F12 UnityEngine.KeyCode
---@field F13 UnityEngine.KeyCode
---@field F14 UnityEngine.KeyCode
---@field F15 UnityEngine.KeyCode
---@field Alpha0 UnityEngine.KeyCode
---@field Alpha1 UnityEngine.KeyCode
---@field Alpha2 UnityEngine.KeyCode
---@field Alpha3 UnityEngine.KeyCode
---@field Alpha4 UnityEngine.KeyCode
---@field Alpha5 UnityEngine.KeyCode
---@field Alpha6 UnityEngine.KeyCode
---@field Alpha7 UnityEngine.KeyCode
---@field Alpha8 UnityEngine.KeyCode
---@field Alpha9 UnityEngine.KeyCode
---@field Exclaim UnityEngine.KeyCode
---@field DoubleQuote UnityEngine.KeyCode
---@field Hash UnityEngine.KeyCode
---@field Dollar UnityEngine.KeyCode
---@field Percent UnityEngine.KeyCode
---@field Ampersand UnityEngine.KeyCode
---@field Quote UnityEngine.KeyCode
---@field LeftParen UnityEngine.KeyCode
---@field RightParen UnityEngine.KeyCode
---@field Asterisk UnityEngine.KeyCode
---@field Plus UnityEngine.KeyCode
---@field Comma UnityEngine.KeyCode
---@field Minus UnityEngine.KeyCode
---@field Period UnityEngine.KeyCode
---@field Slash UnityEngine.KeyCode
---@field Colon UnityEngine.KeyCode
---@field Semicolon UnityEngine.KeyCode
---@field Less UnityEngine.KeyCode
---@field Equals UnityEngine.KeyCode
---@field Greater UnityEngine.KeyCode
---@field Question UnityEngine.KeyCode
---@field At UnityEngine.KeyCode
---@field LeftBracket UnityEngine.KeyCode
---@field Backslash UnityEngine.KeyCode
---@field RightBracket UnityEngine.KeyCode
---@field Caret UnityEngine.KeyCode
---@field Underscore UnityEngine.KeyCode
---@field BackQuote UnityEngine.KeyCode
---@field A UnityEngine.KeyCode
---@field B UnityEngine.KeyCode
---@field C UnityEngine.KeyCode
---@field D UnityEngine.KeyCode
---@field E UnityEngine.KeyCode
---@field F UnityEngine.KeyCode
---@field G UnityEngine.KeyCode
---@field H UnityEngine.KeyCode
---@field I UnityEngine.KeyCode
---@field J UnityEngine.KeyCode
---@field K UnityEngine.KeyCode
---@field L UnityEngine.KeyCode
---@field M UnityEngine.KeyCode
---@field N UnityEngine.KeyCode
---@field O UnityEngine.KeyCode
---@field P UnityEngine.KeyCode
---@field Q UnityEngine.KeyCode
---@field R UnityEngine.KeyCode
---@field S UnityEngine.KeyCode
---@field T UnityEngine.KeyCode
---@field U UnityEngine.KeyCode
---@field V UnityEngine.KeyCode
---@field W UnityEngine.KeyCode
---@field X UnityEngine.KeyCode
---@field Y UnityEngine.KeyCode
---@field Z UnityEngine.KeyCode
---@field LeftCurlyBracket UnityEngine.KeyCode
---@field Pipe UnityEngine.KeyCode
---@field RightCurlyBracket UnityEngine.KeyCode
---@field Tilde UnityEngine.KeyCode
---@field Numlock UnityEngine.KeyCode
---@field CapsLock UnityEngine.KeyCode
---@field ScrollLock UnityEngine.KeyCode
---@field RightShift UnityEngine.KeyCode
---@field LeftShift UnityEngine.KeyCode
---@field RightControl UnityEngine.KeyCode
---@field LeftControl UnityEngine.KeyCode
---@field RightAlt UnityEngine.KeyCode
---@field LeftAlt UnityEngine.KeyCode
---@field LeftMeta UnityEngine.KeyCode
---@field LeftCommand UnityEngine.KeyCode
---@field LeftApple UnityEngine.KeyCode
---@field LeftWindows UnityEngine.KeyCode
---@field RightMeta UnityEngine.KeyCode
---@field RightCommand UnityEngine.KeyCode
---@field RightApple UnityEngine.KeyCode
---@field RightWindows UnityEngine.KeyCode
---@field AltGr UnityEngine.KeyCode
---@field Help UnityEngine.KeyCode
---@field Print UnityEngine.KeyCode
---@field SysReq UnityEngine.KeyCode
---@field Break UnityEngine.KeyCode
---@field Menu UnityEngine.KeyCode
---@field Mouse0 UnityEngine.KeyCode
---@field Mouse1 UnityEngine.KeyCode
---@field Mouse2 UnityEngine.KeyCode
---@field Mouse3 UnityEngine.KeyCode
---@field Mouse4 UnityEngine.KeyCode
---@field Mouse5 UnityEngine.KeyCode
---@field Mouse6 UnityEngine.KeyCode
---@field JoystickButton0 UnityEngine.KeyCode
---@field JoystickButton1 UnityEngine.KeyCode
---@field JoystickButton2 UnityEngine.KeyCode
---@field JoystickButton3 UnityEngine.KeyCode
---@field JoystickButton4 UnityEngine.KeyCode
---@field JoystickButton5 UnityEngine.KeyCode
---@field JoystickButton6 UnityEngine.KeyCode
---@field JoystickButton7 UnityEngine.KeyCode
---@field JoystickButton8 UnityEngine.KeyCode
---@field JoystickButton9 UnityEngine.KeyCode
---@field JoystickButton10 UnityEngine.KeyCode
---@field JoystickButton11 UnityEngine.KeyCode
---@field JoystickButton12 UnityEngine.KeyCode
---@field JoystickButton13 UnityEngine.KeyCode
---@field JoystickButton14 UnityEngine.KeyCode
---@field JoystickButton15 UnityEngine.KeyCode
---@field JoystickButton16 UnityEngine.KeyCode
---@field JoystickButton17 UnityEngine.KeyCode
---@field JoystickButton18 UnityEngine.KeyCode
---@field JoystickButton19 UnityEngine.KeyCode
---@field Joystick1Button0 UnityEngine.KeyCode
---@field Joystick1Button1 UnityEngine.KeyCode
---@field Joystick1Button2 UnityEngine.KeyCode
---@field Joystick1Button3 UnityEngine.KeyCode
---@field Joystick1Button4 UnityEngine.KeyCode
---@field Joystick1Button5 UnityEngine.KeyCode
---@field Joystick1Button6 UnityEngine.KeyCode
---@field Joystick1Button7 UnityEngine.KeyCode
---@field Joystick1Button8 UnityEngine.KeyCode
---@field Joystick1Button9 UnityEngine.KeyCode
---@field Joystick1Button10 UnityEngine.KeyCode
---@field Joystick1Button11 UnityEngine.KeyCode
---@field Joystick1Button12 UnityEngine.KeyCode
---@field Joystick1Button13 UnityEngine.KeyCode
---@field Joystick1Button14 UnityEngine.KeyCode
---@field Joystick1Button15 UnityEngine.KeyCode
---@field Joystick1Button16 UnityEngine.KeyCode
---@field Joystick1Button17 UnityEngine.KeyCode
---@field Joystick1Button18 UnityEngine.KeyCode
---@field Joystick1Button19 UnityEngine.KeyCode
---@field Joystick2Button0 UnityEngine.KeyCode
---@field Joystick2Button1 UnityEngine.KeyCode
---@field Joystick2Button2 UnityEngine.KeyCode
---@field Joystick2Button3 UnityEngine.KeyCode
---@field Joystick2Button4 UnityEngine.KeyCode
---@field Joystick2Button5 UnityEngine.KeyCode
---@field Joystick2Button6 UnityEngine.KeyCode
---@field Joystick2Button7 UnityEngine.KeyCode
---@field Joystick2Button8 UnityEngine.KeyCode
---@field Joystick2Button9 UnityEngine.KeyCode
---@field Joystick2Button10 UnityEngine.KeyCode
---@field Joystick2Button11 UnityEngine.KeyCode
---@field Joystick2Button12 UnityEngine.KeyCode
---@field Joystick2Button13 UnityEngine.KeyCode
---@field Joystick2Button14 UnityEngine.KeyCode
---@field Joystick2Button15 UnityEngine.KeyCode
---@field Joystick2Button16 UnityEngine.KeyCode
---@field Joystick2Button17 UnityEngine.KeyCode
---@field Joystick2Button18 UnityEngine.KeyCode
---@field Joystick2Button19 UnityEngine.KeyCode
---@field Joystick3Button0 UnityEngine.KeyCode
---@field Joystick3Button1 UnityEngine.KeyCode
---@field Joystick3Button2 UnityEngine.KeyCode
---@field Joystick3Button3 UnityEngine.KeyCode
---@field Joystick3Button4 UnityEngine.KeyCode
---@field Joystick3Button5 UnityEngine.KeyCode
---@field Joystick3Button6 UnityEngine.KeyCode
---@field Joystick3Button7 UnityEngine.KeyCode
---@field Joystick3Button8 UnityEngine.KeyCode
---@field Joystick3Button9 UnityEngine.KeyCode
---@field Joystick3Button10 UnityEngine.KeyCode
---@field Joystick3Button11 UnityEngine.KeyCode
---@field Joystick3Button12 UnityEngine.KeyCode
---@field Joystick3Button13 UnityEngine.KeyCode
---@field Joystick3Button14 UnityEngine.KeyCode
---@field Joystick3Button15 UnityEngine.KeyCode
---@field Joystick3Button16 UnityEngine.KeyCode
---@field Joystick3Button17 UnityEngine.KeyCode
---@field Joystick3Button18 UnityEngine.KeyCode
---@field Joystick3Button19 UnityEngine.KeyCode
---@field Joystick4Button0 UnityEngine.KeyCode
---@field Joystick4Button1 UnityEngine.KeyCode
---@field Joystick4Button2 UnityEngine.KeyCode
---@field Joystick4Button3 UnityEngine.KeyCode
---@field Joystick4Button4 UnityEngine.KeyCode
---@field Joystick4Button5 UnityEngine.KeyCode
---@field Joystick4Button6 UnityEngine.KeyCode
---@field Joystick4Button7 UnityEngine.KeyCode
---@field Joystick4Button8 UnityEngine.KeyCode
---@field Joystick4Button9 UnityEngine.KeyCode
---@field Joystick4Button10 UnityEngine.KeyCode
---@field Joystick4Button11 UnityEngine.KeyCode
---@field Joystick4Button12 UnityEngine.KeyCode
---@field Joystick4Button13 UnityEngine.KeyCode
---@field Joystick4Button14 UnityEngine.KeyCode
---@field Joystick4Button15 UnityEngine.KeyCode
---@field Joystick4Button16 UnityEngine.KeyCode
---@field Joystick4Button17 UnityEngine.KeyCode
---@field Joystick4Button18 UnityEngine.KeyCode
---@field Joystick4Button19 UnityEngine.KeyCode
---@field Joystick5Button0 UnityEngine.KeyCode
---@field Joystick5Button1 UnityEngine.KeyCode
---@field Joystick5Button2 UnityEngine.KeyCode
---@field Joystick5Button3 UnityEngine.KeyCode
---@field Joystick5Button4 UnityEngine.KeyCode
---@field Joystick5Button5 UnityEngine.KeyCode
---@field Joystick5Button6 UnityEngine.KeyCode
---@field Joystick5Button7 UnityEngine.KeyCode
---@field Joystick5Button8 UnityEngine.KeyCode
---@field Joystick5Button9 UnityEngine.KeyCode
---@field Joystick5Button10 UnityEngine.KeyCode
---@field Joystick5Button11 UnityEngine.KeyCode
---@field Joystick5Button12 UnityEngine.KeyCode
---@field Joystick5Button13 UnityEngine.KeyCode
---@field Joystick5Button14 UnityEngine.KeyCode
---@field Joystick5Button15 UnityEngine.KeyCode
---@field Joystick5Button16 UnityEngine.KeyCode
---@field Joystick5Button17 UnityEngine.KeyCode
---@field Joystick5Button18 UnityEngine.KeyCode
---@field Joystick5Button19 UnityEngine.KeyCode
---@field Joystick6Button0 UnityEngine.KeyCode
---@field Joystick6Button1 UnityEngine.KeyCode
---@field Joystick6Button2 UnityEngine.KeyCode
---@field Joystick6Button3 UnityEngine.KeyCode
---@field Joystick6Button4 UnityEngine.KeyCode
---@field Joystick6Button5 UnityEngine.KeyCode
---@field Joystick6Button6 UnityEngine.KeyCode
---@field Joystick6Button7 UnityEngine.KeyCode
---@field Joystick6Button8 UnityEngine.KeyCode
---@field Joystick6Button9 UnityEngine.KeyCode
---@field Joystick6Button10 UnityEngine.KeyCode
---@field Joystick6Button11 UnityEngine.KeyCode
---@field Joystick6Button12 UnityEngine.KeyCode
---@field Joystick6Button13 UnityEngine.KeyCode
---@field Joystick6Button14 UnityEngine.KeyCode
---@field Joystick6Button15 UnityEngine.KeyCode
---@field Joystick6Button16 UnityEngine.KeyCode
---@field Joystick6Button17 UnityEngine.KeyCode
---@field Joystick6Button18 UnityEngine.KeyCode
---@field Joystick6Button19 UnityEngine.KeyCode
---@field Joystick7Button0 UnityEngine.KeyCode
---@field Joystick7Button1 UnityEngine.KeyCode
---@field Joystick7Button2 UnityEngine.KeyCode
---@field Joystick7Button3 UnityEngine.KeyCode
---@field Joystick7Button4 UnityEngine.KeyCode
---@field Joystick7Button5 UnityEngine.KeyCode
---@field Joystick7Button6 UnityEngine.KeyCode
---@field Joystick7Button7 UnityEngine.KeyCode
---@field Joystick7Button8 UnityEngine.KeyCode
---@field Joystick7Button9 UnityEngine.KeyCode
---@field Joystick7Button10 UnityEngine.KeyCode
---@field Joystick7Button11 UnityEngine.KeyCode
---@field Joystick7Button12 UnityEngine.KeyCode
---@field Joystick7Button13 UnityEngine.KeyCode
---@field Joystick7Button14 UnityEngine.KeyCode
---@field Joystick7Button15 UnityEngine.KeyCode
---@field Joystick7Button16 UnityEngine.KeyCode
---@field Joystick7Button17 UnityEngine.KeyCode
---@field Joystick7Button18 UnityEngine.KeyCode
---@field Joystick7Button19 UnityEngine.KeyCode
---@field Joystick8Button0 UnityEngine.KeyCode
---@field Joystick8Button1 UnityEngine.KeyCode
---@field Joystick8Button2 UnityEngine.KeyCode
---@field Joystick8Button3 UnityEngine.KeyCode
---@field Joystick8Button4 UnityEngine.KeyCode
---@field Joystick8Button5 UnityEngine.KeyCode
---@field Joystick8Button6 UnityEngine.KeyCode
---@field Joystick8Button7 UnityEngine.KeyCode
---@field Joystick8Button8 UnityEngine.KeyCode
---@field Joystick8Button9 UnityEngine.KeyCode
---@field Joystick8Button10 UnityEngine.KeyCode
---@field Joystick8Button11 UnityEngine.KeyCode
---@field Joystick8Button12 UnityEngine.KeyCode
---@field Joystick8Button13 UnityEngine.KeyCode
---@field Joystick8Button14 UnityEngine.KeyCode
---@field Joystick8Button15 UnityEngine.KeyCode
---@field Joystick8Button16 UnityEngine.KeyCode
---@field Joystick8Button17 UnityEngine.KeyCode
---@field Joystick8Button18 UnityEngine.KeyCode
---@field Joystick8Button19 UnityEngine.KeyCode
local UnityEngine_KeyCode = {}

---@class UnityEngine.SkinnedMeshRenderer : UnityEngine.Renderer
---@field quality NotExportEnum
---@field updateWhenOffscreen boolean
---@field forceMatrixRecalculationPerRender boolean
---@field rootBone UnityEngine.Transform
---@field bones NotExportType
---@field sharedMesh NotExportType
---@field skinnedMotionVectors boolean
---@field vertexBufferTarget NotExportEnum
local UnityEngine_SkinnedMeshRenderer = {}
---@return UnityEngine.SkinnedMeshRenderer
function UnityEngine_SkinnedMeshRenderer.New() end
---@param index number
---@return number
function UnityEngine_SkinnedMeshRenderer:GetBlendShapeWeight(index) end
---@param index number
---@param value number
function UnityEngine_SkinnedMeshRenderer:SetBlendShapeWeight(index, value) end
---@overload fun(mesh : NotExportType)
---@param mesh NotExportType
---@param useScale boolean
function UnityEngine_SkinnedMeshRenderer:BakeMesh(mesh, useScale) end
---@return NotExportType
function UnityEngine_SkinnedMeshRenderer:GetVertexBuffer() end
---@return NotExportType
function UnityEngine_SkinnedMeshRenderer:GetPreviousVertexBuffer() end

---@class UnityEngine.Space
---@field World UnityEngine.Space
---@field Self UnityEngine.Space
local UnityEngine_Space = {}

---@class UnityEngine.MeshRenderer : UnityEngine.Renderer
---@field additionalVertexStreams NotExportType
---@field enlightenVertexStream NotExportType
---@field subMeshStartIndex number
local UnityEngine_MeshRenderer = {}
---@return UnityEngine.MeshRenderer
function UnityEngine_MeshRenderer.New() end

---@class UnityEngine.BoxCollider : UnityEngine.Collider
---@field center UnityEngine.Vector3
---@field size UnityEngine.Vector3
local UnityEngine_BoxCollider = {}
---@return UnityEngine.BoxCollider
function UnityEngine_BoxCollider.New() end

---@class UnityEngine.MeshCollider : UnityEngine.Collider
---@field sharedMesh NotExportType
---@field convex boolean
---@field cookingOptions NotExportEnum
local UnityEngine_MeshCollider = {}
---@return UnityEngine.MeshCollider
function UnityEngine_MeshCollider.New() end

---@class UnityEngine.SphereCollider : UnityEngine.Collider
---@field center UnityEngine.Vector3
---@field radius number
local UnityEngine_SphereCollider = {}
---@return UnityEngine.SphereCollider
function UnityEngine_SphereCollider.New() end

---@class UnityEngine.CharacterController : UnityEngine.Collider
---@field velocity UnityEngine.Vector3
---@field isGrounded boolean
---@field collisionFlags NotExportEnum
---@field radius number
---@field height number
---@field center UnityEngine.Vector3
---@field slopeLimit number
---@field stepOffset number
---@field skinWidth number
---@field minMoveDistance number
---@field detectCollisions boolean
---@field enableOverlapRecovery boolean
local UnityEngine_CharacterController = {}
---@return UnityEngine.CharacterController
function UnityEngine_CharacterController.New() end
---@param speed UnityEngine.Vector3
---@return boolean
function UnityEngine_CharacterController:SimpleMove(speed) end
---@param motion UnityEngine.Vector3
---@return NotExportEnum
function UnityEngine_CharacterController:Move(motion) end

---@class UnityEngine.CapsuleCollider : UnityEngine.Collider
---@field center UnityEngine.Vector3
---@field radius number
---@field height number
---@field direction number
local UnityEngine_CapsuleCollider = {}
---@return UnityEngine.CapsuleCollider
function UnityEngine_CapsuleCollider.New() end

---@class UnityEngine.Animation : UnityEngine.Behaviour
---@field clip UnityEngine.AnimationClip
---@field playAutomatically boolean
---@field wrapMode UnityEngine.WrapMode
---@field isPlaying boolean
---@field Item NotExportType
---@field animatePhysics boolean
---@field cullingType NotExportEnum
---@field localBounds UnityEngine.Bounds
local UnityEngine_Animation = {}
---@return UnityEngine.Animation
function UnityEngine_Animation.New() end
---@overload fun()
---@param name string
function UnityEngine_Animation:Stop(name) end
---@overload fun()
---@param name string
function UnityEngine_Animation:Rewind(name) end
function UnityEngine_Animation:Sample() end
---@param name string
---@return boolean
function UnityEngine_Animation:IsPlaying(name) end
---@overload fun() : boolean
---@overload fun(mode : UnityEngine.PlayMode) : boolean
---@overload fun(animation : string) : boolean
---@param animation string
---@param mode UnityEngine.PlayMode
---@return boolean
function UnityEngine_Animation:Play(animation, mode) end
---@overload fun(animation : string)
---@overload fun(animation : string, fadeLength : number)
---@param animation string
---@param fadeLength number
---@param mode UnityEngine.PlayMode
function UnityEngine_Animation:CrossFade(animation, fadeLength, mode) end
---@overload fun(animation : string)
---@overload fun(animation : string, targetWeight : number)
---@param animation string
---@param targetWeight number
---@param fadeLength number
function UnityEngine_Animation:Blend(animation, targetWeight, fadeLength) end
---@overload fun(animation : string) : NotExportType
---@overload fun(animation : string, fadeLength : number) : NotExportType
---@overload fun(animation : string, fadeLength : number, queue : UnityEngine.QueueMode) : NotExportType
---@param animation string
---@param fadeLength number
---@param queue UnityEngine.QueueMode
---@param mode UnityEngine.PlayMode
---@return NotExportType
function UnityEngine_Animation:CrossFadeQueued(animation, fadeLength, queue, mode) end
---@overload fun(animation : string) : NotExportType
---@overload fun(animation : string, queue : UnityEngine.QueueMode) : NotExportType
---@param animation string
---@param queue UnityEngine.QueueMode
---@param mode UnityEngine.PlayMode
---@return NotExportType
function UnityEngine_Animation:PlayQueued(animation, queue, mode) end
---@overload fun(clip : UnityEngine.AnimationClip, newName : string)
---@overload fun(clip : UnityEngine.AnimationClip, newName : string, firstFrame : number, lastFrame : number)
---@param clip UnityEngine.AnimationClip
---@param newName string
---@param firstFrame number
---@param lastFrame number
---@param addLoopFrame boolean
function UnityEngine_Animation:AddClip(clip, newName, firstFrame, lastFrame, addLoopFrame) end
---@overload fun(clip : UnityEngine.AnimationClip)
---@param clipName string
function UnityEngine_Animation:RemoveClip(clipName) end
---@return number
function UnityEngine_Animation:GetClipCount() end
---@param layer number
function UnityEngine_Animation:SyncLayer(layer) end
---@return System.Collections.IEnumerator
function UnityEngine_Animation:GetEnumerator() end
---@param name string
---@return UnityEngine.AnimationClip
function UnityEngine_Animation:GetClip(name) end

---@class UnityEngine.AnimationClip : UnityEngine.Motion
---@field length number
---@field frameRate number
---@field wrapMode UnityEngine.WrapMode
---@field localBounds UnityEngine.Bounds
---@field legacy boolean
---@field humanMotion boolean
---@field empty boolean
---@field hasGenericRootTransform boolean
---@field hasMotionFloatCurves boolean
---@field hasMotionCurves boolean
---@field hasRootCurves boolean
---@field events NotExportType
local UnityEngine_AnimationClip = {}
---@return UnityEngine.AnimationClip
function UnityEngine_AnimationClip.New() end
---@param go UnityEngine.GameObject
---@param time number
function UnityEngine_AnimationClip:SampleAnimation(go, time) end
---@param relativePath string
---@param type System.Type
---@param propertyName string
---@param curve UnityEngine.AnimationCurve
function UnityEngine_AnimationClip:SetCurve(relativePath, type, propertyName, curve) end
function UnityEngine_AnimationClip:EnsureQuaternionContinuity() end
function UnityEngine_AnimationClip:ClearCurves() end
---@param evt UnityEngine.AnimationEvent
function UnityEngine_AnimationClip:AddEvent(evt) end

---@class UnityEngine.Motion : UnityEngine.Object
---@field averageDuration number
---@field averageAngularSpeed number
---@field averageSpeed UnityEngine.Vector3
---@field apparentSpeed number
---@field isLooping boolean
---@field legacy boolean
---@field isHumanMotion boolean
local UnityEngine_Motion = {}

---@class UnityEngine.AnimationBlendMode
---@field Blend UnityEngine.AnimationBlendMode
---@field Additive UnityEngine.AnimationBlendMode
local UnityEngine_AnimationBlendMode = {}

---@class UnityEngine.QueueMode
---@field CompleteOthers UnityEngine.QueueMode
---@field PlayNow UnityEngine.QueueMode
local UnityEngine_QueueMode = {}

---@class UnityEngine.PlayMode
---@field StopSameLayer UnityEngine.PlayMode
---@field StopAll UnityEngine.PlayMode
local UnityEngine_PlayMode = {}

---@class UnityEngine.WrapMode
---@field Once UnityEngine.WrapMode
---@field Loop UnityEngine.WrapMode
---@field PingPong UnityEngine.WrapMode
---@field Default UnityEngine.WrapMode
---@field ClampForever UnityEngine.WrapMode
---@field Clamp UnityEngine.WrapMode
local UnityEngine_WrapMode = {}

---@class UnityEngine.QualitySettings : UnityEngine.Object
---@field pixelLightCount number
---@field shadows NotExportEnum
---@field shadowProjection NotExportEnum
---@field shadowCascades number
---@field shadowDistance number
---@field shadowResolution NotExportEnum
---@field shadowmaskMode NotExportEnum
---@field shadowNearPlaneOffset number
---@field shadowCascade2Split number
---@field shadowCascade4Split UnityEngine.Vector3
---@field lodBias number
---@field anisotropicFiltering NotExportEnum
---@field globalTextureMipmapLimit number
---@field maximumLODLevel number
---@field enableLODCrossFade boolean
---@field particleRaycastBudget number
---@field softParticles boolean
---@field softVegetation boolean
---@field vSyncCount number
---@field realtimeGICPUUsage number
---@field antiAliasing number
---@field asyncUploadTimeSlice number
---@field asyncUploadBufferSize number
---@field asyncUploadPersistentBuffer boolean
---@field realtimeReflectionProbes boolean
---@field billboardsFaceCameraPosition boolean
---@field useLegacyDetailDistribution boolean
---@field resolutionScalingFixedDPIFactor number
---@field terrainQualityOverrides NotExportEnum
---@field terrainPixelError number
---@field terrainDetailDensityScale number
---@field terrainBasemapDistance number
---@field terrainDetailDistance number
---@field terrainTreeDistance number
---@field terrainBillboardStart number
---@field terrainFadeLength number
---@field terrainMaxTrees number
---@field renderPipeline NotExportType
---@field skinWeights UnityEngine.SkinWeights
---@field count number
---@field streamingMipmapsActive boolean
---@field streamingMipmapsMemoryBudget number
---@field streamingMipmapsMaxLevelReduction number
---@field streamingMipmapsAddAllCameras boolean
---@field streamingMipmapsMaxFileIORequests number
---@field maxQueuedFrames number
---@field names NotExportType
---@field desiredColorSpace NotExportEnum
---@field activeColorSpace NotExportEnum
local UnityEngine_QualitySettings = {}
---@overload fun(applyExpensiveChanges : boolean)
function UnityEngine_QualitySettings.IncreaseLevel() end
---@overload fun(applyExpensiveChanges : boolean)
function UnityEngine_QualitySettings.DecreaseLevel() end
---@overload fun(index : number)
---@param index number
---@param applyExpensiveChanges boolean
function UnityEngine_QualitySettings.SetQualityLevel(index, applyExpensiveChanges) end
---@overload fun(callback : NotExportType)
---@param callback NotExportType
function UnityEngine_QualitySettings.ForEach(callback) end
---@param lodBias number
---@param maximumLODLevel number
---@param setDirty boolean
function UnityEngine_QualitySettings.SetLODSettings(lodBias, maximumLODLevel, setDirty) end
---@param groupName string
---@param textureMipmapLimitSettings NotExportType
function UnityEngine_QualitySettings.SetTextureMipmapLimitSettings(groupName, textureMipmapLimitSettings) end
---@param groupName string
---@return NotExportType
function UnityEngine_QualitySettings.GetTextureMipmapLimitSettings(groupName) end
---@param index number
---@return NotExportType
function UnityEngine_QualitySettings.GetRenderPipelineAssetAt(index) end
---@return number
function UnityEngine_QualitySettings.GetQualityLevel() end
---@return UnityEngine.Object
function UnityEngine_QualitySettings.GetQualitySettings() end

---@class UnityEngine.RenderSettings : UnityEngine.Object
---@field fog boolean
---@field fogStartDistance number
---@field fogEndDistance number
---@field fogMode NotExportEnum
---@field fogColor UnityEngine.Color
---@field fogDensity number
---@field ambientMode NotExportEnum
---@field ambientSkyColor UnityEngine.Color
---@field ambientEquatorColor UnityEngine.Color
---@field ambientGroundColor UnityEngine.Color
---@field ambientIntensity number
---@field ambientLight UnityEngine.Color
---@field subtractiveShadowColor UnityEngine.Color
---@field skybox UnityEngine.Material
---@field sun UnityEngine.Light
---@field ambientProbe NotExportType
---@field customReflectionTexture UnityEngine.Texture
---@field reflectionIntensity number
---@field reflectionBounces number
---@field defaultReflectionMode NotExportEnum
---@field defaultReflectionResolution number
---@field haloStrength number
---@field flareStrength number
---@field flareFadeSpeed number
local UnityEngine_RenderSettings = {}

---@class UnityEngine.SkinWeights
---@field None UnityEngine.SkinWeights
---@field OneBone UnityEngine.SkinWeights
---@field TwoBones UnityEngine.SkinWeights
---@field FourBones UnityEngine.SkinWeights
---@field Unlimited UnityEngine.SkinWeights
local UnityEngine_SkinWeights = {}

---@class UnityEngine.RuntimeAnimatorController : UnityEngine.Object
---@field animationClips NotExportType
local UnityEngine_RuntimeAnimatorController = {}

---@class UnityEngine.Random : System.Object
---@field state NotExportType
---@field value number
---@field insideUnitSphere UnityEngine.Vector3
---@field insideUnitCircle UnityEngine.Vector2
---@field onUnitSphere UnityEngine.Vector3
---@field rotation UnityEngine.Quaternion
---@field rotationUniform UnityEngine.Quaternion
local UnityEngine_Random = {}
---@param seed number
function UnityEngine_Random.InitState(seed) end
---@overload fun(minInclusive : number, maxInclusive : number) : number
---@param minInclusive number
---@param maxExclusive number
---@return number
function UnityEngine_Random.Range(minInclusive, maxExclusive) end
---@overload fun() : UnityEngine.Color
---@overload fun(hueMin : number, hueMax : number) : UnityEngine.Color
---@overload fun(hueMin : number, hueMax : number, saturationMin : number, saturationMax : number) : UnityEngine.Color
---@overload fun(hueMin : number, hueMax : number, saturationMin : number, saturationMax : number, valueMin : number, valueMax : number) : UnityEngine.Color
---@param hueMin number
---@param hueMax number
---@param saturationMin number
---@param saturationMax number
---@param valueMin number
---@param valueMax number
---@param alphaMin number
---@param alphaMax number
---@return UnityEngine.Color
function UnityEngine_Random.ColorHSV(hueMin, hueMax, saturationMin, saturationMax, valueMin, valueMax, alphaMin, alphaMax) end

---@class UnityEngine.Rect : System.ValueType
---@field zero UnityEngine.Rect
---@field x number
---@field y number
---@field position UnityEngine.Vector2
---@field center UnityEngine.Vector2
---@field min UnityEngine.Vector2
---@field max UnityEngine.Vector2
---@field width number
---@field height number
---@field size UnityEngine.Vector2
---@field xMin number
---@field yMin number
---@field xMax number
---@field yMax number
local UnityEngine_Rect = {}
---@overload fun(x : number, y : number, width : number, height : number) : UnityEngine.Rect
---@overload fun(position : UnityEngine.Vector2, size : UnityEngine.Vector2) : UnityEngine.Rect
---@param source UnityEngine.Rect
---@return UnityEngine.Rect
function UnityEngine_Rect.New(source) end
---@param xmin number
---@param ymin number
---@param xmax number
---@param ymax number
---@return UnityEngine.Rect
function UnityEngine_Rect.MinMaxRect(xmin, ymin, xmax, ymax) end
---@param rectangle UnityEngine.Rect
---@param normalizedRectCoordinates UnityEngine.Vector2
---@return UnityEngine.Vector2
function UnityEngine_Rect.NormalizedToPoint(rectangle, normalizedRectCoordinates) end
---@param rectangle UnityEngine.Rect
---@param point UnityEngine.Vector2
---@return UnityEngine.Vector2
function UnityEngine_Rect.PointToNormalized(rectangle, point) end
---@param x number
---@param y number
---@param width number
---@param height number
function UnityEngine_Rect:Set(x, y, width, height) end
---@overload fun(point : UnityEngine.Vector2) : boolean
---@overload fun(point : UnityEngine.Vector3) : boolean
---@param point UnityEngine.Vector3
---@param allowInverse boolean
---@return boolean
function UnityEngine_Rect:Contains(point, allowInverse) end
---@overload fun(other : UnityEngine.Rect) : boolean
---@param other UnityEngine.Rect
---@param allowInverse boolean
---@return boolean
function UnityEngine_Rect:Overlaps(other, allowInverse) end
---@return number
function UnityEngine_Rect:GetHashCode() end
---@overload fun(other : System.Object) : boolean
---@param other UnityEngine.Rect
---@return boolean
function UnityEngine_Rect:Equals(other) end
---@overload fun() : string
---@overload fun(format : string) : string
---@param format string
---@param formatProvider NotExportType
---@return string
function UnityEngine_Rect:ToString(format, formatProvider) end

---@class UnityEngine.Canvas : UnityEngine.Behaviour
---@field renderMode UnityEngine.RenderMode
---@field isRootCanvas boolean
---@field pixelRect UnityEngine.Rect
---@field scaleFactor number
---@field referencePixelsPerUnit number
---@field overridePixelPerfect boolean
---@field vertexColorAlwaysGammaSpace boolean
---@field pixelPerfect boolean
---@field planeDistance number
---@field renderOrder number
---@field overrideSorting boolean
---@field sortingOrder number
---@field targetDisplay number
---@field sortingLayerID number
---@field cachedSortingLayerValue number
---@field additionalShaderChannels NotExportEnum
---@field sortingLayerName string
---@field rootCanvas UnityEngine.Canvas
---@field renderingDisplaySize UnityEngine.Vector2
---@field updateRectTransformForStandalone NotExportEnum
---@field worldCamera UnityEngine.Camera
---@field normalizedSortingGridSize number
local UnityEngine_Canvas = {}
---@return UnityEngine.Canvas
function UnityEngine_Canvas.New() end
---@return UnityEngine.Material
function UnityEngine_Canvas.GetDefaultCanvasMaterial() end
---@return UnityEngine.Material
function UnityEngine_Canvas.GetETC1SupportedCanvasMaterial() end
function UnityEngine_Canvas.ForceUpdateCanvases() end

---@class UnityEngine.RenderMode
---@field ScreenSpaceOverlay UnityEngine.RenderMode
---@field ScreenSpaceCamera UnityEngine.RenderMode
---@field WorldSpace UnityEngine.RenderMode
local UnityEngine_RenderMode = {}

---@class UnityEngine.UI.Button : UnityEngine.UI.Selectable
---@field onClick NotExportType
local UnityEngine_UI_Button = {}
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_Button:OnPointerClick(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function UnityEngine_UI_Button:OnSubmit(eventData) end

---@class UnityEngine.RuntimePlatform
---@field OSXEditor UnityEngine.RuntimePlatform
---@field OSXPlayer UnityEngine.RuntimePlatform
---@field WindowsPlayer UnityEngine.RuntimePlatform
---@field WindowsEditor UnityEngine.RuntimePlatform
---@field IPhonePlayer UnityEngine.RuntimePlatform
---@field Android UnityEngine.RuntimePlatform
---@field LinuxPlayer UnityEngine.RuntimePlatform
---@field LinuxEditor UnityEngine.RuntimePlatform
---@field WebGLPlayer UnityEngine.RuntimePlatform
---@field WSAPlayerX86 UnityEngine.RuntimePlatform
---@field WSAPlayerX64 UnityEngine.RuntimePlatform
---@field WSAPlayerARM UnityEngine.RuntimePlatform
---@field PS4 UnityEngine.RuntimePlatform
---@field XboxOne UnityEngine.RuntimePlatform
---@field tvOS UnityEngine.RuntimePlatform
---@field Switch UnityEngine.RuntimePlatform
---@field Stadia UnityEngine.RuntimePlatform
---@field GameCoreXboxSeries UnityEngine.RuntimePlatform
---@field GameCoreXboxOne UnityEngine.RuntimePlatform
---@field PS5 UnityEngine.RuntimePlatform
---@field EmbeddedLinuxArm64 UnityEngine.RuntimePlatform
---@field EmbeddedLinuxArm32 UnityEngine.RuntimePlatform
---@field EmbeddedLinuxX64 UnityEngine.RuntimePlatform
---@field EmbeddedLinuxX86 UnityEngine.RuntimePlatform
---@field LinuxServer UnityEngine.RuntimePlatform
---@field WindowsServer UnityEngine.RuntimePlatform
---@field OSXServer UnityEngine.RuntimePlatform
---@field QNXArm32 UnityEngine.RuntimePlatform
---@field QNXArm64 UnityEngine.RuntimePlatform
---@field QNXX64 UnityEngine.RuntimePlatform
---@field QNXX86 UnityEngine.RuntimePlatform
---@field VisionOS UnityEngine.RuntimePlatform
local UnityEngine_RuntimePlatform = {}

---@class UnityEngine.UI.RawImage : UnityEngine.UI.MaskableGraphic
---@field mainTexture UnityEngine.Texture
---@field texture UnityEngine.Texture
---@field uvRect UnityEngine.Rect
local UnityEngine_UI_RawImage = {}
function UnityEngine_UI_RawImage:SetNativeSize() end

---@class UnityEngine.SceneManagement.SceneManager : System.Object
---@field sceneCount number
---@field loadedSceneCount number
---@field sceneCountInBuildSettings number
local UnityEngine_SceneManagement_SceneManager = {}
---@return UnityEngine.SceneManagement.SceneManager
function UnityEngine_SceneManagement_SceneManager.New() end
---@return UnityEngine.SceneManagement.Scene
function UnityEngine_SceneManagement_SceneManager.GetActiveScene() end
---@param scene UnityEngine.SceneManagement.Scene
---@return boolean
function UnityEngine_SceneManagement_SceneManager.SetActiveScene(scene) end
---@param scenePath string
---@return UnityEngine.SceneManagement.Scene
function UnityEngine_SceneManagement_SceneManager.GetSceneByPath(scenePath) end
---@param name string
---@return UnityEngine.SceneManagement.Scene
function UnityEngine_SceneManagement_SceneManager.GetSceneByName(name) end
---@param buildIndex number
---@return UnityEngine.SceneManagement.Scene
function UnityEngine_SceneManagement_SceneManager.GetSceneByBuildIndex(buildIndex) end
---@param index number
---@return UnityEngine.SceneManagement.Scene
function UnityEngine_SceneManagement_SceneManager.GetSceneAt(index) end
---@overload fun(sceneName : string, parameters : NotExportType) : UnityEngine.SceneManagement.Scene
---@param sceneName string
---@return UnityEngine.SceneManagement.Scene
function UnityEngine_SceneManagement_SceneManager.CreateScene(sceneName) end
---@param sourceScene UnityEngine.SceneManagement.Scene
---@param destinationScene UnityEngine.SceneManagement.Scene
function UnityEngine_SceneManagement_SceneManager.MergeScenes(sourceScene, destinationScene) end
---@param go UnityEngine.GameObject
---@param scene UnityEngine.SceneManagement.Scene
function UnityEngine_SceneManagement_SceneManager.MoveGameObjectToScene(go, scene) end
---@param instanceIDs NotExportType
---@param scene UnityEngine.SceneManagement.Scene
function UnityEngine_SceneManagement_SceneManager.MoveGameObjectsToScene(instanceIDs, scene) end
---@overload fun(sceneName : string, mode : UnityEngine.SceneManagement.LoadSceneMode)
---@overload fun(sceneName : string)
---@overload fun(sceneName : string, parameters : NotExportType) : UnityEngine.SceneManagement.Scene
---@overload fun(sceneBuildIndex : number, mode : UnityEngine.SceneManagement.LoadSceneMode)
---@overload fun(sceneBuildIndex : number)
---@param sceneBuildIndex number
---@param parameters NotExportType
---@return UnityEngine.SceneManagement.Scene
function UnityEngine_SceneManagement_SceneManager.LoadScene(sceneBuildIndex, parameters) end
---@overload fun(sceneBuildIndex : number, mode : UnityEngine.SceneManagement.LoadSceneMode) : UnityEngine.AsyncOperation
---@overload fun(sceneBuildIndex : number) : UnityEngine.AsyncOperation
---@overload fun(sceneBuildIndex : number, parameters : NotExportType) : UnityEngine.AsyncOperation
---@overload fun(sceneName : string, mode : UnityEngine.SceneManagement.LoadSceneMode) : UnityEngine.AsyncOperation
---@overload fun(sceneName : string) : UnityEngine.AsyncOperation
---@param sceneName string
---@param parameters NotExportType
---@return UnityEngine.AsyncOperation
function UnityEngine_SceneManagement_SceneManager.LoadSceneAsync(sceneName, parameters) end
---@overload fun(sceneBuildIndex : number) : UnityEngine.AsyncOperation
---@overload fun(sceneName : string) : UnityEngine.AsyncOperation
---@overload fun(scene : UnityEngine.SceneManagement.Scene) : UnityEngine.AsyncOperation
---@overload fun(sceneBuildIndex : number, options : UnityEngine.SceneManagement.UnloadSceneOptions) : UnityEngine.AsyncOperation
---@overload fun(sceneName : string, options : UnityEngine.SceneManagement.UnloadSceneOptions) : UnityEngine.AsyncOperation
---@param scene UnityEngine.SceneManagement.Scene
---@param options UnityEngine.SceneManagement.UnloadSceneOptions
---@return UnityEngine.AsyncOperation
function UnityEngine_SceneManagement_SceneManager.UnloadSceneAsync(scene, options) end

---@class UnityEngine.SceneManagement.LoadSceneMode
---@field Single UnityEngine.SceneManagement.LoadSceneMode
---@field Additive UnityEngine.SceneManagement.LoadSceneMode
local UnityEngine_SceneManagement_LoadSceneMode = {}

---@class UnityEngine.SceneManagement.UnloadSceneOptions
---@field None UnityEngine.SceneManagement.UnloadSceneOptions
---@field UnloadAllEmbeddedSceneObjects UnityEngine.SceneManagement.UnloadSceneOptions
local UnityEngine_SceneManagement_UnloadSceneOptions = {}

---@class UnityEngine.RectTransformUtility : System.Object
local UnityEngine_RectTransformUtility = {}
---@param point UnityEngine.Vector2
---@param elementTransform UnityEngine.Transform
---@param canvas UnityEngine.Canvas
---@return UnityEngine.Vector2
function UnityEngine_RectTransformUtility.PixelAdjustPoint(point, elementTransform, canvas) end
---@param rectTransform UnityEngine.RectTransform
---@param canvas UnityEngine.Canvas
---@return UnityEngine.Rect
function UnityEngine_RectTransformUtility.PixelAdjustRect(rectTransform, canvas) end
---@overload fun(rect : UnityEngine.RectTransform, screenPoint : UnityEngine.Vector2) : boolean
---@overload fun(rect : UnityEngine.RectTransform, screenPoint : UnityEngine.Vector2, cam : UnityEngine.Camera) : boolean
---@param rect UnityEngine.RectTransform
---@param screenPoint UnityEngine.Vector2
---@param cam UnityEngine.Camera
---@param offset NotExportType
---@return boolean
function UnityEngine_RectTransformUtility.RectangleContainsScreenPoint(rect, screenPoint, cam, offset) end
---@param rect UnityEngine.RectTransform
---@param screenPoint UnityEngine.Vector2
---@param cam UnityEngine.Camera
---@param out_worldPoint UnityEngine.Vector3
---@return boolean,UnityEngine.Vector3
function UnityEngine_RectTransformUtility.ScreenPointToWorldPointInRectangle(rect, screenPoint, cam, out_worldPoint) end
---@param rect UnityEngine.RectTransform
---@param screenPoint UnityEngine.Vector2
---@param cam UnityEngine.Camera
---@param out_localPoint UnityEngine.Vector2
---@return boolean,UnityEngine.Vector2
function UnityEngine_RectTransformUtility.ScreenPointToLocalPointInRectangle(rect, screenPoint, cam, out_localPoint) end
---@param cam UnityEngine.Camera
---@param screenPos UnityEngine.Vector2
---@return UnityEngine.Ray
function UnityEngine_RectTransformUtility.ScreenPointToRay(cam, screenPos) end
---@param cam UnityEngine.Camera
---@param worldPoint UnityEngine.Vector3
---@return UnityEngine.Vector2
function UnityEngine_RectTransformUtility.WorldToScreenPoint(cam, worldPoint) end
---@overload fun(root : UnityEngine.Transform, child : UnityEngine.Transform) : UnityEngine.Bounds
---@param trans UnityEngine.Transform
---@return UnityEngine.Bounds
function UnityEngine_RectTransformUtility.CalculateRelativeRectTransformBounds(trans) end
---@param rect UnityEngine.RectTransform
---@param axis number
---@param keepPositioning boolean
---@param recursive boolean
function UnityEngine_RectTransformUtility.FlipLayoutOnAxis(rect, axis, keepPositioning, recursive) end
---@param rect UnityEngine.RectTransform
---@param keepPositioning boolean
---@param recursive boolean
function UnityEngine_RectTransformUtility.FlipLayoutAxes(rect, keepPositioning, recursive) end

---@class UnityEngine.EventSystems.EventSystem : UnityEngine.EventSystems.UIBehaviour
---@field current UnityEngine.EventSystems.EventSystem
---@field sendNavigationEvents boolean
---@field pixelDragThreshold number
---@field currentInputModule NotExportType
---@field firstSelectedGameObject UnityEngine.GameObject
---@field currentSelectedGameObject UnityEngine.GameObject
---@field isFocused boolean
---@field alreadySelecting boolean
local UnityEngine_EventSystems_EventSystem = {}
---@param activeEventSystem UnityEngine.EventSystems.EventSystem
---@param sendEvents boolean
---@param createPanelGameObjectsOnStart boolean
function UnityEngine_EventSystems_EventSystem.SetUITookitEventSystemOverride(activeEventSystem, sendEvents, createPanelGameObjectsOnStart) end
function UnityEngine_EventSystems_EventSystem:UpdateModules() end
---@overload fun(selected : UnityEngine.GameObject, pointer : UnityEngine.EventSystems.BaseEventData)
---@param selected UnityEngine.GameObject
function UnityEngine_EventSystems_EventSystem:SetSelectedGameObject(selected) end
---@param eventData UnityEngine.EventSystems.PointerEventData
---@param raycastResults NotExportType
function UnityEngine_EventSystems_EventSystem:RaycastAll(eventData, raycastResults) end
---@overload fun() : boolean
---@param pointerId number
---@return boolean
function UnityEngine_EventSystems_EventSystem:IsPointerOverGameObject(pointerId) end
---@return string
function UnityEngine_EventSystems_EventSystem:ToString() end

---@class UnityEngine.EventSystems.PointerEventData : UnityEngine.EventSystems.BaseEventData
---@field hovered NotExportType
---@field pointerEnter UnityEngine.GameObject
---@field lastPress UnityEngine.GameObject
---@field rawPointerPress UnityEngine.GameObject
---@field pointerDrag UnityEngine.GameObject
---@field pointerClick UnityEngine.GameObject
---@field pointerCurrentRaycast NotExportType
---@field pointerPressRaycast NotExportType
---@field eligibleForClick boolean
---@field displayIndex number
---@field pointerId number
---@field position UnityEngine.Vector2
---@field delta UnityEngine.Vector2
---@field pressPosition UnityEngine.Vector2
---@field clickTime number
---@field clickCount number
---@field scrollDelta UnityEngine.Vector2
---@field useDragThreshold boolean
---@field dragging boolean
---@field button NotExportEnum
---@field pressure number
---@field tangentialPressure number
---@field altitudeAngle number
---@field azimuthAngle number
---@field twist number
---@field tilt UnityEngine.Vector2
---@field penStatus NotExportEnum
---@field radius UnityEngine.Vector2
---@field radiusVariance UnityEngine.Vector2
---@field fullyExited boolean
---@field reentered boolean
---@field enterEventCamera UnityEngine.Camera
---@field pressEventCamera UnityEngine.Camera
---@field pointerPress UnityEngine.GameObject
local UnityEngine_EventSystems_PointerEventData = {}
---@param eventSystem UnityEngine.EventSystems.EventSystem
---@return UnityEngine.EventSystems.PointerEventData
function UnityEngine_EventSystems_PointerEventData.New(eventSystem) end
---@return boolean
function UnityEngine_EventSystems_PointerEventData:IsPointerMoving() end
---@return boolean
function UnityEngine_EventSystems_PointerEventData:IsScrolling() end
---@return string
function UnityEngine_EventSystems_PointerEventData:ToString() end

---@class UnityEngine.EventSystems.BaseEventData : UnityEngine.EventSystems.AbstractEventData
---@field currentInputModule NotExportType
---@field selectedObject UnityEngine.GameObject
local UnityEngine_EventSystems_BaseEventData = {}
---@param eventSystem UnityEngine.EventSystems.EventSystem
---@return UnityEngine.EventSystems.BaseEventData
function UnityEngine_EventSystems_BaseEventData.New(eventSystem) end

---@class UnityEngine.EventSystems.AbstractEventData : System.Object
---@field used boolean
local UnityEngine_EventSystems_AbstractEventData = {}
function UnityEngine_EventSystems_AbstractEventData:Reset() end
function UnityEngine_EventSystems_AbstractEventData:Use() end

---@class UnityEngine.Keyframe : System.ValueType
---@field time number
---@field value number
---@field inTangent number
---@field outTangent number
---@field inWeight number
---@field outWeight number
---@field weightedMode NotExportEnum
local UnityEngine_Keyframe = {}
---@overload fun(time : number, value : number) : UnityEngine.Keyframe
---@overload fun(time : number, value : number, inTangent : number, outTangent : number) : UnityEngine.Keyframe
---@param time number
---@param value number
---@param inTangent number
---@param outTangent number
---@param inWeight number
---@param outWeight number
---@return UnityEngine.Keyframe
function UnityEngine_Keyframe.New(time, value, inTangent, outTangent, inWeight, outWeight) end

---@class UnityEngine.NetworkReachability
---@field NotReachable UnityEngine.NetworkReachability
---@field ReachableViaCarrierDataNetwork UnityEngine.NetworkReachability
---@field ReachableViaLocalAreaNetwork UnityEngine.NetworkReachability
local UnityEngine_NetworkReachability = {}

---@class LuaProfiler : System.Object
---@field list NotExportType
local LuaProfiler = {}
function LuaProfiler.Clear() end
---@param name string
---@return number
function LuaProfiler.GetID(name) end
---@param id number
function LuaProfiler.BeginSample(id) end
function LuaProfiler.EndSample() end

---@class LuaFramework.Util : System.Object
---@field AdvertisingIdentifier string
---@field DataPath string
---@field LuaPath string
---@field LuaResPath string
---@field NetAvailable boolean
---@field IsWifi boolean
local LuaFramework_Util = {}
---@return LuaFramework.Util
function LuaFramework_Util.New() end
---@param o System.Object
---@return number
function LuaFramework_Util.Int(o) end
---@param o System.Object
---@return number
function LuaFramework_Util.Float(o) end
---@param o System.Object
---@return number
function LuaFramework_Util.Long(o) end
---@overload fun(min : number, max : number) : number
---@param min number
---@param max number
---@return number
function LuaFramework_Util.Random(min, max) end
---@param uid string
---@return string
function LuaFramework_Util.Uid(uid) end
---@return number
function LuaFramework_Util.GetTime() end
---@overload fun(go : UnityEngine.GameObject, subnode : string) : UnityEngine.GameObject
---@param go UnityEngine.Transform
---@param subnode string
---@return UnityEngine.GameObject
function LuaFramework_Util.Child(go, subnode) end
---@overload fun(go : UnityEngine.GameObject, subnode : string) : UnityEngine.GameObject
---@param go UnityEngine.Transform
---@param subnode string
---@return UnityEngine.GameObject
function LuaFramework_Util.Peer(go, subnode) end
---@param source string
---@return string
function LuaFramework_Util.md5(source) end
---@param go UnityEngine.Transform
function LuaFramework_Util.ClearChild(go) end
---@return string
function LuaFramework_Util.GetRelativePath() end
---@return string
function LuaFramework_Util.AppContentPath() end
---@return number
function LuaFramework_Util.CheckRuntimeFile() end
---@overload fun(module : string, func : string, args : NotExportType) : NotExportType
---@overload fun(module : string, func : string)
---@overload fun(module : string, func : string, args : string)
---@overload fun(module : string, func : string, arg1 : string, arg2 : string)
---@overload fun(module : string, func : string, arg1 : string, arg2 : string, arg3 : number)
---@overload fun(module : string, func : string, args : UnityEngine.GameObject)
---@overload fun(module : string, func : string, args : number)
---@param module string
---@param func string
---@param args boolean
function LuaFramework_Util.CallMethod(module, func, args) end
---@return boolean
function LuaFramework_Util.CheckEnvironment() end
---@param atlasTexts NotExportType
---@param atlas_dictionary NotExportType
function LuaFramework_Util.CreateAtlasDictionary(atlasTexts, atlas_dictionary) end
---@param animator UnityEngine.Animator
---@param clip string
---@return number
function LuaFramework_Util.GetClipLength(animator, clip) end
---@param btn UnityEngine.UI.Button
---@param pressedSprite UnityEngine.Sprite
function LuaFramework_Util.BindBtnSpriteState(btn, pressedSprite) end
---@param gameObject UnityEngine.GameObject
---@return string
function LuaFramework_Util.GetGameObjectPath(gameObject) end
---@overload fun(file : string) : string
---@param file string
---@param ref_fileSize number
---@return string,number
function LuaFramework_Util.md5file(file, ref_fileSize) end
function LuaFramework_Util.ClearMemory() end
---@param fileName string
---@return string
function LuaFramework_Util.LoadFileBuffer(fileName) end
---@param fileName string
---@return boolean
function LuaFramework_Util.CheckLuaIsExist(fileName) end
---@param dir string
function LuaFramework_Util.DeleteFolder(dir) end
---@return string
function LuaFramework_Util.ReadonlyAssetsPath() end
---@return string
function LuaFramework_Util.GetFilePrefix() end
---@param filename string
---@return string
function LuaFramework_Util.GetFileText(filename) end
function LuaFramework_Util.Shock() end
---@param str string
function LuaFramework_Util.Log(str) end
---@param str string
function LuaFramework_Util.LogWarning(str) end
function LuaFramework_Util.CrashTest() end
---@param str string
function LuaFramework_Util.LogError(str) end
function LuaFramework_Util.QuitApplication() end
---@param go UnityEngine.GameObject
---@return number
function LuaFramework_Util.ButtonBindClick(go) end
---@param go UnityEngine.GameObject
---@return number
function LuaFramework_Util.ButtonUnbindClick(go) end
---@param btn UnityEngine.UI.Button
---@return number
function LuaFramework_Util.GetButtonBindingID(btn) end
---@param go UnityEngine.GameObject
function LuaFramework_Util.RemoveButtonListener(go) end
---@param slider UnityEngine.UI.Slider
---@param luaFunc fun()
function LuaFramework_Util.AddSliderChangeCallBack(slider, luaFunc) end
---@param scrollRect UnityEngine.UI.ScrollRect
---@param luaFunc fun()
function LuaFramework_Util.AddScrollRectChangeCallBack(scrollRect, luaFunc) end
---@param scrollRect UnityEngine.UI.ScrollRect
---@param luaFunc fun()
function LuaFramework_Util.RemoveScrollRectChangeCallBack(scrollRect, luaFunc) end
---@return number
function LuaFramework_Util.NowMillisecond() end
---@param unixTime number
---@param formatDateStr string
---@return string
function LuaFramework_Util.UnixTimeToDate(unixTime, formatDateStr) end
---@param parent UnityEngine.GameObject
---@param sortValue number
---@return number
function LuaFramework_Util.SetCanvasSortingOrderRelative(parent, sortValue) end
---@param date string
---@return string
function LuaFramework_Util.FormatDateToMail(date) end
---@param texture UnityEngine.Texture2D
---@return UnityEngine.Sprite
function LuaFramework_Util.Texture2Sprite(texture) end
---@param path string
---@return boolean
function LuaFramework_Util.IsFileExist(path) end
---@param path string
---@return boolean
function LuaFramework_Util.IsPathRooted(path) end
---@param path string
---@return boolean
function LuaFramework_Util.IsPathRootedOnAndroidAssert(path) end
---@param path string
---@param text string
function LuaFramework_Util.WriteFileText(path, text) end
---@param path string
---@return string
function LuaFramework_Util.ReadCryptedFileText(path) end
---@param path string
---@return string
function LuaFramework_Util.ReadModuleCryptedFileTextInEditor(path) end
---@param path string
---@return NotExportType
function LuaFramework_Util.ReadFromAndroidAssert(path) end
---@param path string
---@return string
function LuaFramework_Util.GetRootDirectory(path) end
---@param text string
---@return number
function LuaFramework_Util.GetStringLength(text) end
---@return string
function LuaFramework_Util.ReadLocalSettingTXT() end
---@param machine_id string
function LuaFramework_Util.ModifyLocalSettingTXT(machine_id) end
---@return string
function LuaFramework_Util.ReadLocalOpenId() end
---@param openid string
function LuaFramework_Util.ModifyLocalOpenId(openid) end
---@param NetName string
function LuaFramework_Util.SetGameNet(NetName) end
---@return string
function LuaFramework_Util.GetGameNet() end
---@param firlSrc string
function LuaFramework_Util.DeleteFile(firlSrc) end
---@param src string
---@param dst string
function LuaFramework_Util.ReplaceFile(src, dst) end
---@param src string
---@param prefix string
---@return boolean
function LuaFramework_Util.StringStartsWith(src, prefix) end
---@param src string
---@param suffix string
---@return boolean
function LuaFramework_Util.StringEndsWith(src, suffix) end
---@param src string
---@param target string
---@return boolean
function LuaFramework_Util.StringContains(src, target) end
---@return boolean
function LuaFramework_Util.GetDevMode() end
---@param filePath string
function LuaFramework_Util.MakeSureDirExist(filePath) end
---@param directory string
---@return NotExportType
function LuaFramework_Util.GetAllFiles(directory) end
---@param transform UnityEngine.Transform
---@param layer number
---@param excludeChild string
function LuaFramework_Util.ChangeLayer(transform, layer, excludeChild) end
---@param go UnityEngine.GameObject
---@param x number
---@param y number
---@param z number
function LuaFramework_Util.ChangeWorldPosition(go, x, y, z) end
---@param go UnityEngine.GameObject
---@param x number
---@param y number
---@param z number
function LuaFramework_Util.ChangeLocalPosition(go, x, y, z) end
---@param callback fun()
function LuaFramework_Util.RequestIDFA(callback) end
---@param go System.Object
---@return boolean
function LuaFramework_Util.IsNull(go) end
---@param obj UnityEngine.GameObject
---@return boolean
function LuaFramework_Util.IsPrefabInstance(obj) end
---@param url string
---@param width number
---@param height number
---@return UnityEngine.Sprite
function LuaFramework_Util.CreateSprite(url, width, height) end
function LuaFramework_Util.EditorPause() end
---@param go UnityEngine.GameObject
---@param luaCallback fun()
---@return LuaFramework.LuaBehaviour
function LuaFramework_Util.AddLuaBehaviour(go, luaCallback) end
---@overload fun(parentObj : UnityEngine.Transform, childObj : UnityEngine.Transform)
---@param parentObj UnityEngine.GameObject
---@param childObj UnityEngine.GameObject
function LuaFramework_Util.SetParent(parentObj, childObj) end
---@param obj UnityEngine.GameObject
function LuaFramework_Util.ForceRebuildLayoutImmediate(obj) end
---@param parent UnityEngine.GameObject
function LuaFramework_Util.ClearRaycastResults(parent) end
---@param input TMPro.TMP_InputField
---@param callback fun()
function LuaFramework_Util.AddInputFileOnChangeEvent(input, callback) end
---@param input TMPro.TMP_InputField
---@param callback fun()
function LuaFramework_Util.AddInputFileOnEndEvent(input, callback) end
---@param input TMPro.TMP_InputField
---@param callback fun()
function LuaFramework_Util.AddInputFileOnSelectvent(input, callback) end
---@param layout UnityEngine.UI.LayoutGroup
---@param type number
function LuaFramework_Util.SetGroupTextAnchorType(layout, type) end
---@param slb NotExportType
---@return number
function LuaFramework_Util.GetScrollBarValue(slb) end
---@param slb NotExportType
---@param value number
function LuaFramework_Util.SetScrollBarValue(slb, value) end
---@param rt UnityEngine.RectTransform
---@param cam UnityEngine.Camera
---@return UnityEngine.Rect
function LuaFramework_Util.RectTransToScreenPos(rt, cam) end
---@param rect1 UnityEngine.RectTransform
---@param rect2 UnityEngine.RectTransform
---@return boolean
function LuaFramework_Util.IsRectTransformOverlap(rect1, rect2) end
function LuaFramework_Util.ShowiOSTracking() end
---@param spr UnityEngine.SpriteRenderer
---@param width number
---@param height number
function LuaFramework_Util.SetSpriteRendererSize(spr, width, height) end
---@param path string
---@param extName string
---@param lst NotExportType
---@return NotExportType
function LuaFramework_Util.GetExtFile(path, extName, lst) end
---@param go UnityEngine.GameObject
---@param shakeTime number
---@param step number
---@param shakeRateX number
---@param shakeRateY number
function LuaFramework_Util.ShakeGameObject(go, shakeTime, step, shakeRateX, shakeRateY) end
---@param go UnityEngine.GameObject
---@return number
function LuaFramework_Util.PlayParticle(go) end
---@param go UnityEngine.GameObject
function LuaFramework_Util.StopParticle(go) end
---@param go UnityEngine.GameObject
---@param gray boolean
function LuaFramework_Util.SetUIImageGray(go, gray) end
---@param go UnityEngine.GameObject
---@param gray boolean
function LuaFramework_Util.SetImageColorGray(go, gray) end
---@param _function fun()
function LuaFramework_Util.SetLuaDrag(_function) end
---@param pos UnityEngine.Vector3
---@return UnityEngine.Vector3
function LuaFramework_Util.LuaEasyTouchScreenToWorldPoint(pos) end
---@param animator UnityEngine.Animator
---@param clip string
---@return number
function LuaFramework_Util.CalculateAnimatorLenth(animator, clip) end
---@param screenPos UnityEngine.Vector2
---@param camera UnityEngine.Camera
---@param maskName string
---@return UnityEngine.GameObject
function LuaFramework_Util.RayCollideGameObject(screenPos, camera, maskName) end
---@param scrollRect UnityEngine.GameObject
---@param callBack fun()
function LuaFramework_Util.SetVariantScrollRectCallBack(scrollRect, callBack) end
---@param text string
function LuaFramework_Util.CopyTextToClipboard(text) end
---@return string
function LuaFramework_Util.GetTextOnClipboard() end
---@param go UnityEngine.GameObject
---@param name string
---@param value number
function LuaFramework_Util.SetMaterialFloat(go, name, value) end
---@overload fun(cam : UnityEngine.Camera, pos : UnityEngine.Vector3, go : UnityEngine.GameObject) : boolean
---@param cam UnityEngine.Camera
---@param go UnityEngine.GameObject
---@return boolean
function LuaFramework_Util.IsTopGraphic(cam, go) end
---@param go UnityEngine.GameObject
---@param isTarget boolean
function LuaFramework_Util.SetRaycastTarget(go, isTarget) end
---@param emailAdress string
---@param title string
---@param str string
function LuaFramework_Util.SendEmail(emailAdress, title, str) end
---@param callback NotExportType
function LuaFramework_Util.GetRequestIDFA(callback) end
function LuaFramework_Util.EditorDisplayDialog() end
---@param url string
function LuaFramework_Util._OpenURL(url) end
---@param url string
function LuaFramework_Util.OpenURLByPlatform(url) end

---@class LuaFramework.AppConst : System.Object
---@field DebugMode boolean
---@field ExampleMode boolean
---@field UpdateMode boolean
---@field LuaByteMode boolean
---@field LuaBundleMode boolean
---@field TimerInterval number
---@field GameFrameRate number
---@field HotfixDir string
---@field AppName string
---@field LuaTempDir string
---@field AppPrefix string
---@field ExtName string
---@field AssetDir string
---@field WebUrl string
---@field LuaSandbox string
---@field UserId string
---@field SocketPort number
---@field SocketAddress string
---@field VERSIONCODE string
---@field DefaultVersionStr string
---@field DownloadFilesPath string
---@field is_amazon_pay boolean
---@field HTTP_SERVER_IP_DEVTEST string
---@field HTTP_SERVER_IP_DEVTEST1 string
---@field HTTP_SERVER_IP_DEV string
---@field HTTP_SERVER_IP_TEST string
---@field HTTP_SERVER_IP_PRE_RELEASE string
---@field HTTP_SERVER_IP_RELEASE string
---@field HTTP_SERVER_IP_SNAPSHOT string
---@field HTTP_SERVER_IP_Server2 string
---@field HTTP_SERVER_IP_Server1 string
---@field HTTP_SERVER_IP_Server3 string
---@field HTTP_SERVER_IP_Server_WuHan string
---@field HTTP_SERVER_IP_DEV_LOCAL string
---@field DebugResUpdateDisabled boolean
---@field EditMode boolean
---@field VersionTXTExtendsName string
---@field APPID string
---@field IsInit boolean
---@field BundlePackageInfoFile string
---@field BundlePackagePattern string
---@field LuaDir string
---@field ForceUpdateTip string
---@field DecompressStr NotExportType
---@field DeepLinkStr string
---@field IsSimulateAssetBundleInEditor boolean
---@field DevMode boolean
---@field HTTP_SERVER_IP string
---@field FrameworkRoot string
---@field HotfixRoot string
---@field ExternalinkRoot string
local LuaFramework_AppConst = {}
---@return LuaFramework.AppConst
function LuaFramework_AppConst.New() end
---@return boolean
function LuaFramework_AppConst.IsEditorModel() end
---@return boolean
function LuaFramework_AppConst.IsDevMode() end

---@class LuaFramework.LuaHelper : System.Object
local LuaFramework_LuaHelper = {}
---@param callback fun()
---@return number
function LuaFramework_LuaHelper.RegisterCallback(callback) end
---@param assetId number
function LuaFramework_LuaHelper.ReleaseAsset(assetId) end
---@param assetId number
---@return UnityEngine.Object
function LuaFramework_LuaHelper.GetAssetObject(assetId) end
---@return number
function LuaFramework_LuaHelper.GetNextAssetId() end
---@param assetId number
---@return YooAsset.AssetHandle
function LuaFramework_LuaHelper.GetAssetHandle(assetId) end
---@param directoryFileName string
---@param extension string
---@param type System.Type
---@param callbackId number
---@return Cysharp.Threading.Tasks.UniTaskVoid
function LuaFramework_LuaHelper.LoadAssetAsync(directoryFileName, extension, type, callbackId) end
---@param directoryFileName string
---@param extension string
---@param type System.Type
---@return YooAsset.AssetHandle
function LuaFramework_LuaHelper.LoadAssetSync(directoryFileName, extension, type) end
---@param classname string
---@return System.Type
function LuaFramework_LuaHelper.GetType(classname) end
---@return LuaFramework.PanelManager
function LuaFramework_LuaHelper.GetPanelManager() end
---@return LuaFramework.ResourceManager
function LuaFramework_LuaHelper.GetResManager() end
---@return LuaFramework.NetworkManager
function LuaFramework_LuaHelper.GetNetManager() end
---@return LuaFramework.SoundManager
function LuaFramework_LuaHelper.GetSoundManager() end
---@return NotExportType
function LuaFramework_LuaHelper.GetObjectPoolManager() end
---@param data NotExportType
---@param func fun()
function LuaFramework_LuaHelper.OnCallLuaFunc(data, func) end
---@param data string
---@param func fun()
function LuaFramework_LuaHelper.OnJsonCallFunc(data, func) end
---@param file string
---@param callbackId number
---@param activateOnLoad boolean
---@param mode UnityEngine.SceneManagement.LoadSceneMode
function LuaFramework_LuaHelper.LoadScene(file, callbackId, activateOnLoad, mode) end

---@class LuaFramework.ByteBuffer : System.Object
local LuaFramework_ByteBuffer = {}
---@overload fun() : LuaFramework.ByteBuffer
---@param data NotExportType
---@return LuaFramework.ByteBuffer
function LuaFramework_ByteBuffer.New(data) end
function LuaFramework_ByteBuffer:Close() end
---@param v number
function LuaFramework_ByteBuffer:WriteByte(v) end
---@param v number
function LuaFramework_ByteBuffer:WriteInt(v) end
---@param v number
function LuaFramework_ByteBuffer:WriteShort(v) end
---@param v number
function LuaFramework_ByteBuffer:WriteLong(v) end
---@param v number
function LuaFramework_ByteBuffer:WriteFloat(v) end
---@param v number
function LuaFramework_ByteBuffer:WriteDouble(v) end
---@param v string
function LuaFramework_ByteBuffer:WriteString(v) end
---@param v NotExportType
function LuaFramework_ByteBuffer:WriteBytes(v) end
---@param strBuffer NotExportType
function LuaFramework_ByteBuffer:WriteBuffer(strBuffer) end
---@return number
function LuaFramework_ByteBuffer:ReadByte() end
---@return number
function LuaFramework_ByteBuffer:ReadInt() end
---@return number
function LuaFramework_ByteBuffer:ReadShort() end
---@return number
function LuaFramework_ByteBuffer:ReadLong() end
---@return number
function LuaFramework_ByteBuffer:ReadFloat() end
---@return number
function LuaFramework_ByteBuffer:ReadDouble() end
---@return string
function LuaFramework_ByteBuffer:ReadString() end
---@return NotExportType
function LuaFramework_ByteBuffer:ReadBytes() end
---@return NotExportType
function LuaFramework_ByteBuffer:ReadBuffer() end
---@return NotExportType
function LuaFramework_ByteBuffer:ToBytes() end
function LuaFramework_ByteBuffer:Flush() end

---@class LuaFramework.LuaBehaviour : LuaFramework.View
---@field lifeTimeCallBack fun()
local LuaFramework_LuaBehaviour = {}
---@param go UnityEngine.GameObject
---@param luafunc fun()
function LuaFramework_LuaBehaviour.SetLuaFunction(go, luafunc) end
---@param go UnityEngine.GameObject
---@param luafunc fun()
function LuaFramework_LuaBehaviour:AddPress(go, luafunc) end
---@param go UnityEngine.GameObject
---@param luafunc fun()
function LuaFramework_LuaBehaviour:AddClick(go, luafunc) end
---@param go UnityEngine.GameObject
---@param luafunc fun()
function LuaFramework_LuaBehaviour:AddToggleChange(go, luafunc) end
---@param go UnityEngine.GameObject
---@param luafunc fun()
function LuaFramework_LuaBehaviour:AddScrollRectChange(go, luafunc) end
---@param go UnityEngine.GameObject
---@param luafunc fun()
function LuaFramework_LuaBehaviour:AddInputFieldOnEndEvent(go, luafunc) end
---@param go UnityEngine.GameObject
function LuaFramework_LuaBehaviour:RemoveClick(go) end
function LuaFramework_LuaBehaviour:ClearClick() end

---@class LuaFramework.View : LuaFramework.Base
local LuaFramework_View = {}
---@param message NotExportType
function LuaFramework_View:OnMessage(message) end

---@class LuaFramework.Base : UnityEngine.MonoBehaviour
local LuaFramework_Base = {}

---@class LuaFramework.GameManager : LuaFramework.Manager
local LuaFramework_GameManager = {}
function LuaFramework_GameManager:CheckExtractResource() end
function LuaFramework_GameManager:OnResourceInited() end

---@class LuaFramework.Manager : LuaFramework.Base
local LuaFramework_Manager = {}

---@class LuaFramework.LuaManager : LuaFramework.Manager
local LuaFramework_LuaManager = {}
function LuaFramework_LuaManager:InitStart() end
---@param filename string
function LuaFramework_LuaManager:DoFile(filename) end
---@param funcName string
---@param args NotExportType
---@return NotExportType
function LuaFramework_LuaManager:CallFunction(funcName, args) end
function LuaFramework_LuaManager:LuaGC() end
function LuaFramework_LuaManager:Close() end

---@class LuaFramework.PanelManager : LuaFramework.Manager
local LuaFramework_PanelManager = {}
---@param name string
---@param func fun()
function LuaFramework_PanelManager:CreatePanel(name, func) end
---@param name string
function LuaFramework_PanelManager:ClosePanel(name) end

---@class LuaFramework.SoundManager : LuaFramework.Manager
---@field m_SoundPlayOverCallBack fun()
local LuaFramework_SoundManager = {}
---@param abName string
---@param assetNames NotExportType
---@param callback fun()
function LuaFramework_SoundManager:InitAudioMixer(abName, assetNames, callback) end
---@param sceneName string
function LuaFramework_SoundManager:SwitchAudioMixer(sceneName) end
---@param abName string
---@param assetName string
---@param mixType string
---@param extension string
function LuaFramework_SoundManager:PlayBackSoundFadeIn(abName, assetName, mixType, extension) end
---@param audioName string
---@return boolean
function LuaFramework_SoundManager:IsBGMPlaying(audioName) end
---@param abName string
---@param assetName string
---@param mixType string
---@param extension string
function LuaFramework_SoundManager:PlayBackSound(abName, assetName, mixType, extension) end
---@param abName string
---@param assetName string
---@param mixType string
---@param extension string
---@param pos UnityEngine.Vector3
---@param volume number
---@return number
function LuaFramework_SoundManager:PlaySound(abName, assetName, mixType, extension, pos, volume) end
---@param abName string
---@param assetName string
---@param mixType string
---@param extension string
---@param pos UnityEngine.Vector3
---@param volume number
---@return number
function LuaFramework_SoundManager:PlaySoundLoop(abName, assetName, mixType, extension, pos, volume) end
function LuaFramework_SoundManager:PauseBackSound() end
function LuaFramework_SoundManager:ResumeBackSound() end
function LuaFramework_SoundManager:StopBackSound() end
---@param hash number
function LuaFramework_SoundManager:RemoveSound(hash) end
---@param hash number
---@return UnityEngine.AudioSource
function LuaFramework_SoundManager:GetSoundByHash(hash) end
---@param callback fun()
function LuaFramework_SoundManager:RegisterSoundPlayOverCallBack(callback) end
---@param hash number
---@return boolean
function LuaFramework_SoundManager:IsSoundPlaying(hash) end
function LuaFramework_SoundManager:PauseAllSound() end
function LuaFramework_SoundManager:ResumeAllSound() end
function LuaFramework_SoundManager:StopAllSound() end
function LuaFramework_SoundManager:UnloadAllAudio() end
---@return boolean
function LuaFramework_SoundManager:CanPlaySoundEffect() end
---@param clip UnityEngine.AudioClip
---@param position UnityEngine.Vector3
function LuaFramework_SoundManager:Play(clip, position) end
---@param mixType string
---@return number
function LuaFramework_SoundManager:GetMixerVolume(mixType) end
---@param mixType string
---@param targetVolume number
---@param time number
---@param callback fun()
function LuaFramework_SoundManager:TweenMixerVolume(mixType, targetVolume, time, callback) end
---@param mixType string
---@param sourceVolume number
---@param targetVolume number
---@param time number
---@param callback fun()
function LuaFramework_SoundManager:TweenMixerVolumeByType(mixType, sourceVolume, targetVolume, time, callback) end
---@overload fun(time : number, callback : NotExportType)
---@param time number
---@param sourceVolume number
---@param targetVolume number
---@param callback NotExportType
function LuaFramework_SoundManager:TweenOutBGM(time, sourceVolume, targetVolume, callback) end
---@overload fun(time : number, callback : NotExportType)
---@param time number
---@param sourceVolume number
---@param targetVolume number
---@param callback NotExportType
function LuaFramework_SoundManager:TweenInBGM(time, sourceVolume, targetVolume, callback) end
---@param targetVolume number
function LuaFramework_SoundManager:SetBgmVolume(targetVolume) end
---@param musicName string
---@param time number
---@param sourceVolume number
---@param targetVolume number
---@param callback NotExportType
function LuaFramework_SoundManager:TweenOutMusic(musicName, time, sourceVolume, targetVolume, callback) end

---@class LuaFramework.TimerManager : LuaFramework.Manager
---@field Interval number
local LuaFramework_TimerManager = {}
---@param value number
function LuaFramework_TimerManager:StartTimer(value) end
function LuaFramework_TimerManager:StopTimer() end
---@param info NotExportType
function LuaFramework_TimerManager:AddTimerEvent(info) end
---@param info NotExportType
function LuaFramework_TimerManager:RemoveTimerEvent(info) end
---@param info NotExportType
function LuaFramework_TimerManager:StopTimerEvent(info) end
---@param info NotExportType
function LuaFramework_TimerManager:ResumeTimerEvent(info) end

---@class LuaFramework.ThreadManager : LuaFramework.Manager
local LuaFramework_ThreadManager = {}
---@param ev NotExportType
---@param func NotExportType
function LuaFramework_ThreadManager:AddEvent(ev, func) end

---@class LuaFramework.NetworkManager : LuaFramework.Manager
---@field Connected boolean
local LuaFramework_NetworkManager = {}
---@param _event number
---@param data string
function LuaFramework_NetworkManager.AddEvent(_event, data) end
function LuaFramework_NetworkManager:OnInit() end
function LuaFramework_NetworkManager:Unload() end
---@param func string
---@param args NotExportType
---@return NotExportType
function LuaFramework_NetworkManager:CallMethod(func, args) end
---@param ip string
---@param port number
function LuaFramework_NetworkManager:SendConnect(ip, port) end
function LuaFramework_NetworkManager:Close() end
---@param msgid number
---@param body string
---@return number
function LuaFramework_NetworkManager:SendMessage(msgid, body) end

---@class LuaFramework.ResourceManager : LuaFramework.Manager
local LuaFramework_ResourceManager = {}
function LuaFramework_ResourceManager:Initialize() end
---@param abName string
---@param assetNames NotExportType
---@param func fun()
function LuaFramework_ResourceManager:LoadPrefab(abName, assetNames, func) end
---@param abname string
---@return UnityEngine.AssetBundle
function LuaFramework_ResourceManager:LoadAssetBundle(abname) end

---@class UnityEngine.U2D.SpriteAtlas : UnityEngine.Object
---@field isVariant boolean
---@field tag string
---@field spriteCount number
local UnityEngine_U2D_SpriteAtlas = {}
---@return UnityEngine.U2D.SpriteAtlas
function UnityEngine_U2D_SpriteAtlas.New() end
---@param sprite UnityEngine.Sprite
---@return boolean
function UnityEngine_U2D_SpriteAtlas:CanBindTo(sprite) end
---@param name string
---@return UnityEngine.Sprite
function UnityEngine_U2D_SpriteAtlas:GetSprite(name) end
---@overload fun(sprites : NotExportType) : number
---@param sprites NotExportType
---@param name string
---@return number
function UnityEngine_U2D_SpriteAtlas:GetSprites(sprites, name) end

---@class UnityEngine.UI.CanvasScaler : UnityEngine.EventSystems.UIBehaviour
---@field uiScaleMode NotExportEnum
---@field referencePixelsPerUnit number
---@field scaleFactor number
---@field referenceResolution UnityEngine.Vector2
---@field screenMatchMode NotExportEnum
---@field matchWidthOrHeight number
---@field physicalUnit NotExportEnum
---@field fallbackScreenDPI number
---@field defaultSpriteDPI number
---@field dynamicPixelsPerUnit number
local UnityEngine_UI_CanvasScaler = {}

---@class UnityEngine.AnimationCurve : System.Object
---@field keys NotExportType
---@field Item UnityEngine.Keyframe
---@field length number
---@field preWrapMode UnityEngine.WrapMode
---@field postWrapMode UnityEngine.WrapMode
local UnityEngine_AnimationCurve = {}
---@overload fun(keys : NotExportType) : UnityEngine.AnimationCurve
---@return UnityEngine.AnimationCurve
function UnityEngine_AnimationCurve.New() end
---@param timeStart number
---@param timeEnd number
---@param value number
---@return UnityEngine.AnimationCurve
function UnityEngine_AnimationCurve.Constant(timeStart, timeEnd, value) end
---@param timeStart number
---@param valueStart number
---@param timeEnd number
---@param valueEnd number
---@return UnityEngine.AnimationCurve
function UnityEngine_AnimationCurve.Linear(timeStart, valueStart, timeEnd, valueEnd) end
---@param timeStart number
---@param valueStart number
---@param timeEnd number
---@param valueEnd number
---@return UnityEngine.AnimationCurve
function UnityEngine_AnimationCurve.EaseInOut(timeStart, valueStart, timeEnd, valueEnd) end
---@param time number
---@return number
function UnityEngine_AnimationCurve:Evaluate(time) end
---@overload fun(time : number, value : number) : number
---@param key UnityEngine.Keyframe
---@return number
function UnityEngine_AnimationCurve:AddKey(key) end
---@param index number
---@param key UnityEngine.Keyframe
---@return number
function UnityEngine_AnimationCurve:MoveKey(index, key) end
function UnityEngine_AnimationCurve:ClearKeys() end
---@param index number
function UnityEngine_AnimationCurve:RemoveKey(index) end
---@return number
function UnityEngine_AnimationCurve:GetHashCode() end
---@param index number
---@param weight number
function UnityEngine_AnimationCurve:SmoothTangents(index, weight) end
---@overload fun(o : System.Object) : boolean
---@param other UnityEngine.AnimationCurve
---@return boolean
function UnityEngine_AnimationCurve:Equals(other) end
---@param other UnityEngine.AnimationCurve
function UnityEngine_AnimationCurve:CopyFrom(other) end

---@class UnityEngine.AnimationEvent : System.Object
---@field stringParameter string
---@field floatParameter number
---@field intParameter number
---@field objectReferenceParameter UnityEngine.Object
---@field functionName string
---@field time number
---@field messageOptions NotExportEnum
---@field isFiredByLegacy boolean
---@field isFiredByAnimator boolean
---@field animationState NotExportType
---@field animatorStateInfo UnityEngine.AnimatorStateInfo
---@field animatorClipInfo NotExportType
local UnityEngine_AnimationEvent = {}
---@return UnityEngine.AnimationEvent
function UnityEngine_AnimationEvent.New() end

---@class UnityEngine.AudioListener : UnityEngine.AudioBehaviour
---@field volume number
---@field pause boolean
---@field velocityUpdateMode NotExportEnum
local UnityEngine_AudioListener = {}
---@return UnityEngine.AudioListener
function UnityEngine_AudioListener.New() end
---@param samples NotExportType
---@param channel number
function UnityEngine_AudioListener.GetOutputData(samples, channel) end
---@param samples NotExportType
---@param channel number
---@param window NotExportEnum
function UnityEngine_AudioListener.GetSpectrumData(samples, channel, window) end

---@class UnityEngine.CanvasRenderer : UnityEngine.Component
---@field hasPopInstruction boolean
---@field materialCount number
---@field popMaterialCount number
---@field absoluteDepth number
---@field hasMoved boolean
---@field cullTransparentMesh boolean
---@field hasRectClipping boolean
---@field relativeDepth number
---@field cull boolean
---@field clippingSoftness UnityEngine.Vector2
local UnityEngine_CanvasRenderer = {}
---@return UnityEngine.CanvasRenderer
function UnityEngine_CanvasRenderer.New() end
---@overload fun(verts : NotExportType, positions : NotExportType, colors : NotExportType, uv0S : NotExportType, uv1S : NotExportType, normals : NotExportType, tangents : NotExportType, indices : NotExportType)
---@param verts NotExportType
---@param positions NotExportType
---@param colors NotExportType
---@param uv0S NotExportType
---@param uv1S NotExportType
---@param uv2S NotExportType
---@param uv3S NotExportType
---@param normals NotExportType
---@param tangents NotExportType
---@param indices NotExportType
function UnityEngine_CanvasRenderer.SplitUIVertexStreams(verts, positions, colors, uv0S, uv1S, uv2S, uv3S, normals, tangents, indices) end
---@overload fun(verts : NotExportType, positions : NotExportType, colors : NotExportType, uv0S : NotExportType, uv1S : NotExportType, normals : NotExportType, tangents : NotExportType, indices : NotExportType)
---@param verts NotExportType
---@param positions NotExportType
---@param colors NotExportType
---@param uv0S NotExportType
---@param uv1S NotExportType
---@param uv2S NotExportType
---@param uv3S NotExportType
---@param normals NotExportType
---@param tangents NotExportType
---@param indices NotExportType
function UnityEngine_CanvasRenderer.CreateUIVertexStream(verts, positions, colors, uv0S, uv1S, uv2S, uv3S, normals, tangents, indices) end
---@overload fun(verts : NotExportType, positions : NotExportType, colors : NotExportType, uv0S : NotExportType, uv1S : NotExportType, normals : NotExportType, tangents : NotExportType)
---@param verts NotExportType
---@param positions NotExportType
---@param colors NotExportType
---@param uv0S NotExportType
---@param uv1S NotExportType
---@param uv2S NotExportType
---@param uv3S NotExportType
---@param normals NotExportType
---@param tangents NotExportType
function UnityEngine_CanvasRenderer.AddUIVertexStream(verts, positions, colors, uv0S, uv1S, uv2S, uv3S, normals, tangents) end
---@param color UnityEngine.Color
function UnityEngine_CanvasRenderer:SetColor(color) end
---@return UnityEngine.Color
function UnityEngine_CanvasRenderer:GetColor() end
---@param rect UnityEngine.Rect
function UnityEngine_CanvasRenderer:EnableRectClipping(rect) end
function UnityEngine_CanvasRenderer:DisableRectClipping() end
---@overload fun(material : UnityEngine.Material, index : number)
---@param material UnityEngine.Material
---@param texture UnityEngine.Texture
function UnityEngine_CanvasRenderer:SetMaterial(material, texture) end
---@overload fun(index : number) : UnityEngine.Material
---@return UnityEngine.Material
function UnityEngine_CanvasRenderer:GetMaterial() end
---@param material UnityEngine.Material
---@param index number
function UnityEngine_CanvasRenderer:SetPopMaterial(material, index) end
---@param index number
---@return UnityEngine.Material
function UnityEngine_CanvasRenderer:GetPopMaterial(index) end
---@param texture UnityEngine.Texture
function UnityEngine_CanvasRenderer:SetTexture(texture) end
---@param texture UnityEngine.Texture
function UnityEngine_CanvasRenderer:SetAlphaTexture(texture) end
---@param mesh NotExportType
function UnityEngine_CanvasRenderer:SetMesh(mesh) end
---@return NotExportType
function UnityEngine_CanvasRenderer:GetMesh() end
function UnityEngine_CanvasRenderer:Clear() end
---@return number
function UnityEngine_CanvasRenderer:GetAlpha() end
---@param alpha number
function UnityEngine_CanvasRenderer:SetAlpha(alpha) end
---@return number
function UnityEngine_CanvasRenderer:GetInheritedAlpha() end

---@class ReferGameObjects : UnityEngine.MonoBehaviour
---@field names NotExportType
---@field monos NotExportType
---@field Length number
local ReferGameObjects = {}
---@param n string
---@return UnityEngine.Object
function ReferGameObjects:Get(n) end
---@param obj UnityEngine.Object
---@param name string
function ReferGameObjects:Set(obj, name) end
---@param index number
---@return UnityEngine.Object
function ReferGameObjects:GetByIndex(index) end
function ReferGameObjects:UpdateName() end

---@class LuaHttpRequest : System.Object
local LuaHttpRequest = {}
---@param url string
---@param method string
---@param func fun()
---@return LuaHttpRequest
function LuaHttpRequest.New(url, method, func) end
---@param k string
---@param v string
function LuaHttpRequest:AddHeader(k, v) end
---@param k string
---@param v string
function LuaHttpRequest:AddField(k, v) end
---@param second number
function LuaHttpRequest:SetConnectTimeOut(second) end
---@param timeOut number
function LuaHttpRequest:SetTimeOut(timeOut) end
---@param key string
function LuaHttpRequest:Do(key) end

---@class UnityEngine.SpriteRenderer : UnityEngine.Renderer
---@field sprite UnityEngine.Sprite
---@field drawMode NotExportEnum
---@field size UnityEngine.Vector2
---@field adaptiveModeThreshold number
---@field tileMode NotExportEnum
---@field color UnityEngine.Color
---@field maskInteraction NotExportEnum
---@field flipX boolean
---@field flipY boolean
---@field spriteSortPoint NotExportEnum
local UnityEngine_SpriteRenderer = {}
---@return UnityEngine.SpriteRenderer
function UnityEngine_SpriteRenderer.New() end
---@param callback NotExportType
function UnityEngine_SpriteRenderer:RegisterSpriteChangeCallback(callback) end
---@param callback NotExportType
function UnityEngine_SpriteRenderer:UnregisterSpriteChangeCallback(callback) end

---@class InfiniteScroller : UnityEngine.MonoBehaviour
local InfiniteScroller = {}
---@param callbackChange fun()
---@param callbackEndDrag fun()
---@param callbackBeginDrag fun()
function InfiniteScroller:RegCallback(callbackChange, callbackEndDrag, callbackBeginDrag) end
function InfiniteScroller:UnRegCallback() end
---@return UnityEngine.UI.ScrollRect
function InfiniteScroller:GetScrollRect() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function InfiniteScroller:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function InfiniteScroller:OnBeginDrag(eventData) end

---@class RollingNumberUGUI : UnityEngine.MonoBehaviour
---@field autoScale boolean
---@field maxLengthLarge number
---@field scaleSmall number
---@field scaleLarge number
---@field thousandComma boolean
---@field textComp UnityEngine.UI.Text
---@field deltaWaitTime_new number
---@field text string
local RollingNumberUGUI = {}
---@param seperator boolean
function RollingNumberUGUI:SetSeparator(seperator) end
---@param kmb boolean
function RollingNumberUGUI:SetKMB(kmb) end
---@param value number
function RollingNumberUGUI:SetValue(value) end
---@return number
function RollingNumberUGUI:GetValue() end
---@param value number
---@param time number
---@param callback fun()
---@param rank number
function RollingNumberUGUI:RollByTime(value, time, callback, rank) end
---@param value number
---@param speed number
---@param callback fun()
function RollingNumberUGUI:RollBySpeed(value, speed, callback) end
function RollingNumberUGUI:Stop() end
function RollingNumberUGUI:StopToEnd() end
function RollingNumberUGUI:StopToEndWithoutCallback() end
function RollingNumberUGUI:SetDisableState() end
function RollingNumberUGUI:SetEnableState() end
---@param color UnityEngine.Color
function RollingNumberUGUI:SetColor(color) end
---@return UnityEngine.Color
function RollingNumberUGUI:GetColor() end
---@param callback fun()
function RollingNumberUGUI:SetCallbackOnChange(callback) end
---@param duration number
function RollingNumberUGUI:FadeIn(duration) end
---@return number
function RollingNumberUGUI:GetCurrentValue() end
---@param value number
---@param time number
---@param callback fun()
function RollingNumberUGUI:RollByTimeAcc(value, time, callback) end
---@return boolean
function RollingNumberUGUI:IsRolling() end

---@class TextAutoScaler : UnityEngine.MonoBehaviour
---@field textComp UnityEngine.UI.Text
---@field length number
---@field scaleSmall number
---@field scaleLarge number
---@field text string
local TextAutoScaler = {}

---@class AppleSignInHelper : System.Object
---@field Instance AppleSignInHelper
local AppleSignInHelper = {}
---@return AppleSignInHelper
function AppleSignInHelper.New() end
function AppleSignInHelper:Init() end
---@param appleUserId string
---@param callback fun()
function AppleSignInHelper:CheckCredentialStatusForUserId(appleUserId, callback) end
---@param callback fun()
function AppleSignInHelper:Login(callback) end
function AppleSignInHelper:Update() end
---@param callback fun()
function AppleSignInHelper:QuickLogin(callback) end
function AppleSignInHelper:GoToComment() end
---@return string
function AppleSignInHelper:GetOnlyID_By_KeyChain() end
function AppleSignInHelper:AttPermissionRequest() end
function AppleSignInHelper:showSimGDPR() end
---@param mailAdress string
function AppleSignInHelper:SetFirebaseAnalyticsMail(mailAdress) end

---@class FaceBookHelper : System.Object
---@field m_LuaLoginCallBackFunc fun()
---@field m_LuaLimitLoginCallBackFunc fun()
---@field m_RefreshTokenCallback fun()
---@field m_UserPhotoCallback fun()
---@field Instance FaceBookHelper
local FaceBookHelper = {}
function FaceBookHelper:Init() end
---@param callback fun()
function FaceBookHelper:Login(callback) end
function FaceBookHelper:LogOut() end
---@param purchase number
---@param currency string
---@param item_id string
function FaceBookHelper:LogPurchase(purchase, currency, item_id) end
---@param luaFunction fun()
function FaceBookHelper:RefreshAccessToken(luaFunction) end
---@param callback fun()
function FaceBookHelper:RequestUserPhoto(callback) end
---@param url string
---@param title string
---@param content string
---@param photoUrl string
---@param callback fun()
function FaceBookHelper:Share2Friend(url, title, content, photoUrl, callback) end
---@param url string
---@param callback fun()
function FaceBookHelper:InviteFriend(url, callback) end
---@param packageName string
---@param priceAmount number
---@param priceCurrency string
function FaceBookHelper:LogPurchaseFb(packageName, priceAmount, priceCurrency) end
---@param storeItem string
---@param numGold number
function FaceBookHelper:LogAppEventFb(storeItem, numGold) end
---@return boolean
function FaceBookHelper:CheckAttAuthorized() end
---@param callback fun()
function FaceBookHelper:LimitLogin(callback) end

---@class IAPHelper : System.Object
---@field environment string
---@field Instance IAPHelper
local IAPHelper = {}
---@param products NotExportType
function IAPHelper:RegisterProducts(products) end
---@param _function fun()
function IAPHelper:RegisterInitializeCallback(_function) end
---@param _function fun()
function IAPHelper:RegisterSuccessCallback(_function) end
---@param _function fun()
function IAPHelper:RegisterFailCallback(_function) end
---@param _function fun()
function IAPHelper:RegisterPendingCallback(_function) end
function IAPHelper:Initialize() end
---@overload fun(product : NotExportType, failureDescription : NotExportType)
---@param product NotExportType
---@param failureReason NotExportEnum
function IAPHelper:OnPurchaseFailed(product, failureReason) end
---@param controller NotExportType
---@param extensions NotExportType
function IAPHelper:OnInitialized(controller, extensions) end
---@overload fun(error : NotExportEnum)
---@param error NotExportEnum
---@param str string
function IAPHelper:OnInitializeFailed(error, str) end
---@param productId string
---@param payload string
function IAPHelper:DoPurchasing(productId, payload) end
---@param args NotExportType
---@return NotExportEnum
function IAPHelper:ProcessPurchase(args) end

---@class AIHelpHelper : UnityEngine.MonoBehaviour
---@field Instance AIHelpHelper
local AIHelpHelper = {}
function AIHelpHelper.Init() end
---@param EntranceId string
function AIHelpHelper:ShowConversation(EntranceId) end
---@param customs string
---@param UserId string
---@param UserName string
function AIHelpHelper:updateUserInfo(customs, UserId, UserName) end

---@class GoogleCoreHelper : UnityEngine.MonoBehaviour
---@field Instance GoogleCoreHelper
local GoogleCoreHelper = {}
function GoogleCoreHelper.Init() end
function GoogleCoreHelper:OpenReview() end

---@class ThinkingAnalyticsHelper : SingletonEx_ThinkingAnalyticsHelper
---@field isSetTime boolean
local ThinkingAnalyticsHelper = {}
---@return string
function ThinkingAnalyticsHelper:GetRam() end
---@return NotExportType
function ThinkingAnalyticsHelper:GetDynamicSuperProperties() end
---@param type number
---@param properties NotExportType
---@return NotExportType
function ThinkingAnalyticsHelper:AutoTrackEventCallback(type, properties) end
function ThinkingAnalyticsHelper:InitSDK() end
---@param id string
function ThinkingAnalyticsHelper:SetGuideID(id) end
---@param id string
function ThinkingAnalyticsHelper:Login(id) end
function ThinkingAnalyticsHelper:Logout() end
---@overload fun(evt : string, parameters : NotExportType)
---@overload fun(evt : string, jsonStr : string)
---@param evt string
function ThinkingAnalyticsHelper:TrackEvent(evt) end
---@param delta number
function ThinkingAnalyticsHelper:SetServerDelta(delta) end
---@param timestamp number
function ThinkingAnalyticsHelper:CalibrateTime(timestamp) end

---@class SingletonEx_ThinkingAnalyticsHelper : UnityEngine.MonoBehaviour
---@field Instance ThinkingAnalyticsHelper
---@field IsActive boolean
---@field TypeName string
local SingletonEx_ThinkingAnalyticsHelper = {}
function SingletonEx_ThinkingAnalyticsHelper:Start() end
function SingletonEx_ThinkingAnalyticsHelper:SaveState() end

---@class UnityEngine.SystemInfo : System.Object
---@field unsupportedIdentifier string
---@field batteryLevel number
---@field batteryStatus NotExportEnum
---@field operatingSystem string
---@field operatingSystemFamily NotExportEnum
---@field processorType string
---@field processorFrequency number
---@field processorCount number
---@field systemMemorySize number
---@field deviceUniqueIdentifier string
---@field deviceName string
---@field deviceModel string
---@field supportsAccelerometer boolean
---@field supportsGyroscope boolean
---@field supportsLocationService boolean
---@field supportsVibration boolean
---@field supportsAudio boolean
---@field deviceType NotExportEnum
---@field graphicsMemorySize number
---@field graphicsDeviceName string
---@field graphicsDeviceVendor string
---@field graphicsDeviceID number
---@field graphicsDeviceVendorID number
---@field graphicsDeviceType NotExportEnum
---@field graphicsUVStartsAtTop boolean
---@field graphicsDeviceVersion string
---@field graphicsShaderLevel number
---@field graphicsMultiThreaded boolean
---@field renderingThreadingMode NotExportEnum
---@field foveatedRenderingCaps NotExportEnum
---@field hasHiddenSurfaceRemovalOnGPU boolean
---@field hasDynamicUniformArrayIndexingInFragmentShaders boolean
---@field supportsShadows boolean
---@field supportsRawShadowDepthSampling boolean
---@field supportsMotionVectors boolean
---@field supports3DTextures boolean
---@field supportsCompressed3DTextures boolean
---@field supports2DArrayTextures boolean
---@field supports3DRenderTextures boolean
---@field supportsCubemapArrayTextures boolean
---@field supportsAnisotropicFilter boolean
---@field copyTextureSupport NotExportEnum
---@field supportsComputeShaders boolean
---@field supportsGeometryShaders boolean
---@field supportsTessellationShaders boolean
---@field supportsRenderTargetArrayIndexFromVertexShader boolean
---@field supportsInstancing boolean
---@field supportsHardwareQuadTopology boolean
---@field supports32bitsIndexBuffer boolean
---@field supportsSparseTextures boolean
---@field supportedRenderTargetCount number
---@field supportsSeparatedRenderTargetsBlend boolean
---@field supportedRandomWriteTargetCount number
---@field supportsMultisampledTextures number
---@field supportsMultisampled2DArrayTextures boolean
---@field supportsMultisampleAutoResolve boolean
---@field supportsTextureWrapMirrorOnce number
---@field usesReversedZBuffer boolean
---@field npotSupport NotExportEnum
---@field maxTextureSize number
---@field maxTexture3DSize number
---@field maxTextureArraySlices number
---@field maxCubemapSize number
---@field maxAnisotropyLevel number
---@field maxComputeBufferInputsVertex number
---@field maxComputeBufferInputsFragment number
---@field maxComputeBufferInputsGeometry number
---@field maxComputeBufferInputsDomain number
---@field maxComputeBufferInputsHull number
---@field maxComputeBufferInputsCompute number
---@field maxComputeWorkGroupSize number
---@field maxComputeWorkGroupSizeX number
---@field maxComputeWorkGroupSizeY number
---@field maxComputeWorkGroupSizeZ number
---@field computeSubGroupSize number
---@field supportsAsyncCompute boolean
---@field supportsGpuRecorder boolean
---@field supportsGraphicsFence boolean
---@field supportsAsyncGPUReadback boolean
---@field supportsRayTracing boolean
---@field supportsSetConstantBuffer boolean
---@field constantBufferOffsetAlignment number
---@field maxConstantBufferSize number
---@field maxGraphicsBufferSize number
---@field hasMipMaxLevel boolean
---@field supportsMipStreaming boolean
---@field usesLoadStoreActions boolean
---@field hdrDisplaySupportFlags NotExportEnum
---@field supportsConservativeRaster boolean
---@field supportsMultiview boolean
---@field supportsStoreAndResolveAction boolean
---@field supportsMultisampleResolveDepth boolean
---@field supportsMultisampleResolveStencil boolean
---@field supportsIndirectArgumentsBuffer boolean
local UnityEngine_SystemInfo = {}
---@return UnityEngine.SystemInfo
function UnityEngine_SystemInfo.New() end
---@param format NotExportEnum
---@return boolean
function UnityEngine_SystemInfo.SupportsRenderTextureFormat(format) end
---@param format NotExportEnum
---@return boolean
function UnityEngine_SystemInfo.SupportsBlendingOnRenderTextureFormat(format) end
---@param format NotExportEnum
---@return boolean
function UnityEngine_SystemInfo.SupportsRandomWriteOnRenderTextureFormat(format) end
---@param format NotExportEnum
---@return boolean
function UnityEngine_SystemInfo.SupportsTextureFormat(format) end
---@param format NotExportEnum
---@param dimension number
---@return boolean
function UnityEngine_SystemInfo.SupportsVertexAttributeFormat(format, dimension) end
---@param format NotExportEnum
---@param usage NotExportEnum
---@return boolean
function UnityEngine_SystemInfo.IsFormatSupported(format, usage) end
---@param format NotExportEnum
---@param usage NotExportEnum
---@return NotExportEnum
function UnityEngine_SystemInfo.GetCompatibleFormat(format, usage) end
---@param format NotExportEnum
---@return NotExportEnum
function UnityEngine_SystemInfo.GetGraphicsFormat(format) end
---@param desc NotExportType
---@return number
function UnityEngine_SystemInfo.GetRenderTextureSupportedMSAASampleCount(desc) end

---@class Facebook.Unity.AccessToken : System.Object
---@field CurrentAccessToken Facebook.Unity.AccessToken
---@field TokenString string
---@field ExpirationTime NotExportType
---@field Permissions NotExportType
---@field UserId string
---@field LastRefresh NotExportType
---@field GraphDomain string
local Facebook_Unity_AccessToken = {}
---@return string
function Facebook_Unity_AccessToken:ToString() end

---@class Facebook.Unity.AuthenticationToken : System.Object
---@field TokenString string
---@field Nonce string
local Facebook_Unity_AuthenticationToken = {}
---@return string
function Facebook_Unity_AuthenticationToken:ToString() end

---@class InputFieldController : UnityEngine.MonoBehaviour
---@field text string
local InputFieldController = {}
---@param callbackEndEdit fun()
function InputFieldController:SetCallback(callbackEndEdit) end

---@class LuaGameBase.ClickScript : LuaGameBase.ClickScriptBase
local LuaGameBase_ClickScript = {}
---@param callback fun()
function LuaGameBase_ClickScript:AddOnMouseDownListener(callback) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function LuaGameBase_ClickScript:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function LuaGameBase_ClickScript:OnDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function LuaGameBase_ClickScript:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function LuaGameBase_ClickScript:OnPointerClick(eventData) end

---@class LuaGameBase.ClickScriptBase : UnityEngine.MonoBehaviour
---@field m_IsClick boolean
local LuaGameBase_ClickScriptBase = {}
---@param eventData UnityEngine.EventSystems.PointerEventData
function LuaGameBase_ClickScriptBase:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function LuaGameBase_ClickScriptBase:OnDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function LuaGameBase_ClickScriptBase:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function LuaGameBase_ClickScriptBase:OnPointerClick(eventData) end

---@class UnityEngine.Ping : System.Object
---@field isDone boolean
---@field time number
---@field ip string
local UnityEngine_Ping = {}
---@param address string
---@return UnityEngine.Ping
function UnityEngine_Ping.New(address) end
function UnityEngine_Ping:DestroyPing() end

---@class UnityEngine.UI.Slider : UnityEngine.UI.Selectable
---@field fillRect UnityEngine.RectTransform
---@field handleRect UnityEngine.RectTransform
---@field direction NotExportEnum
---@field minValue number
---@field maxValue number
---@field wholeNumbers boolean
---@field value number
---@field normalizedValue number
---@field onValueChanged NotExportType
local UnityEngine_UI_Slider = {}
---@param input number
function UnityEngine_UI_Slider:SetValueWithoutNotify(input) end
---@param executing NotExportEnum
function UnityEngine_UI_Slider:Rebuild(executing) end
function UnityEngine_UI_Slider:LayoutComplete() end
function UnityEngine_UI_Slider:GraphicUpdateComplete() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_Slider:OnPointerDown(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_Slider:OnDrag(eventData) end
---@param eventData NotExportType
function UnityEngine_UI_Slider:OnMove(eventData) end
---@return UnityEngine.UI.Selectable
function UnityEngine_UI_Slider:FindSelectableOnLeft() end
---@return UnityEngine.UI.Selectable
function UnityEngine_UI_Slider:FindSelectableOnRight() end
---@return UnityEngine.UI.Selectable
function UnityEngine_UI_Slider:FindSelectableOnUp() end
---@return UnityEngine.UI.Selectable
function UnityEngine_UI_Slider:FindSelectableOnDown() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_Slider:OnInitializePotentialDrag(eventData) end
---@param direction NotExportEnum
---@param includeRectLayouts boolean
function UnityEngine_UI_Slider:SetDirection(direction, includeRectLayouts) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_UI_Slider:DOValue(endValue, duration, snapping) end

---@class UnityEngine.SceneManagement.Scene : System.ValueType
---@field handle number
---@field path string
---@field name string
---@field isLoaded boolean
---@field buildIndex number
---@field isDirty boolean
---@field rootCount number
---@field isSubScene boolean
local UnityEngine_SceneManagement_Scene = {}
---@return boolean
function UnityEngine_SceneManagement_Scene:IsValid() end
---@overload fun() : NotExportType
---@param rootGameObjects NotExportType
function UnityEngine_SceneManagement_Scene:GetRootGameObjects(rootGameObjects) end
---@return number
function UnityEngine_SceneManagement_Scene:GetHashCode() end
---@param other System.Object
---@return boolean
function UnityEngine_SceneManagement_Scene:Equals(other) end

---@class LuaFramework.AnimHelper : System.Object
---@field easy_state DG.Tweening.Ease
local LuaFramework_AnimHelper = {}
---@return LuaFramework.AnimHelper
function LuaFramework_AnimHelper.New() end
---@param sourceNum NotExportType
---@param targetNum number
---@param t number
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.AniDoSmoothFloat(sourceNum, targetNum, t) end
---@overload fun(sourceNum : NotExportType, targetNum : number, t : number, callback : fun()) : DG.Tweening.Tweener
---@overload fun(sourceNum : number, targetNum : number, t : number, callback : fun()) : DG.Tweening.Tweener
---@param text UnityEngine.UI.Text
---@param sourceNum number
---@param targetNum number
---@param speed number
---@param ease DG.Tweening.Ease
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoSmoothInt(text, sourceNum, targetNum, speed, ease, callback) end
---@param sourceNum number
---@param targetNum number
---@param t number
---@param callback fun()
---@param complete_callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoSmoothFloatUpdate(sourceNum, targetNum, t, callback, complete_callback) end
---@param sourceNum number
---@param targetNum number
---@param t number
---@param callback fun()
---@param complete_callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoSmootFloatUpdateAverage(sourceNum, targetNum, t, callback, complete_callback) end
---@param sourceNum TMPro.TextMeshProUGUI
---@param targetNum number
---@param t number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoSmoothText(sourceNum, targetNum, t, callback) end
---@param text UnityEngine.UI.Text
---@param sourceNum number
---@param targetNum number
---@param t number
---@param ease DG.Tweening.Ease
---@param updateCallback fun()
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoSmoothInt2(text, sourceNum, targetNum, t, ease, updateCallback, callback) end
---@param sourceNum TMPro.TextMeshProUGUI
---@param targetNum number
---@param t number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoSmoothNumTextWithComma(sourceNum, targetNum, t, callback) end
---@param go UnityEngine.GameObject
---@param pos NotExportType
---@param time number
---@param delay number
---@param pathType number
---@param withEase number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoSmoothPath(go, pos, time, delay, pathType, withEase, callback) end
---@param go UnityEngine.GameObject
---@param pos NotExportType
---@param time number
---@param delay number
---@param pathType number
---@param withEase number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoSmoothLocalPath(go, pos, time, delay, pathType, withEase, callback) end
---@param go UnityEngine.GameObject
---@param pos NotExportType
---@param time number
---@param delay number
---@param pathType number
---@param withEase number
---@param callback fun()
---@param is_local boolean
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoBezierPath(go, pos, time, delay, pathType, withEase, callback, is_local) end
---@param go UnityEngine.GameObject
---@param pos NotExportType
---@param time number
---@param callback fun()
---@return NotExportType
function LuaFramework_AnimHelper.DoThrowPathMove(go, pos, time, callback) end
---@param startPoint UnityEngine.Vector3
---@param controlPoint UnityEngine.Vector3
---@param endPoint UnityEngine.Vector3
---@param segmentNum number
---@return NotExportType
function LuaFramework_AnimHelper.GetBeizerList(startPoint, controlPoint, endPoint, segmentNum) end
---@param go UnityEngine.GameObject
---@param x number
---@param y number
---@param z number
---@param t number
---@param isLocal boolean
---@param callBack fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.Move(go, x, y, z, t, isLocal, callBack) end
---@overload fun(go : UnityEngine.GameObject, x : number, y : number, z : number, t : number, isLocal : boolean, ease : DG.Tweening.Ease, callBack : fun()) : DG.Tweening.Tweener
---@param go UnityEngine.GameObject
---@param x number
---@param y number
---@param z number
---@param t number
---@param isLocal boolean
---@param ease DG.Tweening.Ease
---@param update fun()
---@param callBack fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.MoveEase(go, x, y, z, t, isLocal, ease, update, callBack) end
---@param go UnityEngine.GameObject
---@param x number
---@param y number
---@param z number
---@param t number
---@param isLocal boolean
---@param callBack fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.Scale(go, x, y, z, t, isLocal, callBack) end
---@param go UnityEngine.GameObject
---@param x number
---@param y number
---@param z number
---@param t number
---@param isLocal boolean
---@param callBack fun()
---@param ease DG.Tweening.Ease
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.Scale_ease(go, x, y, z, t, isLocal, callBack, ease) end
---@param render UnityEngine.SpriteRenderer
---@param color UnityEngine.Color
---@param time number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoColor(render, color, time, callback) end
---@param render UnityEngine.SpriteRenderer
---@param color UnityEngine.Color
---@param time number
---@param loopCnt number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoColorLoop(render, color, time, loopCnt, callback) end
---@param render UnityEngine.UI.Image
---@param color UnityEngine.Color
---@param time number
---@param loopCnt number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoImageColorLoop(render, color, time, loopCnt, callback) end
---@param go UnityEngine.GameObject
---@param scale number
---@param time number
---@param loopCnt number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoScaleLoop(go, scale, time, loopCnt, callback) end
---@param scrollContent UnityEngine.RectTransform
---@param targetX number
---@param time number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.ScrollToX(scrollContent, targetX, time, callback) end
---@param scrollContent UnityEngine.RectTransform
---@param targetX number
---@param time number
---@param ease DG.Tweening.Ease
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.ScrollToX_Ease(scrollContent, targetX, time, ease, callback) end
---@param scrollContent UnityEngine.RectTransform
---@param targetY number
---@param time number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.ScrollToY(scrollContent, targetY, time, callback) end
---@param scrollContent UnityEngine.RectTransform
---@param targetY number
---@param time number
---@param ease DG.Tweening.Ease
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.ScrollToY_Ease(scrollContent, targetY, time, ease, callback) end
---@param scrollContent UnityEngine.RectTransform
---@param pos UnityEngine.Vector2
---@param time number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.ScrollToXY(scrollContent, pos, time, callback) end
---@param scrollContent UnityEngine.RectTransform
---@param pos UnityEngine.Vector2
---@param time number
---@param easeType DG.Tweening.Ease
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.ScrollToXY_Ease(scrollContent, pos, time, easeType, callback) end
---@overload fun(slider : UnityEngine.UI.Slider, text : TMPro.TextMeshProUGUI, target : number, time : number, callback : fun()) : DG.Tweening.Tweener
---@overload fun(slider : UnityEngine.UI.Slider, text : UnityEngine.UI.Text, target : number, time : number, callback : fun()) : DG.Tweening.Tweener
---@param slider UnityEngine.UI.Slider
---@param text UnityEngine.UI.Text
---@param target number
---@param max number
---@param time number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.SlideTo(slider, text, target, max, time, callback) end
---@param go UnityEngine.GameObject
---@param to UnityEngine.Vector3
---@param duration number
---@param delay number
---@param isLocal boolean
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DelayMove(go, to, duration, delay, isLocal, callback) end
---@param image UnityEngine.UI.Image
---@param to number
---@param duration number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoFade(image, to, duration, callback) end
---@param image UnityEngine.UI.Image
---@param to number
---@param duration number
---@param time number
---@param looptype number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoFadeLoop(image, to, duration, time, looptype, callback) end
---@param text TMPro.TextMeshProUGUI
---@param to number
---@param duration number
---@param time number
---@param looptype number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoFadeTextLoop(text, to, duration, time, looptype, callback) end
---@param canvasGroup UnityEngine.CanvasGroup
---@param to number
---@param duration number
---@param time number
---@param looptype number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoCanvasGroupFadeLoop(canvasGroup, to, duration, time, looptype, callback) end
---@param text TMPro.TextMeshProUGUI
---@param to number
---@param duration number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoFadeText(text, to, duration, callback) end
---@param canvasGroup UnityEngine.CanvasGroup
---@param to number
---@param duration number
---@param delay number
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoCanvasGroupFade(canvasGroup, to, duration, delay, callback) end
---@param go UnityEngine.GameObject
---@param duration number
---@param vibrato number
---@param x number
---@param y number
---@param z number
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.ShakePosition(go, duration, vibrato, x, y, z) end
---@param go UnityEngine.GameObject
---@param x number
---@param y number
---@param z number
---@param t number
---@param isLocal boolean
---@param callBack fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.rotate(go, x, y, z, t, isLocal, callBack) end
---@param tween DG.Tweening.Tweener
---@param callback fun()
---@return DG.Tweening.Tweener
function LuaFramework_AnimHelper.DoOnComplete(tween, callback) end
---@param go UnityEngine.GameObject
function LuaFramework_AnimHelper.Kill(go) end

---@class FirebaseHelper : System.Object
---@field Token string
local FirebaseHelper = {}
---@return FirebaseHelper
function FirebaseHelper.New() end
function FirebaseHelper.FirebaseInitAsync() end
function FirebaseHelper.Destroy() end
---@param evt string
---@param parameters NotExportType
function FirebaseHelper.TrackEvent(evt, parameters) end
---@param prop string
---@param value string
function FirebaseHelper.SetUserProperty(prop, value) end
function FirebaseHelper.TrackEvent_reward_video() end
function FirebaseHelper.TrackEvent_interstitial_video() end
function FirebaseHelper.TrackEvent_reward_video_loaded() end
function FirebaseHelper.TrackEvent_interstitial_video_loaded() end
---@param userId string
function FirebaseHelper.SetUserId(userId) end
---@param id string
---@param category string
---@param money string
---@param currency string
function FirebaseHelper.Revenue(id, category, money, currency) end
---@param lunc fun()
function FirebaseHelper.SendTokenToLua(lunc) end

---@class MaxAdHelper : System.Object
---@field IsAttAuthorized boolean
---@field uId string
---@field I MaxAdHelper
local MaxAdHelper = {}
---@return MaxAdHelper
function MaxAdHelper.New() end
---@param uid string
---@param segament string
function MaxAdHelper:InitializeSdk(uid, segament) end
---@return number
function MaxAdHelper:GetRewardState() end
---@param cb fun()
function MaxAdHelper:SetRewardReceivedCallBack(cb) end
---@param cb fun()
function MaxAdHelper:SetRewardAdMissCallBack(cb) end
---@param cb fun()
function MaxAdHelper:SetRewardRevenuePaidCallBack(cb) end
---@param cb fun()
function MaxAdHelper:SetAdHiddenEventCallBack(cb) end
---@param cb fun()
function MaxAdHelper:SetAdDisplayFailedEventCallBack(cb) end
---@param cb fun()
function MaxAdHelper:SetAdBiEventCallBack(cb) end
function MaxAdHelper:LoadInterstitial() end
---@return boolean
function MaxAdHelper:IsInterstitialReady() end
---@param placement string
---@param customData string
function MaxAdHelper:ShowInterstitial(placement, customData) end
function MaxAdHelper:LoadRewardedAd() end
---@return boolean
function MaxAdHelper:IsRewardedAdReady() end
---@param placement string
---@param customData string
function MaxAdHelper:ShowRewardedAd(placement, customData) end
function MaxAdHelper:ShowDebugger() end
---@param eventName string
---@param adType number
function MaxAdHelper:SendAdMessageToBI(eventName, adType) end
---@param Code string
---@param Message string
---@param MediatedNetworkErrorCode string
---@param MediatedNetworkErrorMessage string
---@param AdLoadFailureInfo string
function MaxAdHelper:SendAdFailMessageToBI(Code, Message, MediatedNetworkErrorCode, MediatedNetworkErrorMessage, AdLoadFailureInfo) end
function MaxAdHelper:SendAdAdInterMessageToBI() end
---@param eventName string
---@param adInfo MaxSdkBase.AdInfo
function MaxAdHelper:SendAdFillMessageToBI(eventName, adInfo) end
---@param authType string
function MaxAdHelper:SendPrivacyPopMessageToBI(authType) end
---@param attstatus string
---@param uid string
function MaxAdHelper:SendATTMessageToBI(attstatus, uid) end

---@class LuaGameBase.GameCollection : System.Object
local LuaGameBase_GameCollection = {}
---@return LuaGameBase.GameCollection
function LuaGameBase_GameCollection.New() end
---@param num number
---@return NotExportType
function LuaGameBase_GameCollection.GetGOArray(num) end
---@param json string
---@return NotExportType
function LuaGameBase_GameCollection.JsonToBytes(json) end
---@return NotExportType
function LuaGameBase_GameCollection.GetJsonHeader() end

---@class WriteFiles : System.Object
---@field WritFile WriteFiles
local WriteFiles = {}
---@return WriteFiles
function WriteFiles.New() end
function WriteFiles.WriteStringToFile() end
---@param txt string
---@param detail string
---@return string
function WriteFiles.WriteFrameToFile(txt, detail) end
---@param type UnityEngine.LogType
---@param format string
function WriteFiles:Log(type, format) end

---@class UnityEngine.LogType
---@field Error UnityEngine.LogType
---@field Assert UnityEngine.LogType
---@field Warning UnityEngine.LogType
---@field Log UnityEngine.LogType
---@field Exception UnityEngine.LogType
local UnityEngine_LogType = {}

---@class MaxSdkBase.AdInfo : System.Object
---@field AdUnitIdentifier string
---@field AdFormat string
---@field NetworkName string
---@field NetworkPlacement string
---@field Placement string
---@field CreativeIdentifier string
---@field Revenue number
---@field RevenuePrecision string
---@field WaterfallInfo NotExportType
---@field LatencyMillis number
---@field DspName string
local MaxSdkBase_AdInfo = {}
---@param adInfoDictionary NotExportType
---@return MaxSdkBase.AdInfo
function MaxSdkBase_AdInfo.New(adInfoDictionary) end
---@return string
function MaxSdkBase_AdInfo:ToString() end

---@class MyGame.VersionReader : System.Object
local MyGame_VersionReader = {}
---@return MyGame.VersionReader
function MyGame_VersionReader.New() end
---@param jsonstr string
---@return number
function MyGame_VersionReader.ReadVersion(jsonstr) end
---@param jsonstr string
---@return NotExportType
function MyGame_VersionReader.ReadVersionInfo(jsonstr) end
---@return number
function MyGame_VersionReader.GetLobbyVersion() end
---@return number
function MyGame_VersionReader.GetLobbyVersionInPack() end
---@return number
function MyGame_VersionReader.GetLobbyVersionInPack2() end
function MyGame_VersionReader.SetVersionToInitState() end
---@param machine_id number
---@return number
function MyGame_VersionReader.GetMachineVersion(machine_id) end
---@param machine_id number
---@return number
function MyGame_VersionReader.GetMachineVersionInPack(machine_id) end
---@param versionFilePath string
---@param encrypted boolean
---@return number
function MyGame_VersionReader.GetLocalResVersion(versionFilePath, encrypted) end

---@class UnityEngine.UI.ScrollRect : UnityEngine.EventSystems.UIBehaviour
---@field content UnityEngine.RectTransform
---@field horizontal boolean
---@field vertical boolean
---@field movementType NotExportEnum
---@field elasticity number
---@field inertia boolean
---@field decelerationRate number
---@field scrollSensitivity number
---@field viewport UnityEngine.RectTransform
---@field horizontalScrollbar NotExportType
---@field verticalScrollbar NotExportType
---@field horizontalScrollbarVisibility NotExportEnum
---@field verticalScrollbarVisibility NotExportEnum
---@field horizontalScrollbarSpacing number
---@field verticalScrollbarSpacing number
---@field onValueChanged UnityEngine.UI.ScrollRect.ScrollRectEvent
---@field velocity UnityEngine.Vector2
---@field normalizedPosition UnityEngine.Vector2
---@field horizontalNormalizedPosition number
---@field verticalNormalizedPosition number
---@field minWidth number
---@field preferredWidth number
---@field flexibleWidth number
---@field minHeight number
---@field preferredHeight number
---@field flexibleHeight number
---@field layoutPriority number
local UnityEngine_UI_ScrollRect = {}
---@param executing NotExportEnum
function UnityEngine_UI_ScrollRect:Rebuild(executing) end
function UnityEngine_UI_ScrollRect:LayoutComplete() end
function UnityEngine_UI_ScrollRect:GraphicUpdateComplete() end
---@return boolean
function UnityEngine_UI_ScrollRect:IsActive() end
function UnityEngine_UI_ScrollRect:StopMovement() end
---@param data UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_ScrollRect:OnScroll(data) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_ScrollRect:OnInitializePotentialDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_ScrollRect:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_ScrollRect:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_ScrollRect:OnDrag(eventData) end
function UnityEngine_UI_ScrollRect:CalculateLayoutInputHorizontal() end
function UnityEngine_UI_ScrollRect:CalculateLayoutInputVertical() end
function UnityEngine_UI_ScrollRect:SetLayoutHorizontal() end
function UnityEngine_UI_ScrollRect:SetLayoutVertical() end
---@param endValue UnityEngine.Vector2
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Tweener
function UnityEngine_UI_ScrollRect:DONormalizedPos(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Tweener
function UnityEngine_UI_ScrollRect:DOHorizontalNormalizedPos(endValue, duration, snapping) end
---@param endValue number
---@param duration number
---@param snapping boolean
---@return DG.Tweening.Tweener
function UnityEngine_UI_ScrollRect:DOVerticalNormalizedPos(endValue, duration, snapping) end

---@class UnityEngine.UI.ScrollRect.ScrollRectEvent : UnityEngine.Events.UnityEvent_UnityEngine_Vector2
local UnityEngine_UI_ScrollRect_ScrollRectEvent = {}
---@return UnityEngine.UI.ScrollRect.ScrollRectEvent
function UnityEngine_UI_ScrollRect_ScrollRectEvent.New() end

---@class UnityEngine.Events.UnityEvent_UnityEngine_Vector2 : UnityEngine.Events.UnityEventBase
local UnityEngine_Events_UnityEvent_UnityEngine_Vector2 = {}
---@return UnityEngine.Events.UnityEvent_UnityEngine_Vector2
function UnityEngine_Events_UnityEvent_UnityEngine_Vector2.New() end
---@param call NotExportType
function UnityEngine_Events_UnityEvent_UnityEngine_Vector2:AddListener(call) end
---@param call NotExportType
function UnityEngine_Events_UnityEvent_UnityEngine_Vector2:RemoveListener(call) end
---@param arg0 UnityEngine.Vector2
function UnityEngine_Events_UnityEvent_UnityEngine_Vector2:Invoke(arg0) end

---@class UnityEngine.Events.UnityEventBase : System.Object
local UnityEngine_Events_UnityEventBase = {}
---@overload fun(obj : System.Object, functionName : string, argumentTypes : NotExportType) : NotExportType
---@param objectType System.Type
---@param functionName string
---@param argumentTypes NotExportType
---@return NotExportType
function UnityEngine_Events_UnityEventBase.GetValidMethodInfo(objectType, functionName, argumentTypes) end
---@return number
function UnityEngine_Events_UnityEventBase:GetPersistentEventCount() end
---@param index number
---@return UnityEngine.Object
function UnityEngine_Events_UnityEventBase:GetPersistentTarget(index) end
---@param index number
---@return string
function UnityEngine_Events_UnityEventBase:GetPersistentMethodName(index) end
---@param index number
---@param state NotExportEnum
function UnityEngine_Events_UnityEventBase:SetPersistentListenerState(index, state) end
---@param index number
---@return NotExportEnum
function UnityEngine_Events_UnityEventBase:GetPersistentListenerState(index) end
function UnityEngine_Events_UnityEventBase:RemoveAllListeners() end
---@return string
function UnityEngine_Events_UnityEventBase:ToString() end

---@class SpriteToggle : UnityEngine.MonoBehaviour
---@field On boolean
local SpriteToggle = {}

---@class GuideInfoMsg : System.Object
---@field id number
---@field guideId number
---@field ext string
local GuideInfoMsg = {}
---@return GuideInfoMsg
function GuideInfoMsg.New() end

---@class t_base_guideConfig : System.Object
---@field id number
---@field guideID number
---@field nextID number
---@field needSync number
---@field guideType number
---@field controlType number
---@field param string
---@field cmd number
---@field path string
---@field contentParam string
---@field content string
---@field skipParam string
---@field satisfyParam string
---@field award string
---@field before_setGuidePanel number
---@field after_setGuidePanel number
---@field startHere number
---@field tdParam string
---@field syncPoint number
---@field finishParam string
---@field finish_action number
---@field report string
---@field skipTrigger string
local t_base_guideConfig = {}
---@return t_base_guideConfig
function t_base_guideConfig.New() end

---@class t_base_guide_triggerConfig : System.Object
---@field triggerId number
---@field view string
---@field descripe string
---@field startCondition string
---@field endCondition string
---@field isForce number
---@field behaviorStep number
---@field follwStep string
---@field type string
---@field path string
---@field content string
---@field contentParam string
---@field isPause number
---@field param string
---@field controlType number
---@field client number
---@field syncPoint number
local t_base_guide_triggerConfig = {}
---@return t_base_guide_triggerConfig
function t_base_guide_triggerConfig.New() end

---@class GuideMgr : System.Object
---@field BattleID number
---@field Level number
---@field m_CurGuide NotExportType
---@field m_CurGuideStepID number
---@field m_CurrTriggerID number
---@field Wait boolean
---@field isDoorOpen boolean
---@field isShowMainRole boolean
---@field TriggerGuideDic NotExportType
---@field resCompleteCfgID number
---@field UseRoleUidDic NotExportType
---@field CanEnterBattle boolean
---@field MaskBG UnityEngine.Transform
---@field m_GuideExtDic NotExportType
---@field IsPowerEnough boolean
---@field cityId number
---@field uId number
---@field powerUpCount number
---@field CallNumber number
---@field isGuiding boolean
---@field m_CurGuideID number
---@field m_RunningTriggerGuideCfgId number
local GuideMgr = {}
---@return GuideMgr
function GuideMgr.New() end
---@return GuideMgr
function GuideMgr.GetIns() end
---@return UnityEngine.GameObject
function GuideMgr.GetGuideUI() end
function GuideMgr.HideGuideUI() end
---@param step number
---@return t_base_guideConfig
function GuideMgr.GetGuideConfig(step) end
---@param step number
---@return t_base_guide_triggerConfig
function GuideMgr.GetTriggerConfig(step) end
function GuideMgr:Init() end
---@param action NotExportType
function GuideMgr:GuideEnterMainScene(action) end
---@param guideInfo NotExportType
---@param isLogin boolean
function GuideMgr:SetCurrentGuideConfig(guideInfo, isLogin) end
---@param func fun()
function GuideMgr:LoadGuideView(func) end
---@param func fun()
function GuideMgr:HideGuideView(func) end
function GuideMgr:HideGuideViewc2Lua() end
---@param cfg t_base_guideConfig
function GuideMgr:SetGuideInfoC2Lua(cfg) end
---@param func fun()
function GuideMgr:GuideActionLua2c(func) end
---@param func fun()
function GuideMgr:GuideConditionLua2c(func) end
---@param conditionType string
---@return boolean
function GuideMgr:IsGuideCondition(conditionType) end
---@param func fun()
function GuideMgr:GuideConditionLuaNew2c(func) end
---@param conditionType string
---@return boolean
function GuideMgr:IsGuideConditionNew(conditionType) end
---@param number number
function GuideMgr:GuideActionCallNumber(number) end
---@param actionType number
function GuideMgr:SetGuideActionC2Lua(actionType) end
---@param func fun()
function GuideMgr:CreateGuideStepLua2C(func) end
---@param type number
---@param path string
function GuideMgr:GuideHandle(type, path) end
---@param guideCfg NotExportType
function GuideMgr:SetGuideTable(guideCfg) end
---@param guideCfg NotExportType
function GuideMgr:SetGuideTriggerTable(guideCfg) end
---@param uiName string
---@param isShow boolean
function GuideMgr:RefreshUI(uiName, isShow) end
---@param guideCfg NotExportType
function GuideMgr:GuideTriggerTable(guideCfg) end
---@return NotExportType
function GuideMgr:GetGuideTable() end
---@return NotExportType
function GuideMgr:GetGuideTriggerTable() end
---@param guideID number
---@return boolean
function GuideMgr:OpenNewGuide(guideID) end
function GuideMgr:Update() end
---@param completeGuideStep boolean
function GuideMgr:ReqSyncGuide(completeGuideStep) end
---@param stepId number
---@param guideId number
---@param award string
---@param ext string
function GuideMgr:OnResSyncGuideMsg(stepId, guideId, award, ext) end
---@param triggerId number
---@param ext string
function GuideMgr:OnResSyncGuideTriggerIdMsg(triggerId, ext) end
---@overload fun(str : NotExportType)
---@param str GuideInfoMsg
function GuideMgr:SetExtDic(str) end
---@param args NotExportType
function GuideMgr:CompeleteCurrentGuideStep(args) end
---@param isOpen boolean
function GuideMgr:ShowGuideUI(isOpen) end
---@param step number
---@param needSync boolean
---@param preStep number
function GuideMgr:SetNextGuideStep(step, needSync, preStep) end
---@param step number
---@param EndWithFirstGuideStep boolean
function GuideMgr:SetPrevGuideStep(step, EndWithFirstGuideStep) end
function GuideMgr:DisposeGuideStep() end
function GuideMgr:BreakGuideStep() end
---@param args NotExportType
function GuideMgr:OnSatisfiedImmediately(args) end
---@param args NotExportType
function GuideMgr:OnHandleCurrentGuideEvent(args) end
---@param controlType number
---@param args NotExportType
function GuideMgr:NotifyGuide(controlType, args) end
function GuideMgr:EnterGuideBattle() end
---@return number
function GuideMgr:GetCfgID() end
---@return boolean
function GuideMgr:isForceGuiding() end
---@param RoleID number
---@param RoleUID number
function GuideMgr:SaveUseRoleUID(RoleID, RoleUID) end
---@param mode number
---@param UIPath string
---@param content string
---@param offsetX number
---@param offsetY number
function GuideMgr:ShowBubbleTips(mode, UIPath, content, offsetX, offsetY) end
---@param content string
---@return string
function GuideMgr:SetTipsContentRoleName(content) end
function GuideMgr:TriggerGuideGM() end
function GuideMgr:ResetGuide() end
---@return boolean
function GuideMgr:IsShieldClickGuiding() end
---@param val boolean
function GuideMgr:ChangeShield(val) end
function GuideMgr:ClearData() end
function GuideMgr:CheckGuideValut() end
function GuideMgr:StartSpecialGuide() end
---@param step number
---@return boolean
function GuideMgr:IsGuideStep(step) end
function GuideMgr:CheckGuideSceneSkip() end
---@return boolean
function GuideMgr:CanSkipGuideScene() end

---@class CommonProgressBar : UnityEngine.MonoBehaviour
local CommonProgressBar = {}
---@param percent number
function CommonProgressBar:ShowProgressWithPercent(percent) end
---@param current number
---@param max number
function CommonProgressBar:ShowProgressWithNum(current, max) end
---@param percent number
---@param text string
function CommonProgressBar:ShowProgressWithText(percent, text) end

---@class ImageSpritesContainer : SpriteContainer
---@field defSprite UnityEngine.Sprite
---@field autoNativeSize boolean
local ImageSpritesContainer = {}
---@param id string
function ImageSpritesContainer:ShowSprite(id) end
---@param idx number
function ImageSpritesContainer:ShowSpriteByIndex(idx) end

---@class SpriteContainer : UnityEngine.MonoBehaviour
---@field sprites NotExportType
local SpriteContainer = {}
---@param key string
---@return UnityEngine.Sprite
function SpriteContainer:Get(key) end
---@param index number
---@return UnityEngine.Sprite
function SpriteContainer:GetAsIndex(index) end

---@class WheelRotator : UnityEngine.MonoBehaviour
---@field completeStopHandler NotExportType
---@field cursorTickHandler NotExportType
---@field speedMultiplier number
---@field slowDownCurve UnityEngine.AnimationCurve
---@field is_use_speed_curve boolean
---@field is_cursor_move_by_speed_on_beginning boolean
---@field speedUpCurve UnityEngine.AnimationCurve
---@field speedDownCurve UnityEngine.AnimationCurve
---@field time number
---@field total_time number
---@field shiftScale number
---@field isTest boolean
---@field test_cnt number
---@field cursor_move_up_scale number
---@field _cursorParas NotExportType
---@field _cursor_object NotExportType
---@field _cursorEase DG.Tweening.Ease
---@field isShowDebugLog boolean
---@field cursorParas NotExportType
---@field lastCursorParas NotExportType
---@field cursor_object UnityEngine.Transform
---@field cursorEase DG.Tweening.Ease
---@field IsRotating boolean
local WheelRotator = {}
---@overload fun(totalCount : number)
---@param totalCount number
---@param stopPart number
---@param finishedAction NotExportType
function WheelRotator:Spin(totalCount, stopPart, finishedAction) end
---@param stopPart number
---@param finishedAction NotExportType
function WheelRotator:StopMove(stopPart, finishedAction) end
function WheelRotator:Finish() end

---@class UnityEngine.UI.Toggle : UnityEngine.UI.Selectable
---@field toggleTransition NotExportEnum
---@field graphic UnityEngine.UI.Graphic
---@field onValueChanged NotExportType
---@field group UnityEngine.UI.ToggleGroup
---@field isOn boolean
local UnityEngine_UI_Toggle = {}
---@param executing NotExportEnum
function UnityEngine_UI_Toggle:Rebuild(executing) end
function UnityEngine_UI_Toggle:LayoutComplete() end
function UnityEngine_UI_Toggle:GraphicUpdateComplete() end
---@param value boolean
function UnityEngine_UI_Toggle:SetIsOnWithoutNotify(value) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UnityEngine_UI_Toggle:OnPointerClick(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function UnityEngine_UI_Toggle:OnSubmit(eventData) end

---@class UnityEngine.UI.ToggleGroup : UnityEngine.EventSystems.UIBehaviour
---@field allowSwitchOff boolean
local UnityEngine_UI_ToggleGroup = {}
---@param toggle UnityEngine.UI.Toggle
---@param sendCallback boolean
function UnityEngine_UI_ToggleGroup:NotifyToggleOn(toggle, sendCallback) end
---@param toggle UnityEngine.UI.Toggle
function UnityEngine_UI_ToggleGroup:UnregisterToggle(toggle) end
---@param toggle UnityEngine.UI.Toggle
function UnityEngine_UI_ToggleGroup:RegisterToggle(toggle) end
function UnityEngine_UI_ToggleGroup:EnsureValidState() end
---@return boolean
function UnityEngine_UI_ToggleGroup:AnyTogglesOn() end
---@return NotExportType
function UnityEngine_UI_ToggleGroup:ActiveToggles() end
---@return UnityEngine.UI.Toggle
function UnityEngine_UI_ToggleGroup:GetFirstActiveToggle() end
---@param sendCallback boolean
function UnityEngine_UI_ToggleGroup:SetAllTogglesOff(sendCallback) end

---@class UnityEngine.UI.GridLayoutGroup : UnityEngine.UI.LayoutGroup
---@field startCorner NotExportEnum
---@field startAxis NotExportEnum
---@field cellSize UnityEngine.Vector2
---@field spacing UnityEngine.Vector2
---@field constraint NotExportEnum
---@field constraintCount number
local UnityEngine_UI_GridLayoutGroup = {}
function UnityEngine_UI_GridLayoutGroup:CalculateLayoutInputHorizontal() end
function UnityEngine_UI_GridLayoutGroup:CalculateLayoutInputVertical() end
function UnityEngine_UI_GridLayoutGroup:SetLayoutHorizontal() end
function UnityEngine_UI_GridLayoutGroup:SetLayoutVertical() end

---@class UnityEngine.UI.LayoutGroup : UnityEngine.EventSystems.UIBehaviour
---@field padding UnityEngine.RectOffset
---@field childAlignment NotExportEnum
---@field minWidth number
---@field preferredWidth number
---@field flexibleWidth number
---@field minHeight number
---@field preferredHeight number
---@field flexibleHeight number
---@field layoutPriority number
local UnityEngine_UI_LayoutGroup = {}
function UnityEngine_UI_LayoutGroup:CalculateLayoutInputHorizontal() end
function UnityEngine_UI_LayoutGroup:CalculateLayoutInputVertical() end
function UnityEngine_UI_LayoutGroup:SetLayoutHorizontal() end
function UnityEngine_UI_LayoutGroup:SetLayoutVertical() end

---@class SpriteAssetContainer : UnityEngine.MonoBehaviour
---@field spriteAssets NotExportType
local SpriteAssetContainer = {}
---@param key string
---@return NotExportType
function SpriteAssetContainer:Get(key) end
---@param index number
---@return NotExportType
function SpriteAssetContainer:GetAsIndex(index) end

---@class ScrollRectDragListener : UnityEngine.UI.ScrollRect
local ScrollRectDragListener = {}
---@param callback fun()
function ScrollRectDragListener:AddOnEndDragListener(callback) end
---@param callback fun()
function ScrollRectDragListener:RemoveOnEndDragListener(callback) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function ScrollRectDragListener:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function ScrollRectDragListener:OnBeginDrag(eventData) end

---@class UnityEngine.RectOffset : System.Object
---@field left number
---@field right number
---@field top number
---@field bottom number
---@field horizontal number
---@field vertical number
local UnityEngine_RectOffset = {}
---@overload fun() : UnityEngine.RectOffset
---@param left number
---@param right number
---@param top number
---@param bottom number
---@return UnityEngine.RectOffset
function UnityEngine_RectOffset.New(left, right, top, bottom) end
---@overload fun() : string
---@overload fun(format : string) : string
---@param format string
---@param formatProvider NotExportType
---@return string
function UnityEngine_RectOffset:ToString(format, formatProvider) end
---@param rect UnityEngine.Rect
---@return UnityEngine.Rect
function UnityEngine_RectOffset:Add(rect) end
---@param rect UnityEngine.Rect
---@return UnityEngine.Rect
function UnityEngine_RectOffset:Remove(rect) end

---@class UnityEngine.CanvasGroup : UnityEngine.Behaviour
---@field alpha number
---@field interactable boolean
---@field blocksRaycasts boolean
---@field ignoreParentGroups boolean
local UnityEngine_CanvasGroup = {}
---@return UnityEngine.CanvasGroup
function UnityEngine_CanvasGroup.New() end
---@param sp UnityEngine.Vector2
---@param eventCamera UnityEngine.Camera
---@return boolean
function UnityEngine_CanvasGroup:IsRaycastLocationValid(sp, eventCamera) end
---@param endValue number
---@param duration number
---@return DG.Tweening.Core.TweenerCore_float_float_DG_Tweening_Plugins_Options_FloatOptions
function UnityEngine_CanvasGroup:DOFade(endValue, duration) end

---@class UGUIExtend.AdvancedImage : UnityEngine.UI.Image
---@field cModifiedMat UnityEngine.Material
---@field is_h_flip boolean
---@field hitArea NotExportType
---@field useSpriteHitArea boolean
---@field hitScale UnityEngine.Vector2
---@field visible boolean
---@field enabledPopulateMesh boolean
---@field useSpriteMesh boolean
---@field horizontalMirror boolean
---@field verticalMirror boolean
---@field fillBorders NotExportType
local UGUIExtend_AdvancedImage = {}
---@param screenPoint UnityEngine.Vector2
---@param eventCamera UnityEngine.Camera
---@return boolean
function UGUIExtend_AdvancedImage:IsRaycastLocationValid(screenPoint, eventCamera) end
function UGUIExtend_AdvancedImage:SetNativeSize() end
---@param baseMaterial UnityEngine.Material
---@return UnityEngine.Material
function UGUIExtend_AdvancedImage:GetModifiedMaterial(baseMaterial) end

---@class RollingNumber3D : UnityEngine.MonoBehaviour
---@field autoScale boolean
---@field maxLengthLarge number
---@field scaleSmall number
---@field scaleLarge number
---@field thousandComma boolean
---@field textComp NotExportType
---@field deltaWaitTime_new number
---@field text string
local RollingNumber3D = {}
---@param seperator boolean
function RollingNumber3D:SetSeparator(seperator) end
---@param value number
function RollingNumber3D:SetValue(value) end
---@return number
function RollingNumber3D:GetValue() end
---@param value number
---@param time number
---@param callback fun()
function RollingNumber3D:RollByTime(value, time, callback) end
---@param value number
---@param speed number
---@param callback fun()
function RollingNumber3D:RollBySpeed(value, speed, callback) end
function RollingNumber3D:Stop() end
function RollingNumber3D:StopToEnd() end
function RollingNumber3D:StopToEndWithoutCallback() end
function RollingNumber3D:SetDisableState() end
function RollingNumber3D:SetEnableState() end
---@param color UnityEngine.Color
function RollingNumber3D:SetColor(color) end
---@return UnityEngine.Color
function RollingNumber3D:GetColor() end
---@param callback fun()
function RollingNumber3D:SetCallbackOnChange(callback) end
---@param duration number
function RollingNumber3D:FadeIn(duration) end
---@return number
function RollingNumber3D:GetCurrentValue() end
---@param value number
---@param time number
---@param callback fun()
function RollingNumber3D:RollByTimeAcc(value, time, callback) end
---@return boolean
function RollingNumber3D:IsRolling() end

---@class RollingSpriteNumber : UnityEngine.MonoBehaviour
---@field autoScale boolean
---@field maxLengthLarge number
---@field scaleSmall number
---@field scaleLarge number
---@field thousandComma boolean
---@field isUseJuHao boolean
---@field StrInLineStart string
---@field textComp TMPro.SpriteTextMeshProUGUI
---@field deltaWaitTime_new number
---@field text string
local RollingSpriteNumber = {}
---@param seperator boolean
function RollingSpriteNumber:SetSeparator(seperator) end
---@param value number
function RollingSpriteNumber:SetValue(value) end
---@return number
function RollingSpriteNumber:GetValue() end
---@param value number
---@param time number
---@param callback fun()
function RollingSpriteNumber:RollByTime(value, time, callback) end
---@param value number
---@param speed number
---@param callback fun()
function RollingSpriteNumber:RollBySpeed(value, speed, callback) end
function RollingSpriteNumber:Stop() end
function RollingSpriteNumber:StopToEnd() end
function RollingSpriteNumber:StopToEndWithoutCallback() end
function RollingSpriteNumber:SetDisableState() end
function RollingSpriteNumber:SetEnableState() end
---@param color UnityEngine.Color
function RollingSpriteNumber:SetColor(color) end
---@return UnityEngine.Color
function RollingSpriteNumber:GetColor() end
---@param callback fun()
function RollingSpriteNumber:SetCallbackOnChange(callback) end
---@param duration number
function RollingSpriteNumber:FadeIn(duration) end
---@return number
function RollingSpriteNumber:GetCurrentValue() end
---@param value number
---@param time number
---@param callback fun()
function RollingSpriteNumber:RollByTimeAcc(value, time, callback) end
---@return boolean
function RollingSpriteNumber:IsRolling() end

---@class GameObjectContainer : UnityEngine.MonoBehaviour
---@field list NotExportType
local GameObjectContainer = {}
---@param key string
function GameObjectContainer:ShowObject(key) end

---@class CanvasColorGroup : UnityEngine.MonoBehaviour
---@field color UnityEngine.Color
---@field list NotExportType
---@field isAutoFindChild boolean
local CanvasColorGroup = {}

---@class PageView : UnityEngine.EventSystems.UIBehaviour
---@field pageSize UnityEngine.Vector2
---@field spacing number
---@field dragEnable boolean
---@field sliderAxis NotExportEnum
---@field allowLoop boolean
---@field tweenStepCount number
---@field triggerThreshold number
---@field elasticity boolean
---@field PageCount number
---@field CurrentIndex number
local PageView = {}
---@param eventData UnityEngine.EventSystems.PointerEventData
function PageView:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function PageView:OnDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function PageView:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function PageView:OnInitializePotentialDrag(eventData) end
function PageView:AddRequisiteComponent() end
---@param name string
---@param func fun()
function PageView:AddLuaListener(name, func) end
---@param idx number
function PageView:MoveToIndex(idx) end
---@param offset number
function PageView:MoveByIndex(offset) end
function PageView:NextPage() end
function PageView:PrePage() end
---@param child UnityEngine.RectTransform
function PageView:AddChild(child) end
---@param page UnityEngine.RectTransform
function PageView:AddPage(page) end
function PageView:ClearAllPages() end

---@class GameMaster.GameAPI : System.Object
---@field InstallationGuid_Key string
local GameMaster_GameAPI = {}
---@return string
function GameMaster_GameAPI.GetInstallationGuid() end
---@param name string
---@return string
function GameMaster_GameAPI.OnClickUI(name) end
---@param guid string
function GameMaster_GameAPI.OnIoUI(guid) end
---@param guid string
function GameMaster_GameAPI.OnShowUI(guid) end
---@param eventName string
---@param obj NotExportType
function GameMaster_GameAPI.SendMessageToBI(eventName, obj) end

---@class LuaFramework.Protocal : System.Object
---@field Connect number
---@field Exception number
---@field Disconnect number
---@field Message number
local LuaFramework_Protocal = {}
---@return LuaFramework.Protocal
function LuaFramework_Protocal.New() end

---@class TMPro.TMP_Text : UnityEngine.UI.MaskableGraphic
---@field text string
---@field textPreprocessor NotExportType
---@field isRightToLeftText boolean
---@field font NotExportType
---@field fontSharedMaterial UnityEngine.Material
---@field fontSharedMaterials NotExportType
---@field fontMaterial UnityEngine.Material
---@field fontMaterials NotExportType
---@field color UnityEngine.Color
---@field alpha number
---@field enableVertexGradient boolean
---@field colorGradient NotExportType
---@field colorGradientPreset NotExportType
---@field spriteAsset NotExportType
---@field tintAllSprites boolean
---@field styleSheet NotExportType
---@field textStyle NotExportType
---@field overrideColorTags boolean
---@field faceColor NotExportType
---@field outlineColor NotExportType
---@field outlineWidth number
---@field fontSize number
---@field fontWeight NotExportEnum
---@field pixelsPerUnit number
---@field enableAutoSizing boolean
---@field fontSizeMin number
---@field fontSizeMax number
---@field fontStyle NotExportEnum
---@field isUsingBold boolean
---@field horizontalAlignment NotExportEnum
---@field verticalAlignment NotExportEnum
---@field alignment NotExportEnum
---@field characterSpacing number
---@field wordSpacing number
---@field lineSpacing number
---@field lineSpacingAdjustment number
---@field paragraphSpacing number
---@field characterWidthAdjustment number
---@field enableWordWrapping boolean
---@field wordWrappingRatios number
---@field overflowMode NotExportEnum
---@field isTextOverflowing boolean
---@field firstOverflowCharacterIndex number
---@field linkedTextComponent TMPro.TMP_Text
---@field isTextTruncated boolean
---@field enableKerning boolean
---@field extraPadding boolean
---@field richText boolean
---@field parseCtrlCharacters boolean
---@field isOverlay boolean
---@field isOrthographic boolean
---@field enableCulling boolean
---@field ignoreVisibility boolean
---@field horizontalMapping NotExportEnum
---@field verticalMapping NotExportEnum
---@field mappingUvLineOffset number
---@field renderMode NotExportEnum
---@field geometrySortingOrder NotExportEnum
---@field isTextObjectScaleStatic boolean
---@field vertexBufferAutoSizeReduction boolean
---@field firstVisibleCharacter number
---@field maxVisibleCharacters number
---@field maxVisibleWords number
---@field maxVisibleLines number
---@field useMaxVisibleDescender boolean
---@field pageToDisplay number
---@field margin NotExportType
---@field textInfo NotExportType
---@field havePropertiesChanged boolean
---@field isUsingLegacyAnimationComponent boolean
---@field transform UnityEngine.Transform
---@field rectTransform UnityEngine.RectTransform
---@field autoSizeTextContainer boolean
---@field mesh NotExportType
---@field isVolumetricText boolean
---@field bounds UnityEngine.Bounds
---@field textBounds UnityEngine.Bounds
---@field flexibleHeight number
---@field flexibleWidth number
---@field minWidth number
---@field minHeight number
---@field maxWidth number
---@field maxHeight number
---@field preferredWidth number
---@field preferredHeight number
---@field renderedWidth number
---@field renderedHeight number
---@field layoutPriority number
local TMPro_TMP_Text = {}
---@param ignoreActiveState boolean
---@param forceTextReparsing boolean
function TMPro_TMP_Text:ForceMeshUpdate(ignoreActiveState, forceTextReparsing) end
---@param mesh NotExportType
---@param index number
function TMPro_TMP_Text:UpdateGeometry(mesh, index) end
---@overload fun(flags : NotExportEnum)
function TMPro_TMP_Text:UpdateVertexData() end
---@param vertices NotExportType
function TMPro_TMP_Text:SetVertices(vertices) end
function TMPro_TMP_Text:UpdateMeshPadding() end
---@param targetColor UnityEngine.Color
---@param duration number
---@param ignoreTimeScale boolean
---@param useAlpha boolean
function TMPro_TMP_Text:CrossFadeColor(targetColor, duration, ignoreTimeScale, useAlpha) end
---@param alpha number
---@param duration number
---@param ignoreTimeScale boolean
function TMPro_TMP_Text:CrossFadeAlpha(alpha, duration, ignoreTimeScale) end
---@overload fun(sourceText : string, syncTextInputBox : boolean)
---@overload fun(sourceText : string, arg0 : number)
---@overload fun(sourceText : string, arg0 : number, arg1 : number)
---@overload fun(sourceText : string, arg0 : number, arg1 : number, arg2 : number)
---@overload fun(sourceText : string, arg0 : number, arg1 : number, arg2 : number, arg3 : number)
---@overload fun(sourceText : string, arg0 : number, arg1 : number, arg2 : number, arg3 : number, arg4 : number)
---@overload fun(sourceText : string, arg0 : number, arg1 : number, arg2 : number, arg3 : number, arg4 : number, arg5 : number)
---@overload fun(sourceText : string, arg0 : number, arg1 : number, arg2 : number, arg3 : number, arg4 : number, arg5 : number, arg6 : number)
---@overload fun(sourceText : string, arg0 : number, arg1 : number, arg2 : number, arg3 : number, arg4 : number, arg5 : number, arg6 : number, arg7 : number)
---@overload fun(sourceText : NotExportType)
---@overload fun(sourceText : NotExportType)
---@param sourceText NotExportType
---@param start number
---@param length number
function TMPro_TMP_Text:SetText(sourceText, start, length) end
---@overload fun(sourceText : NotExportType)
---@param sourceText NotExportType
---@param start number
---@param length number
function TMPro_TMP_Text:SetCharArray(sourceText, start, length) end
---@overload fun() : UnityEngine.Vector2
---@overload fun(width : number, height : number) : UnityEngine.Vector2
---@overload fun(text : string) : UnityEngine.Vector2
---@param text string
---@param width number
---@param height number
---@return UnityEngine.Vector2
function TMPro_TMP_Text:GetPreferredValues(text, width, height) end
---@overload fun() : UnityEngine.Vector2
---@param onlyVisibleCharacters boolean
---@return UnityEngine.Vector2
function TMPro_TMP_Text:GetRenderedValues(onlyVisibleCharacters) end
---@param text string
---@return NotExportType
function TMPro_TMP_Text:GetTextInfo(text) end
function TMPro_TMP_Text:ComputeMarginSize() end
---@overload fun()
---@param uploadGeometry boolean
function TMPro_TMP_Text:ClearMesh(uploadGeometry) end
---@return string
function TMPro_TMP_Text:GetParsedText() end

---@class TMPro.TextMeshProUGUI : TMPro.TMP_Text
---@field materialForRendering UnityEngine.Material
---@field autoSizeTextContainer boolean
---@field mesh NotExportType
---@field canvasRenderer UnityEngine.CanvasRenderer
---@field maskOffset NotExportType
local TMPro_TextMeshProUGUI = {}
function TMPro_TextMeshProUGUI:CalculateLayoutInputHorizontal() end
function TMPro_TextMeshProUGUI:CalculateLayoutInputVertical() end
function TMPro_TextMeshProUGUI:SetVerticesDirty() end
function TMPro_TextMeshProUGUI:SetLayoutDirty() end
function TMPro_TextMeshProUGUI:SetMaterialDirty() end
function TMPro_TextMeshProUGUI:SetAllDirty() end
---@param update NotExportEnum
function TMPro_TextMeshProUGUI:Rebuild(update) end
---@param baseMaterial UnityEngine.Material
---@return UnityEngine.Material
function TMPro_TextMeshProUGUI:GetModifiedMaterial(baseMaterial) end
function TMPro_TextMeshProUGUI:RecalculateClipping() end
---@param clipRect UnityEngine.Rect
---@param validRect boolean
function TMPro_TextMeshProUGUI:Cull(clipRect, validRect) end
function TMPro_TextMeshProUGUI:UpdateMeshPadding() end
---@param ignoreActiveState boolean
---@param forceTextReparsing boolean
function TMPro_TextMeshProUGUI:ForceMeshUpdate(ignoreActiveState, forceTextReparsing) end
---@param text string
---@return NotExportType
function TMPro_TextMeshProUGUI:GetTextInfo(text) end
function TMPro_TextMeshProUGUI:ClearMesh() end
---@param mesh NotExportType
---@param index number
function TMPro_TextMeshProUGUI:UpdateGeometry(mesh, index) end
---@overload fun(flags : NotExportEnum)
function TMPro_TextMeshProUGUI:UpdateVertexData() end
function TMPro_TextMeshProUGUI:UpdateFontAsset() end
function TMPro_TextMeshProUGUI:ComputeMarginSize() end

---@class TMPro.SpriteTextMeshProUGUI : TMPro.TextMeshProUGUI
---@field text string
---@field visible boolean
local TMPro_SpriteTextMeshProUGUI = {}
---@param value number
function TMPro_SpriteTextMeshProUGUI:SetTextComma(value) end
---@param str string
function TMPro_SpriteTextMeshProUGUI:setValue(str) end

---@class AnimatorPlayHelper : UnityEngine.MonoBehaviour
---@field finishDisable boolean
local AnimatorPlayHelper = {}
---@overload fun(anima : UnityEngine.Animator, actionName : string, callback : fun(), specifiedTime : number, isLoop : boolean)
---@param anima UnityEngine.Animator
---@param actionName NotExportType
---@param callback fun()
---@param specifiedTime number
---@param isLoop boolean
function AnimatorPlayHelper.SetAnimationEvent(anima, actionName, callback, specifiedTime, isLoop) end
---@overload fun(anima : UnityEngine.Animator, actionName : string, finishDisable : boolean, callback : fun(), specifiedTime : number, speed : number)
---@overload fun(anima : UnityEngine.Animator, actionName : string, startTime : number, finishDisable : boolean, callback : fun(), specifiedTime : number, speed : number)
---@overload fun(anima : UnityEngine.Animator, actionName : NotExportType, finishDisable : boolean, callback : fun(), specifiedTime : number, speed : number)
---@overload fun(anima : UnityEngine.Animator, actionName : NotExportType, finishDisable : boolean, specifiedTime : number, specifiedCallback : fun(), finishCallback : fun(), speed : number)
---@overload fun(anima : UnityEngine.Animator, actionName : string, finishDisable : boolean, specifiedTime : number, specifiedCallback : fun(), finishCallback : fun(), speed : number)
---@overload fun(actionName : string, finishDisable : boolean, callback : fun(), specifiedTime : number, speed : number)
---@param actionName string
---@param finishDisable boolean
---@param specifiedTime number
---@param specifiedCallback fun()
---@param finishCallback fun()
---@param speed number
function AnimatorPlayHelper:Play(actionName, finishDisable, specifiedTime, specifiedCallback, finishCallback, speed) end
function AnimatorPlayHelper:PlayAnimation() end
---@param funcKey string
---@param func fun()
---@param isLoop boolean
function AnimatorPlayHelper:SetLuaHandle(funcKey, func, isLoop) end
---@param enable boolean
function AnimatorPlayHelper:SetFinishDisable(enable) end
---@param name string
function AnimatorPlayHelper:SetActionName(name) end
---@param speed number
function AnimatorPlayHelper:SetSpeed(speed) end
---@param startPlayTime number
function AnimatorPlayHelper:SetStartPlayTime(startPlayTime) end
---@param param string
function AnimatorPlayHelper:callString(param) end

---@class TMPro.TMP_InputField : UnityEngine.UI.Selectable
---@field shouldHideMobileInput boolean
---@field shouldHideSoftKeyboard boolean
---@field text string
---@field isFocused boolean
---@field caretBlinkRate number
---@field caretWidth number
---@field textViewport UnityEngine.RectTransform
---@field textComponent TMPro.TMP_Text
---@field placeholder UnityEngine.UI.Graphic
---@field verticalScrollbar NotExportType
---@field scrollSensitivity number
---@field caretColor UnityEngine.Color
---@field customCaretColor boolean
---@field selectionColor UnityEngine.Color
---@field onEndEdit NotExportType
---@field onSubmit NotExportType
---@field onSelect NotExportType
---@field onDeselect NotExportType
---@field onTextSelection NotExportType
---@field onEndTextSelection NotExportType
---@field onValueChanged NotExportType
---@field onTouchScreenKeyboardStatusChanged NotExportType
---@field onValidateInput NotExportType
---@field characterLimit number
---@field pointSize number
---@field fontAsset NotExportType
---@field onFocusSelectAll boolean
---@field resetOnDeActivation boolean
---@field restoreOriginalTextOnEscape boolean
---@field isRichTextEditingAllowed boolean
---@field contentType NotExportEnum
---@field lineType NotExportEnum
---@field lineLimit number
---@field inputType NotExportEnum
---@field keyboardType NotExportEnum
---@field characterValidation NotExportEnum
---@field inputValidator NotExportType
---@field readOnly boolean
---@field richText boolean
---@field multiLine boolean
---@field asteriskChar NotExportType
---@field wasCanceled boolean
---@field caretPosition number
---@field selectionAnchorPosition number
---@field selectionFocusPosition number
---@field stringPosition number
---@field selectionStringAnchorPosition number
---@field selectionStringFocusPosition number
---@field minWidth number
---@field preferredWidth number
---@field flexibleWidth number
---@field minHeight number
---@field preferredHeight number
---@field flexibleHeight number
---@field layoutPriority number
local TMPro_TMP_InputField = {}
---@param input string
function TMPro_TMP_InputField:SetTextWithoutNotify(input) end
---@param shift boolean
function TMPro_TMP_InputField:MoveTextEnd(shift) end
---@param shift boolean
function TMPro_TMP_InputField:MoveTextStart(shift) end
---@param shift boolean
---@param ctrl boolean
function TMPro_TMP_InputField:MoveToEndOfLine(shift, ctrl) end
---@param shift boolean
---@param ctrl boolean
function TMPro_TMP_InputField:MoveToStartOfLine(shift, ctrl) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro_TMP_InputField:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro_TMP_InputField:OnDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro_TMP_InputField:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro_TMP_InputField:OnPointerDown(eventData) end
---@param e NotExportType
function TMPro_TMP_InputField:ProcessEvent(e) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function TMPro_TMP_InputField:OnUpdateSelected(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro_TMP_InputField:OnScroll(eventData) end
function TMPro_TMP_InputField:ForceLabelUpdate() end
---@param update NotExportEnum
function TMPro_TMP_InputField:Rebuild(update) end
function TMPro_TMP_InputField:LayoutComplete() end
function TMPro_TMP_InputField:GraphicUpdateComplete() end
function TMPro_TMP_InputField:ActivateInputField() end
---@param eventData UnityEngine.EventSystems.BaseEventData
function TMPro_TMP_InputField:OnSelect(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro_TMP_InputField:OnPointerClick(eventData) end
function TMPro_TMP_InputField:OnControlClick() end
function TMPro_TMP_InputField:ReleaseSelection() end
---@param clearSelection boolean
function TMPro_TMP_InputField:DeactivateInputField(clearSelection) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function TMPro_TMP_InputField:OnDeselect(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function TMPro_TMP_InputField:OnSubmit(eventData) end
function TMPro_TMP_InputField:CalculateLayoutInputHorizontal() end
function TMPro_TMP_InputField:CalculateLayoutInputVertical() end
---@param pointSize number
function TMPro_TMP_InputField:SetGlobalPointSize(pointSize) end
---@param fontAsset NotExportType
function TMPro_TMP_InputField:SetGlobalFontAsset(fontAsset) end

---@class LuaFramework.ToLuaUtil : System.Object
local LuaFramework_ToLuaUtil = {}
---@return LuaFramework.ToLuaUtil
function LuaFramework_ToLuaUtil.New() end
---@overload fun(obj : UnityEngine.GameObject, x : number, y : number, z : number)
---@overload fun(obj : UnityEngine.Object, x : number, y : number, z : number)
---@param obj UnityEngine.MonoBehaviour
---@param x number
---@param y number
---@param z number
function LuaFramework_ToLuaUtil.SetPos(obj, x, y, z) end
---@overload fun(obj : UnityEngine.Object, x : number, y : number, z : number)
---@overload fun(obj : UnityEngine.GameObject, x : number, y : number, z : number)
---@param obj UnityEngine.MonoBehaviour
---@param x number
---@param y number
---@param z number
function LuaFramework_ToLuaUtil.SetLocalPos(obj, x, y, z) end
---@overload fun(obj : UnityEngine.GameObject) : number
---@param t UnityEngine.Transform
---@return number
function LuaFramework_ToLuaUtil.GetLocalY(t) end
---@overload fun(obj : UnityEngine.GameObject) : number
---@param t UnityEngine.Transform
---@return number
function LuaFramework_ToLuaUtil.GetLocalX(t) end
---@param obj UnityEngine.GameObject
---@return UnityEngine.Vector3
function LuaFramework_ToLuaUtil.GetPos(obj) end
---@param obj UnityEngine.GameObject
---@param b UnityEngine.GameObject
function LuaFramework_ToLuaUtil.SetParent(obj, b) end
---@param obj UnityEngine.GameObject
---@param x number
---@param y number
---@param z number
function LuaFramework_ToLuaUtil.SetLocalScale(obj, x, y, z) end
---@param obj UnityEngine.GameObject
function LuaFramework_ToLuaUtil.SetAsFirstSibling(obj) end
---@param obj UnityEngine.GameObject
function LuaFramework_ToLuaUtil.SetAsLastSibling(obj) end
---@param obj UnityEngine.GameObject
---@param x number
---@param y number
---@param z number
---@return UnityEngine.Vector3
function LuaFramework_ToLuaUtil.TransformPoint(obj, x, y, z) end
---@param animator UnityEngine.Animator
---@param speed number
---@return number
function LuaFramework_ToLuaUtil.SetAnimatorSpeed(animator, speed) end

---@class UIDragControl : UnityEngine.MonoBehaviour
---@field obj UnityEngine.GameObject
local UIDragControl = {}
---@param eventData UnityEngine.EventSystems.PointerEventData
function UIDragControl:OnDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UIDragControl:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function UIDragControl:OnPointerClick(eventData) end
---@param onDrag fun()
---@param endDrag fun()
function UIDragControl:SetDragFunc(onDrag, endDrag) end
---@param onClick fun()
function UIDragControl:SetClickFunc(onClick) end

---@class Rigibody2DAddForce : UnityEngine.MonoBehaviour
local Rigibody2DAddForce = {}
---@param rgb NotExportType
---@param force UnityEngine.Vector2
---@param mode string
function Rigibody2DAddForce:AddRigibody2DForce(rgb, force, mode) end

---@class LuaCallNotificationsUtility : System.Object
local LuaCallNotificationsUtility = {}
---@param channels NotExportType
function LuaCallNotificationsUtility.InitNotifications(channels) end
---@param title string
---@param body string
---@param seconds number
---@param channelId string
---@param badgeNumber NotExportType
---@param reschedule boolean
---@param smallIcon string
---@param largeIcon string
function LuaCallNotificationsUtility.SendNotification(title, body, seconds, channelId, badgeNumber, reschedule, smallIcon, largeIcon) end
---@param message string
---@param title string
---@param newTime number
---@param isRepeatDay boolean
function LuaCallNotificationsUtility.NotificationMessage(message, title, newTime, isRepeatDay) end
---@param notificationId number
function LuaCallNotificationsUtility.CancelPendingNotificationItem(notificationId) end
function LuaCallNotificationsUtility.CancelAllNotification() end
---@param notificationId number
function LuaCallNotificationsUtility.DismissNotification(notificationId) end
function LuaCallNotificationsUtility.DismissAllNotification() end
---@return string
function LuaCallNotificationsUtility.GetLastNotificationIntent() end

---@class UnityEngine.UI.InputField.OnChangeEvent : UnityEngine.Events.UnityEvent_string
local UnityEngine_UI_InputField_OnChangeEvent = {}
---@return UnityEngine.UI.InputField.OnChangeEvent
function UnityEngine_UI_InputField_OnChangeEvent.New() end

---@class UnityEngine.Events.UnityEvent_string : UnityEngine.Events.UnityEventBase
local UnityEngine_Events_UnityEvent_string = {}
---@return UnityEngine.Events.UnityEvent_string
function UnityEngine_Events_UnityEvent_string.New() end
---@param call NotExportType
function UnityEngine_Events_UnityEvent_string:AddListener(call) end
---@param call NotExportType
function UnityEngine_Events_UnityEvent_string:RemoveListener(call) end
---@param arg0 string
function UnityEngine_Events_UnityEvent_string:Invoke(arg0) end

---@class UnityEngine.UI.InputField.SubmitEvent : UnityEngine.Events.UnityEvent_string
local UnityEngine_UI_InputField_SubmitEvent = {}
---@return UnityEngine.UI.InputField.SubmitEvent
function UnityEngine_UI_InputField_SubmitEvent.New() end

---@class AppIconHelper : UnityEngine.MonoBehaviour
local AppIconHelper = {}
---@return boolean
function AppIconHelper.IsSupportsAlternateIcons() end
---@return string
function AppIconHelper.GetAlternateIconName() end
---@param iconName string
function AppIconHelper.ChangeIcon(iconName) end

---@class VerticalWheelRotator : UnityEngine.MonoBehaviour
---@field completeStopHandler NotExportType
---@field speedUpCurve UnityEngine.AnimationCurve
---@field speedDownCurve UnityEngine.AnimationCurve
---@field objectTickHandler NotExportType
---@field curState NotExportEnum
---@field isTest boolean
---@field test_end number
---@field test_cnt number
---@field number number
---@field cursorParas NotExportType
---@field cursor_object NotExportType
---@field cursorEase DG.Tweening.Ease
---@field isShowDebugLog boolean
---@field curBornItemIndex number
---@field curSelectIndex number
local VerticalWheelRotator = {}
---@param dataLenth number
---@param totalCount number
function VerticalWheelRotator:Spin(dataLenth, totalCount) end
---@param stopPart number
---@param finishedAction NotExportType
function VerticalWheelRotator:StopMove(stopPart, finishedAction) end

---@class VerticalWheelRotatorChooseEnd : VerticalWheelRotator
---@field speedDownCurveList NotExportType
local VerticalWheelRotatorChooseEnd = {}
---@param index number
function VerticalWheelRotatorChooseEnd:SetUseSpeedDownCurve(index) end

---@class LuaValueInfo : System.Object
---@field name string
---@field valueType string
---@field valueStr string
---@field isValue boolean
local LuaValueInfo = {}
---@return LuaValueInfo
function LuaValueInfo.New() end

---@class LuaDebugTool : System.Object
local LuaDebugTool = {}
---@return LuaDebugTool
function LuaDebugTool.New() end
---@param obj System.Object
---@param key string
---@return System.Object
function LuaDebugTool.getCSharpValue(obj, key) end
---@param values NotExportType
---@return NotExportType
function LuaDebugTool.convertLuaValueInfos(values) end
---@param obj System.Object
---@return NotExportType
function LuaDebugTool.getUserDataInfo(obj) end
---@param t System.Type
---@return NotExportEnum
function LuaDebugTool.getInsType(t) end
---@param obj System.Object
---@return NotExportType
function LuaDebugTool.SearchDataInfo(obj) end
---@param obj System.Object
---@return NotExportType
function LuaDebugTool.getListValues(obj) end
---@param obj System.Object
---@return NotExportType
function LuaDebugTool.getDictionaryValues(obj) end

---@class WorkerState
---@field Waiting WorkerState
---@field Paused WorkerState
---@field Abort WorkerState
---@field Downloading WorkerState
---@field Complete WorkerState
---@field Failed WorkerState
local WorkerState = {}

---@class DownloadQueryResult : System.Object
---@field Url string
---@field LocalPath string
---@field WorkID number
---@field Progress number
---@field Priority number
---@field State WorkerState
---@field Error string
local DownloadQueryResult = {}
---@return DownloadQueryResult
function DownloadQueryResult.New() end

---@class DownloadErrorInfo : System.Object
---@field Type DownloadErrorType
---@field ErrorMsg string
---@field HttpStatusCode string
local DownloadErrorInfo = {}
---@param errType DownloadErrorType
---@param msg string
---@param httpCode string
---@return DownloadErrorInfo
function DownloadErrorInfo.New(errType, msg, httpCode) end

---@class DownloadProgressChangedEventArg : DownloadEventArg
---@field TotalSize number
---@field DownloadSize number
local DownloadProgressChangedEventArg = {}
---@param id number
---@param url string
---@param _local string
---@param progress number
---@param readSize number
---@param totalSize number
---@return DownloadProgressChangedEventArg
function DownloadProgressChangedEventArg.New(id, url, _local, progress, readSize, totalSize) end

---@class DownloadEventArg : System.Object
---@field CanCrossScenes boolean
---@field Url string
---@field LocalPath string
---@field Progress number
---@field WorkerID number
local DownloadEventArg = {}
---@param id number
---@param url string
---@param _local string
---@param progress number
---@return DownloadEventArg
function DownloadEventArg.New(id, url, _local, progress) end

---@class DownloadSuccessedEventArg : DownloadEventArg
---@field TotalSize number
local DownloadSuccessedEventArg = {}
---@param id number
---@param url string
---@param _local string
---@param size number
---@return DownloadSuccessedEventArg
function DownloadSuccessedEventArg.New(id, url, _local, size) end

---@class DownloadFailedEventArg : DownloadEventArg
---@field TotalSize number
---@field DownloadSize number
---@field Error DownloadErrorInfo
local DownloadFailedEventArg = {}
---@param id number
---@param url string
---@param _local string
---@param readSize number
---@param totalSize number
---@param error DownloadErrorInfo
---@return DownloadFailedEventArg
function DownloadFailedEventArg.New(id, url, _local, readSize, totalSize, error) end

---@class DownloadErrorType
---@field Other DownloadErrorType
---@field Net DownloadErrorType
local DownloadErrorType = {}

---@class AssetsManager : MyGame.GameObjects.Components.Singleton_AssetsManager
---@field StorageName string
---@field defaultPriority number
---@field assetsStorage FileStorage
local AssetsManager = {}
---@overload fun(urlBase : string, urlDetail : string, priority : number, onSucess : NotExportType)
---@overload fun(urlBase : string, urlDetail : string, priority : number, onSucess : NotExportType, callbackCrossScene : boolean)
---@overload fun(urlBase : string, urlDetail : string, priority : number, onSucess : NotExportType, onError : NotExportType)
---@param urlBase string
---@param urlDetail string
---@param priority number
---@param onSucess NotExportType
---@param onError NotExportType
---@param onUpdate NotExportType
function AssetsManager:Get(urlBase, urlDetail, priority, onSucess, onError, onUpdate) end
---@param url string
---@param onSucess NotExportType
---@param onError NotExportType
---@param onUpdate NotExportType
function AssetsManager:ModifyListener(url, onSucess, onError, onUpdate) end
---@param url string
function AssetsManager:Pause(url) end
---@param url string
function AssetsManager:Resume(url) end
---@param url string
function AssetsManager:Stop(url) end
---@param urlBase string
---@param urlDetail string
function AssetsManager:StartImmediately(urlBase, urlDetail) end
---@param url string
---@return string
function AssetsManager:GetFilePathFromStorage(url) end
---@param urlBase string
---@param urlDetail string
---@return boolean
function AssetsManager:Exist(urlBase, urlDetail) end
---@param url string
---@param relativePath string
---@param callback fun()
function AssetsManager:GetFileFromLocalOrWeb(url, relativePath, callback) end

---@class MyGame.GameObjects.Components.Singleton_AssetsManager : UnityEngine.MonoBehaviour
---@field Instance AssetsManager
---@field IsActive boolean
---@field TypeName string
local MyGame_GameObjects_Components_Singleton_AssetsManager = {}
function MyGame_GameObjects_Components_Singleton_AssetsManager:Start() end
function MyGame_GameObjects_Components_Singleton_AssetsManager:SaveState() end

---@class UnzipManager : MyGame.GameObjects.Components.Singleton_UnzipManager
local UnzipManager = {}
---@param src string
---@param dst string
---@param onSuccess NotExportType
---@param onFail NotExportType
---@param onUpdate NotExportType
function UnzipManager:Unzip(src, dst, onSuccess, onFail, onUpdate) end

---@class MyGame.GameObjects.Components.Singleton_UnzipManager : UnityEngine.MonoBehaviour
---@field Instance UnzipManager
---@field IsActive boolean
---@field TypeName string
local MyGame_GameObjects_Components_Singleton_UnzipManager = {}
function MyGame_GameObjects_Components_Singleton_UnzipManager:Start() end
function MyGame_GameObjects_Components_Singleton_UnzipManager:SaveState() end

---@class StorageFileInfo : System.Object
---@field path string
---@field createTime number
---@field size number
local StorageFileInfo = {}
---@return StorageFileInfo
function StorageFileInfo.New() end

---@class FileStorage : System.Object
---@field Name string
---@field Directory string
---@field Space number
---@field CurrentSpace number
local FileStorage = {}
---@param name string
---@param space number
---@return FileStorage
function FileStorage.New(name, space) end
---@param dir string
function FileStorage:Create(dir) end
function FileStorage:InitFileInfo() end
---@param realtivePath string
---@return string
function FileStorage:ConvertToStorageLocal(realtivePath) end
---@param asset string
---@return boolean
function FileStorage:Contains(asset) end
---@param asset string
---@param file string
function FileStorage:Add(asset, file) end
---@param asset string
---@param out_fileInfo StorageFileInfo
---@return boolean,StorageFileInfo
function FileStorage:TryGet(asset, out_fileInfo) end
function FileStorage:DeleteAll() end

---@class GameApp : System.Object
---@field Asset GameFrameX.Asset.Runtime.AssetComponent
---@field Config NotExportType
---@field Base NotExportType
---@field Entity NotExportType
---@field GlobalConfig NotExportType
---@field Network NotExportType
---@field ObjectPool NotExportType
---@field Sound NotExportType
---@field Web NotExportType
local GameApp = {}

---@class GameFrameX.Asset.Runtime.AssetComponent : GameFrameX.Runtime.GameFrameworkComponent
---@field BuildInPackageName string
---@field GamePlayMode NotExportEnum
local GameFrameX_Asset_Runtime_AssetComponent = {}
---@param packageName string
---@param host string
---@param fallbackHostServer string
---@param isDefaultPackage boolean
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:InitPackageAsync(packageName, host, fallbackHostServer, isDefaultPackage) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : NotExportType
---@overload fun(path : string, type : System.Type) : NotExportType
---@param path string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:LoadSubAssetsAsync(path) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : NotExportType
---@param path string
---@param type System.Type
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:LoadSubAssetSync(path, type) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : NotExportType
---@param path string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:LoadRawFileAsync(path) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : NotExportType
---@param path string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:LoadRawFileSync(path) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : Cysharp.Threading.Tasks.UniTask_YooAsset_AssetHandle
---@overload fun(path : string, type : System.Type) : Cysharp.Threading.Tasks.UniTask_YooAsset_AssetHandle
---@param path string
---@return Cysharp.Threading.Tasks.UniTask_YooAsset_AssetHandle
function GameFrameX_Asset_Runtime_AssetComponent:LoadAssetAsync(path) end
---@overload fun(path : string, type : System.Type) : NotExportType
---@overload fun(path : string) : NotExportType
---@param assetInfo YooAsset.AssetInfo
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:LoadAllAssetsAsync(assetInfo) end
---@overload fun(path : string) : NotExportType
---@overload fun(path : string, type : System.Type) : NotExportType
---@param assetInfo YooAsset.AssetInfo
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:LoadAllAssetsSync(assetInfo) end
---@param path string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:LoadSubAssetsSync(path) end
---@param path string
---@return YooAsset.AssetHandle
function GameFrameX_Asset_Runtime_AssetComponent:LoadAssetsSync(path) end
---@overload fun(path : string, type : System.Type) : YooAsset.AssetHandle
---@param assetInfo YooAsset.AssetInfo
---@return YooAsset.AssetHandle
function GameFrameX_Asset_Runtime_AssetComponent:LoadAssetSync(assetInfo) end
---@param path string
---@param sceneMode UnityEngine.SceneManagement.LoadSceneMode
---@param activateOnLoad boolean
---@return Cysharp.Threading.Tasks.UniTask_YooAsset_SceneHandle
function GameFrameX_Asset_Runtime_AssetComponent:LoadSceneAsync(path, sceneMode, activateOnLoad) end
---@param path string
---@param sceneMode UnityEngine.SceneManagement.LoadSceneMode
---@param activateOnLoad boolean
---@return YooAsset.SceneHandle
function GameFrameX_Asset_Runtime_AssetComponent:LoadSceneAsyncOnLoad(path, sceneMode, activateOnLoad) end
---@param packageName string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:CreateAssetsPackage(packageName) end
---@param packageName string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:TryGetAssetsPackage(packageName) end
---@param packageName string
---@return boolean
function GameFrameX_Asset_Runtime_AssetComponent:HasAssetsPackage(packageName) end
---@param packageName string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:GetAssetsPackage(packageName) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : boolean
---@param path string
---@return boolean
function GameFrameX_Asset_Runtime_AssetComponent:IsNeedDownload(path) end
---@overload fun(assetTags : NotExportType) : NotExportType
---@param assetTag string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:GetAssetInfos(assetTag) end
---@param path string
---@return YooAsset.AssetInfo
function GameFrameX_Asset_Runtime_AssetComponent:GetAssetInfo(path) end
---@param assetPath string
---@return boolean
function GameFrameX_Asset_Runtime_AssetComponent:HasAssetPath(assetPath) end
---@param assetsPackage NotExportType
function GameFrameX_Asset_Runtime_AssetComponent:SetDefaultAssetsPackage(assetsPackage) end
---@param packageName string
function GameFrameX_Asset_Runtime_AssetComponent:UnloadAllAssetsAsync(packageName) end
---@overload fun(packageName : string, assetPath : string)
---@param assetPath string
function GameFrameX_Asset_Runtime_AssetComponent:UnloadAsset(assetPath) end
---@param packageName string
function GameFrameX_Asset_Runtime_AssetComponent:UnloadUnusedAssetsAsync(packageName) end
---@param packageName string
function GameFrameX_Asset_Runtime_AssetComponent:ClearAllBundleFilesAsync(packageName) end
---@param packageName string
function GameFrameX_Asset_Runtime_AssetComponent:ClearUnusedBundleFilesAsync(packageName) end

---@class GameFrameX.Runtime.GameFrameworkComponent : UnityEngine.MonoBehaviour
local GameFrameX_Runtime_GameFrameworkComponent = {}

---@class GameFrameX.Asset.Runtime.AssetManager : GameFrameX.Runtime.GameFrameworkModule
---@field DefaultPackageName string
---@field DownloadingMaxNum number
---@field FailedTryAgain number
---@field VerifyLevel NotExportEnum
---@field Milliseconds number
---@field PlayMode NotExportEnum
---@field ReadOnlyPath string
---@field ReadWritePath string
local GameFrameX_Asset_Runtime_AssetManager = {}
---@return GameFrameX.Asset.Runtime.AssetManager
function GameFrameX_Asset_Runtime_AssetManager.New() end
function GameFrameX_Asset_Runtime_AssetManager:Initialize() end
---@param packageName string
---@param hostServerURL string
---@param fallbackHostServerURL string
---@param isDefaultPackage boolean
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetManager:InitPackageAsync(packageName, hostServerURL, fallbackHostServerURL, isDefaultPackage) end
---@overload fun(assetPath : string)
---@param packageName string
---@param assetPath string
function GameFrameX_Asset_Runtime_AssetManager:UnloadAsset(packageName, assetPath) end
---@param packageName string
function GameFrameX_Asset_Runtime_AssetManager:UnloadAllAssetsAsync(packageName) end
---@param packageName string
function GameFrameX_Asset_Runtime_AssetManager:UnloadUnusedAssetsAsync(packageName) end
---@param packageName string
function GameFrameX_Asset_Runtime_AssetManager:ClearAllBundleFilesAsync(packageName) end
---@param packageName string
function GameFrameX_Asset_Runtime_AssetManager:ClearUnusedBundleFilesAsync(packageName) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : NotExportType
---@overload fun(path : string, type : System.Type) : NotExportType
---@param path string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetManager:LoadSubAssetsAsync(path) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : NotExportType
---@overload fun(path : string, type : System.Type) : NotExportType
---@param path string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetManager:LoadSubAssetSync(path) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : NotExportType
---@param path string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetManager:LoadRawFileAsync(path) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : NotExportType
---@param path string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetManager:LoadRawFileSync(path) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : Cysharp.Threading.Tasks.UniTask_YooAsset_AssetHandle
---@overload fun(path : string, type : System.Type) : Cysharp.Threading.Tasks.UniTask_YooAsset_AssetHandle
---@param path string
---@return Cysharp.Threading.Tasks.UniTask_YooAsset_AssetHandle
function GameFrameX_Asset_Runtime_AssetManager:LoadAssetAsync(path) end
---@overload fun(path : string, type : System.Type) : NotExportType
---@overload fun(path : string) : NotExportType
---@param assetInfo YooAsset.AssetInfo
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetManager:LoadAllAssetsAsync(assetInfo) end
---@overload fun(path : string) : NotExportType
---@overload fun(path : string, type : System.Type) : NotExportType
---@param assetInfo YooAsset.AssetInfo
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetManager:LoadAllAssetsSync(assetInfo) end
---@overload fun(path : string) : YooAsset.AssetHandle
---@overload fun(path : string, type : System.Type) : YooAsset.AssetHandle
---@param assetInfo YooAsset.AssetInfo
---@return YooAsset.AssetHandle
function GameFrameX_Asset_Runtime_AssetManager:LoadAssetSync(assetInfo) end
---@overload fun(path : string, sceneMode : UnityEngine.SceneManagement.LoadSceneMode, activateOnLoad : boolean) : Cysharp.Threading.Tasks.UniTask_YooAsset_SceneHandle
---@param assetInfo YooAsset.AssetInfo
---@param sceneMode UnityEngine.SceneManagement.LoadSceneMode
---@param activateOnLoad boolean
---@return Cysharp.Threading.Tasks.UniTask_YooAsset_SceneHandle
function GameFrameX_Asset_Runtime_AssetManager:LoadSceneAsync(assetInfo, sceneMode, activateOnLoad) end
---@param path string
---@param sceneMode UnityEngine.SceneManagement.LoadSceneMode
---@param activateOnLoad boolean
---@return YooAsset.SceneHandle
function GameFrameX_Asset_Runtime_AssetManager:LoadSceneAsyncOnLoad(path, sceneMode, activateOnLoad) end
---@param packageName string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetManager:CreateAssetsPackage(packageName) end
---@param packageName string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetManager:TryGetAssetsPackage(packageName) end
---@param packageName string
---@return boolean
function GameFrameX_Asset_Runtime_AssetManager:HasAssetsPackage(packageName) end
---@param packageName string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetManager:GetAssetsPackage(packageName) end
---@overload fun(assetInfo : YooAsset.AssetInfo) : boolean
---@param path string
---@return boolean
function GameFrameX_Asset_Runtime_AssetManager:IsNeedDownload(path) end
---@overload fun(assetTags : NotExportType) : NotExportType
---@param assetTag string
---@return NotExportType
function GameFrameX_Asset_Runtime_AssetManager:GetAssetInfos(assetTag) end
---@param path string
---@return YooAsset.AssetInfo
function GameFrameX_Asset_Runtime_AssetManager:GetAssetInfo(path) end
---@param path string
---@return boolean
function GameFrameX_Asset_Runtime_AssetManager:HasAssetPath(path) end
---@param resourcePackage NotExportType
function GameFrameX_Asset_Runtime_AssetManager:SetDefaultAssetsPackage(resourcePackage) end
---@param playMode NotExportEnum
function GameFrameX_Asset_Runtime_AssetManager:SetPlayMode(playMode) end
---@param readOnlyPath string
function GameFrameX_Asset_Runtime_AssetManager:SetReadOnlyPath(readOnlyPath) end
---@param readWritePath string
function GameFrameX_Asset_Runtime_AssetManager:SetReadWritePath(readWritePath) end

---@class GameFrameX.Runtime.GameFrameworkModule : System.Object
local GameFrameX_Runtime_GameFrameworkModule = {}

---@class GameFrameX.Runtime.Utility : System.Object
local GameFrameX_Runtime_Utility = {}

---@class YooAsset.AssetInfo : System.Object
---@field PackageName string
---@field AssetType System.Type
---@field Error string
---@field IsInvalid boolean
---@field Address string
---@field AssetPath string
local YooAsset_AssetInfo = {}

---@class YooAsset.AssetHandle : YooAsset.HandleBase
---@field AssetObject UnityEngine.Object
local YooAsset_AssetHandle = {}
function YooAsset_AssetHandle:WaitForAsyncComplete() end
function YooAsset_AssetHandle:Release() end
function YooAsset_AssetHandle:Dispose() end
---@overload fun() : UnityEngine.GameObject
---@overload fun(parent : UnityEngine.Transform) : UnityEngine.GameObject
---@overload fun(parent : UnityEngine.Transform, worldPositionStays : boolean) : UnityEngine.GameObject
---@overload fun(position : UnityEngine.Vector3, rotation : UnityEngine.Quaternion) : UnityEngine.GameObject
---@param position UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
---@param parent UnityEngine.Transform
---@return UnityEngine.GameObject
function YooAsset_AssetHandle:InstantiateSync(position, rotation, parent) end
---@overload fun(actived : boolean) : NotExportType
---@overload fun(parent : UnityEngine.Transform, actived : boolean) : NotExportType
---@overload fun(parent : UnityEngine.Transform, worldPositionStays : boolean, actived : boolean) : NotExportType
---@overload fun(position : UnityEngine.Vector3, rotation : UnityEngine.Quaternion, actived : boolean) : NotExportType
---@param position UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
---@param parent UnityEngine.Transform
---@param actived boolean
---@return NotExportType
function YooAsset_AssetHandle:InstantiateAsync(position, rotation, parent, actived) end

---@class YooAsset.HandleBase : System.Object
---@field IsSucceed boolean
---@field Status NotExportEnum
---@field LastError string
---@field Progress number
---@field Duration number
---@field IsDone boolean
---@field IsValid boolean
---@field Task NotExportType
local YooAsset_HandleBase = {}
---@return YooAsset.AssetInfo
function YooAsset_HandleBase:GetAssetInfo() end
---@return NotExportType
function YooAsset_HandleBase:GetDownloadStatus() end

---@class YooAsset.SceneHandle : YooAsset.HandleBase
---@field SceneName string
---@field SceneObject UnityEngine.SceneManagement.Scene
local YooAsset_SceneHandle = {}
---@return boolean
function YooAsset_SceneHandle:ActivateScene() end
---@return boolean
function YooAsset_SceneHandle:UnSuspend() end
---@return boolean
function YooAsset_SceneHandle:IsMainScene() end
---@return NotExportType
function YooAsset_SceneHandle:UnloadAsync() end

---@class Cysharp.Threading.Tasks.UniTask : System.ValueType
---@field CompletedTask Cysharp.Threading.Tasks.UniTask
---@field Status NotExportEnum
local Cysharp_Threading_Tasks_UniTask = {}
---@param source NotExportType
---@param token number
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.New(source, token) end
---@param taskFactory NotExportType
---@return System.Collections.IEnumerator
function Cysharp_Threading_Tasks_UniTask.ToCoroutine(taskFactory) end
---@overload fun() : NotExportType
---@overload fun(timing : NotExportEnum) : NotExportType
---@overload fun(cancellationToken : NotExportType, cancelImmediately : boolean) : Cysharp.Threading.Tasks.UniTask
---@param timing NotExportEnum
---@param cancellationToken NotExportType
---@param cancelImmediately boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.Yield(timing, cancellationToken, cancelImmediately) end
---@overload fun() : Cysharp.Threading.Tasks.UniTask
---@overload fun(timing : NotExportEnum) : Cysharp.Threading.Tasks.UniTask
---@overload fun(cancellationToken : NotExportType, cancelImmediately : boolean) : Cysharp.Threading.Tasks.UniTask
---@param timing NotExportEnum
---@param cancellationToken NotExportType
---@param cancelImmediately boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.NextFrame(timing, cancellationToken, cancelImmediately) end
---@overload fun(coroutineRunner : UnityEngine.MonoBehaviour) : Cysharp.Threading.Tasks.UniTask
---@param coroutineRunner UnityEngine.MonoBehaviour
---@param cancellationToken NotExportType
---@param cancelImmediately boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.WaitForEndOfFrame(coroutineRunner, cancellationToken, cancelImmediately) end
---@overload fun() : NotExportType
---@param cancellationToken NotExportType
---@param cancelImmediately boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.WaitForFixedUpdate(cancellationToken, cancelImmediately) end
---@overload fun(duration : number, ignoreTimeScale : boolean, delayTiming : NotExportEnum, cancellationToken : NotExportType, cancelImmediately : boolean) : Cysharp.Threading.Tasks.UniTask
---@param duration number
---@param ignoreTimeScale boolean
---@param delayTiming NotExportEnum
---@param cancellationToken NotExportType
---@param cancelImmediately boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.WaitForSeconds(duration, ignoreTimeScale, delayTiming, cancellationToken, cancelImmediately) end
---@overload fun() : Cysharp.Threading.Tasks.UniTask
---@param delayFrameCount number
---@param delayTiming NotExportEnum
---@param cancellationToken NotExportType
---@param cancelImmediately boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.DelayFrame(delayFrameCount, delayTiming, cancellationToken, cancelImmediately) end
---@overload fun(millisecondsDelay : number, ignoreTimeScale : boolean, delayTiming : NotExportEnum, cancellationToken : NotExportType, cancelImmediately : boolean) : Cysharp.Threading.Tasks.UniTask
---@overload fun(delayTimeSpan : NotExportType, ignoreTimeScale : boolean, delayTiming : NotExportEnum, cancellationToken : NotExportType, cancelImmediately : boolean) : Cysharp.Threading.Tasks.UniTask
---@overload fun(millisecondsDelay : number, delayType : NotExportEnum, delayTiming : NotExportEnum, cancellationToken : NotExportType, cancelImmediately : boolean) : Cysharp.Threading.Tasks.UniTask
---@param delayTimeSpan NotExportType
---@param delayType NotExportEnum
---@param delayTiming NotExportEnum
---@param cancellationToken NotExportType
---@param cancelImmediately boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.Delay(delayTimeSpan, delayType, delayTiming, cancellationToken, cancelImmediately) end
---@param ex NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.FromException(ex) end
---@param cancellationToken NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.FromCanceled(cancellationToken) end
---@overload fun(factory : NotExportType) : Cysharp.Threading.Tasks.UniTask
---@param factory NotExportType
---@param cancellationToken NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.Create(factory, cancellationToken) end
---@param factory NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask.Lazy(factory) end
---@overload fun(asyncAction : NotExportType)
---@param asyncAction NotExportType
---@param cancellationToken NotExportType
function Cysharp_Threading_Tasks_UniTask.Void(asyncAction, cancellationToken) end
---@overload fun(asyncAction : NotExportType) : NotExportType
---@param asyncAction NotExportType
---@param cancellationToken NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask.Action(asyncAction, cancellationToken) end
---@overload fun(asyncAction : NotExportType) : NotExportType
---@param asyncAction NotExportType
---@param cancellationToken NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask.UnityAction(asyncAction, cancellationToken) end
---@param factory NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.Defer(factory) end
---@param cancellationToken NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.Never(cancellationToken) end
---@overload fun(action : NotExportType, configureAwait : boolean, cancellationToken : NotExportType) : Cysharp.Threading.Tasks.UniTask
---@overload fun(action : NotExportType, state : System.Object, configureAwait : boolean, cancellationToken : NotExportType) : Cysharp.Threading.Tasks.UniTask
---@overload fun(action : NotExportType, configureAwait : boolean, cancellationToken : NotExportType) : Cysharp.Threading.Tasks.UniTask
---@param action NotExportType
---@param state System.Object
---@param configureAwait boolean
---@param cancellationToken NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.RunOnThreadPool(action, state, configureAwait, cancellationToken) end
---@overload fun(cancellationToken : NotExportType) : NotExportType
---@param timing NotExportEnum
---@param cancellationToken NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask.SwitchToMainThread(timing, cancellationToken) end
---@overload fun(cancellationToken : NotExportType) : NotExportType
---@param timing NotExportEnum
---@param cancellationToken NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask.ReturnToMainThread(timing, cancellationToken) end
---@param action NotExportType
---@param timing NotExportEnum
function Cysharp_Threading_Tasks_UniTask.Post(action, timing) end
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask.SwitchToThreadPool() end
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask.SwitchToTaskPool() end
---@param synchronizationContext NotExportType
---@param cancellationToken NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask.SwitchToSynchronizationContext(synchronizationContext, cancellationToken) end
---@param synchronizationContext NotExportType
---@param cancellationToken NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask.ReturnToSynchronizationContext(synchronizationContext, cancellationToken) end
---@param dontPostWhenSameContext boolean
---@param cancellationToken NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask.ReturnToCurrentSynchronizationContext(dontPostWhenSameContext, cancellationToken) end
---@param predicate NotExportType
---@param timing NotExportEnum
---@param cancellationToken NotExportType
---@param cancelImmediately boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.WaitUntil(predicate, timing, cancellationToken, cancelImmediately) end
---@param predicate NotExportType
---@param timing NotExportEnum
---@param cancellationToken NotExportType
---@param cancelImmediately boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.WaitWhile(predicate, timing, cancellationToken, cancelImmediately) end
---@param cancellationToken NotExportType
---@param timing NotExportEnum
---@param completeImmediately boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.WaitUntilCanceled(cancellationToken, timing, completeImmediately) end
---@overload fun(tasks : NotExportType) : Cysharp.Threading.Tasks.UniTask
---@param tasks NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask.WhenAll(tasks) end
---@overload fun(tasks : NotExportType) : NotExportType
---@param tasks NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask.WhenAny(tasks) end
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask:GetAwaiter() end
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask:SuppressCancellationThrow() end
---@return string
function Cysharp_Threading_Tasks_UniTask:ToString() end
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask:Preserve() end
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask:AsAsyncUnitUniTask() end
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask:AsTask() end
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask:ToAsyncLazy() end
---@param cancellationToken NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask:AttachExternalCancellation(cancellationToken) end
---@param exceptionHandler NotExportType
---@return System.Collections.IEnumerator
function Cysharp_Threading_Tasks_UniTask:ToCoroutine(exceptionHandler) end
---@param timeout NotExportType
---@param delayType NotExportEnum
---@param timeoutCheckTiming NotExportEnum
---@param taskCancellationTokenSource NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask:Timeout(timeout, delayType, timeoutCheckTiming, taskCancellationTokenSource) end
---@param timeout NotExportType
---@param delayType NotExportEnum
---@param timeoutCheckTiming NotExportEnum
---@param taskCancellationTokenSource NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask:TimeoutWithoutException(timeout, delayType, timeoutCheckTiming, taskCancellationTokenSource) end
function Cysharp_Threading_Tasks_UniTask:Forget() end
---@param exceptionHandler NotExportType
---@param handleExceptionOnMainThread boolean
function Cysharp_Threading_Tasks_UniTask:Forget(exceptionHandler, handleExceptionOnMainThread) end
---@param continuationFunction NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask:ContinueWith(continuationFunction) end
---@param continuationFunction NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask:ContinueWith(continuationFunction) end
---@param continuationFunction NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask:ContinueWith(continuationFunction) end
---@param continuationFunction NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask:ContinueWith(continuationFunction) end

---@class Cysharp.Threading.Tasks.UniTaskVoid : System.ValueType
local Cysharp_Threading_Tasks_UniTaskVoid = {}
function Cysharp_Threading_Tasks_UniTaskVoid:Forget() end

---@class Cysharp.Threading.Tasks.UniTaskExtensions : System.Object
local Cysharp_Threading_Tasks_UniTaskExtensions = {}
---@param task NotExportType
---@param useCurrentSynchronizationContext boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTaskExtensions.AsUniTask(task, useCurrentSynchronizationContext) end
---@param task Cysharp.Threading.Tasks.UniTask
---@return NotExportType
function Cysharp_Threading_Tasks_UniTaskExtensions.AsTask(task) end
---@param task Cysharp.Threading.Tasks.UniTask
---@return NotExportType
function Cysharp_Threading_Tasks_UniTaskExtensions.ToAsyncLazy(task) end
---@param task Cysharp.Threading.Tasks.UniTask
---@param cancellationToken NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTaskExtensions.AttachExternalCancellation(task, cancellationToken) end
---@param task Cysharp.Threading.Tasks.UniTask
---@param exceptionHandler NotExportType
---@return System.Collections.IEnumerator
function Cysharp_Threading_Tasks_UniTaskExtensions.ToCoroutine(task, exceptionHandler) end
---@param task Cysharp.Threading.Tasks.UniTask
---@param timeout NotExportType
---@param delayType NotExportEnum
---@param timeoutCheckTiming NotExportEnum
---@param taskCancellationTokenSource NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTaskExtensions.Timeout(task, timeout, delayType, timeoutCheckTiming, taskCancellationTokenSource) end
---@param task Cysharp.Threading.Tasks.UniTask
---@param timeout NotExportType
---@param delayType NotExportEnum
---@param timeoutCheckTiming NotExportEnum
---@param taskCancellationTokenSource NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTaskExtensions.TimeoutWithoutException(task, timeout, delayType, timeoutCheckTiming, taskCancellationTokenSource) end
---@overload fun(task : Cysharp.Threading.Tasks.UniTask)
---@param task Cysharp.Threading.Tasks.UniTask
---@param exceptionHandler NotExportType
---@param handleExceptionOnMainThread boolean
function Cysharp_Threading_Tasks_UniTaskExtensions.Forget(task, exceptionHandler, handleExceptionOnMainThread) end
---@overload fun(task : Cysharp.Threading.Tasks.UniTask, continuationFunction : NotExportType) : Cysharp.Threading.Tasks.UniTask
---@param task Cysharp.Threading.Tasks.UniTask
---@param continuationFunction NotExportType
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTaskExtensions.ContinueWith(task, continuationFunction) end
---@overload fun(task : NotExportType) : Cysharp.Threading.Tasks.UniTask
---@overload fun(task : NotExportType) : Cysharp.Threading.Tasks.UniTask
---@overload fun(task : NotExportType, continueOnCapturedContext : boolean) : Cysharp.Threading.Tasks.UniTask
---@overload fun(task : NotExportType) : Cysharp.Threading.Tasks.UniTask
---@param task NotExportType
---@param continueOnCapturedContext boolean
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTaskExtensions.Unwrap(task, continueOnCapturedContext) end
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@overload fun(tasks : NotExportType) : NotExportType
---@param tasks NotExportType
---@return NotExportType
function Cysharp_Threading_Tasks_UniTaskExtensions.GetAwaiter(tasks) end

---@class Cysharp.Threading.Tasks.UniTask_YooAsset_AssetHandle : System.ValueType
---@field Status NotExportEnum
local Cysharp_Threading_Tasks_UniTask_YooAsset_AssetHandle = {}
---@overload fun(result : YooAsset.AssetHandle) : Cysharp.Threading.Tasks.UniTask_YooAsset_AssetHandle
---@param source NotExportType
---@param token number
---@return Cysharp.Threading.Tasks.UniTask_YooAsset_AssetHandle
function Cysharp_Threading_Tasks_UniTask_YooAsset_AssetHandle.New(source, token) end
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask_YooAsset_AssetHandle:GetAwaiter() end
---@return Cysharp.Threading.Tasks.UniTask_YooAsset_AssetHandle
function Cysharp_Threading_Tasks_UniTask_YooAsset_AssetHandle:Preserve() end
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask_YooAsset_AssetHandle:AsUniTask() end
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask_YooAsset_AssetHandle:SuppressCancellationThrow() end
---@return string
function Cysharp_Threading_Tasks_UniTask_YooAsset_AssetHandle:ToString() end

---@class Cysharp.Threading.Tasks.UniTask_YooAsset_SceneHandle : System.ValueType
---@field Status NotExportEnum
local Cysharp_Threading_Tasks_UniTask_YooAsset_SceneHandle = {}
---@overload fun(result : YooAsset.SceneHandle) : Cysharp.Threading.Tasks.UniTask_YooAsset_SceneHandle
---@param source NotExportType
---@param token number
---@return Cysharp.Threading.Tasks.UniTask_YooAsset_SceneHandle
function Cysharp_Threading_Tasks_UniTask_YooAsset_SceneHandle.New(source, token) end
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask_YooAsset_SceneHandle:GetAwaiter() end
---@return Cysharp.Threading.Tasks.UniTask_YooAsset_SceneHandle
function Cysharp_Threading_Tasks_UniTask_YooAsset_SceneHandle:Preserve() end
---@return Cysharp.Threading.Tasks.UniTask
function Cysharp_Threading_Tasks_UniTask_YooAsset_SceneHandle:AsUniTask() end
---@return NotExportType
function Cysharp_Threading_Tasks_UniTask_YooAsset_SceneHandle:SuppressCancellationThrow() end
---@return string
function Cysharp_Threading_Tasks_UniTask_YooAsset_SceneHandle:ToString() end

---@class LuaFramework.AssetType
---@field Image LuaFramework.AssetType
---@field Video LuaFramework.AssetType
---@field Sprite LuaFramework.AssetType
---@field Prefab LuaFramework.AssetType
---@field Config LuaFramework.AssetType
---@field AOTCode LuaFramework.AssetType
---@field Code LuaFramework.AssetType
---@field UI LuaFramework.AssetType
---@field Sound LuaFramework.AssetType
---@field Scene LuaFramework.AssetType
---@field Localization LuaFramework.AssetType
local LuaFramework_AssetType = {}

---@class LuaInterface.EventObject : System.Object
---@field op NotExportEnum
---@field func System.Delegate
---@field type System.Type
local LuaInterface_EventObject = {}
---@param t System.Type
---@return LuaInterface.EventObject
function LuaInterface_EventObject.New(t) end

---@class LuaInterface.LuaConstructor : System.Object
local LuaInterface_LuaConstructor = {}
---@param func NotExportType
---@param types NotExportType
---@return LuaInterface.LuaConstructor
function LuaInterface_LuaConstructor.New(func, types) end
---@param L NotExportType
---@return number
function LuaInterface_LuaConstructor:Call(L) end
function LuaInterface_LuaConstructor:Destroy() end

---@class LuaInterface.LuaField : System.Object
local LuaInterface_LuaField = {}
---@param info NotExportType
---@param t System.Type
---@return LuaInterface.LuaField
function LuaInterface_LuaField.New(info, t) end
---@param L NotExportType
---@return number
function LuaInterface_LuaField:Get(L) end
---@param L NotExportType
---@return number
function LuaInterface_LuaField:Set(L) end

---@class LuaInterface.LuaMethod : System.Object
local LuaInterface_LuaMethod = {}
---@param md NotExportType
---@param t System.Type
---@param types NotExportType
---@return LuaInterface.LuaMethod
function LuaInterface_LuaMethod.New(md, t, types) end
---@param L NotExportType
---@return number
function LuaInterface_LuaMethod:Call(L) end
function LuaInterface_LuaMethod:Destroy() end

---@class LuaInterface.LuaOut : System.Object
local LuaInterface_LuaOut = {}
---@return LuaInterface.LuaOut
function LuaInterface_LuaOut.New() end

---@class LuaInterface.LuaProperty : System.Object
local LuaInterface_LuaProperty = {}
---@param prop NotExportType
---@param t System.Type
---@return LuaInterface.LuaProperty
function LuaInterface_LuaProperty.New(prop, t) end
---@param L NotExportType
---@return number
function LuaInterface_LuaProperty:Get(L) end
---@param L NotExportType
---@return number
function LuaInterface_LuaProperty:Set(L) end

---@class System.Array : System.Object
---@field LongLength number
---@field IsFixedSize boolean
---@field IsReadOnly boolean
---@field IsSynchronized boolean
---@field SyncRoot System.Object
---@field Length number
---@field Rank number
local System_Array = {}
---@overload fun(elementType : System.Type, lengths : NotExportType) : System.Array
---@overload fun(elementType : System.Type, length : number) : System.Array
---@overload fun(elementType : System.Type, length1 : number, length2 : number) : System.Array
---@overload fun(elementType : System.Type, length1 : number, length2 : number, length3 : number) : System.Array
---@overload fun(elementType : System.Type, lengths : NotExportType) : System.Array
---@param elementType System.Type
---@param lengths NotExportType
---@param lowerBounds NotExportType
---@return System.Array
function System_Array.CreateInstance(elementType, lengths, lowerBounds) end
---@overload fun(array : System.Array, value : System.Object) : number
---@overload fun(array : System.Array, index : number, length : number, value : System.Object) : number
---@overload fun(array : System.Array, value : System.Object, comparer : NotExportType) : number
---@param array System.Array
---@param index number
---@param length number
---@param value System.Object
---@param comparer NotExportType
---@return number
function System_Array.BinarySearch(array, index, length, value, comparer) end
---@overload fun(sourceArray : System.Array, destinationArray : System.Array, length : number)
---@overload fun(sourceArray : System.Array, sourceIndex : number, destinationArray : System.Array, destinationIndex : number, length : number)
---@overload fun(sourceArray : System.Array, destinationArray : System.Array, length : number)
---@param sourceArray System.Array
---@param sourceIndex number
---@param destinationArray System.Array
---@param destinationIndex number
---@param length number
function System_Array.Copy(sourceArray, sourceIndex, destinationArray, destinationIndex, length) end
---@overload fun(array : System.Array, value : System.Object) : number
---@overload fun(array : System.Array, value : System.Object, startIndex : number) : number
---@param array System.Array
---@param value System.Object
---@param startIndex number
---@param count number
---@return number
function System_Array.IndexOf(array, value, startIndex, count) end
---@overload fun(array : System.Array, value : System.Object) : number
---@overload fun(array : System.Array, value : System.Object, startIndex : number) : number
---@param array System.Array
---@param value System.Object
---@param startIndex number
---@param count number
---@return number
function System_Array.LastIndexOf(array, value, startIndex, count) end
---@overload fun(array : System.Array)
---@param array System.Array
---@param index number
---@param length number
function System_Array.Reverse(array, index, length) end
---@overload fun(array : System.Array)
---@overload fun(array : System.Array, index : number, length : number)
---@overload fun(array : System.Array, comparer : NotExportType)
---@overload fun(array : System.Array, index : number, length : number, comparer : NotExportType)
---@overload fun(keys : System.Array, items : System.Array)
---@overload fun(keys : System.Array, items : System.Array, comparer : NotExportType)
---@overload fun(keys : System.Array, items : System.Array, index : number, length : number)
---@param keys System.Array
---@param items System.Array
---@param index number
---@param length number
---@param comparer NotExportType
function System_Array.Sort(keys, items, index, length, comparer) end
---@param array System.Array
---@param index number
---@param length number
function System_Array.Clear(array, index, length) end
---@param sourceArray System.Array
---@param sourceIndex number
---@param destinationArray System.Array
---@param destinationIndex number
---@param length number
function System_Array.ConstrainedCopy(sourceArray, sourceIndex, destinationArray, destinationIndex, length) end
---@overload fun(array : System.Array, index : number)
---@param array System.Array
---@param index number
function System_Array:CopyTo(array, index) end
---@return System.Object
function System_Array:Clone() end
---@param dimension number
---@return number
function System_Array:GetLongLength(dimension) end
---@overload fun(index : number) : System.Object
---@overload fun(index1 : number, index2 : number) : System.Object
---@overload fun(index1 : number, index2 : number, index3 : number) : System.Object
---@overload fun(indices : NotExportType) : System.Object
---@overload fun(indices : NotExportType) : System.Object
---@overload fun(index : number) : System.Object
---@overload fun(index1 : number, index2 : number) : System.Object
---@param index1 number
---@param index2 number
---@param index3 number
---@return System.Object
function System_Array:GetValue(index1, index2, index3) end
---@overload fun(value : System.Object, index : number)
---@overload fun(value : System.Object, index1 : number, index2 : number)
---@overload fun(value : System.Object, index1 : number, index2 : number, index3 : number)
---@overload fun(value : System.Object, indices : NotExportType)
---@overload fun(value : System.Object, indices : NotExportType)
---@overload fun(value : System.Object, index : number)
---@overload fun(value : System.Object, index1 : number, index2 : number)
---@param value System.Object
---@param index1 number
---@param index2 number
---@param index3 number
function System_Array:SetValue(value, index1, index2, index3) end
---@return System.Collections.IEnumerator
function System_Array:GetEnumerator() end
---@param dimension number
---@return number
function System_Array:GetLength(dimension) end
---@param dimension number
---@return number
function System_Array:GetLowerBound(dimension) end
---@param dimension number
---@return number
function System_Array:GetUpperBound(dimension) end
function System_Array:Initialize() end

---@class System.Collections.Generic.Dictionary.KeyCollection : System.Object
---@field Count number
local System_Collections_Generic_Dictionary_KeyCollection = {}
---@param dictionary NotExportType
---@return System.Collections.Generic.Dictionary.KeyCollection
function System_Collections_Generic_Dictionary_KeyCollection.New(dictionary) end
---@return NotExportType
function System_Collections_Generic_Dictionary_KeyCollection:GetEnumerator() end
---@param array NotExportType
---@param index number
function System_Collections_Generic_Dictionary_KeyCollection:CopyTo(array, index) end

---@class System.Collections.Generic.Dictionary.ValueCollection : System.Object
---@field Count number
local System_Collections_Generic_Dictionary_ValueCollection = {}
---@param dictionary NotExportType
---@return System.Collections.Generic.Dictionary.ValueCollection
function System_Collections_Generic_Dictionary_ValueCollection.New(dictionary) end
---@return NotExportType
function System_Collections_Generic_Dictionary_ValueCollection:GetEnumerator() end
---@param array NotExportType
---@param index number
function System_Collections_Generic_Dictionary_ValueCollection:CopyTo(array, index) end

---@class System.Collections.Generic.Dictionary : System.Object
---@field Comparer NotExportType
---@field Count number
---@field Keys NotExportType
---@field Values NotExportType
---@field Item NotExportType
local System_Collections_Generic_Dictionary = {}
---@overload fun() : System.Collections.Generic.Dictionary
---@overload fun(capacity : number) : System.Collections.Generic.Dictionary
---@overload fun(comparer : NotExportType) : System.Collections.Generic.Dictionary
---@overload fun(capacity : number, comparer : NotExportType) : System.Collections.Generic.Dictionary
---@overload fun(dictionary : NotExportType) : System.Collections.Generic.Dictionary
---@overload fun(dictionary : NotExportType, comparer : NotExportType) : System.Collections.Generic.Dictionary
---@overload fun(collection : NotExportType) : System.Collections.Generic.Dictionary
---@param collection NotExportType
---@param comparer NotExportType
---@return System.Collections.Generic.Dictionary
function System_Collections_Generic_Dictionary.New(collection, comparer) end
---@param key NotExportType
---@param value NotExportType
function System_Collections_Generic_Dictionary:Add(key, value) end
function System_Collections_Generic_Dictionary:Clear() end
---@param key NotExportType
---@return boolean
function System_Collections_Generic_Dictionary:ContainsKey(key) end
---@param value NotExportType
---@return boolean
function System_Collections_Generic_Dictionary:ContainsValue(value) end
---@return NotExportType
function System_Collections_Generic_Dictionary:GetEnumerator() end
---@param info NotExportType
---@param context NotExportType
function System_Collections_Generic_Dictionary:GetObjectData(info, context) end
---@param sender System.Object
function System_Collections_Generic_Dictionary:OnDeserialization(sender) end
---@param key NotExportType
---@return boolean
function System_Collections_Generic_Dictionary:Remove(key) end
---@param key NotExportType
---@param out_value NotExportType
---@return boolean,NotExportType
function System_Collections_Generic_Dictionary:TryGetValue(key, out_value) end
---@param capacity number
---@return number
function System_Collections_Generic_Dictionary:EnsureCapacity(capacity) end
---@overload fun()
---@param capacity number
function System_Collections_Generic_Dictionary:TrimExcess(capacity) end

---@class System.Collections.Generic.KeyValuePair : System.ValueType
---@field Key NotExportType
---@field Value NotExportType
local System_Collections_Generic_KeyValuePair = {}
---@param key NotExportType
---@param value NotExportType
---@return System.Collections.Generic.KeyValuePair
function System_Collections_Generic_KeyValuePair.New(key, value) end
---@return string
function System_Collections_Generic_KeyValuePair:ToString() end

---@class System.Collections.Generic.List : System.Object
---@field Capacity number
---@field Count number
---@field Item NotExportType
local System_Collections_Generic_List = {}
---@overload fun() : System.Collections.Generic.List
---@overload fun(capacity : number) : System.Collections.Generic.List
---@param collection NotExportType
---@return System.Collections.Generic.List
function System_Collections_Generic_List.New(collection) end
---@param item NotExportType
function System_Collections_Generic_List:Add(item) end
---@param collection NotExportType
function System_Collections_Generic_List:AddRange(collection) end
---@return NotExportType
function System_Collections_Generic_List:AsReadOnly() end
---@overload fun(index : number, count : number, item : NotExportType, comparer : NotExportType) : number
---@overload fun(item : NotExportType) : number
---@param item NotExportType
---@param comparer NotExportType
---@return number
function System_Collections_Generic_List:BinarySearch(item, comparer) end
function System_Collections_Generic_List:Clear() end
---@param item NotExportType
---@return boolean
function System_Collections_Generic_List:Contains(item) end
---@overload fun(array : NotExportType)
---@overload fun(index : number, array : NotExportType, arrayIndex : number, count : number)
---@param array NotExportType
---@param arrayIndex number
function System_Collections_Generic_List:CopyTo(array, arrayIndex) end
---@param match NotExportType
---@return boolean
function System_Collections_Generic_List:Exists(match) end
---@param match NotExportType
---@return NotExportType
function System_Collections_Generic_List:Find(match) end
---@param match NotExportType
---@return System.Collections.Generic.List
function System_Collections_Generic_List:FindAll(match) end
---@overload fun(match : NotExportType) : number
---@overload fun(startIndex : number, match : NotExportType) : number
---@param startIndex number
---@param count number
---@param match NotExportType
---@return number
function System_Collections_Generic_List:FindIndex(startIndex, count, match) end
---@param match NotExportType
---@return NotExportType
function System_Collections_Generic_List:FindLast(match) end
---@overload fun(match : NotExportType) : number
---@overload fun(startIndex : number, match : NotExportType) : number
---@param startIndex number
---@param count number
---@param match NotExportType
---@return number
function System_Collections_Generic_List:FindLastIndex(startIndex, count, match) end
---@param action NotExportType
function System_Collections_Generic_List:ForEach(action) end
---@return NotExportType
function System_Collections_Generic_List:GetEnumerator() end
---@param index number
---@param count number
---@return System.Collections.Generic.List
function System_Collections_Generic_List:GetRange(index, count) end
---@overload fun(item : NotExportType) : number
---@overload fun(item : NotExportType, index : number) : number
---@param item NotExportType
---@param index number
---@param count number
---@return number
function System_Collections_Generic_List:IndexOf(item, index, count) end
---@param index number
---@param item NotExportType
function System_Collections_Generic_List:Insert(index, item) end
---@param index number
---@param collection NotExportType
function System_Collections_Generic_List:InsertRange(index, collection) end
---@overload fun(item : NotExportType) : number
---@overload fun(item : NotExportType, index : number) : number
---@param item NotExportType
---@param index number
---@param count number
---@return number
function System_Collections_Generic_List:LastIndexOf(item, index, count) end
---@param item NotExportType
---@return boolean
function System_Collections_Generic_List:Remove(item) end
---@param match NotExportType
---@return number
function System_Collections_Generic_List:RemoveAll(match) end
---@param index number
function System_Collections_Generic_List:RemoveAt(index) end
---@param index number
---@param count number
function System_Collections_Generic_List:RemoveRange(index, count) end
---@overload fun()
---@param index number
---@param count number
function System_Collections_Generic_List:Reverse(index, count) end
---@overload fun()
---@overload fun(comparer : NotExportType)
---@overload fun(index : number, count : number, comparer : NotExportType)
---@param comparison NotExportType
function System_Collections_Generic_List:Sort(comparison) end
---@return NotExportType
function System_Collections_Generic_List:ToArray() end
function System_Collections_Generic_List:TrimExcess() end
---@param match NotExportType
---@return boolean
function System_Collections_Generic_List:TrueForAll(match) end

---@class System.Collections.IEnumerator
---@field Current System.Object
local System_Collections_IEnumerator = {}
---@return boolean
function System_Collections_IEnumerator:MoveNext() end
function System_Collections_IEnumerator:Reset() end

---@class System.Collections.ObjectModel.ReadOnlyCollection : System.Object
---@field Count number
---@field Item NotExportType
local System_Collections_ObjectModel_ReadOnlyCollection = {}
---@param list NotExportType
---@return System.Collections.ObjectModel.ReadOnlyCollection
function System_Collections_ObjectModel_ReadOnlyCollection.New(list) end
---@param value NotExportType
---@return boolean
function System_Collections_ObjectModel_ReadOnlyCollection:Contains(value) end
---@param array NotExportType
---@param index number
function System_Collections_ObjectModel_ReadOnlyCollection:CopyTo(array, index) end
---@return NotExportType
function System_Collections_ObjectModel_ReadOnlyCollection:GetEnumerator() end
---@param value NotExportType
---@return number
function System_Collections_ObjectModel_ReadOnlyCollection:IndexOf(value) end

---@class System.Delegate : System.Object
---@field Method NotExportType
---@field Target System.Object
local System_Delegate = {}
---@overload fun(type : System.Type, firstArgument : System.Object, method : NotExportType, throwOnBindFailure : boolean) : System.Delegate
---@overload fun(type : System.Type, firstArgument : System.Object, method : NotExportType) : System.Delegate
---@overload fun(type : System.Type, method : NotExportType, throwOnBindFailure : boolean) : System.Delegate
---@overload fun(type : System.Type, method : NotExportType) : System.Delegate
---@overload fun(type : System.Type, target : System.Object, method : string) : System.Delegate
---@overload fun(type : System.Type, target : System.Type, method : string, ignoreCase : boolean, throwOnBindFailure : boolean) : System.Delegate
---@overload fun(type : System.Type, target : System.Type, method : string) : System.Delegate
---@overload fun(type : System.Type, target : System.Type, method : string, ignoreCase : boolean) : System.Delegate
---@overload fun(type : System.Type, target : System.Object, method : string, ignoreCase : boolean, throwOnBindFailure : boolean) : System.Delegate
---@param type System.Type
---@param target System.Object
---@param method string
---@param ignoreCase boolean
---@return System.Delegate
function System_Delegate.CreateDelegate(type, target, method, ignoreCase) end
---@overload fun(a : System.Delegate, b : System.Delegate) : System.Delegate
---@param delegates NotExportType
---@return System.Delegate
function System_Delegate.Combine(delegates) end
---@param source System.Delegate
---@param value System.Delegate
---@return System.Delegate
function System_Delegate.Remove(source, value) end
---@param source System.Delegate
---@param value System.Delegate
---@return System.Delegate
function System_Delegate.RemoveAll(source, value) end
---@param args NotExportType
---@return System.Object
function System_Delegate:DynamicInvoke(args) end
---@return System.Object
function System_Delegate:Clone() end
---@param obj System.Object
---@return boolean
function System_Delegate:Equals(obj) end
---@return number
function System_Delegate:GetHashCode() end
---@param info NotExportType
---@param context NotExportType
function System_Delegate:GetObjectData(info, context) end
---@return NotExportType
function System_Delegate:GetInvocationList() end

---@class System.Enum : System.ValueType
local System_Enum = {}
---@overload fun(enumType : System.Type, value : string) : System.Object
---@param enumType System.Type
---@param value string
---@param ignoreCase boolean
---@return System.Object
function System_Enum.Parse(enumType, value, ignoreCase) end
---@param enumType System.Type
---@return System.Type
function System_Enum.GetUnderlyingType(enumType) end
---@param enumType System.Type
---@return System.Array
function System_Enum.GetValues(enumType) end
---@param enumType System.Type
---@param value System.Object
---@return string
function System_Enum.GetName(enumType, value) end
---@param enumType System.Type
---@return NotExportType
function System_Enum.GetNames(enumType) end
---@overload fun(enumType : System.Type, value : System.Object) : System.Object
---@overload fun(enumType : System.Type, value : number) : System.Object
---@overload fun(enumType : System.Type, value : number) : System.Object
---@overload fun(enumType : System.Type, value : number) : System.Object
---@overload fun(enumType : System.Type, value : number) : System.Object
---@overload fun(enumType : System.Type, value : number) : System.Object
---@overload fun(enumType : System.Type, value : number) : System.Object
---@overload fun(enumType : System.Type, value : number) : System.Object
---@param enumType System.Type
---@param value number
---@return System.Object
function System_Enum.ToObject(enumType, value) end
---@param enumType System.Type
---@param value System.Object
---@return boolean
function System_Enum.IsDefined(enumType, value) end
---@param enumType System.Type
---@param value System.Object
---@param format string
---@return string
function System_Enum.Format(enumType, value, format) end
---@overload fun(enumType : System.Type, value : string, ignoreCase : boolean, out_result : System.Object) : boolean, System.Object
---@param enumType System.Type
---@param value string
---@param out_result System.Object
---@return boolean,System.Object
function System_Enum.TryParse(enumType, value, out_result) end
---@param obj System.Object
---@return boolean
function System_Enum:Equals(obj) end
---@return number
function System_Enum:GetHashCode() end
---@overload fun() : string
---@param format string
---@return string
function System_Enum:ToString(format) end
---@param target System.Object
---@return number
function System_Enum:CompareTo(target) end
---@param flag System.Enum
---@return boolean
function System_Enum:HasFlag(flag) end
---@return NotExportEnum
function System_Enum:GetTypeCode() end

---@class LuaInterface.NullObject : System.Object
local LuaInterface_NullObject = {}
---@return LuaInterface.NullObject
function LuaInterface_NullObject.New() end

---@class System.String : System.Object
---@field Empty System.String
---@field Length number
local System_String = {}
---@overload fun(value : NotExportType) : System.String
---@overload fun(value : NotExportType, startIndex : number, length : number) : System.String
---@overload fun(value : NotExportType) : System.String
---@overload fun(value : NotExportType, startIndex : number, length : number) : System.String
---@overload fun(value : NotExportType) : System.String
---@overload fun(value : NotExportType, startIndex : number, length : number) : System.String
---@overload fun(value : NotExportType, startIndex : number, length : number, enc : NotExportType) : System.String
---@overload fun(c : NotExportType, count : number) : System.String
---@param value NotExportType
---@return System.String
function System_String.New(value) end
---@overload fun(strA : System.String, strB : System.String) : number
---@overload fun(strA : System.String, strB : System.String, ignoreCase : boolean) : number
---@overload fun(strA : System.String, strB : System.String, comparisonType : NotExportEnum) : number
---@overload fun(strA : System.String, strB : System.String, culture : NotExportType, options : NotExportEnum) : number
---@overload fun(strA : System.String, strB : System.String, ignoreCase : boolean, culture : NotExportType) : number
---@overload fun(strA : System.String, indexA : number, strB : System.String, indexB : number, length : number) : number
---@overload fun(strA : System.String, indexA : number, strB : System.String, indexB : number, length : number, ignoreCase : boolean) : number
---@overload fun(strA : System.String, indexA : number, strB : System.String, indexB : number, length : number, ignoreCase : boolean, culture : NotExportType) : number
---@overload fun(strA : System.String, indexA : number, strB : System.String, indexB : number, length : number, culture : NotExportType, options : NotExportEnum) : number
---@param strA System.String
---@param indexA number
---@param strB System.String
---@param indexB number
---@param length number
---@param comparisonType NotExportEnum
---@return number
function System_String.Compare(strA, indexA, strB, indexB, length, comparisonType) end
---@overload fun(strA : System.String, strB : System.String) : number
---@param strA System.String
---@param indexA number
---@param strB System.String
---@param indexB number
---@param length number
---@return number
function System_String.CompareOrdinal(strA, indexA, strB, indexB, length) end
---@overload fun(a : System.String, b : System.String) : boolean
---@overload fun(a : System.String, b : System.String, comparisonType : NotExportEnum) : boolean
---@overload fun(obj : System.Object) : boolean
---@overload fun(value : System.String) : boolean
---@param value System.String
---@param comparisonType NotExportEnum
---@return boolean
function System_String:Equals(value, comparisonType) end
---@overload fun(arg0 : System.Object) : System.String
---@overload fun(arg0 : System.Object, arg1 : System.Object) : System.String
---@overload fun(arg0 : System.Object, arg1 : System.Object, arg2 : System.Object) : System.String
---@overload fun(args : NotExportType) : System.String
---@overload fun(values : NotExportType) : System.String
---@overload fun(str0 : System.String, str1 : System.String) : System.String
---@overload fun(str0 : System.String, str1 : System.String, str2 : System.String) : System.String
---@overload fun(str0 : System.String, str1 : System.String, str2 : System.String, str3 : System.String) : System.String
---@overload fun(values : NotExportType) : System.String
---@param arg0 System.Object
---@param arg1 System.Object
---@param arg2 System.Object
---@param arg3 System.Object
---@return System.String
function System_String.Concat(arg0, arg1, arg2, arg3) end
---@overload fun(format : System.String, arg0 : System.Object) : System.String
---@overload fun(format : System.String, arg0 : System.Object, arg1 : System.Object) : System.String
---@overload fun(format : System.String, arg0 : System.Object, arg1 : System.Object, arg2 : System.Object) : System.String
---@overload fun(format : System.String, args : NotExportType) : System.String
---@overload fun(provider : NotExportType, format : System.String, arg0 : System.Object) : System.String
---@overload fun(provider : NotExportType, format : System.String, arg0 : System.Object, arg1 : System.Object) : System.String
---@overload fun(provider : NotExportType, format : System.String, arg0 : System.Object, arg1 : System.Object, arg2 : System.Object) : System.String
---@param provider NotExportType
---@param format System.String
---@param args NotExportType
---@return System.String
function System_String.Format(provider, format, args) end
---@overload fun(separator : NotExportType, value : NotExportType) : System.String
---@overload fun(separator : NotExportType, values : NotExportType) : System.String
---@overload fun(separator : NotExportType, value : NotExportType, startIndex : number, count : number) : System.String
---@overload fun(separator : System.String, value : NotExportType) : System.String
---@overload fun(separator : System.String, values : NotExportType) : System.String
---@overload fun(separator : System.String, values : NotExportType) : System.String
---@param separator System.String
---@param value NotExportType
---@param startIndex number
---@param count number
---@return System.String
function System_String.Join(separator, value, startIndex, count) end
---@param str System.String
---@return System.String
function System_String.Copy(str) end
---@param value System.String
---@return boolean
function System_String.IsNullOrEmpty(value) end
---@param value System.String
---@return boolean
function System_String.IsNullOrWhiteSpace(value) end
---@param str System.String
---@return System.String
function System_String.Intern(str) end
---@param str System.String
---@return System.String
function System_String.IsInterned(str) end
---@overload fun(value : System.Object) : number
---@param strB System.String
---@return number
function System_String:CompareTo(strB) end
---@overload fun(value : System.String) : boolean
---@overload fun(value : System.String, comparisonType : NotExportEnum) : boolean
---@overload fun(value : System.String, ignoreCase : boolean, culture : NotExportType) : boolean
---@param value NotExportType
---@return boolean
function System_String:EndsWith(value) end
---@overload fun() : number
---@param comparisonType NotExportEnum
---@return number
function System_String:GetHashCode(comparisonType) end
---@overload fun(value : System.String) : boolean
---@overload fun(value : System.String, comparisonType : NotExportEnum) : boolean
---@overload fun(value : System.String, ignoreCase : boolean, culture : NotExportType) : boolean
---@param value NotExportType
---@return boolean
function System_String:StartsWith(value) end
---@param startIndex number
---@param value System.String
---@return System.String
function System_String:Insert(startIndex, value) end
---@overload fun(totalWidth : number) : System.String
---@param totalWidth number
---@param paddingChar NotExportType
---@return System.String
function System_String:PadLeft(totalWidth, paddingChar) end
---@overload fun(totalWidth : number) : System.String
---@param totalWidth number
---@param paddingChar NotExportType
---@return System.String
function System_String:PadRight(totalWidth, paddingChar) end
---@overload fun(startIndex : number, count : number) : System.String
---@param startIndex number
---@return System.String
function System_String:Remove(startIndex) end
---@overload fun(oldValue : System.String, newValue : System.String, ignoreCase : boolean, culture : NotExportType) : System.String
---@overload fun(oldValue : System.String, newValue : System.String, comparisonType : NotExportEnum) : System.String
---@overload fun(oldChar : NotExportType, newChar : NotExportType) : System.String
---@param oldValue System.String
---@param newValue System.String
---@return System.String
function System_String:Replace(oldValue, newValue) end
---@overload fun(separator : NotExportType, options : NotExportEnum) : NotExportType
---@overload fun(separator : NotExportType, count : number, options : NotExportEnum) : NotExportType
---@overload fun(separator : NotExportType) : NotExportType
---@overload fun(separator : NotExportType, count : number) : NotExportType
---@overload fun(separator : NotExportType, options : NotExportEnum) : NotExportType
---@overload fun(separator : NotExportType, count : number, options : NotExportEnum) : NotExportType
---@overload fun(separator : System.String, options : NotExportEnum) : NotExportType
---@overload fun(separator : System.String, count : number, options : NotExportEnum) : NotExportType
---@overload fun(separator : NotExportType, options : NotExportEnum) : NotExportType
---@param separator NotExportType
---@param count number
---@param options NotExportEnum
---@return NotExportType
function System_String:Split(separator, count, options) end
---@overload fun(startIndex : number) : System.String
---@param startIndex number
---@param length number
---@return System.String
function System_String:Substring(startIndex, length) end
---@overload fun() : System.String
---@param culture NotExportType
---@return System.String
function System_String:ToLower(culture) end
---@return System.String
function System_String:ToLowerInvariant() end
---@overload fun() : System.String
---@param culture NotExportType
---@return System.String
function System_String:ToUpper(culture) end
---@return System.String
function System_String:ToUpperInvariant() end
---@overload fun() : System.String
---@overload fun(trimChar : NotExportType) : System.String
---@param trimChars NotExportType
---@return System.String
function System_String:Trim(trimChars) end
---@overload fun() : System.String
---@overload fun(trimChar : NotExportType) : System.String
---@param trimChars NotExportType
---@return System.String
function System_String:TrimStart(trimChars) end
---@overload fun() : System.String
---@overload fun(trimChar : NotExportType) : System.String
---@param trimChars NotExportType
---@return System.String
function System_String:TrimEnd(trimChars) end
---@overload fun(value : System.String) : boolean
---@overload fun(value : System.String, comparisonType : NotExportEnum) : boolean
---@overload fun(value : NotExportType) : boolean
---@param value NotExportType
---@param comparisonType NotExportEnum
---@return boolean
function System_String:Contains(value, comparisonType) end
---@overload fun(value : NotExportType) : number
---@overload fun(value : NotExportType, startIndex : number) : number
---@overload fun(value : NotExportType, comparisonType : NotExportEnum) : number
---@overload fun(value : NotExportType, startIndex : number, count : number) : number
---@overload fun(value : System.String) : number
---@overload fun(value : System.String, startIndex : number) : number
---@overload fun(value : System.String, startIndex : number, count : number) : number
---@overload fun(value : System.String, comparisonType : NotExportEnum) : number
---@overload fun(value : System.String, startIndex : number, comparisonType : NotExportEnum) : number
---@param value System.String
---@param startIndex number
---@param count number
---@param comparisonType NotExportEnum
---@return number
function System_String:IndexOf(value, startIndex, count, comparisonType) end
---@overload fun(anyOf : NotExportType) : number
---@overload fun(anyOf : NotExportType, startIndex : number) : number
---@param anyOf NotExportType
---@param startIndex number
---@param count number
---@return number
function System_String:IndexOfAny(anyOf, startIndex, count) end
---@overload fun(value : NotExportType) : number
---@overload fun(value : NotExportType, startIndex : number) : number
---@overload fun(value : NotExportType, startIndex : number, count : number) : number
---@overload fun(value : System.String) : number
---@overload fun(value : System.String, startIndex : number) : number
---@overload fun(value : System.String, startIndex : number, count : number) : number
---@overload fun(value : System.String, comparisonType : NotExportEnum) : number
---@overload fun(value : System.String, startIndex : number, comparisonType : NotExportEnum) : number
---@param value System.String
---@param startIndex number
---@param count number
---@param comparisonType NotExportEnum
---@return number
function System_String:LastIndexOf(value, startIndex, count, comparisonType) end
---@overload fun(anyOf : NotExportType) : number
---@overload fun(anyOf : NotExportType, startIndex : number) : number
---@param anyOf NotExportType
---@param startIndex number
---@param count number
---@return number
function System_String:LastIndexOfAny(anyOf, startIndex, count) end
---@return System.Object
function System_String:Clone() end
---@param sourceIndex number
---@param destination NotExportType
---@param destinationIndex number
---@param count number
function System_String:CopyTo(sourceIndex, destination, destinationIndex, count) end
---@overload fun() : NotExportType
---@param startIndex number
---@param length number
---@return NotExportType
function System_String:ToCharArray(startIndex, length) end
---@overload fun() : System.String
---@param provider NotExportType
---@return System.String
function System_String:ToString(provider) end
---@return NotExportType
function System_String:GetEnumerator() end
---@return NotExportEnum
function System_String:GetTypeCode() end
---@overload fun() : boolean
---@param normalizationForm NotExportEnum
---@return boolean
function System_String:IsNormalized(normalizationForm) end
---@overload fun() : System.String
---@param normalizationForm NotExportEnum
---@return System.String
function System_String:Normalize(normalizationForm) end

---@class System.Type : NotExportType
---@field Delimiter NotExportType
---@field EmptyTypes NotExportType
---@field Missing System.Object
---@field FilterAttribute NotExportType
---@field FilterName NotExportType
---@field FilterNameIgnoreCase NotExportType
---@field DefaultBinder NotExportType
---@field IsSerializable boolean
---@field ContainsGenericParameters boolean
---@field IsVisible boolean
---@field MemberType NotExportEnum
---@field Namespace string
---@field AssemblyQualifiedName string
---@field FullName string
---@field Assembly NotExportType
---@field Module NotExportType
---@field IsNested boolean
---@field DeclaringType System.Type
---@field DeclaringMethod NotExportType
---@field ReflectedType System.Type
---@field UnderlyingSystemType System.Type
---@field IsTypeDefinition boolean
---@field IsArray boolean
---@field IsByRef boolean
---@field IsPointer boolean
---@field IsConstructedGenericType boolean
---@field IsGenericParameter boolean
---@field IsGenericTypeParameter boolean
---@field IsGenericMethodParameter boolean
---@field IsGenericType boolean
---@field IsGenericTypeDefinition boolean
---@field IsVariableBoundArray boolean
---@field IsByRefLike boolean
---@field HasElementType boolean
---@field GenericTypeArguments NotExportType
---@field GenericParameterPosition number
---@field GenericParameterAttributes NotExportEnum
---@field Attributes NotExportEnum
---@field IsAbstract boolean
---@field IsImport boolean
---@field IsSealed boolean
---@field IsSpecialName boolean
---@field IsClass boolean
---@field IsNestedAssembly boolean
---@field IsNestedFamANDAssem boolean
---@field IsNestedFamily boolean
---@field IsNestedFamORAssem boolean
---@field IsNestedPrivate boolean
---@field IsNestedPublic boolean
---@field IsNotPublic boolean
---@field IsPublic boolean
---@field IsAutoLayout boolean
---@field IsExplicitLayout boolean
---@field IsLayoutSequential boolean
---@field IsAnsiClass boolean
---@field IsAutoClass boolean
---@field IsUnicodeClass boolean
---@field IsCOMObject boolean
---@field IsContextful boolean
---@field IsCollectible boolean
---@field IsEnum boolean
---@field IsMarshalByRef boolean
---@field IsPrimitive boolean
---@field IsValueType boolean
---@field IsSignatureType boolean
---@field IsSecurityCritical boolean
---@field IsSecuritySafeCritical boolean
---@field IsSecurityTransparent boolean
---@field StructLayoutAttribute NotExportType
---@field TypeInitializer NotExportType
---@field TypeHandle NotExportType
---@field GUID NotExportType
---@field BaseType System.Type
---@field IsInterface boolean
local System_Type = {}
---@param o System.Object
---@return NotExportType
function System_Type.GetTypeHandle(o) end
---@param args NotExportType
---@return NotExportType
function System_Type.GetTypeArray(args) end
---@param type System.Type
---@return NotExportEnum
function System_Type.GetTypeCode(type) end
---@overload fun(clsid : NotExportType) : System.Type
---@overload fun(clsid : NotExportType, throwOnError : boolean) : System.Type
---@overload fun(clsid : NotExportType, server : string) : System.Type
---@param clsid NotExportType
---@param server string
---@param throwOnError boolean
---@return System.Type
function System_Type.GetTypeFromCLSID(clsid, server, throwOnError) end
---@overload fun(progID : string) : System.Type
---@overload fun(progID : string, throwOnError : boolean) : System.Type
---@overload fun(progID : string, server : string) : System.Type
---@param progID string
---@param server string
---@param throwOnError boolean
---@return System.Type
function System_Type.GetTypeFromProgID(progID, server, throwOnError) end
---@param genericTypeDefinition System.Type
---@param typeArguments NotExportType
---@return System.Type
function System_Type.MakeGenericSignatureType(genericTypeDefinition, typeArguments) end
---@param position number
---@return System.Type
function System_Type.MakeGenericMethodParameter(position) end
---@param handle NotExportType
---@return System.Type
function System_Type.GetTypeFromHandle(handle) end
---@overload fun(typeName : string, throwOnError : boolean, ignoreCase : boolean) : System.Type
---@overload fun(typeName : string, throwOnError : boolean) : System.Type
---@overload fun(typeName : string) : System.Type
---@overload fun(typeName : string, assemblyResolver : NotExportType, typeResolver : NotExportType) : System.Type
---@overload fun(typeName : string, assemblyResolver : NotExportType, typeResolver : NotExportType, throwOnError : boolean) : System.Type
---@overload fun(typeName : string, assemblyResolver : NotExportType, typeResolver : NotExportType, throwOnError : boolean, ignoreCase : boolean) : System.Type
---@return System.Type
function System_Type:GetType() end
---@param typeName string
---@param throwIfNotFound boolean
---@param ignoreCase boolean
---@return System.Type
function System_Type.ReflectionOnlyGetType(typeName, throwIfNotFound, ignoreCase) end
---@param value System.Object
---@return boolean
function System_Type:IsEnumDefined(value) end
---@param value System.Object
---@return string
function System_Type:GetEnumName(value) end
---@return NotExportType
function System_Type:GetEnumNames() end
---@param filter NotExportType
---@param filterCriteria System.Object
---@return NotExportType
function System_Type:FindInterfaces(filter, filterCriteria) end
---@param memberType NotExportEnum
---@param bindingAttr NotExportEnum
---@param filter NotExportType
---@param filterCriteria System.Object
---@return NotExportType
function System_Type:FindMembers(memberType, bindingAttr, filter, filterCriteria) end
---@param c System.Type
---@return boolean
function System_Type:IsSubclassOf(c) end
---@param c System.Type
---@return boolean
function System_Type:IsAssignableFrom(c) end
---@return System.Type
function System_Type:GetElementType() end
---@return number
function System_Type:GetArrayRank() end
---@return System.Type
function System_Type:GetGenericTypeDefinition() end
---@return NotExportType
function System_Type:GetGenericArguments() end
---@return NotExportType
function System_Type:GetGenericParameterConstraints() end
---@overload fun(types : NotExportType) : NotExportType
---@overload fun(bindingAttr : NotExportEnum, binder : NotExportType, types : NotExportType, modifiers : NotExportType) : NotExportType
---@param bindingAttr NotExportEnum
---@param binder NotExportType
---@param callConvention NotExportEnum
---@param types NotExportType
---@param modifiers NotExportType
---@return NotExportType
function System_Type:GetConstructor(bindingAttr, binder, callConvention, types, modifiers) end
---@overload fun() : NotExportType
---@param bindingAttr NotExportEnum
---@return NotExportType
function System_Type:GetConstructors(bindingAttr) end
---@overload fun(name : string) : NotExportType
---@param name string
---@param bindingAttr NotExportEnum
---@return NotExportType
function System_Type:GetEvent(name, bindingAttr) end
---@overload fun() : NotExportType
---@param bindingAttr NotExportEnum
---@return NotExportType
function System_Type:GetEvents(bindingAttr) end
---@overload fun(name : string) : NotExportType
---@param name string
---@param bindingAttr NotExportEnum
---@return NotExportType
function System_Type:GetField(name, bindingAttr) end
---@overload fun() : NotExportType
---@param bindingAttr NotExportEnum
---@return NotExportType
function System_Type:GetFields(bindingAttr) end
---@overload fun(name : string) : NotExportType
---@overload fun(name : string, bindingAttr : NotExportEnum) : NotExportType
---@param name string
---@param type NotExportEnum
---@param bindingAttr NotExportEnum
---@return NotExportType
function System_Type:GetMember(name, type, bindingAttr) end
---@overload fun() : NotExportType
---@param bindingAttr NotExportEnum
---@return NotExportType
function System_Type:GetMembers(bindingAttr) end
---@overload fun(name : string) : NotExportType
---@overload fun(name : string, bindingAttr : NotExportEnum) : NotExportType
---@overload fun(name : string, types : NotExportType) : NotExportType
---@overload fun(name : string, types : NotExportType, modifiers : NotExportType) : NotExportType
---@overload fun(name : string, bindingAttr : NotExportEnum, binder : NotExportType, types : NotExportType, modifiers : NotExportType) : NotExportType
---@overload fun(name : string, bindingAttr : NotExportEnum, binder : NotExportType, callConvention : NotExportEnum, types : NotExportType, modifiers : NotExportType) : NotExportType
---@overload fun(name : string, genericParameterCount : number, types : NotExportType) : NotExportType
---@overload fun(name : string, genericParameterCount : number, types : NotExportType, modifiers : NotExportType) : NotExportType
---@overload fun(name : string, genericParameterCount : number, bindingAttr : NotExportEnum, binder : NotExportType, types : NotExportType, modifiers : NotExportType) : NotExportType
---@param name string
---@param genericParameterCount number
---@param bindingAttr NotExportEnum
---@param binder NotExportType
---@param callConvention NotExportEnum
---@param types NotExportType
---@param modifiers NotExportType
---@return NotExportType
function System_Type:GetMethod(name, genericParameterCount, bindingAttr, binder, callConvention, types, modifiers) end
---@overload fun() : NotExportType
---@param bindingAttr NotExportEnum
---@return NotExportType
function System_Type:GetMethods(bindingAttr) end
---@overload fun(name : string) : System.Type
---@param name string
---@param bindingAttr NotExportEnum
---@return System.Type
function System_Type:GetNestedType(name, bindingAttr) end
---@overload fun() : NotExportType
---@param bindingAttr NotExportEnum
---@return NotExportType
function System_Type:GetNestedTypes(bindingAttr) end
---@overload fun(name : string) : NotExportType
---@overload fun(name : string, bindingAttr : NotExportEnum) : NotExportType
---@overload fun(name : string, returnType : System.Type) : NotExportType
---@overload fun(name : string, types : NotExportType) : NotExportType
---@overload fun(name : string, returnType : System.Type, types : NotExportType) : NotExportType
---@overload fun(name : string, returnType : System.Type, types : NotExportType, modifiers : NotExportType) : NotExportType
---@param name string
---@param bindingAttr NotExportEnum
---@param binder NotExportType
---@param returnType System.Type
---@param types NotExportType
---@param modifiers NotExportType
---@return NotExportType
function System_Type:GetProperty(name, bindingAttr, binder, returnType, types, modifiers) end
---@overload fun() : NotExportType
---@param bindingAttr NotExportEnum
---@return NotExportType
function System_Type:GetProperties(bindingAttr) end
---@return NotExportType
function System_Type:GetDefaultMembers() end
---@overload fun(name : string, invokeAttr : NotExportEnum, binder : NotExportType, target : System.Object, args : NotExportType) : System.Object
---@overload fun(name : string, invokeAttr : NotExportEnum, binder : NotExportType, target : System.Object, args : NotExportType, culture : NotExportType) : System.Object
---@param name string
---@param invokeAttr NotExportEnum
---@param binder NotExportType
---@param target System.Object
---@param args NotExportType
---@param modifiers NotExportType
---@param culture NotExportType
---@param namedParameters NotExportType
---@return System.Object
function System_Type:InvokeMember(name, invokeAttr, binder, target, args, modifiers, culture, namedParameters) end
---@overload fun(name : string) : System.Type
---@param name string
---@param ignoreCase boolean
---@return System.Type
function System_Type:GetInterface(name, ignoreCase) end
---@return NotExportType
function System_Type:GetInterfaces() end
---@param interfaceType System.Type
---@return NotExportType
function System_Type:GetInterfaceMap(interfaceType) end
---@param o System.Object
---@return boolean
function System_Type:IsInstanceOfType(o) end
---@param other System.Type
---@return boolean
function System_Type:IsEquivalentTo(other) end
---@return System.Type
function System_Type:GetEnumUnderlyingType() end
---@return System.Array
function System_Type:GetEnumValues() end
---@overload fun() : System.Type
---@param rank number
---@return System.Type
function System_Type:MakeArrayType(rank) end
---@return System.Type
function System_Type:MakeByRefType() end
---@param typeArguments NotExportType
---@return System.Type
function System_Type:MakeGenericType(typeArguments) end
---@return System.Type
function System_Type:MakePointerType() end
---@return string
function System_Type:ToString() end
---@overload fun(o : System.Object) : boolean
---@param o System.Type
---@return boolean
function System_Type:Equals(o) end
---@return number
function System_Type:GetHashCode() end

---@class UnityEngine.Coroutine : UnityEngine.YieldInstruction
local UnityEngine_Coroutine = {}

