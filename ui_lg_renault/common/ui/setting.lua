saved_vRouteType = 0
supportedHueList = {L"picto"}
createState("st_SettingsMenu")
st_SettingsMenu:useLayers(backgroundLayersNoFooter, ui_HorizontalMenu, ui_HorizontalFooter, ui_Home)
function st_SettingsMenu.init()
    ui.vHorizontalMenuFilter = "settings"
    ui.vNavigationMenuType = 2
    txtTitle:SET(m_i18n("Navigation"))
end

function st_SettingsMenu.exit()
    SAVESETTINGS()
end

function sc_SaveOriginalRouteParams()
    MODEL.ui.savedRouteParamListSett.clear()
    for item, index in ModelList_iter(MODEL.ui.routeParamListSett.list) do
        ui.savedRouteParamListSett:add({
            text = item.text(),
            isselected = MODEL[item.isselected()]()
        })
    end
end

function sc_CompareRouteParamsWithOriginal()
    local newParams = MODEL.ui.routeParamListSett.list
    for item, index in ModelList_iter(MODEL.ui.savedRouteParamListSett.list) do
        if item.text() ~= newParams[index].text() then
            ASSERT(false, "routeParamsChanged-nek true-nak kellene lennie!")
            routeParamsChanged = true
            return
        elseif item.isselected() ~= MODEL[newParams[index].isselected()]() then
            routeParamsChanged = true
        end
    end
end

createState("st_SettingRouteParam")
st_SettingRouteParam:useLayers(backgroundLayers, ui_SettingRouteParam, localMenuLayers_full)
function st_SettingRouteParam.enter()
    sc_SaveOriginalRouteParams()
    routeParamsChanged = false
    routeParamsRefreshNeeded = false
end

function st_SettingRouteParam.init()
    txtTitle:SET(m_i18n("Route Settings"))
    sc_SetCalcmethodText()
    sc_init_local_menu("ui.routeSettingsLocalMenu")
    MODEL.ui.lst_lmRouteParamsList.current_index = 0
    MODEL.ui.lst_lmRouteParamsList.current_page = 0
end

function st_SettingRouteParam.done()
    MODEL.route.saverouteparams()
    if routeParamsChanged then
        st_SettingRouteParam.sc_SaveParams()
    end
end

function st_SettingRouteParam.exit()
    if not routeParamsChanged then
        sc_CompareRouteParamsWithOriginal()
    end
    sc_ApplyRouteParamChanges(routeParamsChanged, routeParamsRefreshNeeded)
    routeParamsChanged = false
    routeParamsRefreshNeeded = false
    MODEL.route.list.navigated.settings.check_consistency_with_global_settings()
end

function sc_ResetParams_OnRelease()
    sc_close_local_menu()
    MODEL.screen.msgbox.new.setup(2)
    MODEL.screen.msgbox.new.set_line(1, m_i18n("Would you like to reset all route settings to their defaults?"))
    MODEL.screen.msgbox.new.setup_button(1, "sc_ResetAllRouteParams", m_i18n("Reset to Defaults"), "", "ico_done_mid.bmp#3")
    MODEL.screen.msgbox.new.setup_button(2, "", m_i18n("Cancel"), "", "ico_cancel_mid.bmp#3")
    MODEL.screen.msgbox.create_new()
end

function sc_ResetAllRouteParams()
    MODEL.route.list.navigated.off_road = false
    PERSISTENT.route[0].route_type = L"FAST"
    PERSISTENT.route[0].allow_unpaved = false
    PERSISTENT.route[0].allow_highway = true
    PERSISTENT.route[0].allow_ferry = true
    PERSISTENT.route[0].allow_toll = true
    PERSISTENT.route[0].allow_charge = true
    PERSISTENT.route[0].allow_carpool = false
    PERSISTENT.route[0].allow_crossborder = true
    st_SettingRouteParam.sc_LoadParams()
end

