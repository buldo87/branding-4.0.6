PoiSelected = false
maxZoom = DOUBLE.new(sc_GetSysEntry("map", "3d_max_zoomlevel", 14000))
satMaxPhase = 24
EMapMode = {Mode_3D = 1, Mode_2D = 2}
EViewMode = {
    Close = 0,
    Normal = 1,
    Far = 2
}
g_MapModeBeforeDragMode = -1
function sc_SignPostLayerShow()
    if st_EasyNav.active and not MODEL.lua.SignpostVisible() and MODEL.lua.SignpostOn() then
        sc_AngleSignPost()
        MODEL.lua.SignpostVisible = true
        MODEL.lua.showDiriconBg = true
        ui_NavigateMapSingpost:Y(-vLaneInfoSignpostHeight())
        ui_NavigateMapSingpost:YBLEND(0, 15)
    end
    obs_want_junctionview:trigger()
end

function sc_SignPostLayerHide()
    if MODEL.lua.SignpostVisible() then
        sc_RestoreSmartZoom()
        MODEL.lua.SignpostVisible = false
        MODEL.lua.showDiriconBg = false
        ui_NavigateMapSingpost:YBLEND(-vLaneInfoSignpostHeight() - 5, 15)
        MODEL.lua.JunctionViewHiddenByUser = true
    end
    obs_want_junctionview:trigger()
end

obs_want_junctionview = var.observer({
    ONCHANGE = function()
        MODEL.navigation.want_junctionview = MODEL.lua.JunctionViewOn() and not MODEL.route.list.navigated.calculating() and not MODEL.navigation.dead_reckoning() and bLaneinfoSignpostValid() and MODEL.map.primary.center_follow() and not MODEL.screen.msgbox.is_onscreen()
    end,
    MODEL = {
        MODEL.lua.JunctionViewOn,
        MODEL.route.list.navigated.calculating,
        MODEL.navigation.dead_reckoning,
        MODEL.map.primary.center_follow,
        MODEL.screen.msgbox.is_onscreen
    }
})
g_cursor_strapped = false
function sc_ResetStrappedCursor()
    MODEL.map.primary.cursor_icon = "cursor"
    g_cursor_strapped = false
    PoiSelected = false
end

obs_user_browsing_map = var.observer({
    ONCHANGE = function()
        if g_cursor_strapped == false then
            return
        end
        sc_ResetStrappedCursor()
    end,
    MODEL = {
        MODEL.map.primary.center_target,
        MODEL.map.primary.rotate,
        MODEL.map.primary.zoom,
        MODEL.map.primary.tilt,
        MODEL.map.primary.mode,
        MODEL.map.cursor.position
    },
    TRIGGER_ON_START = false
})
createState("st_EasyNav")
st_EasyNav:useLayers(primary, ui_Status, ui_PropLayer, ui_EasyNav_Main, ui_EasyNav_Main_Functions, ui_Bd_ShowCockpitButton, ui_Bd_cockpitButton, ui_EasyNav_NextMan, ui_EasyNav_DragMode, ui_SimulationControls, ui_SimulationStop, ui_NavigateMapSpeedLimit, ui_SpeedCamWarningLayer, ui_NavigateMapSingpost, ui_NavigateMapJunctionView, ui_EasyNav_RoundaboutIcons, localMenuLayers, ui_BugReport, ui_RecalcMsgBoxNavigate, ui_EasyNav_Additional_Features, uieffect)
st_EasyNav.active = nil
function st_EasyNav.enter()
    sc_ValidRouteChangedTripInfoInit(true)
    gGoTextIsSelect = true
    gKeepMapPosAfterBack = false
end

function st_EasyNav.init()
    MODEL.map.primary.auto_camera_animation = false
    sc_PosRecalcLayer()
    sc_Set_Presets()
    sc_init_local_menu("ui.lm_st_EasyNav")
    primary:ONMAPCLICK(sc_EasyMapClick)
    obs_enter_drag_mode:START("no_trigger")
    if MODEL.lua.dragMode() then
        sc_dragmode(true)
        MODEL.lua.mainMenuMode = false
    else
        if MODEL.navigation.is_in_simulation() then
            sc_SetFlyOverMode()
        else
            sc_set_Nav2D3D()
            MODEL.lua.mainMenuMode = false
        end
        sc_Set_Follow_On()
        MODEL.map.primary.show_cursor = false
    end
    ATTACH_LANEINFO(sprLaneInfoEasy, "laneinfo.ini")
    ATTACH_LANEINFO(sprLaneInfoSignpost, "laneinfo_signpost.ini")
    bLaneInfoSignpostForceRedraw:SET(1)
