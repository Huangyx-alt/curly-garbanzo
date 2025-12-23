local CmdTestCoroutine = require "Framework.Command.Logic.CmdTestCoroutine"
local CmdTestFailed = require "Framework.Command.Logic.CmdTestFailed"
local CmdTestMath = require "Framework.Command.Logic.CmdTestMath"

local function Run()
    local commandSequence = CommandSequence.New()
    commandSequence:AddCommand(CmdTestCoroutine.New())
    commandSequence:AddCommand(CmdTestMath.New())
    --commandSequence:AddCommand(CmdTestFailed.New())
    commandSequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            local a = 1 + 4
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
    }))

    local parallel = CommandParallel.New()
    parallel:AddCommand(CmdTestCoroutine.New())
    --parallel:AddCommand(CmdTestFailed.New())
    parallel:AddCommand(CmdTestMath.New())
    parallel:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            local a = 1 + 4
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
    }))
    commandSequence:AddCommand(parallel)    
    
    local commandSequence2 = CommandSequenceNotInterrupted.New()
    commandSequence2:AddCommand(CmdTestCoroutine.New())
    commandSequence2:AddCommand(CmdTestFailed.New())
    commandSequence2:AddCommand(CmdTestMath.New())
    commandSequence2:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            local a = 1 + 4
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
    }))
    commandSequence:AddCommand(commandSequence2)
    
    commandSequence:AddDoneFunc(function()
        local a = 1
    end)
    commandSequence:Execute()
end

return {
    Run = Run
}
