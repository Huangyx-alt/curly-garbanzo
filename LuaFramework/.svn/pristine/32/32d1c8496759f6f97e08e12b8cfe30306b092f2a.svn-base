require "State/Common/BaseCommonState"
require "State/Common/CommonOriginalState"
require "State/Common/CommonState1State"
require "State/Common/CommonState2State"
require "State/Common/CommonState3State"
require "State/Common/CommonState4State"
require "State/Common/CommonState5State"
require "State/Common/CommonState6State"
require "State/Common/CommonState7State"
require "State/Common/CommonState8State"

CommonState = {}

function CommonState.BuildFsm(owner,fsm_name,state_name)
    CommonState.DisposeFsm(owner)
    if state_name then
        owner._fsm = Fsm.CreateFsm(fsm_name,owner,{
            CommonOriginalState:New(state_name[1]),
            CommonState1State:New(state_name[2]),
            CommonState2State:New(state_name[3]),
            CommonState3State:New(state_name[4]),
            CommonState4State:New(state_name[5]),
            CommonState5State:New(state_name[6]),
            CommonState6State:New(state_name[7]),
            CommonState7State:New(state_name[8]),
            CommonState8State:New(state_name[9]),
        })
        owner._fsm:StartFsm(state_name[1])
    else
        owner._fsm = Fsm.CreateFsm(fsm_name,owner,{
            CommonOriginalState:New(),
            CommonState1State:New(),
            CommonState2State:New(),
            CommonState3State:New(),
            CommonState4State:New(),
            CommonState5State:New(),
            CommonState6State:New(),
            CommonState7State:New(),
            CommonState8State:New()
        })
        owner._fsm:StartFsm("CommonOriginalState")
    end
end

function CommonState.DisposeFsm(owner)
    if owner and owner._fsm then
        owner._fsm:Dispose()
        owner._fsm = nil
    end
end