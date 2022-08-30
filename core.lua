-- By D4KiR

-- CONFIG
local iconsize = 18
-- CONFIG

local loaded = false

function RAPLCheckEntry(name)
	if RAPLTAB then
		if not RAPLTAB[name] then
			RAPLTAB[name] = {}
		end
	end
end

function RAPLUnitName(unit)
	if UnitExists(unit) then
		local name, realm = UnitName(unit)
		if realm and realm ~= "" then
			name = name .. "-" .. realm
		else
			name = name .. "-" .. GetRealmName()
		end
		return name
	else
		return ""
	end
end

function RAPLCalculateGRP(name)
	RAPLCheckEntry(name)

	local rating = 0
	local count = 0

	--[[if RAPLTAB[name].ratingown and RAPLTAB[name].ratingown > 0 then
		rating = rating + RAPLTAB[name].ratingown
		count = count + 1
	end]]
	
	if RAPLTAB and RAPLTAB[name].ratingscom then
		for i = 1, 4 do
			local sourcename = RAPLUnitName("PARTY" .. i)
			if sourcename then
				rat = RAPLTAB[name].ratingscom[sourcename]
				if rat and rat > 0 then
					rating = rating + rat
					count = count + 1
				end
			end
		end
	end

	if RAPLTAB then
		if count > 0 then
			RAPLTAB[name].ratinggrp = rating / count
			RAPLTAB[name].countgrp = count
		else
			RAPLTAB[name].ratinggrp = 0
			RAPLTAB[name].countgrp = 0
		end
	end
end

function RAPLCalculateCOM(name)
	RAPLCheckEntry(name)

	local rating = 0
	local count = 0

	--[[if RAPLTAB[name].ratingown and RAPLTAB[name].ratingown > 0 then
		rating = rating + RAPLTAB[name].ratingown
		count = count + 1
	end]]

	if RAPLTAB and RAPLTAB[name].ratingscom then
		for i, v in pairs(RAPLTAB[name].ratingscom) do
			if v and v > 0 then
				rating = rating + v
				count = count + 1
			end
		end
	end

	if RAPLTAB then
		if count > 0 then
			RAPLTAB[name].ratingcom = rating / count
			RAPLTAB[name].countcom = count
		else
			RAPLTAB[name].ratingcom = 0
			RAPLTAB[name].countcom = 0
		end
	end
end