--    local junctionViewType = sc_GetSysEntry("navigation", "junction_view_type", "NNG")
--    if junctionViewType == "NNG" then
--        ATTACH_JUNCTIONVIEW(sprJunctionView, "$junctionview_nng.ini", gJunctionViewDirectory)
--    elseif junctionViewType == "mixed" then
--        ATTACH_JUNCTIONVIEW(sprJunctionView, "$junctionview_mixed.ini", gJunctionViewDirectory)
--    elseif junctionViewType == "NNG_NQ" then
--        ATTACH_JUNCTIONVIEW(sprJunctionView, "$junctionview_nng_nq.ini", "16_9_NQ_Roads")
--    elseif junctionViewType == "NQ" then
--        ATTACH_JUNCTIONVIEW(sprJunctionView, "$junctionview_nq.ini", "default")
--    end
    local junctionViewType = MODEL.lua.BdJunctionViewType()
    if junctionViewType == 1 then
        ATTACH_JUNCTIONVIEW(sprJunctionView, "$junctionview_nng.ini", gJunctionViewDirectory)
    elseif junctionViewType == 2 then
        ATTACH_JUNCTIONVIEW(sprJunctionView, "$junctionview_mixed.ini", gJunctionViewDirectory)
    elseif junctionViewType == 3 then
       ATTACH_JUNCTIONVIEW(sprJunctionView, "$junctionview_nng_nq.ini", "16_9_NQ_Roads")
    elseif junctionViewType == 4 then
       ATTACH_JUNCTIONVIEW(sprJunctionView, "$junctionview_nq.ini", "default")
    end
-- sbertaud13 en commentaire pour position voiture
--    MODEL.map.primary.car_posy = 74
	MODEL.map.primary.car_posy = 80
    st_EasyNav.active = true
    obs_want_junctionview:START()
    obs_want_junctionview:TRIGGER()
    obs_SignPostValid:START()
    if bLaneinfoSignpostValid() == 1 then
        sc_SignPostLayerShow()
    end
    ui_Local_Menu_Background:ALPHA(0)
    ui_Local_Menu_Background:HIDE()
    if not MODEL.map.primary.center_follow() and not gKeepMapPosAfterBack then
        MODEL.map.primary.center_noanim(MODEL.map.cursor.position())
    end
    gKeepMapPosAfterBack = false
    MODEL.map.primary.auto_camera_animation = true

    if MODEL.lua.wTurnRestriction() ~= 0 and MODEL.lua.wTurnRestrictionVoice() and sc_wReadOutTurnRestSupported() then
        obs_wturnrest:START("NO_TRIGGER")
    end
--  if MODEL.lua.BdviewCurrentCity() ~= 0 and MODEL.lua.BdReadOutCityName() and sc_ReadOutCityNameSupported() then
--  obs_BdReadCityName:START("NO_TRIGGER")
--  end
    if MODEL.lua.ButtonCockpitShow() == 2 then
        ui_Bd_cockpitButton:HIDE()
        ui_Bd_ShowCockpitButton:SHOW()
    else
        ui_Bd_ShowCockpitButton:HIDE()
    end
end

function st_EasyNav.done()
    obs_enter_drag_mode:STOP()
    st_EasyNav.active = nil
    obs_want_junctionview:STOP()
    MODEL.navigation.want_junctionview = false
    obs_SignPostValid:STOP()
    obs_user_browsing_map:STOP()
end

function sc_Change2D3DMode()
    ui.vShowFake2D3DButton = 0
    if MODEL.lua.vEasyMapModeFake() == MODEL.lua.vEasyMapMode() then
        MODEL.map.primary.autochange_mode_for_zoom = gAutoChangeModeForZoomSave
    else
        MODEL.map.primary.autochange_mode_for_zoom = false
        if MODEL.lua.vEasyMapModeFake() == EMapMode.Mode_2D then
            sc_Easy2Ddragmode()
            MODEL.map.primary.autochange_mode_for_zoom = false
        else
            sc_Easy3Ddragmode()
            MODEL.map.primary.autochange_mode_for_zoom = true
        end
        g_MapModeBeforeDragMode = MODEL.lua.vEasyMapModeFake()
    end
    MODEL.lua.vEasyMapMode = MODEL.lua.vEasyMapModeFake()
