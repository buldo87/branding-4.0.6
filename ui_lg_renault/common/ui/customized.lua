sc_set_UIresolution()
sc_set_MAPresolution()

function sc_AB_Affichage_settings()
    sc_NextStateAnim(st_AB_Affichage_settings, "horz_scroll", 1, "")
end

createState("st_AB_Affichage_settings")
st_AB_Affichage_settings:useLayers(backgroundLayers, ui_AB_Affichage_settings, ui_List_Background)
function st_AB_Affichage_settings.init()
    txtTitle:SET(m_i18n("Display settings"))
end

function sc_AB_Alertes_settings()
    sc_NextStateAnim(st_AB_Alertes_settings, "horz_scroll", 1, "")
end

createState("st_AB_Alertes_settings")
st_AB_Alertes_settings:useLayers(backgroundLayers, ui_AB_Alertes_settings, ui_List_Background)
function st_AB_Alertes_settings.init()
    txtTitle:SET(m_i18n("Alerts settings"))
end

function sc_SB_DefineHomeWork()
    MODEL.poi.flat_search.list.index = MODEL["*"]._index()
    Monnomfav = MODEL["*"].name()
    MODEL.screen.msgbox.new.setup(3)
    MODEL.screen.msgbox.new.set_line(1, m_i18n("Associate this favourite (contact) with the button :"))
    MODEL.screen.msgbox.new.set_line_wstr(2, Monnomfav)
    MODEL.screen.msgbox.new.setup_button(1, "sc_SB_DefineHome", m_i18n("Home"), L"", "ico_m_hm.bmp#3")
    MODEL.screen.msgbox.new.setup_button(2, "sc_SB_DefineWork", m_i18n("Work"), L"", "ico_m_wrk.bmp#3")
    MODEL.screen.msgbox.new.setup_button(3, "", m_i18n("Cancel"), L"", "ico_cancel_mid.bmp#3")
    MODEL.screen.msgbox.create_new()
end

function sc_SB_DefineHome()
    MODEL.lua.SBHome = Monnomfav
end

function sc_SB_DefineWork()
    MODEL.lua.SBWork = Monnomfav
end

gContactsSearchStateisEnteredSHW = false
createState("st_ManageContactsSHW")
st_ManageContactsSHW:useLayers(commonLayers, ui_ManageContactsSHW, ui_List_Background)
function st_ManageContactsSHW.init()
    txtTitle:SET(m_i18n("Contacts"))
    g_OnPoiListItemClicked = sc_FlatSearch_OnPoiItemClicked
    isFromFavorite = false
end

function st_ManageContactsSHW.enter()
    gContactsSearchStateisEnteredSHW = true
    MODEL.lua.PoiListFilterString = L""
    MODEL.poi.flat_search.ext_name_filter.name = L""
    sc_SearchContacts()
end

function st_ManageContactsSHW.exit()
    gContactsSearchStateisEnteredSHW = false
    isFromFavorite = false
    obs_poi_filter_search_done:STOP()
end

function sc_map_local_menu_ContactsSHW()
    sc_NextStateAnim(st_ManageContactsSHW, "horz_scroll", 1, "")
end

createState("st_SelectHomeWork")
st_SelectHomeWork:useLayers(backgroundLayers, ui_SelectHomeWork, ui_List_Background)
function st_SelectHomeWork.init()
	txtTitle:SET(m_i18n("Select Home/Work"))
end

function sc_sb_SelectHomeWork()
    sc_NextStateAnim(st_SelectHomeWork, "horz_scroll", 1, "")
end

gFavoritesSearchStateisEnteredSHW = false
createState("st_ManageFavoriteSHW")
st_ManageFavoriteSHW:useLayers(commonLayers, ui_ManageFavoriteSHW, ui_List_Background)
function st_ManageFavoriteSHW.init()
    txtTitle:SET(m_i18n("Favourites"))
    g_OnPoiListItemClicked = sc_FlatSearch_OnPoiItemClicked
    isFromFavorite = false