function RAPLUpdateStars(unit, source)
	if UnitExists(unit) and UnitIsPlayer(unit) then
		RAPLFrame:Show()
		


		local name = RAPLUnitName(unit)
		RAPLCheckEntry(name)



		if ElvUF_Target then
			local left, bottom, width, height = ElvUF_Target:GetRect()
			RAPLFrame:SetParent( ElvUF_Target )
			if bottom < GetScreenHeight() / 2 then -- Lowerscreen
				RAPLFrame:ClearAllPoints()
				RAPLFrame:SetPoint("BOTTOM", ElvUF_Target, "TOP", 0, 60)
			else -- Upperscreen
				RAPLFrame:ClearAllPoints()
				RAPLFrame:SetPoint("TOP", ElvUF_Target, "BOTTOM", 0, -22)
			end
		elseif PitBull4_Frames_Ziel then
			local left, bottom, width, height = PitBull4_Frames_Ziel:GetRect()
			RAPLFrame:SetParent( PitBull4_Frames_Ziel )
			if bottom < GetScreenHeight() / 2 then -- Lowerscreen
				RAPLFrame:ClearAllPoints()
				RAPLFrame:SetPoint("BOTTOM", PitBull4_Frames_Ziel, "TOP", 0, 22)
			else -- Upperscreen
				RAPLFrame:ClearAllPoints()
				RAPLFrame:SetPoint("TOP", PitBull4_Frames_Ziel, "BOTTOM", 0, -52)
			end
		elseif TargetFrameTextureFrameName then
			local left, bottom, width, height = TargetFrame:GetRect()
			if bottom < GetScreenHeight() / 2 then -- Lowerscreen
				RAPLFrame:ClearAllPoints()
				RAPLFrame:SetPoint("BOTTOM", TargetFrameTextureFrameName, "TOP", 0, 12)
			else -- Upperscreen
				RAPLFrame:ClearAllPoints()
				RAPLFrame:SetPoint("TOP", TargetFrameTextureFrameName, "BOTTOM", 0, -126)
			end
		end
			


		if RAPLTAB[name].has then
			RAPLFrame.texture:SetVertexColor(0, 1, 0, 1)
		else
			RAPLFrame.texture:SetVertexColor(1, 0, 0, 0)
		end



		if RAPLTAB[name] then
			if RAPLTAB[name].comment then
				RAPLFrame.Comment:SetText( RAPLTAB[name].comment )
			else
				RAPLFrame.Comment:SetText( "" )
			end
		end



		for i = 1, 5 do
			local star = RAPLFrame.starsown[i]
			if RAPLTAB[name].ratingown and RAPLTAB[name].ratingown > 0 then
				if i <= RAPLTAB[name].ratingown then
					star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_full")
					star.texture:SetVertexColor(0, 1, 0)
				else
					star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
					star.texture:SetVertexColor(1, 0, 0)
				end
			else
				star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
				star.texture:SetVertexColor(0.75, 0.75, 0.75)
			end
		end
		if RAPLTAB[name].ratingown and RAPLTAB[name].ratingown > 0 then
			RAPLFrame.textratingown:SetText(string.format("%.1f", RAPLTAB[name].ratingown))
		else
			RAPLFrame.textratingown:SetText("")
		end



		if IsInGroup() then
			RAPLCalculateGRP(name)
			RAPLFrame.textheadergrp:SetText(string.sub(CHAT_MSG_PARTY, 1, 3) .. ".")
			for i = 1, 5 do
				local star = RAPLFrame.starsgrp[i]
				star:Show()

				if RAPLTAB[name].ratinggrp and RAPLTAB[name].ratinggrp > 0 then
					if i <= RAPLTAB[name].ratinggrp then
						star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_full")
						star.texture:SetVertexColor(0, 1, 0)
					else
						star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
						star.texture:SetVertexColor(1, 0, 0)
					end
				else
					star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
					star.texture:SetVertexColor(0.2, 0.2, 0.2)
				end
			end
			if RAPLTAB[name].ratinggrp and RAPLTAB[name].ratinggrp > 0 then
				RAPLFrame.textratinggrp:SetText(string.format("%.1f", RAPLTAB[name].ratinggrp))
			else
				RAPLFrame.textratinggrp:SetText("")
			end
			if RAPLTAB[name].countgrp then
				RAPLFrame.countgrp:Show()
				RAPLFrame.textcountgrp:SetText(RAPLTAB[name].countgrp)
			else
				RAPLFrame.countgrp:Hide()
				RAPLFrame.textcountgrp:SetText("")
			end
		else
			for i = 1, 5 do
				local star = RAPLFrame.starsgrp[i]
				star:Hide()
			end
			RAPLFrame.textheadergrp:SetText("")
			RAPLFrame.textratinggrp:SetText("")
			RAPLFrame.countgrp:Hide()
			RAPLFrame.textcountgrp:SetText("")
		end



		local y = 2
		if not IsInGroup() then
			y = 1
		end
		y = y + 1
		for i = 1, 5 do
			local star = RAPLFrame.starscom[i]
			star:SetPoint("TOPLEFT", RAPLFrame, "TOPLEFT", (i-1) * iconsize, -iconsize * y)
		end
		RAPLFrame.textheadercom:SetPoint("CENTER", RAPLFrame, "TOPLEFT", iconsize * 5.5, -iconsize * (y + 0.5))
		RAPLFrame.textratingcom:SetPoint("CENTER", RAPLFrame, "TOPLEFT", iconsize * 5.5, -iconsize * (y + 0.5))
		RAPLFrame.countcom:SetPoint("LEFT", RAPLFrame, "TOPLEFT", iconsize * 7, -iconsize * (y + 0.5))
		RAPLFrame.textcountcom:SetPoint("CENTER", RAPLFrame, "TOPLEFT", iconsize * 8.5, -iconsize * (y + 0.5))

		RAPLCalculateCOM(name)
		for i = 1, 5 do
			local star = RAPLFrame.starscom[i]
			star:Show()
			if RAPLTAB[name].ratingcom and RAPLTAB[name].ratingcom > 0 then
				if i <= RAPLTAB[name].ratingcom then
					star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_full")
					star.texture:SetVertexColor(0, 1, 0)
				else
					star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
					star.texture:SetVertexColor(1, 0, 0)
				end
			else
				star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
				star.texture:SetVertexColor(0.2, 0.2, 0.2)
			end
		end
		if RAPLTAB[name].ratingcom and RAPLTAB[name].ratingcom > 0 then
			RAPLFrame.textratingcom:SetText(string.format("%.1f", RAPLTAB[name].ratingcom))
		else
			RAPLFrame.textratingcom:SetText("")
		end
		if RAPLTAB[name].countcom and RAPLTAB[name].countcom > 0 then
			RAPLFrame.textheadercom:SetText(string.sub(CLUB_FINDER_COMMUNITY_TYPE, 1, 3) .. ".")
			RAPLFrame.countcom:Show()
			RAPLFrame.textcountcom:SetText(RAPLTAB[name].countcom)
		else
			for i = 1, 5 do
				local star = RAPLFrame.starscom[i]
				star:Hide()
			end
			RAPLFrame.textheadercom:SetText("")
			RAPLFrame.countcom:Hide()
			RAPLFrame.textcountcom:SetText("")
			y = y - 1
		end



		RAPLFrame:SetSize(iconsize * 5, iconsize * (y + 1))
	else
		RAPLFrame:Hide()
	end