end

gAutoChangeModeForZoomSave = false
function sc_Enable2D3DSwitch()
    if DOUBLE.toInt(MODEL.map.primary.zoom()) < MODEL.map.primary.maxzoom3d() then
        sc_Change2D3DMode()
    else
        ui.vShowFake2D3DButton = 1
        gAutoChangeModeForZoomSave = MODEL.map.primary.autochange_mode_for_zoom()
        MODEL.lua.vEasyMapModeFake = MODEL.lua.vEasyMapMode()
        MODEL.map.primary.autochange_mode_for_zoom = false
    end
end

function sc_switch2D3DFake()
    if MODEL.lua.vEasyMapModeFake() == EMapMode.Mode_2D then
        MODEL.lua.vEasyMapModeFake = EMapMode.Mode_3D
    else
        MODEL.lua.vEasyMapModeFake = EMapMode.Mode_2D
    end
    sc_Dragmode_Type_Changes()
end

function sc_switch2D3D()
    if MODEL.navigation.is_in_simulation() then
        if MODEL.lua.SimulateMapMode() == EMapMode.Mode_2D then
            MODEL.lua.SimulateMapMode = EMapMode.Mode_3D
        else
            MODEL.lua.SimulateMapMode = EMapMode.Mode_2D
        end
    elseif MODEL.lua.vEasyMapMode() == EMapMode.Mode_2D then
        MODEL.lua.vEasyMapMode = EMapMode.Mode_3D
    else
        MODEL.lua.vEasyMapMode = EMapMode.Mode_2D
    end
    if MODEL.lua.dragMode() then
        if MODEL.lua.vEasyMapMode() == EMapMode.Mode_2D then
            MODEL.map.primary.autochange_mode_for_zoom = false
            sc_Easy2Ddragmode()
        else
            MODEL.map.primary.autochange_mode_for_zoom = true
            sc_Easy3Ddragmode()
        end
        g_MapModeBeforeDragMode = MODEL.lua.vEasyMapMode()
    else
        if MODEL.navigation.is_in_simulation() then
            sc_SetFlyOverMode()
            sc_set_FlyOver2D3D()
        else
            sc_set_Nav2D3D()
        end
        sc_Set_Follow_On()
        MODEL.map.primary.show_cursor = false
    end
end

obs_SIMULATION_BUG_OBSERVER = var.observer({
    ONCHANGE = function()
        local mapState = MODEL.map.primary.state()
        if (mapState == "simulate_2d" or mapState == "simulate") and vActiveState() ~= "st_easynav" then
            ASSERT(false, "Invalid state accessed from simulation! Tell Isu if you see this. Thanks")
        end
    end,
    MODEL = MODEL.ui.vActiveState,
    TRIGGER_ON_START = false
})
obs_SIMULATION_BUG_OBSERVER:START()
function st_EasyNav.exit()
    local state = MODEL.map.primary.state()
    if state == "simulate_2d" or state == "simulate" then
        ASSERT(false, "Tell Isu if you see this. Thanks")
        MODEL.map.primary.exit_state()
    end
    gGoTextIsSelect = false
end

function sc_LMPlaceInfo_onrelease()
    sc_close_local_menu()
    if gFlatSearchInQueue == 0 then
        MODEL.poi.copy_query("poi.flat_search", "poi.tmp_flat", 1)
        sc_ShowPlacesAroundCursor("fade", 0, "")
    else
        CLEARTOSTATE(st_FindPOIFlatList)
        sc_ShowPlacesAroundCursor("fade", 0, "")
    end
end

function sc_LMFavorite_onrelease()
    if vActiveState() == "st_whereami" then
        MODEL.my.map.select_address(MODEL.navigation.car.position())
    end
    sc_close_local_menu()
    sc_btnPM_Favorite_OnRelease()
end

function sc_LMCurrentPos_onrelease()
    MODEL.map.primary.center = MODEL.navigation.car.position()
    sc_close_local_menu()