end

function st_ManageFavoriteSHW.enter()
    gFavoritesSearchStateisEnteredSHW = true
    MODEL.lua.PoiListFilterString = L""
    MODEL.poi.flat_search.ext_name_filter.name = L""
    sc_SearchFavorites()
end

function st_ManageFavoriteSHW.exit()
    gFavoritesSearchStateisEnteredSHW = false
    isFromFavorite = false
    obs_poi_filter_search_done:STOP()
end

function sc_map_local_menu_favoriteSHW()
    sc_NextStateAnim(st_ManageFavoriteSHW, "horz_scroll", 1, "")
end

function sc_sb_Transparence_OnRelease()
    sc_NextStateAnim(st_transparence, "horz_scroll", 1, "")
end

createState("st_transparence")
st_transparence:useLayers(backgroundLayers, ui_transparence, ui_List_Background)
function st_transparence.init()
    txtTitle:SET(m_i18n("Transparency"))
end

createState("st_sb_navigationset")
st_sb_navigationset:useLayers(backgroundLayers, ui_sb_navigationset)
function st_sb_navigationset.init()
    txtTitle:SET(m_i18n("Navigation"))
end

function sc_sb_navigationset_OnRelease()
    sc_NextStateAnim(st_sb_navigationset, "horz_scroll", 1, "")
end

function sc_SearchHomeWork(mavar)
    local sbTmphomework = var.new()
    if mavar == 1 then
        sbTmphomework = sc_GetSysEntry("homework", "1", "MAISON")
    else
        sbTmphomework = sc_GetSysEntry("homework", "2", "TRAVAIL")
    end
    sc_DeleteRoute()
    MODEL.poi.copy_query("poi.struct_search", "poi.flat_search", 1)
    local flat_search = MODEL.poi.flat_search
    flat_search.sort = MODEL.poi.struct_search.sort()
    flat_search.reset()
    flat_search.area = 3000000
    flat_search.center = "gps"
    flat_search.distance_on_route = "disabled"
    flat_search.calculate_detour = "disabled"
    flat_search.search_root = MODEL.poi.find_group("@Favourites")
    inpSI_Text:VALUE(sbTmphomework)
    flat_search.name_filter = ui.inpSI_Text.VALUE()
    flat_search.execute()
    if flat_search.list.size() > 0 then
        for item, index in ModelList_iter(MODEL.poi.flat_search.list) do
            if item.name() == ui.inpSI_Text.VALUE() then
                MODEL.my.poi.select_poi(item.provider_id(), item.id())
                MODEL.map.cursor.position = MODEL.my.map.selected_item.position()
                MODEL.poi.resultpoi.clear()
                MODEL.poi.resultpoi.add_poi_by_id(item.provider_id(), item.id())
                isFromFavorite = true
                PoiSelected = true
                sc_EasyRouteTo()
                sc_GO_onrelease()
                return
            end
        end
    else
        sc_InfoMessageBox(m_i18n("Favourite not found."))
        return
    end
    sc_InfoMessageBox(m_i18n("Favourite not found."))
end

