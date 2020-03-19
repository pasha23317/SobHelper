script_name('SobHelper')
script_author('Pasha')
script_description('Helper')
-- ������ ���������
require "lib.moonloader"
local keys = require "vkeys"
local tag = "{FF1493}[SobHelper] {FFD700}�������� ������������� �������"
local imgui = require "imgui"
local encoding = require "encoding"
local inicfg = require "inicfg"
local hook = require 'lib.samp.events'
local ImVec2 = imgui.ImVec2

main_window_state = imgui.ImBool(false) -- �������� �����
local show_imgui_example = imgui.ImBool(false) -- 2 �����
local ID = imgui.ImInt(5) -- ��������� ����
local rank = imgui.ImInt(0) -- ��������� ����
local Mouse = true
local selected = 0
local titles = {"���������", "���� 2"}
 -- ��������� ������ ����
encoding.default = "CP1251"
u8 = encoding.UTF8
local mainIni = inicfg.load({
config =
{
rank = 0,
Black = false,
Female = false
}
}, "SobHelper")
local rank = imgui.ImInt(mainIni.config.rank)
local Black = imgui.ImBool(mainIni.config.Black)
local Female = imgui.ImBool(mainIni.config.Female)

local status = inicfg.load(mainIni, 'SobHelper.ini')
if not doesFileExist('moonloader/config/SobHelper.ini') then inicfg.save(mainIni, 'SobHelper.ini') end

function main() -- ������� �������
	if not isSampAvailable or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	sampRegisterChatCommand("sob", cmd_imgui) -- ���� ������� sob
	imgui.Process = false
	sampAddChatMessage(tag, -1)
	while true do
		wait(0)
		if main_window_state.v == false then
			imgui.Process = false
		end
		if Black.v then
			BlackTheme()
			else
			BlueTheme()
		end
		if isKeyJustPressed(VK_MBUTTON) and (Mouse == true) then
			imgui.ShowCursor = false
			Mouse = false
			else
			if isKeyJustPressed(VK_MBUTTON) and (Mouse == false) then
				imgui.ShowCursor = true
				Mouse = true
			end
		end
		result, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if result then
			_, i = sampGetPlayerIdByCharHandle(ped)
			ID.v = i
		end
	end
end