function st_SettingRouteParam.sc_LoadParams()
    MODEL.route.route_type = PERSISTENT.route[0].route_type()
    MODEL.route.allow_unpaved = PERSISTENT.route[0].allow_unpaved()
    MODEL.route.allow_highway = PERSISTENT.route[0].allow_highway()
    MODEL.route.allow_ferry = PERSISTENT.route[0].allow_ferry()
    MODEL.route.allow_toll = PERSISTENT.route[0].allow_toll()
    MODEL.route.allow_charge = PERSISTENT.route[0].allow_charge()
    MODEL.route.allow_carpool = PERSISTENT.route[0].allow_carpool()
    MODEL.route.allow_crossborder = PERSISTENT.route[0].allow_crossborder()
    routeParamsChanged = true
    sc_SetCalcmethodText()
end

function st_SettingRouteParam.sc_SaveParams()
    PERSISTENT.route[0].route_type = MODEL.route.route_type()
    PERSISTENT.route[0].allow_unpaved = MODEL.route.allow_unpaved()
    PERSISTENT.route[0].allow_highway = MODEL.route.allow_highway()
    PERSISTENT.route[0].allow_ferry = MODEL.route.allow_ferry()
    PERSISTENT.route[0].allow_toll = MODEL.route.allow_toll()
    PERSISTENT.route[0].allow_charge = MODEL.route.allow_charge()
    PERSISTENT.route[0].allow_carpool = MODEL.route.allow_carpool()
    PERSISTENT.route[0].allow_crossborder = MODEL.route.allow_crossborder()
end

function sc_btnSVM_MapScreen_OnRelease()
    sc_NextStateAnim(st_MapSettings, "horz_scroll", 1, "")
end

function sc_btnSVM_VisualGuidance_OnRelease()
    sc_NextStateAnim(st_VisualGuidanceSettings, "horz_scroll", 1, "")
end

function sc_CheckHueShiftSupported(FileName)
    local Supported = false
    for index, value in ipairs(supportedHueList) do
        if wstring.find(FileName, value, 1, false) ~= nil then
            Supported = true
            break
        end
    end
    return Supported
end

function sc_SetHueShiftColor()
    if sc_CheckHueShiftSupported(MODEL.WSTR.screen.theme.list.current.filename()) then
        MODEL.lua.iconhue_supported = true
    else
        MODEL.lua.iconhue_supported = false
    end
    MODEL.lua.iconhue = 0
end

function sc_SelectPrevTheme()
    local currtheme = MODEL.screen.theme.list.index()
    if currtheme == 0 then
        currtheme = MODEL.screen.theme.list.size() - 1
    else
        currtheme = currtheme - 1
    end
    MODEL.screen.theme.change_theme(MODEL.screen.theme.list[currtheme].filename(), false)
end

function sc_SelectNextTheme()
    local currtheme = MODEL.screen.theme.list.index()
    if currtheme == MODEL.screen.theme.list.size() - 1 then
        currtheme = 0
    else
        currtheme = currtheme + 1
    end
    MODEL.screen.theme.change_theme(MODEL.screen.theme.list[currtheme].filename(), false)
end

createState("st_SettingSound")
st_SettingSound:useLayers(backgroundLayers, ui_SettingSound)
function st_SettingSound.init()
    txtTitle:SET(m_i18n("Warnings"))
    MODEL.lua.SpeedcamEnabled = MODEL.warning.speedcam_warning()
end

function sc_btnSR_Voice_OnRelease()
    sc_NextStateAnim(st_SettingRegionalVoice, "horz_scroll", 1, "")
end

function sc_DynamicVolumeTypeChanged()
    PLAYSOUND("!button")
    if MODEL.sound.dynamic_volume_type() == 1 then
        MODEL.sound.dynamic_volume_autocalc_maxvoicespeed()
        MODEL.sound.dynamic_volume_os_volume_max = 255
        MODEL.sound.dynamic_volume_voice_volume_max = 63
    end
end

function sc_lmEasyMenuRoutingMethod_onrelease()
    PERSISTENT.route[0].route_type = MODEL.route.route_type()
    sc_SetCalcmethodText()
    sc_RoutingMethodChanged()
end

function sc_RoutingMethodChanged()
    local bRouteTypeChanged = saved_vRouteType ~= MODEL.route.route_type()
    if bRouteTypeChanged then
        if gNeedRouteParamRecalc then
            sc_ApplyRouteParamChanges(bRouteTypeChanged, false)
        else
            routeParamsChanged = routeParamsChanged or bRouteTypeChanged
        end
        saved_vRouteType = nil
    end
