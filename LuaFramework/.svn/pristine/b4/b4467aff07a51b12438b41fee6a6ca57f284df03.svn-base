
local VolcanoMissionMainStepItemView = BaseView:New("VolcanoMissionMainStepItemView")

local this = VolcanoMissionMainStepItemView

this.ViewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "up",
    "down",
    "right",
    "left",
    "role",
    "img_box",
    "btn_open",
    "img_tips",
    "npcrect",
    "bg",
    "FireDragonFBbgD02",
    "FireDragonFBbgD02glow",  
}

function VolcanoMissionMainStepItemView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function VolcanoMissionMainStepItemView:SetPassLevel(enable,isStartInit)
    fun.set_active(self.FireDragonFBbgD02,enable)
    if enable and not isStartInit then
        UISound.play("missiongem")
    end
end

function VolcanoMissionMainStepItemView:SetPassEffect(enable)
    fun.set_active(self.FireDragonFBbgD02glow,enable)
end

function VolcanoMissionMainStepItemView:Awake()
    self:on_init()
end

function VolcanoMissionMainStepItemView:OnEnable()
    
end

function VolcanoMissionMainStepItemView:OnDisable()
     
end

function VolcanoMissionMainStepItemView:on_btn_open_click()
    if(fun.get_active_self(self.img_box) or fun.get_active_self(self.img_tips))then 
        Facade.SendNotification(NotifyName.VolcanoMission.ShowBoxTips)
    end
end

function VolcanoMissionMainStepItemView:SetShowData(data)
     self.data = data 
end

function VolcanoMissionMainStepItemView:SetId(id)
    self.id = id 
end
 
function VolcanoMissionMainStepItemView:SetBoxVisiable(visiable)
    fun.set_active(self.img_box,visiable)
end

function VolcanoMissionMainStepItemView:SetPos(nextPos)
    fun.set_transform_pos(self.go.transform, nextPos.x,nextPos.y,nextPos.z,true)
end

function VolcanoMissionMainStepItemView:_close()
    self.__index.closeWithAnimation(self)
end


function VolcanoMissionMainStepItemView:SetVisiable(visiable)
    fun.set_active(self.go,visiable)
    if(visiable)then 
        fun.play_animator(self.bg,"idle")
    end
   
end


function VolcanoMissionMainStepItemView:PlayHide()
    fun.set_active(self.go,true)
    fun.play_animator(self.bg,"end") 

    fun.set_active(self.img_box,false )
    fun.set_active(self.img_tips,false ) 
end


function VolcanoMissionMainStepItemView:SetBoxShow(value)
    self.isShowBox = value


    fun.set_active(self.img_tips,value ) 
    fun.set_active(self.img_box,value )
    fun.set_active(self.btn_open,value )
end

function VolcanoMissionMainStepItemView:SetShowNpc(visable)
    
    if(visable)then 
        if(self.isShowBox or self.isShowBox==nil)then  
            fun.set_active(self.img_box,false )
            fun.set_active(self.img_tips,true )
        
        end
    else
        if(self.isShowBox)then  
            fun.set_active(self.img_box,true )
            fun.set_active(self.img_tips,false )
        end
    end

    -- if(visable and self.isShowBox)then 
    --     fun.set_active(self.img_tips,true ) 
    --     fun.set_active(self.img_box,false )
    -- elseif(visable and self.isShowBox==false)then 
    --     fun.set_active(self.img_tips,false ) 
    --     fun.set_active(self.img_box,false )
    -- elseif(visable==false and self.isShowBox==false)then 
    --     fun.set_active(self.img_tips,false )
    --     fun.set_active(self.img_box,false ) 
    -- elseif(visable==false and self.isShowBox==true)then 
    --     fun.set_active(self.img_tips,false ) 
    --     fun.set_active(self.img_box,true )
    -- end
end

function VolcanoMissionMainStepItemView:PlayBoxShake()
    if fun.get_active_self(self.img_box) then
        fun.play_animator(self.img_box,"dou")
    end
end

function VolcanoMissionMainStepItemView:StopBoxShake()
    if fun.get_active_self(self.img_box) then
        fun.play_animator(self.img_box,"idle")
    end
end

function VolcanoMissionMainStepItemView:ChangeBigBox()
    if fun.get_active_self(self.img_tips) then
        fun.set_active(self.img_box,true )
        fun.set_active(self.img_tips,false )
    end
end

return this