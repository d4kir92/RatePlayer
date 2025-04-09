-- By D4KiR
local _, RatePlayer = ...
RatePlayer:SetAddonOutput("RatePlayer", 135946)
-- CONFIG
local iconsize = 18
-- CONFIG
local loaded = false
function RatePlayer:CheckEntry(name)
	if RAPLTAB and not RAPLTAB[name] then
		RAPLTAB[name] = {}
	end
end

function RatePlayer:UnitName(unit)
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

function RatePlayer:CalculateGRP(name)
	RatePlayer:CheckEntry(name)
	local rating = 0
	local count = 0
	if RAPLTAB and RAPLTAB[name].ratingscom then
		for i = 1, 4 do
			local sourcename = RatePlayer:UnitName("PARTY" .. i)
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

function RatePlayer:CalculateCOM(name)
	RatePlayer:CheckEntry(name)
	local rating = 0
	local count = 0
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

function RatePlayer:UpdateStars(unit, source)
	if UnitExists(unit) and UnitIsPlayer(unit) then
		RAPLFrame:Show()
		local name = RatePlayer:UnitName(unit)
		RatePlayer:CheckEntry(name)
		if RAPLTAB[name].has then
			RAPLFrame.texture:SetVertexColor(0, 1, 0, 1)
		else
			RAPLFrame.texture:SetVertexColor(1, 0, 0, 0)
		end

		if RAPLTAB[name] then
			if RAPLTAB[name].comment then
				RAPLFrame.Comment:SetText(RAPLTAB[name].comment)
			else
				RAPLFrame.Comment:SetText("")
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
			RatePlayer:CalculateGRP(name)
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

		local y = 3
		if not IsInGroup() then
			y = 2
		end

		y = y + 1
		for i = 1, 5 do
			local star = RAPLFrame.starscom[i]
			star:SetPoint("TOPLEFT", RAPLFrame, "TOPLEFT", (i + 2.5) * iconsize, -iconsize * y)
		end

		RAPLFrame.textheadercom:SetPoint("RIGHT", RAPLFrame, "TOPLEFT", iconsize * 3.5, -iconsize * (y + 0.5))
		RAPLFrame.textratingcom:SetPoint("CENTER", RAPLFrame, "TOPLEFT", iconsize * 9, -iconsize * (y + 0.5))
		RAPLFrame.countcom:SetPoint("LEFT", RAPLFrame, "TOPLEFT", iconsize * 10, -iconsize * (y + 0.5))
		RAPLFrame.textcountcom:SetPoint("LEFT", RAPLFrame, "TOPLEFT", iconsize * 11.5, -iconsize * (y + 0.5))
		RatePlayer:CalculateCOM(name)
		for i = 1, 5 do
			local star = RAPLFrame.starscom[i]
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
			RAPLFrame.textcountcom:SetText(RAPLTAB[name].countcom)
		else
			RAPLFrame.textcountcom:SetText("0")
			y = y - 1
		end
	else
		RAPLFrame:Hide()
	end
end