end

function sc_CheckUnitsWizardDone()
    if not sc_CheckVoiceUnitCompatibility() then
        sc_CheckUnitsWizard(sc_back, sc_SetUnitWizardBack_Event)
        Back:prevent_default()
        Back:unregister(sc_CheckUnitsWizardDone)
    end
end

function sc_SetUnitWizardBack_Event()
    Back:register(sc_CheckUnitsWizardDone)
end

function sc_CheckUnitsWizard(doneScript, Cancelscript)
    if not sc_CheckVoiceUnitCompatibility() then
        MODEL.screen.msgbox.new.setup(2)
        MODEL.screen.msgbox.new.set_line(1, m_i18n("The units you have selected are not supported by the current guidance voice profile."))
        MODEL.screen.msgbox.new.setup_button(1, doneScript, m_i18n("Proceed"), "", "ico_done_mid.bmp#3")
        if Cancelscript == nil then
            MODEL.screen.msgbox.new.setup_button(2, "", m_i18n("Cancel"), "", "ico_cancel_mid.bmp#3")
        else
            MODEL.screen.msgbox.new.setup_button(2, Cancelscript, m_i18n("Cancel"), "", "ico_cancel_mid.bmp#3")
        end
        MODEL.screen.msgbox.create_new()
    elseif doneScript then
        doneScript()
    end
end

function sc_CheckUnitsProceed()
    sc_NextStateAnim(st_SettingRouteParam, "horz_scroll", 1, "")
end

gFirstSpeedcamWarnDelayID = nil
function sc_FirstSpeedCamWarnInit()
    gFirstSpeedcamWarnDelayID = replaceDelayed(gFirstSpeedcamWarnDelayID, 50, "sc_FirstSpeedCamWarn()")
end

function sc_FirstSpeedCamWarn()
    if MODEL.warning.speedcam.allowed_in_the_country() then
        MODEL.screen.msgbox.new.setup(2)
        MODEL.screen.msgbox.new.set_line_wstr(1, translate(m_i18n("Speed Camera Warning is on by default. Using this function may be prohibited by law in certain countries.")))
        MODEL.screen.msgbox.new.set_line_wstr(2, translate(m_i18n("Leave it on?")))
        MODEL.screen.msgbox.new.setup_button(1, function()
            sc_SpeedcamWarningEnabled()
        end, m_i18n("Leave On"), "", "ico_done_mid.bmp#3")
        MODEL.screen.msgbox.new.setup_button(2, function()
            sc_SpeedcamWarningDisabled()
        end, m_i18n("Turn Off"), "", "ico_cancel_mid.bmp#3")
        MODEL.screen.msgbox.create_new()
    end
end

function sc_SettingWarningsCheckSpeedCamEula()
    sc_AskSpeedCamEula()
end

function sc_AskSpeedCamEula()
    MODEL.screen.msgbox.new.setup(2)
    MODEL.screen.msgbox.new.set_line_wstr(1, translate(m_i18n("Using this function may be prohibited by law in certain countries.")))
    MODEL.screen.msgbox.new.set_line_wstr(2, translate(m_i18n("Turn it on anyway?")))
    MODEL.screen.msgbox.new.setup_button(1, "sc_SpeedcamWarningEnabled", m_i18n("Turn On"), "", "ico_done_mid.bmp#3")
    MODEL.screen.msgbox.new.setup_button(2, "sc_SpeedcamWarningDisabled", m_i18n("Cancel"), "", "ico_cancel_mid.bmp#3")
    MODEL.screen.msgbox.create_new()
end

function sc_SpeedcamWarningEnabled()
    MODEL.warning.speedcam_warning = true
    MODEL.lua.SpeedcamEnabled = true
end

function sc_SpeedcamWarningDisabled()
    MODEL.warning.speedcam_warning = false
    MODEL.lua.SpeedcamEnabled = false
end

createState("st_MapSettings")
st_MapSettings:useLayers(backgroundLayers, ui_MapSettings)
function st_MapSettings.init()
    txtTitle:SET(m_i18n("Map Settings"))
end