function cmd_imgui(arg)
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end
function imgui.OnDrawFrame()
	  imgui.SetNextWindowSize(imgui.ImVec2(260, 305), imgui.Cond.FirstUseEver) -- ������ ����� ����
		imgui.SetNextWindowPos(imgui.ImVec2(150, 435 ), imgui.Cond.FirsUseEver, imgui.ImVec2(0.5, 0.5))
	  imgui.Begin(u8(selected == 0 and "�������������" or titles[selected]), main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.MenuBar) -- ����� ���� � ���������� 'My window'
		if selected == 0 then
			if imgui.BeginMenuBar() then
				if imgui.BeginMenu(u8("�������������")) then
					selected = 0
					imgui.EndMenu()
				end
				if imgui.BeginMenu(u8("���������")) then
					selected = 1
					imgui.EndMenu()
				end
				imgui.EndMenuBar()
				imgui.Text(u8("������� ID ������: "))
				imgui.SameLine()
				imgui.PushItemWidth(100)
				imgui.InputInt(u8"", ID)
				if imgui.Button(u8"������ �������������", imgui.ImVec2(-0.1, 0)) then
					nick = sampGetPlayerNickname(ID.v)
					sampAddChatMessage("�� ������ ������������� � �������: {7CFC00}" .. nick, -1)
					sampSendChat("������������, �� �� �������������?")
				end
				if imgui.Button(u8"��������� ���������", imgui.ImVec2(-0.1, 0)) then
					sobes = true
					_, idp = sampGetPlayerIdByCharHandle(PLAYER_PED)
					sampSendChat("������, �������� ���� ���������, ����� ���, �������, ���.�����")
					doki = string.format("/b �������� ������� �� � /me � /do, %s%s ", " /showpass " .. idp, " /showmc " .. idp);
					sampSendChat(doki)
				end
				if imgui.Button(u8"������� � ���", imgui.ImVec2(-0.1, 0)) then
					if rank.v < 8 then
						_, idp = sampGetPlayerIdByCharHandle(PLAYER_PED)
						sampSendChat("����������, �� ������ �������������!")
						sobes = false
						lua_thread.create(function()
							nick = sampGetPlayerNickname(ID.v)
							wait(1500)
							playergood = nick .. " ������(���) �������������"
							sampSendChat("/r " .. playergood)
							wait(1500)
							sampSendChat("�������� ������������ ��� ���������.")
						end)
					end
					if rank.v >= 8 then
						_, idp = sampGetPlayerIdByCharHandle(PLAYER_PED)
						sobes = false
						lua_thread.create(function()
							nick = sampGetPlayerNickname(ID.v)
							sampSendChat("�� ������� ������ �������������!")
							wait(1500)
							beidz = nick .. " �������� ��������"
							sampSendChat("/me " .. (Female.v and "��������" or "�������").. " ����� � ��������� " .. beidz)
							wait(1500)
							keyshcaf = "/do ����� �� �������� ��� ������� " .. ID.v .. " � ����"
							sampSendChat(keyshcaf)
							wait(1500)
							sampSendChat("/me " .. (Female.v and "��������" or "�������") .." �� �������� ��������")
							wait(1500)
							sampSendChat("/invite " .. ID.v)
						end)
					end
				end
				if imgui.Button(u8"����� ���", imgui.ImVec2(-0.1, 0)) then
					_, idp = sampGetPlayerIdByCharHandle(PLAYER_PED)
					sampSendChat("� ��������� �� ��� �� ���������, � ��� �������� � ��������")
					lua_thread.create(function()
					wait(1500)
					sampSendChat("/b ��� ����� ���")
					end)
					sobes = false
				end
				if imgui.CollapsingHeader(u8'���. �������') then
					if imgui.Button(u8"������ � ����� ���.�������", imgui.ImVec2(-0.1, 0)) then
						sampSendChat("������, ������ � ����� ��� �������������� �������.")
					end
					if imgui.Button(u8"������ ��?", imgui.ImVec2(-0.1, 0)) then
						sampSendChat("������ �� ������� ������ ���� ���?")
					end
					if imgui.Button(u8"��� ����� ���?", imgui.ImVec2(-0.1, 0)) then
						sampSendChat('����������� ������������ "���"')
					end
				end
			end
			elseif selected == 1 then
				if imgui.BeginMenuBar() then
					if imgui.BeginMenu(u8("�������������")) then
						selected = 0
						imgui.EndMenu()
					end
					if imgui.BeginMenu(u8("���������")) then
						selected = 1
						imgui.EndMenu()
					end
					imgui.EndMenuBar()
				if imgui.CollapsingHeader(u8'���������� � ���') then
					imgui.PushItemWidth(130)
					imgui.Combo(u8"���� ���������", rank, u8"������\0�������� ��������\0���������\0���������\0�������\0�������\0�������\0��������\0������� ��������\0��������\0\0")
				end
				imgui.Checkbox(u8"Ҹ���� ����",Black)
				imgui.Checkbox(u8"������� ���������",Female)
				if imgui.Button(u8"��������� ���������") then
					mainIni.config.rank = rank.v
					mainIni.config.Black = Black.v
					mainIni.config.Female = Female.v
					inicfg.save(mainIni, 'SobHelper.ini')
					sampAddChatMessage("{00FFFF}[SobHelper] {FFD700}��������� ���������!", -1)
				end
				imgui.SameLine()
				if imgui.Button(u8"�������������") then
						thisScript():reload()
				end
				imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8"���������� ��� ������ ��� :)").x) / 2);
				imgui.Text(u8("���������� ��� ������ ��� :)"))
			end
		end
	imgui.End()
