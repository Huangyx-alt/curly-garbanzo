--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-03-30 12:03:03
]]


local VolcanoMissionDebug = {}
 
function VolcanoMissionDebug.GetDebugData()
    


    local oldData = {
        step = 0,
        reliveTimes = 0,
        rewardSteps = {},
        stepRewards = {
             [1] = {
                  step = 1,
                  reward = {
                       value = 500,
                       id = 2}
                  },
             [2] = {
                  step = 2,
                  reward = {
                       value = 20,
                       id = 1}
                  },
             [3] = {
                  step = 3,
                  reward = {
                       value = 500,
                       id = 2}
                  },
             [4] = {
                  step = 4,
                  reward = {
                       value = 500,
                       id = 2}
                  },
             [5] = {
                  step = 5,
                  reward = {
                       value = 500,
                       id = 2}
                  },
             [6] = {
                  step = 6,
                  reward = {
                       value = 20,
                       id = 1}
                  }
             },
        endTime = 1711929600,
        mapCount = 6,
        mapId = 1,
        totalRound = 4,
        resource = 0,
        round = 0,
        members = {
             [1] = {
                  step = 0,
                  uid = 1190,
                  gameProps = {}
                  },
             [2] = {
                  step = -1,
                  uid = 2670,
                  gameProps = {}
                  },
             [3] = {
                  step = -1,
                  uid = 3294,
                  gameProps = {}
                  },
             [4] = {
                  step = 0,
                  uid = 5894,
                  gameProps = {}
                  },
             [5] = {
                  step = -1,
                  uid = 7455,
                  gameProps = {}
                  },
             [6] = {
                  step = 0,
                  uid = 7663,
                  gameProps = {}
                  },
             [7] = {
                  step = 0,
                  uid = 8732,
                  gameProps = {}
                  },
             [8] = {
                  step = -1,
                  uid = 9321,
                  gameProps = {}
                  },
             [9] = {
                  step = -1,
                  uid = 10661,
                  gameProps = {}
                  },
             [10] = {
                  step = -1,
                  uid = 10958,
                  gameProps = {}
                  },
             [11] = {
                  step = -1,
                  uid = 11793,
                  gameProps = {}
                  },
             [12] = {
                  step = -1,
                  uid = 12802,
                  gameProps = {}
                  },
             [13] = {
                  step = 5,
                  uid = 13030,
                  gameProps = {}
                  },
             [14] = {
                  step = -1,
                  uid = 13324,
                  gameProps = {}
                  },
             [15] = {
                  step = 5,
                  uid = 13614,
                  gameProps = {}
                  },
             [16] = {
                  step = -1,
                  uid = 13693,
                  gameProps = {}
                  },
             [17] = {
                  step = 0,
                  uid = 15400,
                  gameProps = {}
                  },
             [18] = {
                  step = 0,
                  uid = 16424,
                  gameProps = {}
                  },
             [19] = {
                  step = -1,
                  uid = 17515,
                  gameProps = {}
                  },
             [20] = {
                  step = 0,
                  uid = 19259,
                  gameProps = {}
                  },
             [21] = {
                  step = -1,
                  uid = 19523,
                  gameProps = {}
                  },
             [22] = {
                  step = -1,
                  uid = 19754,
                  gameProps = {}
                  },
             [23] = {
                  step = -1,
                  uid = 22245,
                  gameProps = {}
                  },
             [24] = {
                  step = 0,
                  uid = 22523,
                  gameProps = {}
                  },
             [25] = {
                  step = -1,
                  uid = 22892,
                  gameProps = {}
                  },
             [26] = {
                  step = 0,
                  uid = 23061,
                  gameProps = {}
                  },
             [27] = {
                  step = 0,
                  uid = 24862,
                  gameProps = {}
                  },
             [28] = {
                  step = 5,
                  uid = 25069,
                  gameProps = {}
                  },
             [29] = {
                  step = -1,
                  uid = 26973,
                  gameProps = {}
                  },
             [30] = {
                  step = 0,
                  uid = 29226,
                  gameProps = {}
                  },
             [31] = {
                  step = -1,
                  uid = 30355,
                  gameProps = {}
                  },
             [32] = {
                  step = -1,
                  uid = 30384,
                  gameProps = {}
                  },
             [33] = {
                  step = -1,
                  uid = 31270,
                  gameProps = {}
                  },
             [34] = {
                  step = 0,
                  uid = 31580,
                  gameProps = {}
                  },
             [35] = {
                  step = 0,
                  uid = 33637,
                  gameProps = {}
                  },
             [36] = {
                  step = -1,
                  uid = 33789,
                  gameProps = {}
                  },
             [37] = {
                  step = -1,
                  uid = 33944,
                  gameProps = {}
                  },
             [38] = {
                  step = 0,
                  uid = 34492,
                  gameProps = {}
                  },
             [39] = {
                  step = -1,
                  uid = 34568,
                  gameProps = {}
                  },
             [40] = {
                  step = -1,
                  uid = 35801,
                  gameProps = {}
                  },
             [41] = {
                  step = -1,
                  uid = 35809,
                  gameProps = {}
                  },
             [42] = {
                  step = 0,
                  uid = 36836,
                  gameProps = {}
                  },
             [43] = {
                  step = 0,
                  uid = 37867,
                  gameProps = {}
                  },
             [44] = {
                  step = 5,
                  uid = 37920,
                  gameProps = {}
                  },
             [45] = {
                  step = -1,
                  uid = 39387,
                  gameProps = {}
                  },
             [46] = {
                  step = 0,
                  uid = 40766,
                  gameProps = {}
                  },
             [47] = {
                  step = 0,
                  uid = 42924,
                  gameProps = {}
                  },
             [48] = {
                  step = -1,
                  uid = 43303,
                  gameProps = {}
                  },
             [49] = {
                  step = 0,
                  uid = 44604,
                  gameProps = {}
                  }
             },
        groupId = 1,
        lastMapId = 1,
        lastStep = 4,
        stepCount = 5,
        totalResource = 16
        }

    local newData = {
        step = 0,
        reliveTimes = 0,
        rewardSteps = {},
        stepRewards = {
             [1] = {
                  step = 1,
                  reward = {
                       value = 500,
                       id = 2}
                  },
             [2] = {
                  step = 2,
                  reward = {
                       value = 20,
                       id = 1}
                  },
             [3] = {
                  step = 3,
                  reward = {
                       value = 500,
                       id = 2}
                  },
             [4] = {
                  step = 4,
                  reward = {
                       value = 20,
                       id = 1}
                  },
             [5] = {
                  step = 5,
                  reward = {
                       value = 20,
                       id = 1}
                  },
             [6] = {
                  step = 6,
                  reward = {
                       value = 20,
                       id = 1}
                  },
             [7] = {
                  step = 7,
                  reward = {
                       value = 500,
                       id = 2}
                  }
             },
        endTime = 1711929600,
        mapCount = 6,
        mapId = 2,
        totalRound = 3,
        resource = 0,
        round = 0,
        members = {
             [1] = {
                  step = 0,
                  uid = 938,
                  gameProps = {}
                  },
             [2] = {
                  step = 0,
                  uid = 2052,
                  gameProps = {}
                  },
             [3] = {
                  step = 0,
                  uid = 2176,
                  gameProps = {}
                  },
             [4] = {
                  step = 0,
                  uid = 4624,
                  gameProps = {}
                  },
             [5] = {
                  step = 0,
                  uid = 5672,
                  gameProps = {}
                  },
             [6] = {
                  step = 0,
                  uid = 5724,
                  gameProps = {}
                  },
             [7] = {
                  step = 0,
                  uid = 5911,
                  gameProps = {}
                  },
             [8] = {
                  step = 0,
                  uid = 6297,
                  gameProps = {}
                  },
             [9] = {
                  step = 0,
                  uid = 6583,
                  gameProps = {}
                  },
             [10] = {
                  step = 0,
                  uid = 6676,
                  gameProps = {}
                  },
             [11] = {
                  step = 0,
                  uid = 7109,
                  gameProps = {}
                  },
             [12] = {
                  step = 0,
                  uid = 8247,
                  gameProps = {}
                  },
             [13] = {
                  step = 0,
                  uid = 8830,
                  gameProps = {}
                  },
             [14] = {
                  step = 0,
                  uid = 12032,
                  gameProps = {}
                  },
             [15] = {
                  step = 0,
                  uid = 12168,
                  gameProps = {}
                  },
             [16] = {
                  step = 0,
                  uid = 14113,
                  gameProps = {}
                  },
             [17] = {
                  step = 0,
                  uid = 14751,
                  gameProps = {}
                  },
             [18] = {
                  step = 0,
                  uid = 14908,
                  gameProps = {}
                  },
             [19] = {
                  step = 0,
                  uid = 15564,
                  gameProps = {}
                  },
             [20] = {
                  step = 0,
                  uid = 17560,
                  gameProps = {}
                  },
             [21] = {
                  step = 0,
                  uid = 18070,
                  gameProps = {}
                  },
             [22] = {
                  step = 0,
                  uid = 18103,
                  gameProps = {}
                  },
             [23] = {
                  step = 0,
                  uid = 18268,
                  gameProps = {}
                  },
             [24] = {
                  step = 0,
                  uid = 18464,
                  gameProps = {}
                  },
             [25] = {
                  step = 0,
                  uid = 18477,
                  gameProps = {}
                  },
             [26] = {
                  step = 0,
                  uid = 19381,
                  gameProps = {}
                  },
             [27] = {
                  step = 0,
                  uid = 19438,
                  gameProps = {}
                  },
             [28] = {
                  step = 0,
                  uid = 20845,
                  gameProps = {}
                  },
             [29] = {
                  step = 0,
                  uid = 20913,
                  gameProps = {}
                  },
             [30] = {
                  step = 0,
                  uid = 21593,
                  gameProps = {}
                  },
             [31] = {
                  step = 0,
                  uid = 22196,
                  gameProps = {}
                  },
             [32] = {
                  step = 0,
                  uid = 23171,
                  gameProps = {}
                  },
             [33] = {
                  step = 0,
                  uid = 23221,
                  gameProps = {}
                  },
             [34] = {
                  step = 0,
                  uid = 24387,
                  gameProps = {}
                  },
             [35] = {
                  step = 0,
                  uid = 26028,
                  gameProps = {}
                  },
             [36] = {
                  step = 0,
                  uid = 26680,
                  gameProps = {}
                  },
             [37] = {
                  step = 0,
                  uid = 28196,
                  gameProps = {}
                  },
             [38] = {
                  step = 0,
                  uid = 28527,
                  gameProps = {}
                  },
             [39] = {
                  step = 0,
                  uid = 30033,
                  gameProps = {}
                  },
             [40] = {
                  step = 0,
                  uid = 30088,
                  gameProps = {}
                  },
             [41] = {
                  step = 0,
                  uid = 31712,
                  gameProps = {}
                  },
             [42] = {
                  step = 0,
                  uid = 32671,
                  gameProps = {}
                  },
             [43] = {
                  step = 0,
                  uid = 32880,
                  gameProps = {}
                  },
             [44] = {
                  step = 0,
                  uid = 33150,
                  gameProps = {}
                  },
             [45] = {
                  step = 0,
                  uid = 33297,
                  gameProps = {}
                  },
             [46] = {
                  step = 0,
                  uid = 35358,
                  gameProps = {}
                  },
             [47] = {
                  step = 0,
                  uid = 36103,
                  gameProps = {}
                  },
             [48] = {
                  step = 0,
                  uid = 37675,
                  gameProps = {}
                  },
             [49] = {
                  step = 0,
                  uid = 37687,
                  gameProps = {}
                  },
             [50] = {
                  step = 0,
                  uid = 37990,
                  gameProps = {}
                  },
             [51] = {
                  step = 0,
                  uid = 38783,
                  gameProps = {}
                  },
             [52] = {
                  step = 0,
                  uid = 38832,
                  gameProps = {}
                  },
             [53] = {
                  step = 0,
                  uid = 39754,
                  gameProps = {}
                  },
             [54] = {
                  step = 0,
                  uid = 40142,
                  gameProps = {}
                  },
             [55] = {
                  step = 0,
                  uid = 41850,
                  gameProps = {}
                  },
             [56] = {
                  step = 0,
                  uid = 42745,
                  gameProps = {}
                  },
             [57] = {
                  step = 0,
                  uid = 43037,
                  gameProps = {}
                  },
             [58] = {
                  step = 0,
                  uid = 43400,
                  gameProps = {}
                  },
             [59] = {
                  step = 0,
                  uid = 45293,
                  gameProps = {}
                  }
             },
        groupId = 1,
        lastMapId = 1,
        lastStep = 0,
        stepCount = 6,
        totalResource = 24
        }
    
       return oldData,newData
end




return VolcanoMissionDebug