function sc_SearchHomeWork(mavar)
    local sbTmphomework = var.new()
    sc_DeleteRoute()
    MODEL.poi.copy_query("poi.struct_search", "poi.flat_search", 1)
    local flat_search = MODEL.poi.flat_search
    flat_search.sort = MODEL.poi.struct_search.sort()
    flat_search.reset()
    flat_search.area = 3000000
    flat_search.center = "gps"
    flat_search.distance_on_route = "disabled"
    flat_search.calculate_detour = "disabled"
    flat_search.search_root = MODEL.poi.find_group("@Favourites")
    if mavar == 1 then
        inpSI_Text:VALUE(MODEL.lua.SBHome())
    elseif mavar == 2 then
        inpSI_Text:VALUE(MODEL.lua.SBWork())
    elseif mavar == 3 then
        inpSI_Text:VALUE(L"POSCAR")
    end
    flat_search.name_filter = ui.inpSI_Text.VALUE()
    flat_search.execute()
    if flat_search.list.size() > 0 then
        for item, index in ModelList_iter(MODEL.poi.flat_search.list) do
            if item.name() == ui.inpSI_Text.VALUE() then
                MODEL.my.poi.select_poi(item.provider_id(), item.id())
                MODEL.map.cursor.position = MODEL.my.map.selected_item.position()
                MODEL.poi.resultpoi.clear()
                MODEL.poi.resultpoi.add_poi_by_id(item.provider_id(), item.id())
                isFromFavorite = true
                PoiSelected = true
                sc_EasyRouteTo()
                sc_GO_onrelease()
                return
            end
        end
    else
        flat_search.sort = MODEL.poi.struct_search.sort()
        flat_search.reset()
        flat_search.area = 3000000
        flat_search.center = "gps"
        flat_search.distance_on_route = "disabled"
        flat_search.calculate_detour = "disabled"
        flat_search.search_root = MODEL.poi.find_group("Contacts")
        flat_search.name_filter = ui.inpSI_Text.VALUE()
        flat_search.execute()
        if flat_search.list.size() > 0 then
            for item, index in ModelList_iter(MODEL.poi.flat_search.list) do
                if item.name() == ui.inpSI_Text.VALUE() then
                    MODEL.my.poi.select_poi(item.provider_id(), item.id())
                    MODEL.map.cursor.position = MODEL.my.map.selected_item.position()
                    MODEL.poi.resultpoi.clear()
                    MODEL.poi.resultpoi.add_poi_by_id(item.provider_id(), item.id())
                    isFromFavorite = true
                    PoiSelected = true
                    sc_EasyRouteTo()
                    sc_GO_onrelease()
                    return
                end
            end
        else
            sc_InfoMessageBox(m_i18n("Favourite not found."))
            return
        end
    end
    sc_InfoMessageBox(m_i18n("Favourite not found."))
end

function sc_SB_CreateTextHome()
    if MODEL.lua.SBHome() == L"" then
        return m_i18n("Home button : Not selected")
    else
        local text = translated_format(m_i18n("Home button : %s"), MODEL.lua.SBHome())
        return text
    end
end

function sc_SB_CreateTextWork()
    if MODEL.lua.SBWork() == L"" then
        return m_i18n("Work button : Not selected")
    else
        local text = translated_format(m_i18n("Work button : %s"), MODEL.lua.SBWork())
        return text
    end
end

function sc_Bd_Colors_settings()
    sc_NextStateAnim(st_Bd_Colors_settings, "horz_scroll", 1, "")
end

createState("st_Bd_Colors_settings")
st_Bd_Colors_settings:useLayers(backgroundLayers, ui_Bd_Colors_settings, ui_List_Background)
function st_Bd_Colors_settings.init()
    txtTitle:SET(m_i18n("Colors settings"))
end

function sc_Bd_NavigatButtonCockpit()
    sc_NextStateAnim(st_Bd_NavigatButtonCockpit, "horz_scroll", 1, "")
end

createState("st_Bd_NavigatButtonCockpit")
st_Bd_NavigatButtonCockpit:useLayers(backgroundLayers, ui_Bd_NavigatButtonCockpit, ui_List_Background)
function st_Bd_NavigatButtonCockpit.init()
    txtTitle:SET(m_i18n("The buttons off cockpit"))
end

function sc_Bd_set_Colors()
    txt_Bd_ArrowColor:TEXT(tostring(MODEL.lua.BdArrowColor()))
    txt_Bd_Arrow2Color:TEXT(tostring(MODEL.lua.BdArrow2Color()))
end

function sc_Bd_set_transparence()
    txt_Trans_BouttonArrow:TEXT(tostring(MODEL.lua.TransBouttonArrow()))
end