end
function hook.onShowDialog(dialogId, style, title, button1, button2, text)
	if sobes == true then
		if title == "{BFBBBA}�������" then
			lvl = text:match ("��� � �����: %{FFD700%}(%d+)\n")
			zakonka = text:match("�����������������: %{.+%}(%d+)/%d+\n")
			lvl = tonumber(lvl)
			zakonka = tonumber(zakonka)
			if zakonka >= 35 and (lvl >= 3) then
				sampSendChat("/me " .. (Female.v and "�����" or "����") .. " ������� " .. nick)
				lua_thread.create(function()
				wait(1500)
				sampSendChat("/do ������� � �������.")
				wait(1500)
				sampSendChat("/me " .. (Female.v and "������" or "�����").. " ������� �������")
				end)

			end
			if lvl < 3 then
				sampSendChat("�� ���� ���������� � �����")
				lua_thread.create(function()
				wait(1500)
				sampSendChat("/b ������ 3 �������")
				wait(1500)
				end)
			end
			if zakonka < 35 then
				sampSendChat("�� ��������������� ���������.")
				lua_thread.create(function()
				wait(1500)
				sampSendChat("/b ����� 35 �����������������.")
				wait(1500)
				end)
			end
		end
		if title == "{BFBBBA}���. �����" then
			status = text:match ("������: (.+)\n")
			narko = text:match ("%{CEAD2A%}����������������: (%d+)")
			narko = tonumber(narko)
			if narko <= 20 then
				sampSendChat("/me " .. (Female.v and "�����" or "����") .. " ���.����� ".. nick)
				lua_thread.create(function()
				wait(1500)
				sampSendChat("/do ���.����� � �������")
				wait(1500)
				sampSendChat("/me " .. (Female.v and "������" or "�����").. " ���.����� �������")
				end)
			end
			if narko > 20 then
				sampSendChat("� ��� ����������������, ������� � ��������")
				lua_thread.create(function()
				wait(1500)
				sampSendChat("/b ����� ������ 20-�� ����������������")
				end)
			end
		end
	end