end

function sc_LM_MapScreen_OnRelease()
    sc_close_local_menu()
    sc_NextStateAnim(st_MapSettings, "fade", 1, "")
end

function sc_LM_ShowWhereAmI()
    sc_close_local_menu()
    sc_ShowWhereAmI()
end

function sc_LM_OnMapInfo()
    sc_close_local_menu()
    sc_OnMapInfo()
end

function sc_ShowItinerList()
    sc_NextStateAnim(st_RouteItiner, "vert_scroll", 0, "")
end

function sc_SignPostDiricon()
end

function sc_RestoreSmartZoom()
    local mapLayer = MODEL.map.primary()
    MODEL.lua.showLaneInfo = true
    mapLayer.camera_settings.roundabout.centery = 50
    mapLayer.car_posy = 74
    mapLayer.camera_settings.presetid = MODEL.lua.vEasyViewMode() + 1
end

function sc_AngleSignPost()
    MODEL.lua.showLaneInfo = false
    local mapLayer = MODEL.map.primary()
    mapLayer.camera_settings.roundabout.centery = 65
    mapLayer.camera_settings.presetid = 10 * (MODEL.lua.vEasyViewMode() + 1) + 1
end

function sc_Easy3D()
    local mapLayer = MODEL.map.primary()
    if not MODEL.lua.dragMode() then
        mapLayer.center_follow = true
        mapLayer.rotate_follow = true
    end
    mapLayer.save_state(mapLayer.state())
    mapLayer.switch_state("navmap3d", 1)
    if not MODEL.lua.dragMode() then
        mapLayer.zoom_follow = true
        mapLayer.tilt_follow = true
    end
end

function sc_Easy2D()
    local mapLayer = MODEL.map.primary()
    if not MODEL.lua.dragMode() then
        mapLayer.center_follow = true
        mapLayer.rotate_follow = true
    end
    mapLayer.save_state(mapLayer.state())
    mapLayer.switch_state("2dheadup", 1)
    if not MODEL.lua.dragMode() then
        mapLayer.zoom_follow = true
        mapLayer.car_posy = 74
        mapLayer.center_posy = 74
    end
end

function sc_Dragmode_Type_Changes()
    local mapLayer = MODEL.map.primary()
    if not ui.vShowFake2D3DButton and MODEL.lua.vEasyMapMode() == EMapMode.Mode_3D or ui.vShowFake2D3DButton and MODEL.lua.vEasyMapModeFake() == EMapMode.Mode_3D then
        MODEL.lua.tiltVisible = true
    else
        mapLayer.tilt_factor = float_1
        MODEL.lua.tiltVisible = false
    end
end

function sc_Easy3Ddragmode()
    local mapLayer = MODEL.map.primary()
    sc_Set_Common_3DMap(mapLayer)
    MODEL.lua.dragMode = true
    MODEL.lua.tiltVisible = not ui.vShowFake2D3DButton and MODEL.lua.vEasyMapMode() == EMapMode.Mode_3D or ui.vShowFake2D3DButton and MODEL.lua.vEasyMapModeFake() == EMapMode.Mode_3D
    mapLayer.zoom_lock = false
    mapLayer.tilt_lock = false
    mapLayer.rotate_lock = false
    mapLayer.center_lock = false
    mapLayer.center_follow = false
    mapLayer.zoom_follow = false
    mapLayer.tilt_follow = false
    mapLayer.rotate_follow = false
    mapLayer.navi_mode_3d_labels = false
end

function sc_Easy2Ddragmode()
    local mapLayer = MODEL.map.primary()
    sc_Set_Common_2DMap(mapLayer)
    mapLayer.center_posy = 74
    MODEL.lua.dragMode = true
    MODEL.lua.tiltVisible = false
    mapLayer.zoom_lock = false
    mapLayer.rotate_lock = false
    mapLayer.center_lock = false
    mapLayer.center_follow = false
    mapLayer.zoom_follow = false
    mapLayer.rotate_follow = false
    mapLayer.navi_mode_3d_labels = false
end

function sc_Easy3DFromDragmode()
    local mapLayer = MODEL.map.primary()
    MODEL.lua.dragMode = false
    MODEL.lua.tiltVisible = false
    mapLayer.switch_state("navmap3d", 1)
    mapLayer.zoom_follow = true
    mapLayer.tilt_follow = true
    mapLayer.rotate_follow = true
