local SCALE = 1.2

local GameTooltip = GameTooltip
local UIParent = UIParent
local IsDressableItem = IsDressableItem
local pairs = pairs


local DressUpModel = CreateFrame("DressUpModel",nil,UIParent)
DressUpModel:Hide()


function DressUpModel:UpdateAnchor()
    DressUpModel:ClearAllPoints()
    if (GameTooltip:GetRight() or 0) > UIParent:GetWidth()/2 then
        DressUpModel:SetPoint("BOTTOMRIGHT",GameTooltip,"BOTTOMLEFT")
    else
        DressUpModel:SetPoint("BOTTOMLEFT",GameTooltip,"BOTTOMRIGHT")
    end
end

function DressUpModel:OnUpdate()
    if not GameTooltip:IsShown() then
        self:Hide()
        return
    end
end

function DressUpModel:PLAYER_LOGIN()
    self:SetUnit("player")
end

function DressUpModel:OnEvent(event,...)
    self[event](self,...)
end

local function shoppingTooltipsVisibilityCheck()
    for _,tooltip in pairs(GameTooltip.shoppingTooltips) do
        if tooltip:IsShown() then
            return true
        end
    end
end

local function GameTooltip_ShowCompareItem_hk(self)
    if self ~= GameTooltip then
        return
    end

    if shoppingTooltipsVisibilityCheck() then
        DressUpModel:Hide()
    end
end


local function Tooltip_onTooltipSetItem(self)
    local _,itemLink = self:GetItem()
    if not itemLink or not IsDressableItem(itemLink) or shoppingTooltipsVisibilityCheck() then
        DressUpModel:Hide()
        return
    end

    if DressUpModel.currentItem ~= itemLink or not DressUpModel:IsShown() then
        DressUpModel:UpdateAnchor()
        DressUpModel:Show()
        DressUpModel:Undress()
        DressUpModel:TryOn(itemLink)

        DressUpModel.currentItem = itemLink
    end
end


DressUpModel:SetRotation(0.61)
DressUpModel:SetSize(120,240)
DressUpModel:SetScale(SCALE)
DressUpModel:SetFrameStrata(GameTooltip:GetFrameStrata())
DressUpModel:SetFrameLevel(GameTooltip:GetFrameLevel())
DressUpModel:SetBackdrop({
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    insets = {
        top = 5,
        bottom = 5,
        left = 5,
        right = 5,
    }
})
DressUpModel:SetBackdropColor(0,0,0,1)

DressUpModel:RegisterEvent("PLAYER_LOGIN")
DressUpModel:SetScript("OnEvent",DressUpModel.OnEvent)
DressUpModel:SetScript("OnUpdate",DressUpModel.OnUpdate)
GameTooltip:HookScript("OnTooltipSetItem",Tooltip_onTooltipSetItem)  
hooksecurefunc("GameTooltip_ShowCompareItem",GameTooltip_ShowCompareItem_hk)