end

function InitRatePlayer()
	if not RAPLTAB then
		RAPLTAB = {}
	end

	if not CLUB_FINDER_COMMUNITY_TYPE then
		CLUB_FINDER_COMMUNITY_TYPE = "Community"
	end

	RAPLFrame = CreateFrame("FRAME", "RatePlayer", TargetFrame)
	RAPLFrame:SetSize( iconsize * 5, iconsize * 4 )
	RAPLFrame:SetPoint("BOTTOM", TargetFrame, "TOP", 0, 0)

	if false then
		RAPLFrame.bg = RAPLFrame:CreateTexture("BACKGROUND")
		RAPLFrame.bg:SetAllPoints( RAPLFrame )
		RAPLFrame.bg:SetColorTexture( 1, 0, 0, 0.75 )
	end

	RAPLFrame.texture = RAPLFrame:CreateTexture("BACKGROUND")
	RAPLFrame.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\check_circle")
	RAPLFrame.texture:SetSize(iconsize, iconsize)
	RAPLFrame.texture:SetPoint("BOTTOM", RAPLFrame, "TOP", 0, 0)
	RAPLFrame.texture:SetVertexColor(1, 0, 0)



	RAPLFrame.Comment = CreateFrame("EditBox", nil, RAPLFrame, "InputBoxTemplate")
	RAPLFrame.Comment:SetPoint( "TOP", RAPLFrame, "TOP", 3, 0 )
	RAPLFrame.Comment:SetWidth( iconsize * 5 * 2 )
	RAPLFrame.Comment:SetHeight( iconsize )
	RAPLFrame.Comment:SetMovable( false )
	RAPLFrame.Comment:SetAutoFocus( false )
	RAPLFrame.Comment:SetMultiLine( false )
	RAPLFrame.Comment:SetMaxLetters( 200 )
	RAPLFrame.Comment:SetScript( "OnEnterPressed", function( self )
		self:ClearFocus()
	end )
	RAPLFrame.Comment.text = ""
	RAPLFrame.Comment:SetScript( "OnTextChanged", function( self )
		if loaded then
			local text = self:GetText()
			local name = RAPLUnitName( "TARGET" )
			if name then
				RAPLCheckEntry(name)
				if RAPLTAB[name] and RAPLTAB[name].comment ~= text and self.text ~= text then
					self.text = text
					RAPLTAB[name].comment = text
				end
			end
		end
	end )

	RAPLFrame.starsown = {}
	for i = 1, 5 do
		RAPLFrame.starsown[i] = CreateFrame("BUTTON", "STAR" .. i, RAPLFrame)

		local star = RAPLFrame.starsown[i]
		star.rating = i

		star:SetSize(iconsize, iconsize)
		star:SetPoint("TOPLEFT", RAPLFrame, "TOPLEFT", (i-1) * iconsize, -iconsize)

		star.texture = star:CreateTexture("BACKGROUND")
		star.texture:SetAllPoints(star)
		star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
		star.texture:SetVertexColor(1, 0, 0)

		star:SetScript("OnClick", function(self, ...)
			local name = RAPLUnitName("TARGET")
			if name then
				RAPLCheckEntry(name)
				if RAPLTAB[name].ratingown ~= self.rating then
					RAPLTAB[name].ratingown = self.rating
				else
					RAPLTAB[name].ratingown = 0
				end
				RAPLUpdateStars("TARGET", "SET RATING")
			end
		end)
	end

	RAPLFrame.textratingown = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textratingown:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textratingown:SetPoint("CENTER", RAPLFrame, "TOPLEFT", iconsize * 5.5, -iconsize * 1.5)
	RAPLFrame.textratingown:SetText(0)



	RAPLFrame.starsgrp = {}
	for i = 1, 5 do
		RAPLFrame.starsgrp[i] = CreateFrame("BUTTON", "STAR" .. i, RAPLFrame)

		local star = RAPLFrame.starsgrp[i]
		star.rating = i

		star:SetSize(iconsize, iconsize)
		star:SetPoint("TOPLEFT", RAPLFrame, "TOPLEFT", (i-1) * iconsize, -2 * iconsize)

		star.texture = star:CreateTexture("BACKGROUND")
		star.texture:SetAllPoints(star)
		star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
		star.texture:SetVertexColor(1, 0, 0)
	end

	RAPLFrame.textheadergrp = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textheadergrp:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textheadergrp:SetPoint("RIGHT", RAPLFrame, "TOPLEFT", -iconsize * 0.5, -iconsize * 2.5)
	RAPLFrame.textheadergrp:SetText(string.sub(CHAT_MSG_PARTY, 1, 3) .. ".")

	RAPLFrame.textratinggrp = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textratinggrp:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textratinggrp:SetPoint("CENTER", RAPLFrame, "TOPLEFT", iconsize * 5.5, -iconsize * 2.5)
	RAPLFrame.textratinggrp:SetText(0)

	RAPLFrame.countgrp = RAPLFrame:CreateTexture("BACKGROUND")
	RAPLFrame.countgrp:SetSize(iconsize, iconsize)
	RAPLFrame.countgrp:SetPoint("LEFT", RAPLFrame, "TOPLEFT", iconsize * 7, -iconsize * 2.5)
	RAPLFrame.countgrp:SetTexture("Interface\\AddOns\\RatePlayer\\media\\group")
	RAPLFrame.countgrp:SetVertexColor(0.2, 0.2, 1)

	RAPLFrame.textcountgrp = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textcountgrp:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textcountgrp:SetPoint("CENTER", RAPLFrame, "TOPLEFT", iconsize * 8.5, -iconsize * 2.5)
	RAPLFrame.textcountgrp:SetText(0)



	RAPLFrame.starscom = {}
	for i = 1, 5 do
		RAPLFrame.starscom[i] = CreateFrame("BUTTON", "STAR" .. i, RAPLFrame)

		local star = RAPLFrame.starscom[i]
		star.rating = i

		star:SetSize(iconsize, iconsize)
		star:SetPoint("TOPLEFT", RAPLFrame, "TOPLEFT", (i-1) * iconsize, -iconsize * 2)

		star.texture = star:CreateTexture("BACKGROUND")
		star.texture:SetAllPoints(star)
		star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
		star.texture:SetVertexColor(1, 0, 0)
	end

	RAPLFrame.textheadercom = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textheadercom:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textheadercom:SetPoint("RIGHT", RAPLFrame, "TOPLEFT", -iconsize * 0.5, -iconsize * 3.5)
	RAPLFrame.textheadercom:SetText(string.sub(CLUB_FINDER_COMMUNITY_TYPE, 1, 3) .. ".")

	RAPLFrame.textratingcom = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textratingcom:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textratingcom:SetPoint("CENTER", RAPLFrame, "TOPLEFT", iconsize * 5.5, -iconsize * 3.5)
	RAPLFrame.textratingcom:SetText(0)

	RAPLFrame.countcom = RAPLFrame:CreateTexture("BACKGROUND")
	RAPLFrame.countcom:SetSize(iconsize, iconsize)
	RAPLFrame.countcom:SetPoint("LEFT", RAPLFrame, "TOPLEFT", iconsize * 7, -iconsize * 3.5)
	RAPLFrame.countcom:SetTexture("Interface\\AddOns\\RatePlayer\\media\\group")
	RAPLFrame.countcom:SetVertexColor(0.2, 0.2, 1)

	RAPLFrame.textcountcom = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textcountcom:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textcountcom:SetPoint("CENTER", RAPLFrame, "TOPLEFT", iconsize * 8.5, -iconsize * 3.5)
	RAPLFrame.textcountcom:SetText(0)