end

function sc_Easy2DFromDragmode()
    local mapLayer = MODEL.map.primary()
    MODEL.lua.dragMode = false
    MODEL.lua.tiltVisible = false
    mapLayer.switch_state("2dheadup", 1)
    mapLayer.zoom_follow = true
    mapLayer.center_posy = 74
end

function sc_set_Nav2D3D()
    if MODEL.lua.vEasyMapMode() == EMapMode.Mode_2D then
        sc_Easy2D()
    else
        sc_Easy3D()
    end
end

function sc_set_FlyOver2D3D()
    MODEL.map.primary.switch_state(MODEL.lua.SimulateMapMode() == EMapMode.Mode_2D and "simulate_2d" or "simulate", 1)
end

function sc_set_Nav2D3D_MapSettings()
    sc_set_Nav2D3D()
end

function sc_Set_Presets()
    MODEL.map.primary.camera_settings.presetid = MODEL.lua.vEasyViewMode() + 1
end

function sc_Set_Follow_On()
    local mapLayer = MODEL.map.primary()
    mapLayer.zoom_follow = true
    mapLayer.tilt_follow = true
    mapLayer.center_follow = true
    mapLayer.rotate_follow = true
end

function sc_Set_Follow_Off()
    local mapLayer = MODEL.map.primary()
    mapLayer.center_follow = false
    mapLayer.zoom_follow = false
    mapLayer.tilt_follow = false
    mapLayer.rotate_follow = false
end

function sc_dragmode(SetCursor)
    ui.vShowFake2D3DButton = 0
    if MODEL.navigation.is_in_simulation() then
        ASSERT(false, "Dragmode in simulation?")
        local centerLock = MODEL.map.primary.center_lock()
        local follow = MODEL.map.primary.center_follow()
        MODEL.map.primary.center_lock = true
        MODEL.map.primary.center_follow = true
        return
    end
    if vActiveState() == "st_routeitinermap" then
        ASSERT(false, "Dragmode in itinerview?")
    end
    local mapLayer = MODEL.map.primary()
    if mapLayer.state() == "dragmode" then
        return
    end
    mapLayer.save_state("dragmode")
    mapLayer.switch_state("dragmode")
    sc_Set_Follow_Off()
    mapLayer.show_cursor = true
    if SetCursor then
        MODEL.map.primary.cursor_icon = "cursor"
    end
    mapLayer.auto_set_cursor = true
    if SetCursor then
        MODEL.map.cursor.position = MODEL.navigation.car.position()
        MODEL.my.map.select_address(MODEL.navigation.car.position())
    end
    obs_Dragmode_Type:START("no_trigger")
    if MODEL.lua.vEasyMapMode() == EMapMode.Mode_2D then
        sc_Easy2Ddragmode()
    else
        mapLayer.autochange_mode_for_zoom = true
        sc_Easy3Ddragmode()
    end
    if 0 > g_MapModeBeforeDragMode then
        g_MapModeBeforeDragMode = MODEL.lua.vEasyMapMode()
    end
end

function sc_backFromdragmode()
    if ui.vShowFake2D3DButton == 1 then
        sc_Change2D3DMode()
    end
    MODEL.lua.dragMode = false
    MODEL.map.primary.autochange_mode_for_zoom = true
    obs_Dragmode_Type:STOP()
    MODEL.lua.vEasyMapMode = g_MapModeBeforeDragMode
    g_MapModeBeforeDragMode = -1
    if MODEL.lua.vEasyMapMode() == EMapMode.Mode_2D then
        sc_Easy2DFromDragmode()
    else
        sc_Easy3DFromDragmode()
    end
end

