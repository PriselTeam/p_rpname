local fram = nil
local cTime = 0

function Prisel.RPName:FrameChangeName(isFirstTime)

    local frame = vgui.Create("DFrame")
    frame:SetSize(RX(580), RY(700))
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:SetAlpha(0)
    frame:AlphaTo(255, 0.5, 0)
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    fram = frame

    local min3 = false 
    local max32 = false
    local onlyLetters = false
    local respect = false

    function frame:Paint(w,h)

        draw.RoundedBox(8, 0, 0, w, h, Prisel.RPName.Configuration.Colors["background"])
        draw.RoundedBoxEx(8, 0, 0, w, RY(55), Prisel.RPName.Configuration.Colors["blue"], true, true, false, false)

        draw.SimpleText("CHANGER DE NOM", PLib:Font("Bold", 32), RX(20), RY(25), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        draw.SimpleText("PRÉNOM", PLib:Font("Bold", 26), RX(40), RY(100), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        draw.SimpleText("NOM", PLib:Font("Bold", 26), RX(40), RY(220), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)


        draw.SimpleText("CONDITIONS", PLib:Font("Bold", 26), RX(40), RY(350), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.RoundedBox(0, RX(40), RY(375), RX(240), RY(2), color_white)

        PLib:DrawCircle(RX(50), RY(410), 10, min3 and Prisel.RPName.Configuration.Colors["valid"] or Prisel.RPName.Configuration.Colors["invalid"], 32)
        draw.SimpleText("Votre nom doit contenir au minimum 3 caractères", PLib:Font("SemiBold", 20), RX(70), RY(410), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    
        PLib:DrawCircle(RX(50), RY(450), 10, max32 and Prisel.RPName.Configuration.Colors["valid"] or Prisel.RPName.Configuration.Colors["invalid"], 32)
        draw.SimpleText("Votre nom doit contenir au maximum 32 caractères", PLib:Font("SemiBold", 20), RX(70), RY(450), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        PLib:DrawCircle(RX(50), RY(490), 10, onlyLetters and Prisel.RPName.Configuration.Colors["valid"] or Prisel.RPName.Configuration.Colors["invalid"], 32)
        draw.SimpleText("Votre nom doit contenir uniquement des lettres", PLib:Font("SemiBold", 20), RX(70), RY(490), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        PLib:DrawCircle(RX(50), RY(530), 10, respect and Prisel.RPName.Configuration.Colors["valid"] or Prisel.RPName.Configuration.Colors["invalid"], 32)
        draw.SimpleText("Votre nom doit être respectueux", PLib:Font("SemiBold", 20), RX(70), RY(530), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    if not isFirstTime then

        local closeButton = vgui.Create("DButton", frame)
        closeButton:SetSize(RX(40), RY(40))
        closeButton:SetPos(frame:GetWide() - RX(50), RY(8))
        closeButton:SetText("X")
        closeButton:SetFont(PLib:Font("SemiBold", 24))
        closeButton:SetTextColor(color_white)

        function closeButton:Paint(w,h)
            if closeButton:IsHovered() then
                draw.RoundedBox(4, 0, 0, w, h, Prisel.RPName.Configuration.Colors["background"])
            else
                draw.RoundedBox(4, 0, 0, w, h, Prisel.RPName.Configuration.Colors["hoverBlue"])
            end
        end

        closeButton.DoClick = function()
            frame:Close()
        end

    end

    local firstNameEntry = vgui.Create("DTextEntry", frame)
    firstNameEntry:SetSize(RX(500), RY(50))
    firstNameEntry:SetPos(RX(40), RY(120))
    firstNameEntry:SetFont(PLib:Font("SemiBold", 22))
    firstNameEntry:SetDrawLanguageID(false)

    function firstNameEntry:Paint(w,h)
        draw.RoundedBox(6, 0, 0, w, h, Prisel.RPName.Configuration.Colors["blue"])
        self:DrawTextEntryText(color_white, color_white, color_white)
    end

    local lastNameEntry = vgui.Create("DTextEntry", frame)
    lastNameEntry:SetSize(RX(500), RY(50))
    lastNameEntry:SetPos(RX(40), RY(240))
    lastNameEntry:SetFont(PLib:Font("SemiBold", 22))
    lastNameEntry:SetDrawLanguageID(false)

    function lastNameEntry:Paint(w,h)
        draw.RoundedBox(6, 0, 0, w, h, Prisel.RPName.Configuration.Colors["blue"])
        self:DrawTextEntryText(color_white, color_white, color_white)
    end

    function firstNameEntry:OnChange()
        min3 = string.len(firstNameEntry:GetValue()) >= 3 and string.len(lastNameEntry:GetValue()) >= 3
        max32 = (string.len(firstNameEntry:GetValue()) + string.len(lastNameEntry:GetValue()) + 1) <= 32
        onlyLetters = string.match(firstNameEntry:GetValue(), "^[%a%sÀ-ÖØ-öø-ÿ]+$") and string.match(lastNameEntry:GetValue(), "^[%a%sÀ-ÖØ-öø-ÿ]+$")
        respect = Prisel.RPName:IsNameRespectful(firstNameEntry:GetValue()) and Prisel.RPName:IsNameRespectful(lastNameEntry:GetValue())
    end

    function lastNameEntry:OnChange()
        min3 = string.len(firstNameEntry:GetValue()) >= 3 and string.len(lastNameEntry:GetValue()) >= 3
        max32 = (string.len(firstNameEntry:GetValue()) + string.len(lastNameEntry:GetValue()) + 1) <= 32
        onlyLetters = string.match(firstNameEntry:GetValue(), "^[%a%sÀ-ÖØ-öø-ÿ]+$") and string.match(lastNameEntry:GetValue(), "^[%a%sÀ-ÖØ-öø-ÿ]+$")
        respect = Prisel.RPName:IsNameRespectful(firstNameEntry:GetValue()) and Prisel.RPName:IsNameRespectful(lastNameEntry:GetValue())
    end

    local submitButton = vgui.Create("DButton", frame)
    submitButton:SetSize(RX(400), RY(80))
    submitButton:SetPos(frame:GetWide()/2 - RX(200), RY(575))
    if isFirstTime then
        submitButton:SetText("VALIDER")
        submitButton:SetFont(PLib:Font("Bold", 32))
    else
        submitButton:SetText("Changer de nom pour " .. DarkRP.formatMoney(Prisel.RPName.Configuration.NamePrice))
        submitButton:SetFont(PLib:Font("Bold", 28))

    end
    submitButton:SetTextColor(color_white)

    function submitButton:Paint(w,h)
        if submitButton:IsHovered() then
            draw.RoundedBox(4, 0, 0, w, h, Prisel.RPName.Configuration.Colors["blue"])
        else
            draw.RoundedBox(4, 0, 0, w, h, Prisel.RPName.Configuration.Colors["hoverBlue"])
        end
    end

    function submitButton:DoClick()
            
            if cTime > CurTime() then return end
    
            cTime = CurTime() + 1
    
            if min3 and max32 and onlyLetters and respect then
                net.Start("Prisel::RPName::MainSV")
                    net.WriteUInt(1, 3)
                    net.WriteString(firstNameEntry:GetValue() .. " " .. lastNameEntry:GetValue())
                net.SendToServer()
            else
                if not min3 then
                    notification.AddLegacy("Votre prénom et nom doivent contenir au minimum 3 caractères", NOTIFY_ERROR, 5)
                elseif not max32 then
                    notification.AddLegacy("Votre prénom et nom doivent contenir au maximum 32 caractères", NOTIFY_ERROR, 5)
                elseif not onlyLetters then
                    notification.AddLegacy("Votre prénom et nom doivent contenir uniquement des lettres", NOTIFY_ERROR, 5)
                elseif not respect then
                    notification.AddLegacy("Votre prénom et nom ne sont pas respectueux", NOTIFY_ERROR, 5)
                end
            end
    end

end

function Prisel.RPName:CloseFrame()
    if not IsValid(fram) then return end
    fram:Close()
end

-- function Prisel.RPName:FrameChangeNameAdmin()

--     local frame = vgui.Create("DFrame")
--     frame:SetSize(RX(580), RY(700))
--     frame:Center()
--     frame:SetTitle("")
--     frame:MakePopup()
--     frame:SetAlpha(0)
--     frame:AlphaTo(255, 0.5, 0)
--     frame:SetDraggable(false)
--     frame:ShowCloseButton(false)

--     function frame:Paint(w,h)
--         draw.RoundedBox(8, 0, 0, w, h, Prisel.RPName.Configuration.Colors["background"])
--         draw.RoundedBoxEx(8, 0, 0, w, RY(55), Prisel.RPName.Configuration.Colors["hoverBlue"], true, true, false, false)

--         draw.SimpleText("Nom RP - Administration", PLib:Font("Bold", 32), RX(20), RY(25), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) 
--     end

--     local closeButton = vgui.Create("DButton", frame)
--     closeButton:SetSize(RX(40), RY(40))
--     closeButton:SetPos(frame:GetWide() - RX(50), RY(8))
--     closeButton:SetText("X")
--     closeButton:SetFont(PLib:Font("SemiBold", 24))
--     closeButton:SetTextColor(color_white)

--     function closeButton:Paint(w,h)
--         if closeButton:IsHovered() then
--             draw.RoundedBox(6, 0, 0, w, h, Prisel.RPName.Configuration.Colors["blue"])
--         else
--             draw.RoundedBox(6, 0, 0, w, h, Prisel.RPName.Configuration.Colors["background"])
--         end
--     end

--     closeButton.DoClick = function()
--         frame:Close()
--     end

--     -- local playerList = vgui.Create("DListView", frame)
--     -- playerList:SetSize(RX(500), RY(600))
--     -- playerList:SetPos(RX(40), RY(60))
--     -- playerList:SetMultiSelect(false)
--     -- playerList:AddColumn("Nom")
--     -- playerList:AddColumn("SteamID")
    
--     -- playerList.Paint = function(self, w, h)
--     --     draw.RoundedBox(8, 0, 0, w, h, Prisel.RPName.Configuration.Colors["hoverBlue"])
--     -- end

--     local vScrollPlayer = frame:Add("DScrollPanel")
--     vScrollPlayer:Dock(FILL)
--     vScrollPlayer:DockMargin(RX(20), RY(47.5), RX(20), RY(20))
--     vScrollPlayer.Paint = function(self, w, h)
--         draw.RoundedBox(8, 0, 0, w, h, Prisel.RPName.Configuration.Colors["hoverBlue"])
--     end

--     local vBar = vScrollPlayer:GetVBar()
    
--     vBar.Paint = function(self, w, h)
--         self:NoClipping(true)
--         draw.RoundedBox(8, 0, 0, w, h, Prisel.RPName.Configuration.Colors["blue"])
--     end

--     vBar.btnGrip.Paint = function(self, w, h)
--         self:NoClipping(true)
--         draw.RoundedBox(8, 0, 0, w, h, Prisel.RPName.Configuration.Colors["hoverBlue"])
--     end

--     vBar:SetHideButtons(true)


--     for k, v in ipairs(player.GetAll()) do
--         local vPlayerPanel = vScrollPlayer:Add("DPanel")
--         vPlayerPanel:Dock(TOP)
--         vPlayerPanel:DockMargin(RX(10), RY(10), RX(10), RY(10))
--         vPlayerPanel:SetTall(RY(50))
        
--         vPlayerPanel.Paint = function(self, w, h)
--             -- draw.RoundedBox(8, 0, 0, w, h, Prisel.RPName.Configuration.Colors["background"])
--             draw.RoundedBox(8, 0, 0, w, h, Prisel.RPName.Configuration.Colors["blue"])
--             draw.SimpleText(v:Nick(), PLib:Font("SemiBold", 24), RX(10), h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
--         end

--         local vPlayerButton = vgui.Create("DButton", vPlayerPanel)
--         vPlayerButton:Dock(RIGHT)
--         vPlayerButton:DockMargin(RX(20), RY(10), RX(10), RY(10))
--         vPlayerButton:SetWide(RX(100))
--         vPlayerButton:SetText("Changer")
--         vPlayerButton:SetFont(PLib:Font("SemiBold", 20))
--         vPlayerButton:SetTextColor(color_white)

--         function vPlayerButton:Paint(w,h)
--             if vPlayerButton:IsHovered() then
--                 draw.RoundedBox(8, 0, 0, w, h, Prisel.RPName.Configuration.Colors["background"])
--             else
--                 draw.RoundedBox(8, 0, 0, w, h, Prisel.RPName.Configuration.Colors["hoverBlue"])
--             end
--         end

--         vPlayerButton.DoClick = function()
--             net.Start("Prisel::RPName::MainSV")
--                 net.WriteUInt(2, 3)
--                 net.WriteEntity(v)
--             net.SendToServer()
--         end

--     end 
        

--     -- for k, v in pairs(player.GetAll()) do
--     --     playerList:AddLine(v:Nick(), v:SteamID())
--     -- end
   
--     -- playerList.OnRowRightClick = function( panel, line )
--     --     local menu = DermaMenu()
--     --     menu:AddOption("Envoyer vers le menu de changement de nom", function()
--     --         local ply = player.GetBySteamID(playerList:GetLine(line):GetValue(2))
--     --         if IsValid(ply) then
--     --             net.Start("Prisel::RPName::MainSV")
--     --                 net.WriteUInt(2, 3)
--     --                 net.WriteEntity(ply)
--     --             net.SendToServer()
--     --         end
--     --     end)

--     --     menu:AddOption("Changer son nom", function()
--     --         local ply = player.GetBySteamID(playerList:GetLine(line):GetValue(2))
--     --         if IsValid(ply) then
--     --             Derma_StringRequest("Changer le nom de " .. ply:Nick(), "Entrez le nouveau nom de " .. ply:Nick(), "", function(name)
--     --                 net.Start("Prisel::RPName::MainSV")
--     --                     net.WriteUInt(3, 3)
--     --                     net.WriteEntity(ply)
--     --                     net.WriteString(name)
--     --                 net.SendToServer()
--     --             end)
--     --         end
--     --     end)

--         -- menu:Open()
--     -- end
-- end

function Prisel.RPName:IsNameRespectful(name)
    if not isstring(name) then return end
    name = string.lower(name)

    for k, v in pairs(Prisel.RPName.Configuration.BlacklistedNames) do
        if string.find(name, k) then
            return false
        end
    end

    return true
end

-- hook.Add("OnPlayerChat", "Prisel::RPName::Chat", function(ply, text)
--     if not IsValid(ply) then return end
--     if not ply == LocalPlayer() then return end

--     text = string.lower(text)

--     print(text)

--     if text == "!nameadmin" then
--         if Prisel.RPName.Configuration.Staffs[LocalPlayer():GetUserGroup()] then
--             Prisel.RPName:FrameChangeNameAdmin()
--         end

--         return true
--     end

-- end)