end

function RAPLBuildRating(name, scut, isize)
	RAPLCheckEntry(name)

	local rating = ""
	if scut == "own" and RAPLTAB[name].ratingown then
		for i = 1, 5 do
			if i <= RAPLTAB[name].ratingown then
				rating = rating .. "|T".."Interface\\Addons\\RatePlayer\\media\\star_full_green:" .. isize .. ":" .. isize .. ":0:0|t"
			else
				rating = rating .. "|T".."Interface\\Addons\\RatePlayer\\media\\star_border_red:" .. isize .. ":" .. isize .. ":0:0|t"
			end
		end
	elseif scut == "grp" and RAPLTAB[name].ratinggrp then
		for i = 1, 5 do
			if i <= RAPLTAB[name].ratinggrp then
				rating = rating .. "|T".."Interface\\Addons\\RatePlayer\\media\\star_full_green:" .. isize .. ":" .. isize .. ":0:0|t"
			else
				rating = rating .. "|T".."Interface\\Addons\\RatePlayer\\media\\star_border_red:" .. isize .. ":" .. isize .. ":0:0|t"
			end
		end
		rating = rating .. " (" .. string.format("%.1f", RAPLTAB[name].ratinggrp) .. ") [" .. RAPLTAB[name].countgrp .. "]"
	elseif scut == "com" and RAPLTAB[name].ratingcom then
		for i = 1, 5 do
			if i <= RAPLTAB[name].ratingcom then
				rating = rating .. "|T".."Interface\\Addons\\RatePlayer\\media\\star_full_green:" .. isize .. ":" .. isize .. ":0:0|t"
			else
				rating = rating .. "|T".."Interface\\Addons\\RatePlayer\\media\\star_border_red:" .. isize .. ":" .. isize .. ":0:0|t"
			end
		end
		rating = rating .. " (" .. string.format("%.1f", RAPLTAB[name].ratingcom) .. ") [" .. RAPLTAB[name].countcom .. "]"
	end
	return rating