function sc_EasyMapClick()
    local selectedPois = MODEL.map.primary.clicked_poi_list
    if selectedPois.size() == 1 then
        currentPoi = selectedPois["@0"]
        MODEL.my.poi.select_poi(currentPoi.provider_id(), currentPoi.id())
    end
    PoiSelected = false
    gClickedPoiFlag = false
    if #selectedPois then
        sc_SetPOICursorIcon()
        PoiSelected = true
        gClickedPoiFlag = true
        g_cursor_strapped = true
    elseif not MODEL.map.primary.clicked_speedcam_list.isempty() then
        MODEL.map.primary.cursor_icon = "cursor_speedcam"
        g_cursor_strapped = true
        sc_UpdateSpeedcamModels(MODEL.map.primary.clicked_speedcam_list[0])
    else
        MODEL.map.primary.cursor_icon = "cursor"
        g_cursor_strapped = false
    end
    if MODEL.map.primary.center_follow() then
        obs_enter_drag_mode:STOP()
        sc_dragmode(false)
        obs_enter_drag_mode:START("NO_TRIGGER")
    end
end

function sc_route_planning_start()
    g_WaypointIsolatedWarningIssued = {}
    MODEL.lua.routeCalculation = true
    gAviodRouteRecalculated = true
end

function sc_route_planning_stop()
    MODEL.lua.routeCalculation = false
end

function sc_TunnelOn()
    if gUseNightmodeInTunnel and MODEL.map.auto_nightmode() then
        gBeforeTunnel = MODEL.screen.nightmode()
        MODEL.screen.nightmode = true
    end
end

function sc_TunnelOff()
    if gUseNightmodeInTunnel and MODEL.map.auto_nightmode() then
        MODEL.screen.nightmode = gBeforeTunnel
        gBeforeTunnel = false
    end
end

gSimControlsFadeDelayID = -1
gSimControlsVisibilityDelayID = -1
gSimControlsFadeMin = 0
gSimControlsFadeMax = 32
gSimControlsFadeInTime = 0
gSimControlsFadeOutTime = 24
tSimControlsObjects = {
    "spr_SC_bg",
    "btn_simspeed",
    "btn_ManNext",
    "spr_ManNext",
    "btn_sim_play",
    "spr_sim_play",
    "btn_sim_pause",
    "spr_sim_pause",
    "btn_ManPrev",
    "spr_ManPrev"
}
function sc_simulate_speedup()
    if MODEL.route.simulation_speed_percent() == 100 then
        MODEL.route.simulation_speed_percent = 400
    elseif MODEL.route.simulation_speed_percent() == 400 then
        MODEL.route.simulation_speed_percent = 800
    else
        MODEL.route.simulation_speed_percent = 100
    end
end

function sc_SetVehicleSpecificSettings()
    MODEL.map.show_oneway = true
    MODEL.sound.speech.guidance_muted = false
    MODEL.map.car_display.set_category("car")
    MODEL.route.list.navigated.use_waiting_times = false
    sc_SetPoiVisibilities()
end

function sc_RotateStop()
    MODEL.map.primary.rotate_stop()
end

gCountryChangedMsgCountryIndex = nil
function sc_BorderCross_CountryInfo_OnRelease()
    if gCountryChangedMsgCountryIndex == nil or gCountryChangedMsgCountryIndex == -1 then
        ASSERT(false)
        return
    end
    MODEL.other.country_info.list.index = gCountryChangedMsgCountryIndex
    sc_NextStateAnim(st_CountryInfo, "fade")
end

function sc_LaneInfoVisibleOnchange()
    if MODEL.lua.laneInfoVisible() then
        sprLaneInfoEasy:BLENDALPHA(0, 32, 20)
    else
        sprLaneInfoEasy:BLENDALPHA(32, 0, 20)
    end
end

function sc_OnMapInfo()
    local selectedPois = MODEL.map.primary.clicked_poi_list
    local Poi = MODEL.my.poi.current
    gKeepMapPosAfterBack = true
    if MODEL.my.map.selected_item.type() == 1 and Poi.provider_id() ~= 0 and Poi.id() ~= 0 and PoiSelected then
        gCursorLocationType = "poi"
        sc_NextStateAnim(st_CursorLocation, "fade", 1, "")
    elseif g_cursor_strapped and 0 < selectedPois.size() and gClickedPoiFlag then
        if #selectedPois == 1 then
            local poi = selectedPois["@0"]()
            MODEL.my.poi.select_poi(poi.provider_id(), poi.id())
            gCursorLocationType = "poi"
            sc_NextStateAnim(st_CursorLocation, "fade", 1, "")
        else
            st_PoiSelectionOnMapResult.createRouteOnClick = false
            sc_NextStateAnim(st_PoiSelectionOnMapResult, "fade", 1, "")
        end
    elseif g_cursor_strapped and not MODEL.map.primary.clicked_speedcam_list.isempty() then
        if MODEL.map.primary.clicked_speedcam_list.size() == 1 then
            MODEL.map.primary.clicked_speedcam_list.setcurrent(0)
            gCursorLocationType = "speedcam"
            sc_NextStateAnim(st_CursorLocation, "fade", 1, "")
        else
            sc_NextStateAnim(st_SelectSpeedcamForInfo, "fade", 1, "")
        end
    else
        gCursorLocationType = "cursor"
        sc_NextStateAnim(st_CursorLocation, "fade", 1, "")
    end