function RatePlayer:Init()
	if not RAPLTAB then
		RAPLTAB = {}
	end

	if not CLUB_FINDER_COMMUNITY_TYPE then
		CLUB_FINDER_COMMUNITY_TYPE = "Community"
	end

	RatePlayer:SetVersion(135946, "1.1.79")
	RAPLFrame = CreateFrame("FRAME", "RatePlayer", UIParent)
	RAPLFrame:SetSize(iconsize * 12, iconsize * 5)
	RAPLFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, -100)
	RAPLFrame:SetClampedToScreen(true)
	RAPLFrame:SetMovable(true)
	RAPLFrame:EnableMouse(true)
	RAPLFrame:RegisterForDrag("LeftButton")
	RAPLFrame:SetScript("OnDragStart", RAPLFrame.StartMoving)
	RAPLFrame:SetScript(
		"OnDragStop",
		function()
			RAPLFrame:StopMovingOrSizing()
			local p1, p2, p3, p4, p5 = RAPLFrame:GetPoint()
			RAPLTAB["RAPLFrame.p1"] = p1
			RAPLTAB["RAPLFrame.p2"] = p2
			RAPLTAB["RAPLFrame.p3"] = p3
			RAPLTAB["RAPLFrame.p4"] = p4
			RAPLTAB["RAPLFrame.p5"] = p5
		end
	)

	if RAPLTAB["RAPLFrame.p1"] then
		local p1 = RAPLTAB["RAPLFrame.p1"]
		local p2 = RAPLTAB["RAPLFrame.p2"]
		local p3 = RAPLTAB["RAPLFrame.p3"]
		local p4 = RAPLTAB["RAPLFrame.p4"]
		local p5 = RAPLTAB["RAPLFrame.p5"]
		RAPLFrame:ClearAllPoints()
		RAPLFrame:SetPoint(p1, p2, p3, p4, p5)
	else
		RAPLFrame:ClearAllPoints()
		RAPLFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, -100)
	end

	if true then
		RAPLFrame.bg = RAPLFrame:CreateTexture("RAPLFRAME.bg", "BACKGROUND")
		RAPLFrame.bg:SetAllPoints(RAPLFrame)
		RAPLFrame.bg:SetColorTexture(0, 0, 0, 0.25)
	end

	RAPLFrame.texture = RAPLFrame:CreateTexture("RAPLFRAME.texture", "BACKGROUND")
	RAPLFrame.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\check_circle")
	RAPLFrame.texture:SetSize(iconsize, iconsize)
	RAPLFrame.texture:SetPoint("TOP", RAPLFrame, "TOP", 0, 0)
	RAPLFrame.texture:SetVertexColor(1, 0, 0)
	RAPLFrame.Comment = CreateFrame("EditBox", nil, RAPLFrame, "InputBoxTemplate")
	RAPLFrame.Comment:SetPoint("TOP", RAPLFrame, "TOP", 3, -iconsize)
	RAPLFrame.Comment:SetWidth(iconsize * 12 - 8)
	RAPLFrame.Comment:SetHeight(iconsize)
	RAPLFrame.Comment:SetMovable(false)
	RAPLFrame.Comment:SetAutoFocus(false)
	RAPLFrame.Comment:SetMultiLine(false)
	RAPLFrame.Comment:SetMaxLetters(200)
	RAPLFrame.Comment:SetScript(
		"OnEnterPressed",
		function(sel)
			sel:ClearFocus()
		end
	)

	RAPLFrame.Comment.text = ""
	RAPLFrame.Comment:SetScript(
		"OnTextChanged",
		function(sel)
			if loaded then
				local text = sel:GetText()
				local name = RatePlayer:UnitName("TARGET")
				if name then
					RatePlayer:CheckEntry(name)
					if RAPLTAB[name] and RAPLTAB[name].comment ~= text and sel.text ~= text then
						sel.text = text
						RAPLTAB[name].comment = text
					end
				end
			end
		end
	)

	RAPLFrame.starsown = {}
	for i = 1, 5 do
		RAPLFrame.starsown[i] = CreateFrame("BUTTON", "STAR" .. i, RAPLFrame)
		local star = RAPLFrame.starsown[i]
		star.rating = i
		star:SetSize(iconsize, iconsize)
		star:SetPoint("TOPLEFT", RAPLFrame, "TOPLEFT", (i + 2.5) * iconsize, -2 * iconsize)
		star.texture = star:CreateTexture("starown.texture", "BACKGROUND")
		star.texture:SetAllPoints(star)
		star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
		star.texture:SetVertexColor(1, 0, 0)
		star:SetScript(
			"OnClick",
			function(sel, ...)
				local name = RatePlayer:UnitName("TARGET")
				if name then
					RatePlayer:CheckEntry(name)
					if RAPLTAB[name].ratingown ~= sel.rating then
						RAPLTAB[name].ratingown = sel.rating
					else
						RAPLTAB[name].ratingown = 0
					end

					RatePlayer:UpdateStars("TARGET", "SET RATING")
				end
			end
		)
	end

	RAPLFrame.textratingown = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textratingown:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textratingown:SetPoint("CENTER", RAPLFrame, "TOPLEFT", iconsize * 9, -iconsize * 2.5)
	RAPLFrame.textratingown:SetText(0)
	RAPLFrame.starsgrp = {}
	for i = 1, 5 do
		RAPLFrame.starsgrp[i] = CreateFrame("BUTTON", "STAR" .. i, RAPLFrame)
		local star = RAPLFrame.starsgrp[i]
		star.rating = i
		star:SetSize(iconsize, iconsize)
		star:SetPoint("TOPLEFT", RAPLFrame, "TOPLEFT", (i + 2.5) * iconsize, -3 * iconsize)
		star.texture = star:CreateTexture("stargrp.texture", "BACKGROUND")
		star.texture:SetAllPoints(star)
		star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
		star.texture:SetVertexColor(1, 0, 0)
	end

	RAPLFrame.textheadergrp = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textheadergrp:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textheadergrp:SetPoint("RIGHT", RAPLFrame, "TOPLEFT", iconsize * 3.5, -iconsize * 3.5)
	RAPLFrame.textheadergrp:SetText(string.sub(CHAT_MSG_PARTY, 1, 3) .. ".")
	RAPLFrame.textratinggrp = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textratinggrp:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textratinggrp:SetPoint("CENTER", RAPLFrame, "TOPLEFT", iconsize * 9, -iconsize * 3.5)
	RAPLFrame.textratinggrp:SetText("")
	RAPLFrame.countgrp = RAPLFrame:CreateTexture("countgrp.texture", "BACKGROUND")
	RAPLFrame.countgrp:SetSize(iconsize, iconsize)
	RAPLFrame.countgrp:SetPoint("LEFT", RAPLFrame, "TOPLEFT", iconsize * 10, -iconsize * 3.5)
	RAPLFrame.countgrp:SetTexture("Interface\\AddOns\\RatePlayer\\media\\group")
	RAPLFrame.countgrp:SetVertexColor(0.2, 0.2, 1)
	RAPLFrame.textcountgrp = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textcountgrp:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textcountgrp:SetPoint("LEFT", RAPLFrame, "TOPLEFT", iconsize * 11.5, -iconsize * 3.5)
	RAPLFrame.textcountgrp:SetText("")
	RAPLFrame.starscom = {}
	for i = 1, 5 do
		RAPLFrame.starscom[i] = CreateFrame("BUTTON", "STAR" .. i, RAPLFrame)
		local star = RAPLFrame.starscom[i]
		star.rating = i
		star:SetSize(iconsize, iconsize)
		star:SetPoint("TOPLEFT", RAPLFrame, "TOPLEFT", (i + 2.5) * iconsize, -4 * iconsize)
		star.texture = star:CreateTexture("starcom.texture", "BACKGROUND")
		star.texture:SetAllPoints(star)
		star.texture:SetTexture("Interface\\AddOns\\RatePlayer\\media\\star_border")
		star.texture:SetVertexColor(1, 0, 0)
	end

	RAPLFrame.textheadercom = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textheadercom:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textheadercom:SetText(string.sub(CLUB_FINDER_COMMUNITY_TYPE, 1, 3) .. ".")
	RAPLFrame.textratingcom = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textratingcom:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textratingcom:SetText("")
	RAPLFrame.countcom = RAPLFrame:CreateTexture("countcom.texture", "BACKGROUND")
	RAPLFrame.countcom:SetSize(iconsize, iconsize)
	RAPLFrame.countcom:SetTexture("Interface\\AddOns\\RatePlayer\\media\\group")
	RAPLFrame.countcom:SetVertexColor(0.2, 0.2, 1)
	RAPLFrame.textcountcom = RAPLFrame:CreateFontString(nil, "ARTWORK")
	RAPLFrame.textcountcom:SetFont(STANDARD_TEXT_FONT, 10, "")
	RAPLFrame.textcountcom:SetText("")
	RAPLFrame:Hide()
	RatePlayer:InitRating()