function sc_BdChangeColorSpeed()
    if not MODEL.screen.nightmode() then
        if MODEL.lua.SpeedInfoColorD() == 1 then
            MODEL.lua.SpeedInfoColorD = 2
        elseif MODEL.lua.SpeedInfoColorD() == 2 then
            MODEL.lua.SpeedInfoColorD = 3
        elseif MODEL.lua.SpeedInfoColorD() == 3 then
            MODEL.lua.SpeedInfoColorD = 4
        elseif MODEL.lua.SpeedInfoColorD() == 4 then
            MODEL.lua.SpeedInfoColorD = 5
        elseif MODEL.lua.SpeedInfoColorD() == 5 then
            MODEL.lua.SpeedInfoColorD = 6
        elseif MODEL.lua.SpeedInfoColorD() == 6 then
            MODEL.lua.SpeedInfoColorD = 1
        else
            MODEL.lua.SpeedInfoColorD = 1
        end
    elseif MODEL.screen.nightmode() then
        if MODEL.lua.SpeedInfoColorN() == 1 then
            MODEL.lua.SpeedInfoColorN = 2
        elseif MODEL.lua.SpeedInfoColorN() == 2 then
            MODEL.lua.SpeedInfoColorN = 3
        elseif MODEL.lua.SpeedInfoColorN() == 3 then
            MODEL.lua.SpeedInfoColorN = 4
        elseif MODEL.lua.SpeedInfoColorN() == 4 then
            MODEL.lua.SpeedInfoColorN = 5
        elseif MODEL.lua.SpeedInfoColorN() == 5 then
            MODEL.lua.SpeedInfoColorN = 6
        elseif MODEL.lua.SpeedInfoColorN() == 6 then
            MODEL.lua.SpeedInfoColorN = 1
        else
            MODEL.lua.SpeedInfoColorN = 1
        end
    end
end

function sc_Bd_ChangeColorDistNextMan()
    if not MODEL.screen.nightmode() then
        if MODEL.lua.BdcolorDistNextManD() == 1 then
            MODEL.lua.BdcolorDistNextManD = 2
        elseif MODEL.lua.BdcolorDistNextManD() == 2 then
            MODEL.lua.BdcolorDistNextManD = 3
        elseif MODEL.lua.BdcolorDistNextManD() == 3 then
            MODEL.lua.BdcolorDistNextManD = 4
        elseif MODEL.lua.BdcolorDistNextManD() == 4 then
            MODEL.lua.BdcolorDistNextManD = 5
        elseif MODEL.lua.BdcolorDistNextManD() == 5 then
            MODEL.lua.BdcolorDistNextManD = 6
        elseif MODEL.lua.BdcolorDistNextManD() == 6 then
            MODEL.lua.BdcolorDistNextManD = 1
        else
            MODEL.lua.BdcolorDistNextManD = 1
        end
    elseif MODEL.screen.nightmode() then
        if MODEL.lua.BdcolorDistNextManN() == 1 then
            MODEL.lua.BdcolorDistNextManN = 2
        elseif MODEL.lua.BdcolorDistNextManN() == 2 then
            MODEL.lua.BdcolorDistNextManN = 3
        elseif MODEL.lua.BdcolorDistNextManN() == 3 then
            MODEL.lua.BdcolorDistNextManN = 4
        elseif MODEL.lua.BdcolorDistNextManN() == 4 then
            MODEL.lua.BdcolorDistNextManN = 5
        elseif MODEL.lua.BdcolorDistNextManN() == 5 then
            MODEL.lua.BdcolorDistNextManN = 6
        elseif MODEL.lua.BdcolorDistNextManN() == 6 then
            MODEL.lua.BdcolorDistNextManN = 1
        else
            MODEL.lua.BdcolorDistNextManN = 1
        end
    end
end