end

function sc_NewJunctionView()
    MODEL.lua.JunctionViewHiddenByUser = false
    MODEL.navigation.new_junctionview = false
    sc_SignPostLayerShow()
end

function sc_HideJunctionView()
    MODEL.lua.JunctionViewHiddenByUser = true
end

function sc_JunctionViewOnshow()
    sprJunctionView:REDRAW()
end

function sc_JunctionViewOnhide()
end

createState("st_GpsStatus")
st_GpsStatus:useLayers(uieffect, ui_Footer, ui_Status, ui_Title, ui_GPSStatus, ui_Background)
function st_GpsStatus.init()
    txtTitle:SET(m_i18n("GPS Information"))
    MODEL.gps.autoupdate_satellite_display = true
end

function st_GpsStatus.done()
    MODEL.gps.autoupdate_satellite_display = false
end

function sc_SetGPS_Phase(valid, used, isEgnos, isWaas)
    local phase = 0
    if not valid then
        phase = 1
    elseif not used then
        phase = 3
    elseif isEgnos or isWaas then
        phase = 4
    else
        phase = 0
    end
    return phase
end

function sc_SetGPSSignal_Bmp(valid, used, isEgnos, isWaas)
    local bmp = "gpsstatus_progreswhite_spr.bmp"
    if not valid then
        bmp = "gpsstatus_progreswhite_spr.bmp"
    elseif not used then
        bmp = "gpsstatus_progresred_spr.bmp"
    elseif isEgnos or isWaas then
        bmp = "gpsstatus_progresblue_spr.bmp"
    else
        bmp = "gpsstatus_progresgreen_spr.bmp"
    end
    return bmp
end

function sc_CaptureScreen(force)
    if MODEL.lua.captureScreen or force then
        MODEL.ui.__screenshot()
        doDelayed(15, function()
            sc_InfoMessageBox(m_i18n("DEBUG~Screen Captured"))
        end)
    end
end

lastZoom = DOUBLE_0
lastTilt = DOUBLE_0
tiltStep = DOUBLE_0
function sc_TiltChanged1()
    sc_TiltChanged()
end

function sc_TiltChanged2()
    sc_TiltChanged()
end

function sc_TiltChanged()
    if automaticTiltChange or MODEL.map.primary.tilt_lock() then
        return
    end
    sc_CalcTiltStep()
end

function sc_CalcTiltStep()
    local primary = MODEL.map.primary
    lastZoom = primary.zoom()
    if lastZoom < maxZoom then
        lastTilt = DOUBLE.new(primary.tilt())
        tiltStep = lastTilt / (maxZoom - lastZoom)
    end
end

function sc_MapModeChanged()
    sc_CalcTilt()
end

function sc_ZoomChanged()
    sc_CalcTilt()
end

function sc_CalcTilt()
    local primary = MODEL.map.primary
    if primary.tilt_lock() or primary.mode() ~= "3d" then
        return
    end
    local actZoom = primary.zoom()
    automaticTiltChange = true
    if actZoom > maxZoom then
        actZoom = maxZoom
    elseif actZoom < lastZoom then
        actZoom = lastZoom
    end
    local tilt = (lastTilt - (actZoom - lastZoom) * tiltStep):toInt()
    if tilt > primary.maxtilt3d_current() then
        tilt = primary.maxtilt3d_current()
    elseif tilt < 0 then
        tilt = 0
    end
    primary.tilt = tilt
    if actZoom == lastZoom then
        sc_CalcTiltStep()
    end
    automaticTiltChange = false
end

function sc_OpenMapMenu()
    MODEL.lua.vEasyNavMapMenuOpen = not MODEL.lua.vEasyNavMapMenuOpen()