end

function RatePlayer:BuildRating(name, scut, isize)
	RatePlayer:CheckEntry(name)
	local rating = ""
	if scut == "own" and RAPLTAB[name].ratingown then
		for i = 1, 5 do
			if i <= RAPLTAB[name].ratingown then
				rating = rating .. "|T" .. "Interface\\Addons\\RatePlayer\\media\\star_full_green:" .. isize .. ":" .. isize .. ":0:0|t"
			else
				rating = rating .. "|T" .. "Interface\\Addons\\RatePlayer\\media\\star_border_red:" .. isize .. ":" .. isize .. ":0:0|t"
			end
		end
	elseif scut == "grp" and RAPLTAB[name].ratinggrp then
		for i = 1, 5 do
			if i <= RAPLTAB[name].ratinggrp then
				rating = rating .. "|T" .. "Interface\\Addons\\RatePlayer\\media\\star_full_green:" .. isize .. ":" .. isize .. ":0:0|t"
			else
				rating = rating .. "|T" .. "Interface\\Addons\\RatePlayer\\media\\star_border_red:" .. isize .. ":" .. isize .. ":0:0|t"
			end
		end

		rating = rating .. " (" .. string.format("%.1f", RAPLTAB[name].ratinggrp) .. ") [" .. RAPLTAB[name].countgrp .. "]"
	elseif scut == "com" and RAPLTAB[name].ratingcom then
		for i = 1, 5 do
			if i <= RAPLTAB[name].ratingcom then
				rating = rating .. "|T" .. "Interface\\Addons\\RatePlayer\\media\\star_full_green:" .. isize .. ":" .. isize .. ":0:0|t"
			else
				rating = rating .. "|T" .. "Interface\\Addons\\RatePlayer\\media\\star_border_red:" .. isize .. ":" .. isize .. ":0:0|t"
			end
		end

		rating = rating .. " (" .. string.format("%.1f", RAPLTAB[name].ratingcom) .. ") [" .. RAPLTAB[name].countcom .. "]"
	end

	return rating