function sc_Set_DayNightMode()
    local easyColorMode = MODEL.lua.vEasyColorMode()
    if easyColorMode == 0 then
        MODEL.map.auto_nightmode = false
        MODEL.screen.nightmode = false
    elseif easyColorMode == 1 then
        MODEL.map.auto_nightmode = false
        MODEL.screen.nightmode = true
    elseif easyColorMode == 2 then
        MODEL.map.auto_nightmode = true
    end
end

function sc_use_captureScreen()
    if MODEL.lua.captureScreen() then
        GESTURE("CI0", sc_CaptureScreen)
    else
        GESTURE("CI0")
    end
end

function sc_CalibrateScreen()
    CALIBRATE_SCREEN()
end

function sc_Restart()
    NEXTSTATE(RestartState)
    doDelayed(1, function()
        MODEL.other.softrestart()
    end)
end

function sc_SpeedWarnSettings()
    if MODEL.warning.speedlimit_warning() then
        MODEL.warning.speedlimit_warning_visual = true
        MODEL.warning.speedlimit_warning_voice = true
    else
        MODEL.warning.speedlimit_warning_visual = false
        MODEL.warning.speedlimit_warning_voice = false
    end
end

function sc_SpeedCamWarnSettings()
    if MODEL.lua.SpeedcamEnabled() then
        MODEL.lua.SpeedcamEnabled = false
        sc_SettingWarningsCheckSpeedCamEula()
    else
        sc_SpeedcamWarningDisabled()
    end
end

function sc_ShowCoordinateFormat()
    sc_NextStateAnim(st_CoordinateFormat, "horz_scroll", 1, "")
end

createState("st_CoordinateFormat")
st_CoordinateFormat:useLayers(backgroundLayers, ui_CoordinateFormat)
function st_CoordinateFormat.init()
    txtTitle:SET(m_i18n("Coordinate Format"))
end

createState("st_About")
st_About:useLayers(backgroundLayers, ui_About)
function st_About.init()
    txtTitle.TEXT = m_i18n("Navi Version")
end

function sc_AboutContentsPreload()
    ui_pleasewait:HIDE()
    MODEL.other.contents.preload()
end

createState("st_AboutContents")
st_AboutContents:useLayers(backgroundLayers, ui_AboutContents, localMenuLayers_full)
function st_AboutContents.init()
    txtTitle.TEXT = m_i18n("Content")
    sc_init_local_menu("ui.lm_ContentLocal.list")
end

function st_AboutContents.enter()
    ui_pleasewait:SHOW()
    sc_AboutContentsPreload()
    MODEL.other.contents.load_category_list()
end

function sc_ContentCatList()
    sc_close_local_menu()
    sc_NextStateAnim(st_AboutContents, "horz_scroll", 1, "")
end

function sc_ContentListOnRelease(index)
    local num = MODEL.other.contents.category_list[index].id()
    if num == 20 then
        MODEL.lua.ContentIsHNR = true
    else
        MODEL.lua.ContentIsHNR = false
    end
    sc_NextStateAnim(st_AboutContentList, "horz_scroll", 1, "")
end

createState("st_AboutContentList")
st_AboutContentList:useLayers(backgroundLayers, ui_AboutContentList)
function st_AboutContentList.init()
    local text = translated_format(m_i18n("Content List - %s"), MODEL.other.contents.current_category())
    txtTitle.TEXT = text
end

function sc_GetHnrErrorText(errorCode)
    if errorCode == 4 then
        return translate(m_i18n("Missing Maps"))
    elseif errorCode == 5 then
        return translate(m_i18n("Partially Incompatible"))
    end
end

function sc_SynctoolUpdate_onRelease()
    sc_close_local_menu()
    MODEL.other.lg_renault.synctool_update_button_pressed()
    sc_StartSynctool()
end

function sc_StartSynctool()
    ui.vSynctoolStarted = 1
    if MODEL.other.create_process(0, towstring(ui.vSyncTool)) == 0 then
        MODEL.other.lg_renault.synctool_not_running = 0
        ui_PoiInitPleaseWait:SHOW()
    end
end


-- 801
createState("st_VisualGuidanceSettings")
st_VisualGuidanceSettings:useLayers(backgroundLayers, ui_VisualGuidanceSettings, uieffect)
function st_VisualGuidanceSettings.init()
    txtTitle:SET(m_i18n("Visual Guidance"))
end