function sc_Bd_ChangeColorDistSecondMan()
    if not MODEL.screen.nightmode() then
        if MODEL.lua.BdColorDistSecondManD() == 1 then
            MODEL.lua.BdColorDistSecondManD = 2
        elseif MODEL.lua.BdColorDistSecondManD() == 2 then
            MODEL.lua.BdColorDistSecondManD = 3
        elseif MODEL.lua.BdColorDistSecondManD() == 3 then
            MODEL.lua.BdColorDistSecondManD = 4
        elseif MODEL.lua.BdColorDistSecondManD() == 4 then
            MODEL.lua.BdColorDistSecondManD = 5
        elseif MODEL.lua.BdColorDistSecondManD() == 5 then
            MODEL.lua.BdColorDistSecondManD = 6
        elseif MODEL.lua.BdColorDistSecondManD() == 6 then
            MODEL.lua.BdColorDistSecondManD = 1
        else
            MODEL.lua.BdColorDistSecondManD = 1
        end
    elseif MODEL.screen.nightmode() then
        if MODEL.lua.BdColorDistSecondManN() == 1 then
            MODEL.lua.BdColorDistSecondManN = 2
        elseif MODEL.lua.BdColorDistSecondManN() == 2 then
            MODEL.lua.BdColorDistSecondManN = 3
        elseif MODEL.lua.BdColorDistSecondManN() == 3 then
            MODEL.lua.BdColorDistSecondManN = 4
        elseif MODEL.lua.BdColorDistSecondManN() == 4 then
            MODEL.lua.BdColorDistSecondManN = 5
        elseif MODEL.lua.BdColorDistSecondManN() == 5 then
            MODEL.lua.BdColorDistSecondManN = 6
        elseif MODEL.lua.BdColorDistSecondManN() == 6 then
            MODEL.lua.BdColorDistSecondManN = 1
        else
            MODEL.lua.BdColorDistSecondManN = 1
        end
    end
end

function sc_ButtonCockpitShow()
	ui_Bd_cockpitButton:SHOW()
	ui_Bd_ShowCockpitButton:HIDE()
	MODEL.lua.ButtonCockpitMove = true
	MODEL.lua.CockpitButtonHoms = true
	doDelayed(600, function()
		ui_Bd_cockpitButton:HIDE()
		ui_Bd_ShowCockpitButton:SHOW()
		MODEL.lua.ButtonCockpitMove = false
		MODEL.lua.CockpitButtonHoms = false
	end)
end

-- 2506 **********
function sc_wReadOutTurnRestSupported()
	local res = MODEL.regional.current_voice.is_tts()
	for i = 0, MODEL.ui.list_wTurnRestTypes.list.size() - 1 do
		if not MODEL.regional.is_it_voice_localizable(MODEL.ui.list_wTurnRestTypes[i].text()) then
			res = false
			break
		end
	end
	return res
end
-- 2525 **********
function sc_wsay_aboutturnrestriction()
	if ((MODEL.lua.wTurnRestriction() == 1 and not MODEL.navigation.has_route()) or MODEL.lua.wTurnRestriction() == 2) and (MODEL.navigation.is_in_simulation() or (MODEL.gps.connection_status() < 3 and not MODEL.lua.dragMode() and (MODEL.navigation.car_pos_valid() or MODEL.gps.valid() or MODEL.navigation.dead_reckoning()))) then
		sc_wsayspeech(translate_voice(MODEL.ui.list_wTurnRestTypes[MODEL.navigation.turn_restriction_icon()].text()),0)
	end
end

function sc_SettingWarningsTurnRestTest()
	sc_wsayspeech_test(translate_voice(MODEL.ui.list_wTurnRestTypes[0].text()))
end
-- 3767 **********
function sc_uturnonoff()
  if not MODEL.lua.vAvoidUTurn() then
    MODEL.route.allow_uturn = true
  else
    MODEL.route.allow_uturn = false
  end
end

-- 5085 **********
sc_BdJVPanel = function()
	sc_NextStateAnim(st_BdJVPanel, "horz_scroll", 1, "")
end

createState("st_BdJVPanel")
st_BdJVPanel:useLayers(backgroundLayers, ui_BdJVPanel)
st_BdJVPanel.init = function()
	txtTitle:SET(m_i18n("Junction view panel"))
end