end
function BlueTheme()
	imgui.SwitchContext()
	 local style = imgui.GetStyle()
	 local colors = style.Colors
	 local clr = imgui.Col
	 local ImVec4 = imgui.ImVec4
	 style.WindowRounding = 2
	 style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	 style.ChildWindowRounding = 2.0
	 style.FrameRounding = 3
	 style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	 style.ScrollbarSize = 13.0
	 style.ScrollbarRounding = 0
	 style.GrabMinSize = 8.0
	 style.GrabRounding = 1.0
	 style.WindowPadding = imgui.ImVec2(4.0, 4.0)
	 style.FramePadding = imgui.ImVec2(3.5, 3.5)
	 style.ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
	 colors[clr.WindowBg]              = ImVec4(0.14, 0.12, 0.16, 1.00);
	 colors[clr.ChildWindowBg]         = ImVec4(0.30, 0.20, 0.39, 0.00);
	 colors[clr.PopupBg]               = ImVec4(0.05, 0.05, 0.10, 0.90);
	 colors[clr.Border]                = ImVec4(0.89, 0.85, 0.92, 0.30);
	 colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.00);
	 colors[clr.FrameBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
	 colors[clr.FrameBgHovered]        = ImVec4(0.41, 0.19, 0.63, 0.68);
	 colors[clr.FrameBgActive]         = ImVec4(0.41, 0.19, 0.63, 1.00);
	 colors[clr.TitleBg]               = ImVec4(0.41, 0.19, 0.63, 0.45);
	 colors[clr.TitleBgCollapsed]      = ImVec4(0.41, 0.19, 0.63, 0.35);
	 colors[clr.TitleBgActive]         = ImVec4(0.41, 0.19, 0.63, 0.78);
	 colors[clr.MenuBarBg]             = ImVec4(0.30, 0.20, 0.39, 0.57);
	 colors[clr.ScrollbarBg]           = ImVec4(0.30, 0.20, 0.39, 1.00);
	 colors[clr.ScrollbarGrab]         = ImVec4(0.41, 0.19, 0.63, 0.31);
	 colors[clr.ScrollbarGrabHovered]  = ImVec4(0.41, 0.19, 0.63, 0.78);
	 colors[clr.ScrollbarGrabActive]   = ImVec4(0.41, 0.19, 0.63, 1.00);
	 colors[clr.ComboBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
	 colors[clr.CheckMark]             = ImVec4(0.56, 0.61, 1.00, 1.00);
	 colors[clr.SliderGrab]            = ImVec4(0.41, 0.19, 0.63, 0.24);
	 colors[clr.SliderGrabActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	 colors[clr.Button]                = ImVec4(0.41, 0.19, 0.63, 0.44);
	 colors[clr.ButtonHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
	 colors[clr.ButtonActive]          = ImVec4(0.64, 0.33, 0.94, 1.00);
	 colors[clr.Header]                = ImVec4(0.41, 0.19, 0.63, 0.76);
	 colors[clr.HeaderHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
	 colors[clr.HeaderActive]          = ImVec4(0.41, 0.19, 0.63, 1.00);
	 colors[clr.ResizeGrip]            = ImVec4(0.41, 0.19, 0.63, 0.20);
	 colors[clr.ResizeGripHovered]     = ImVec4(0.41, 0.19, 0.63, 0.78);
	 colors[clr.ResizeGripActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	 colors[clr.CloseButton]           = ImVec4(1.00, 1.00, 1.00, 0.75);
	 colors[clr.CloseButtonHovered]    = ImVec4(0.88, 0.74, 1.00, 0.59);
	 colors[clr.CloseButtonActive]     = ImVec4(0.88, 0.85, 0.92, 1.00);
	 colors[clr.PlotLines]             = ImVec4(0.89, 0.85, 0.92, 0.63);
	 colors[clr.PlotLinesHovered]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	 colors[clr.PlotHistogram]         = ImVec4(0.89, 0.85, 0.92, 0.63);
	 colors[clr.PlotHistogramHovered]  = ImVec4(0.41, 0.19, 0.63, 1.00);
	 colors[clr.TextSelectedBg]        = ImVec4(0.41, 0.19, 0.63, 0.43);
	 colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35);
end
function BlackTheme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    style.WindowPadding = imgui.ImVec2(9, 5)
    style.WindowRounding = 10
    style.ChildWindowRounding = 10
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 6.0
    style.ItemSpacing = imgui.ImVec2(9.0, 3.0)
    style.ItemInnerSpacing = imgui.ImVec2(9.0, 3.0)
    style.IndentSpacing = 21
    style.ScrollbarSize = 6.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 17.0
    style.GrabRounding = 16.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)


    colors[clr.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
    colors[clr.TextDisabled]           = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.ChildWindowBg]          = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.PopupBg]                = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.Border]                 = ImVec4(0.82, 0.77, 0.78, 1.00)
    colors[clr.BorderShadow]           = ImVec4(0.35, 0.35, 0.35, 0.66)
    colors[clr.FrameBg]                = ImVec4(1.00, 1.00, 1.00, 0.28)
    colors[clr.FrameBgHovered]         = ImVec4(0.68, 0.68, 0.68, 0.67)
    colors[clr.FrameBgActive]          = ImVec4(0.79, 0.73, 0.73, 0.62)
    colors[clr.TitleBg]                = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.46, 0.46, 0.46, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.MenuBarBg]              = ImVec4(0.00, 0.00, 0.00, 0.80)
    colors[clr.ScrollbarBg]            = ImVec4(0.00, 0.00, 0.00, 0.60)
    colors[clr.ScrollbarGrab]          = ImVec4(1.00, 1.00, 1.00, 0.87)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(1.00, 1.00, 1.00, 0.79)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.80, 0.50, 0.50, 0.40)
    colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 0.99)
    colors[clr.CheckMark]              = ImVec4(0.99, 0.99, 0.99, 0.52)
    colors[clr.SliderGrab]             = ImVec4(1.00, 1.00, 1.00, 0.42)
    colors[clr.SliderGrabActive]       = ImVec4(0.76, 0.76, 0.76, 1.00)
    colors[clr.Button]                 = ImVec4(0.51, 0.51, 0.51, 0.60)
    colors[clr.ButtonHovered]          = ImVec4(0.68, 0.68, 0.68, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.67, 0.67, 0.67, 1.00)
    colors[clr.Header]                 = ImVec4(0.72, 0.72, 0.72, 0.54)
    colors[clr.HeaderHovered]          = ImVec4(0.92, 0.92, 0.95, 0.77)
    colors[clr.HeaderActive]           = ImVec4(0.82, 0.82, 0.82, 0.80)
    colors[clr.Separator]              = ImVec4(0.73, 0.73, 0.73, 1.00)
    colors[clr.SeparatorHovered]       = ImVec4(0.81, 0.81, 0.81, 1.00)
    colors[clr.SeparatorActive]        = ImVec4(0.74, 0.74, 0.74, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.80, 0.80, 0.80, 0.30)
    colors[clr.ResizeGripHovered]      = ImVec4(0.95, 0.95, 0.95, 0.60)
    colors[clr.ResizeGripActive]       = ImVec4(1.00, 1.00, 1.00, 0.90)
    colors[clr.CloseButton]            = ImVec4(0.45, 0.45, 0.45, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.70, 0.70, 0.90, 0.60)
    colors[clr.CloseButtonActive]      = ImVec4(0.70, 0.70, 0.70, 1.00)
    colors[clr.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(1.00, 1.00, 1.00, 0.35)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.88, 0.88, 0.88, 0.35)
end