end

function UnitHasRating(name, scut)
	RAPLCheckEntry(name)

	local hasrating = false
	if RAPLTAB then
		if scut == "own" and RAPLTAB[name].ratingown and RAPLTAB[name].ratingown > 0 then
			hasrating = true
		elseif scut == "grp" and RAPLTAB[name].ratinggrp and RAPLTAB[name].ratinggrp > 0 then
			hasrating = true
		elseif scut == "com" and RAPLTAB[name].ratingcom and RAPLTAB[name].ratingcom > 0 then
			hasrating = true
		end
	end
	return hasrating
end

function UnitRating(name, scut, isize)
	RAPLCheckEntry(name)
	
	local rating = ""
	if scut == "own" and RAPLTAB[name].ratingown and RAPLTAB[name].ratingown > 0 then
		rating = string.format("%.1f", RAPLTAB[name].ratingown)
	elseif scut == "grp" and RAPLTAB[name].ratinggrp and RAPLTAB[name].ratinggrp > 0 then
		rating = string.format("%.1f", RAPLTAB[name].ratinggrp)
	elseif scut == "com" and RAPLTAB[name].ratingcom and RAPLTAB[name].ratingcom > 0 then
		rating = string.format("%.1f", RAPLTAB[name].ratingcom)
	end
	if rating ~= "" then
		rating = rating .. "|cFF00FF00|T".."Interface\\Addons\\RatePlayer\\media\\star_full_green:" .. isize .. ":" .. isize .. ":0:0|t"
	else
		rating = rating .. "|cFF333333N/A|T".."Interface\\Addons\\RatePlayer\\media\\star_border_grey:" .. isize .. ":" .. isize .. ":0:0|t"
	end
	rating = rating .. "|r"
	return rating