end

function RatePlayer:UnitHasRating(name, scut)
	RatePlayer:CheckEntry(name)
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

function RatePlayer:UnitRating(name, scut, isize)
	RatePlayer:CheckEntry(name)
	local rating = ""
	if scut == "own" and RAPLTAB[name].ratingown and RAPLTAB[name].ratingown > 0 then
		rating = string.format("%.1f", RAPLTAB[name].ratingown)
	elseif scut == "grp" and RAPLTAB[name].ratinggrp and RAPLTAB[name].ratinggrp > 0 then
		rating = string.format("%.1f", RAPLTAB[name].ratinggrp)
	elseif scut == "com" and RAPLTAB[name].ratingcom and RAPLTAB[name].ratingcom > 0 then
		rating = string.format("%.1f", RAPLTAB[name].ratingcom)
	end

	if rating ~= "" then
		rating = rating .. "|cFF00FF00|T" .. "Interface\\Addons\\RatePlayer\\media\\star_full_green:" .. isize .. ":" .. isize .. ":0:0|t"
	else
		rating = rating .. "|cFF333333N/A|T" .. "Interface\\Addons\\RatePlayer\\media\\star_border_grey:" .. isize .. ":" .. isize .. ":0:0|t"
	end

	rating = rating .. "|r"

	return rating
end

function RatePlayer:InitRating()
	RAPLTAB.UnitHasRating = RatePlayer.UnitHasRating
	RAPLTAB.UnitRating = RatePlayer.UnitRating
end

function RatePlayer:AddRating(tt, name, unit)
	RatePlayer:CheckEntry(name)
	if RAPLTAB[name].ratingown and RAPLTAB[name].ratingown > 0 then
		tt:AddLine(RATINGS_MENU .. " (" .. YOU .. ")" .. ": " .. RatePlayer:BuildRating(name, "own", 16))
	end

	if IsInGroup() and RAPLTAB[name].ratinggrp and RAPLTAB[name].ratinggrp > 0 then
		tt:AddLine(RATINGS_MENU .. " (" .. CHAT_MSG_PARTY .. ")" .. ": " .. RatePlayer:BuildRating(name, "grp", 16))
	end

	if RAPLTAB[name].ratingcom and RAPLTAB[name].ratingcom > 0 then
		tt:AddLine(RATINGS_MENU .. " (" .. CLUB_FINDER_COMMUNITY_TYPE .. ")" .. ": " .. RatePlayer:BuildRating(name, "com", 16))
	end
end

-- MOUSEOVER TOOLTIP
if GameTooltip.OnTooltipSetUnit then
	GameTooltip:HookScript(
		"OnTooltipSetUnit",
		function(self, ...)
			local name, unit, _, _ = self:GetUnit()
			if unit and UnitIsPlayer(unit) then
				name = RatePlayer:UnitName(unit)
				if name then
					RatePlayer:AddRating(self, name, unit)
				end
			end
		end
	)
end

