local CollectRewardsView =  require "View/CollectRewardsView/CollectRewardsView"

local CollectRewardsEvaluateUsView = CollectRewardsView:New("CollectRewardsEvaluateUsView")
local this = CollectRewardsEvaluateUsView

local collect_cb = nil
function CollectRewardsEvaluateUsView:on_btn_collect_click()
    if collect_cb then
        collect_cb()
    end
end
function CollectRewardsEvaluateUsView:set_close(cb)
    collect_cb  =cb
end

return this