end

function RAPLAddRating(tt, name, unit)
	RAPLCheckEntry(name)

	if RAPLTAB[name].ratingown and RAPLTAB[name].ratingown > 0 then
        tt:AddLine(RATINGS_MENU .. " (" .. YOU .. ")" .. ": " .. RAPLBuildRating(name, "own", 16))
    end
	if IsInGroup() and RAPLTAB[name].ratinggrp and RAPLTAB[name].ratinggrp > 0 then
        tt:AddLine(RATINGS_MENU .. " (" .. CHAT_MSG_PARTY .. ")" .. ": " .. RAPLBuildRating(name, "grp", 16))
    end
	if RAPLTAB[name].ratingcom and RAPLTAB[name].ratingcom > 0 then
        tt:AddLine(RATINGS_MENU .. " (" .. CLUB_FINDER_COMMUNITY_TYPE .. ")" .. ": " .. RAPLBuildRating(name, "com", 16))
    end
end

-- MOUSEOVER TOOLTIP
GameTooltip:HookScript("OnTooltipSetUnit", function(self, ...)
	local name, unit, guid, realm = self:GetUnit()
	if unit and UnitIsPlayer(unit) then
        name = RAPLUnitName(unit)
        if name then
			RAPLAddRating(self, name, unit)
		end
	end
end)

-- LFG
if LFGListApplicationViewer_UpdateApplicantMember then
	hooksecurefunc("LFGListApplicationViewer_UpdateApplicantMember", function(member, id, index)
		local name, class, localizedClass, level, itemLevel, tank, healer, damage, assignedRole = C_LFGList.GetApplicantMemberInfo(id, index)
		
		RAPLCheckEntry(name)

		if name and UnitHasRating(name, "com") then
			member.Name:SetText(UnitRating(name, "com", 12) .. " " .. member.Name:GetText())
		end
	end)
end

-- NETWORKING PREFIX
local RAPLPREFIX = "D4RAPL"