end

function sc_GetSatX(phase, index, radius, bmpWidth)
    local phase = (phase + satMaxPhase / 3 * index) % satMaxPhase
    local angle = DOUBLE.new("6.283") * phase / satMaxPhase
    return (DOUBLE.cos(angle) * radius):toInt() - bmpWidth / 2
end

function sc_GetSatY(phase, index, radius, bmpWidth)
    local phase = (phase + satMaxPhase / 3 * index) % satMaxPhase
    local angle = DOUBLE.new("6.283") * phase / satMaxPhase
    return (DOUBLE.sin(angle) * radius):toInt() - bmpWidth / 2
end

gOverspeed = false
function sc_GetAdvancedSpeedLimitPhase(speed, speed_limit)
    if speed_limit == nil then
        return 0
    end
    if speed <= speed_limit or MODEL.navigation.is_in_simulation() or not MODEL.warning.speedlimit_warning() then
        ui.vSpeedLimitBlinkCounter = 3
        gOverspeed = false
        return 0
    elseif speed <= speed_limit * MODEL.warning.speedwarn_alt_tolerance() / 100 then
        ui.vSpeedLimitBlinkCounter = 3
        gOverspeed = false
        return 1
    else
        if not gOverspeed then
            ui.vSpeedLimitBlinkCounter = 0
        end
        gOverspeed = true
        return 2
    end
end

function sc_BlinkSpeedLimitAlpha()
    ui.vSpeedLimitBlinkCounter = vSpeedLimitBlinkCounter() + 1
    if vSpeedLimitBlinkCounter() % 2 then
        return 0
    else
        return 32
    end
end

function sc_RefreshOverviewStatus()
    MODEL.lua.OverViewModeOn = not MODEL.lua.OverViewModeOn()
    MODEL.lua.OverViewModeOn = not MODEL.lua.OverViewModeOn()
end

function sc_SetPOICursorIcon()
    local FileName = MODEL.screen.get_icon_file_and_phase(MODEL.my.poi.current.icon(), 1)
    if FileName:sub(1, 1) == "*" then
        MODEL.map.primary.cursor_icon = "cursor_poi_brand"
    else
        MODEL.map.primary.cursor_icon = "cursor_poi"
    end
end

function sc_getCompassTilt(tilt, mode)
    if mode == "2d" then
        tilt = 0
    end
    return DOUBLE.new(12000 - tilt) / 12000
end

function sc_GetMediaButtonIcon(phase)
    if phase >= 1 and phase <= 8 then
        return "media_icon" .. phase .. ".bmp#3"
    end
    return ""
end

gSpeedLimitLoopDelay = -1
function sc_SpeedLimitConditionValidity()
    if MODEL.warning.driveralert.speed_limit_condition.valid() then
        obs_SpeedLimitConditionChanged:START()
    else
        obs_SpeedLimitConditionChanged:STOP()
        MODEL.lua.ShowConditionalSpeedLimit = false
        sc_SpeedLimitConditionTimerStop()
    end
end

function sc_SpeedLimitConditionChanged()
    local driveralert = MODEL.warning.driveralert
    MODEL.lua.ShowConditionalSpeedLimit = false
    if MODEL.warning.driveralert.speed_limit_condition() == eSpeedlimitContionTypes.eTime then
        sc_SpeedLimitConditionTimerStop()
    elseif gSpeedLimitLoopDelay == -1 then
        MODEL.lua.ShowConditionalSpeedLimit = true
    end
end

function sc_SpeedLimitConditionLoop()
    local driveralert = MODEL.warning.driveralert
    if not driveralert.speed_limit_condition.valid() or driveralert.speed_limit_condition() == eSpeedlimitContionTypes.eTime then
        ASSERT(false, "Forgot stop timer?")
        MODEL.lua.ShowConditionalSpeedLimit = false
        sc_SpeedLimitConditionTimerStop()
    else
        MODEL.lua.ShowConditionalSpeedLimit = not MODEL.lua.ShowConditionalSpeedLimit()
    end
end

function sc_SpeedLimitConditionTimerStop()
    if gSpeedLimitLoopDelay ~= -1 then
        killDelayed(gSpeedLimitLoopDelay)
        gSpeedLimitLoopDelay = -1
    end
end