-- LFG
if LFGListApplicationViewer_UpdateApplicantMember then
	hooksecurefunc(
		"LFGListApplicationViewer_UpdateApplicantMember",
		function(member, id, index)
			local name, _, _, _, _, _, _, _, _ = C_LFGList.GetApplicantMemberInfo(id, index)
			RatePlayer:CheckEntry(name)
			if name and RatePlayer:UnitHasRating(name, "com") then
				member.Name:SetText(RatePlayer:UnitRating(name, "com", 12) .. " " .. member.Name:GetText())
			end
		end
	)
end

-- NETWORKING PREFIX
local RAPLPREFIX = "D4RAPL"
local f = CreateFrame("FRAME")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UNIT_TARGET")
f:SetScript(
	"OnEvent",
	function(self, event, unit, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			if not loaded then
				loaded = true
				RatePlayer:Init()
			end
		elseif loaded then
			if event == "UNIT_TARGET" and unit == "player" then
				if UnitExists("TARGET") and UnitIsPlayer("TARGET") and UnitFactionGroup("TARGET") == UnitFactionGroup("PLAYER") then
					local name = RatePlayer:UnitName("TARGET")
					if name then
						RatePlayer:CheckEntry(name)
						RAPLTAB[name].has = false
						isArena, isRegistered = IsActiveBattlefieldArena()
						if UnitInParty("TARGET") then
							if isArena or GetLFGMode and (GetLFGMode(LE_LFG_CATEGORY_LFD) or GetLFGMode(LE_LFG_CATEGORY_RF) or GetLFGMode(LE_LFG_CATEGORY_SCENARIO) or GetLFGMode(LE_LFG_CATEGORY_LFR)) then
								C_ChatInfo.SendAddonMessage(RAPLPREFIX, "ask:" .. RatePlayer:UnitName("TARGET"), "INSTANCE_CHAT")
							else
								C_ChatInfo.SendAddonMessage(RAPLPREFIX, "ask:" .. RatePlayer:UnitName("TARGET"), "PARTY")
							end
						elseif UnitInRaid("TARGET") then
							C_ChatInfo.SendAddonMessage(RAPLPREFIX, "ask:" .. RatePlayer:UnitName("TARGET"), "RAID")
						elseif GetGuildInfo("PLAYER") then
							C_ChatInfo.SendAddonMessage(RAPLPREFIX, "ask:" .. RatePlayer:UnitName("TARGET"), "GUILD")
						end

						if not UnitIsUnit("TARGET", "PLAYER") then
							if UnitIsConnected("TARGET") then
								C_ChatInfo.SendAddonMessage(RAPLPREFIX, "has:" .. RatePlayer:UnitName("TARGET"), "WHISPER", RatePlayer:UnitName("TARGET"))
							end
						else
							RAPLTAB[name].has = true
						end
					end
				end

				RatePlayer:UpdateStars("TARGET", "UNIT_TARGET")
			end
		end
	end
)

local function OnEventNW(self, event, prefix, ...)
	if event == "CHAT_MSG_ADDON" then
		if prefix == RAPLPREFIX then
			local msg, channel, sourcename = ...
			if sourcename == RatePlayer:UnitName("PLAYER") then return end -- IGNORE MESSAGE FROM SELF
			local pre, name, rating = strsplit(":", msg)
			if name then
				RatePlayer:CheckEntry(name)
				-- Receive, Get Rating from others
				if pre == "receive" then
					if not RAPLTAB[name].ratingscom then
						RAPLTAB[name].ratingscom = {}
					end

					RAPLTAB[name].ratingscom[sourcename] = tonumber(rating)
					RatePlayer:UpdateStars("TARGET", "RECEIVED RATING")
				elseif pre == "receivehas" then
					-- Receive, Get Has from others
					RAPLTAB[name].has = true
					RatePlayer:UpdateStars("TARGET", "RECEIVED RATING")
				elseif pre == "ask" then
					-- Ask, Send Rating to others
					if RAPLTAB[name].ratingown then
						C_ChatInfo.SendAddonMessage(RAPLPREFIX, "receive:" .. name .. ":" .. RAPLTAB[name].ratingown, channel) -- Send Receive Message
					end
				elseif pre == "has" then
					-- Has, Send Has to others
					if name == RatePlayer:UnitName("PLAYER") then
						C_ChatInfo.SendAddonMessage(RAPLPREFIX, "receivehas:" .. RatePlayer:UnitName("PLAYER"), channel, sourcename) -- Send Receive Message
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