local f = CreateFrame("FRAME")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UNIT_TARGET")
f:SetScript("OnEvent", function(self, event, unit, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if not loaded then
			loaded = true
			InitRatePlayer()
		end
	elseif loaded then
		if event == "UNIT_TARGET" and unit == "player" then
			if UnitExists("TARGET") and UnitIsPlayer("TARGET") and UnitFactionGroup("TARGET") == UnitFactionGroup("PLAYER") then
				local name = RAPLUnitName("TARGET")
				if name then
					RAPLCheckEntry(name)
					RAPLTAB[name].has = false

					isArena, isRegistered = IsActiveBattlefieldArena();

					if UnitInParty("TARGET") then
						if isArena or GetLFGMode and ( GetLFGMode( LE_LFG_CATEGORY_LFD ) or GetLFGMode( LE_LFG_CATEGORY_RF ) or GetLFGMode( LE_LFG_CATEGORY_SCENARIO ) or GetLFGMode( LE_LFG_CATEGORY_LFR ) ) then
							C_ChatInfo.SendAddonMessage(RAPLPREFIX, "ask:" .. RAPLUnitName("TARGET"), "INSTANCE_CHAT")
						else
							C_ChatInfo.SendAddonMessage(RAPLPREFIX, "ask:" .. RAPLUnitName("TARGET"), "PARTY")
						end
					elseif UnitInRaid("TARGET") then
						C_ChatInfo.SendAddonMessage(RAPLPREFIX, "ask:" .. RAPLUnitName("TARGET"), "RAID")
					elseif GetGuildInfo("PLAYER") then
						C_ChatInfo.SendAddonMessage(RAPLPREFIX, "ask:" .. RAPLUnitName("TARGET"), "GUILD")
					end

					if not UnitIsUnit("TARGET", "PLAYER") then
						if UnitIsConnected("TARGET") then
							C_ChatInfo.SendAddonMessage(RAPLPREFIX, "has:" .. RAPLUnitName("TARGET"), "WHISPER", RAPLUnitName("TARGET"))
						end
					else
						RAPLTAB[name].has = true
					end
				end
			end
			RAPLUpdateStars("TARGET", "UNIT_TARGET")
		end
	end
end)

local function OnEventNW(self, event, prefix, ...)
	if event == "CHAT_MSG_ADDON" then
		if prefix == RAPLPREFIX then
			local msg, channel, sourcename = ...

			if sourcename == RAPLUnitName("PLAYER") then -- IGNORE MESSAGE FROM SELF
				return
			end

			local pre, name, rating = strsplit(":", msg)
			if name then
				RAPLCheckEntry(name)
				if pre == "receive" then -- Receive, Get Rating from others
					if not RAPLTAB[name].ratingscom then
						RAPLTAB[name].ratingscom = {}
					end
					RAPLTAB[name].ratingscom[sourcename] = tonumber(rating)
					RAPLUpdateStars("TARGET", "RECEIVED RATING")
				elseif pre == "receivehas" then -- Receive, Get Has from others
					RAPLTAB[name].has = true
					RAPLUpdateStars("TARGET", "RECEIVED RATING")
				elseif pre == "ask" then -- Ask, Send Rating to others
					if RAPLTAB[name].ratingown then
						C_ChatInfo.SendAddonMessage(RAPLPREFIX, "receive:" .. name .. ":" .. RAPLTAB[name].ratingown, channel) -- Send Receive Message
					end
				elseif pre == "has" then -- Has, Send Has to others
					if name == RAPLUnitName("PLAYER") then
						C_ChatInfo.SendAddonMessage(RAPLPREFIX, "receivehas:" .. RAPLUnitName("PLAYER"), channel, sourcename) -- Send Receive Message
					end
				end
			else
				print("|cFFFF0000NAME FAILED", name, pre, channel, msg)
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		C_ChatInfo.RegisterAddonMessagePrefix(RAPLPREFIX)
	end
end
local nwf = CreateFrame("Frame")
nwf:RegisterEvent("CHAT_MSG_ADDON")
nwf:RegisterEvent("PLAYER_ENTERING_WORLD")
nwf:SetScript("OnEvent", OnEventNW)

