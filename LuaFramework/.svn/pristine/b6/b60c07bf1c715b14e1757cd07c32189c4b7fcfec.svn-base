local BankModel = BaseModel:New("BankModel")

--[[
    {
        type = 1  -- 1 小猪，2 小象 
        count = 2  -- 金额
        level = 3  --级别 
    }
]]
local BankInfoList = {}

local this = BankModel

--------------------------消息返回-----------------------------------
---
---

--获取到得银行信息
function BankModel.S2C_GetBankInfoList(code ,data)
    if(code == RET.RET_SUCCESS)then
        BankInfoList = {}
        for _,v in pairs(data.list) do 
            if not BankInfoList[v.type] then 
                BankInfoList[v.type].type = v
            end 
        end 
    end 
end

-- 服务器主动推送 银行购买信息
function  BankModel.S2C_UpdateBankInfoLsit(code ,data)
    if(code == RET.RET_SUCCESS)then
        if data.info and #data.info >0 then 
            if not BankInfoList[data.info.type] then 
                BankInfoList[data.info.type] = data.info
            end 
        end 
    end 
end


--------------------------消息请求------------------------------------
---
---
--请求银行信息
function BankModel.C2S_GetBankInfoList(type)
    type = type or 1  --默认小猪银行

  --  this.SendMessage(MSG_ID.MSG_MAIL_LIST,{page=page})
end

--取钱得协议(购买银行礼包)
function BankModel.C2S_BuyBankGift(type)
    --  this.SendMessage(MSG_ID.MSG_MAIL_LIST,{type=type})
end

---------------------------对外接口------------------------------------
---
---

---------------------------数据处理------------------------------------
---
---

----------------------------重载接口-------------------------------------------
---
---

this.MsgIdList = {

}

return this 