MODEL.SETPERSISTENT.lua.BdSecondDir = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdChronoVisible = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdSecondManVisible = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdBottomInfosVisible = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdBottom2D3D = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdBottomHour = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdBottomGpsBat = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdBottomAlt = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdBottomVoiceG = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.vgjMCCurrentMap = INT_MODEL(2)
MODEL.SETPERSISTENT.lua.BdshowSpeedortime = INT_MODEL(1)
MODEL.SETPERSISTENT.lua.BdshowSpeedFS = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdshowPeage = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdshowSpeedPermOverS = INT_MODEL(2)
MODEL.SETPERSISTENT.lua.SpeedInfoColorD = INT_MODEL(5)
MODEL.SETPERSISTENT.lua.SpeedInfoColorN = INT_MODEL(6)
MODEL.SET.lua.showParam_skin = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdShowHouseNumber = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.vgjShowCompass = INT_MODEL(1)
MODEL.SETPERSISTENT.lua.compasHousenumbOFFnav = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.BdTopInfosTMCvisible = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdviewnumberInfoTMC = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdviewCurrentCity = INT_MODEL(2)
MODEL.SETPERSISTENT.lua.BdReadTTSsayeta = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.BdGlowtype = INT_MODEL(3)
MODEL.SETPERSISTENT.lua.blockroadBmpVisible = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdTMCbuttonVisible = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdzoomButtonVisible = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdweatherButtonVisible = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdweatherButtonVisibleCockpit = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdcolorDistNextManD = INT_MODEL(5)
MODEL.SETPERSISTENT.lua.BdcolorDistNextManN = INT_MODEL(6)
MODEL.SETPERSISTENT.lua.BdColorDistSecondManD = INT_MODEL(5)
MODEL.SETPERSISTENT.lua.BdColorDistSecondManN = INT_MODEL(6)
MODEL.SETPERSISTENT.lua.ButtonCockpitShow = INT_MODEL(2)
MODEL.SETPERSISTENT.lua.ButtonCockpitMove = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.BdOpenHwyPanelAuto = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdValueOpenHwyPanelAuto = INT_MODEL(15000)
MODEL.SETPERSISTENT.lua.BdSoundHwyPanelAuto = INT_MODEL(1)
MODEL.SETPERSISTENT.lua.BdJunctionViewType = INT_MODEL(2)
MODEL.SETPERSISTENT.lua.BdTransCockpit = INT_MODEL(15)
MODEL.SETPERSISTENT.lua.BdTransNextStreet = INT_MODEL(18)
MODEL.SETPERSISTENT.lua.BdTransCurrentStreet = INT_MODEL(18)
MODEL.SETPERSISTENT.lua.BdTransSpeedFS = INT_MODEL(15)
MODEL.SETPERSISTENT.lua.BdStartState = INT_MODEL(2)
MODEL.SETPERSISTENT.lua.SBHome = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.SBWork = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.BdArrowColor = INT_MODEL(8)
MODEL.SETPERSISTENT.lua.BdArrow2Color = INT_MODEL(14)
MODEL.SETPERSISTENT.lua.BdCockpitButtonColor = INT_MODEL(7)
MODEL.SETPERSISTENT.lua.BdCockpitButtonColorN = INT_MODEL(84)
MODEL.SETPERSISTENT.lua.wTMCTunerMode = INT_MODEL(1)
MODEL.SETPERSISTENT.lua.tripInfoColorD = INT_MODEL(5)
MODEL.SETPERSISTENT.lua.tripInfoColorN = INT_MODEL(6)
MODEL.SET.lua.wSettingDistSoundName = WSTRING_MODEL(L"")
MODEL.SET.lua.wSettingProgramParameter = WSTRING_MODEL(L"")
MODEL.SET.lua.wBlockValid = INT_MODEL(0)
MODEL.SET.lua.wLocalMenuHide = BOOL_MODEL(false)
MODEL.SET.lua.wCurrentTime = PROXY_WSTRING_MODEL({
    getter = function()
        return MODEL.other.format_time_dayperiod(MODEL.gps.current_time(), 0, 0)
    end,
    observe = {
        MODEL.gps.current_time
    }
})
MODEL.SETPERSISTENT.lua.BdSizeInputText = INT_MODEL(3)
MODEL.SETPERSISTENT.lua.holdStationTime = INT_MODEL(15)
MODEL.SETPERSISTENT.lua.testStationTime = INT_MODEL(3)
MODEL.SETPERSISTENT.lua.TimeFormatmodel = INT_MODEL(5)
MODEL.SETPERSISTENT.lua.BdSizeInfosCockpit = INT_MODEL(2)
MODEL.SETPERSISTENT.lua.ThemeChangerOn = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.ThemeChangerDebug = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.ThemeChangerSound = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.ThemeChangerWeather = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.BdAfichmeteobmp = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.Mode_Day_Scheme = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.Mode_Day_Sky = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.Mode_Night_Scheme = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.Mode_Night_Sky = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.Force = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.ForceSeason = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.ForceMonth = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.ForceMonthInt = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.ForceAlea = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.ForceWeatherD = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.ForceWeatherN = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.LastWeatherD = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.LastWeatherN = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.LastSeason = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.LastMonth = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.LastSchemename = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.MeteoDId = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.MeteoNId = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.TCavantminuit = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.NextWeatherD = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.NextWeatherN = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.RealMeteo = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.RealPrevisionD = WSTRING_MODEL(L"0")
MODEL.SETPERSISTENT.lua.RealPrevisionN = WSTRING_MODEL(L"0")
MODEL.SETPERSISTENT.lua.NextRealPrevisionD = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.NextRealPrevisionN = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.MeteoTempD = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.MeteoTempN = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.NextMeteoTempD = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.NextMeteoTempN = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.SbTemperature = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.SbTemperatureNext = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.WeatherOutOfdate = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.Schemename = WSTRING_MODEL(L"")
MODEL.SET.lua.SBChangeDayNight = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.BdweatherRemainingDay = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.BdweatherRemainingDayCockpit = BOOL_MODEL(false)
MODEL.SET.lua.APMode_Day_Scheme = INT_MODEL(0)
MODEL.SET.lua.APMode_Day_Sky = INT_MODEL(0)
MODEL.SET.lua.APMode_Night_Scheme = INT_MODEL(0)
MODEL.SET.lua.APMode_Night_Sky = INT_MODEL(0)
MODEL.SET.lua.APForceSeason = INT_MODEL(0)
MODEL.SET.lua.APForceMonthInt = INT_MODEL(0)
MODEL.SET.lua.APForceAlea = INT_MODEL(0)
MODEL.SET.lua.APForceWeatherD = INT_MODEL(0)
MODEL.SET.lua.APForceWeatherN = INT_MODEL(0)
MODEL.SET.lua.APLastWeatherD = WSTRING_MODEL(L"")
MODEL.SET.lua.APLastWeatherN = WSTRING_MODEL(L"")
MODEL.SET.lua.APThemeChangerDebug = BOOL_MODEL(false)
MODEL.SET.lua.APThemeChangerSound = BOOL_MODEL(false)
MODEL.SET.lua.APThemeChangerWeather = BOOL_MODEL(false)
MODEL.SET.lua.APRealMeteo = BOOL_MODEL(false)
MODEL.SET.lua.APMode_Day_Scheme = INT_MODEL(0)
MODEL.SET.lua.APMode_Day_Sky = INT_MODEL(0)
MODEL.SET.lua.APMode_Night_Scheme = INT_MODEL(0)
MODEL.SET.lua.APMode_Night_Sky = INT_MODEL(0)
MODEL.SET.lua.APForceSeason = INT_MODEL(0)
MODEL.SET.lua.APForceMonthInt = INT_MODEL(0)
MODEL.SET.lua.APForceAlea = INT_MODEL(0)
MODEL.SET.lua.APForceWeatherD = INT_MODEL(0)
MODEL.SET.lua.APForceWeatherN = INT_MODEL(0)
MODEL.SET.lua.APLastWeatherD = WSTRING_MODEL(L"")
MODEL.SET.lua.APLastWeatherN = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.Val_Mode_Day_Scheme = WSTRING_MODEL(L"fixed|1000")
MODEL.SETPERSISTENT.lua.Val_Mode_Night_Scheme = WSTRING_MODEL(L"fixed|1000")
MODEL.SETPERSISTENT.lua.Val_Mode_Day_Sky = WSTRING_MODEL(L"fixed|1000")
MODEL.SETPERSISTENT.lua.Val_Mode_Night_Sky = WSTRING_MODEL(L"fixed|1000")
MODEL.SETPERSISTENT.lua.Val_ForceSeason = WSTRING_MODEL(L"no|1000")
MODEL.SETPERSISTENT.lua.Val_ForceMonth = WSTRING_MODEL(L"no|1000")
MODEL.SETPERSISTENT.lua.Val_ForceAlea = WSTRING_MODEL(L"no|1000")
MODEL.SETPERSISTENT.lua.Val_ForceWeatherD = WSTRING_MODEL(L"no|1000")
MODEL.SETPERSISTENT.lua.Val_ForceWeatherN = WSTRING_MODEL(L"no|1000")
MODEL.SETPERSISTENT.lua.SBdefaultDayMapColorProfile = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.SBdefaultNightMapColorProfile = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.SBSchemeChange = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.SBtcmajmeteo = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.vgotcar = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.VoirMeteo = BOOL_MODEL(false)
MODEL.SET.lua.APVoirMeteo = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.MeteoOn = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.MeteoIni = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.MeteoModOn = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.RealMeteo = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.SchemeMeteo = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.MeteoSound = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.MeteoSoundTTS = BOOL_MODEL(false)
MODEL.SET.lua.APMeteoSound = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.delvoirmeteo = INT_MODEL(500)
MODEL.SET.lua.APdelvoirmeteo = INT_MODEL(500)
MODEL.SETPERSISTENT.lua.typevoirmeteo = INT_MODEL(0)
MODEL.SET.lua.APtypevoirmeteo = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.typeforcemeteo = INT_MODEL(0)
MODEL.SET.lua.APtypeforcemeteo = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.winsystem = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.SbTransCapt = INT_MODEL(10)
MODEL.SETPERSISTENT.lua.SbTransVitLim = INT_MODEL(24)
MODEL.SETPERSISTENT.lua.SbTransBouss = INT_MODEL(20)
MODEL.SET.lua.AffichBoussole = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.SBChoixMenu = INT_MODEL(1)
MODEL.SETPERSISTENT.lua.ExcesVitesse = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.SbAffichTitre = BOOL_MODEL(true)
MODEL.SET.lua.Vitesse = INT_MODEL(50)
MODEL.SET.lua.VitesseZD = INT_MODEL(50)
MODEL.SET.lua.Hauteur = INT_MODEL(18)
MODEL.SET.lua.Largeur = INT_MODEL(20)
MODEL.SETPERSISTENT.lua.vdjOverViewEnable = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.vdjOverViewSound = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.vdjOverViewDistance = INT_MODEL(1000)
MODEL.SETPERSISTENT.lua.vdjOverViewZoom = INT_MODEL(1000)
MODEL.SETPERSISTENT.lua.OverviewSpeedcam = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.vOverviewON = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.vNorthUpRotation = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.bFollowRotation = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.SBCarPos2D = INT_MODEL(80)
MODEL.SETPERSISTENT.lua.SBCarPos3D = INT_MODEL(80)
MODEL.SETPERSISTENT.lua.SBOverviewSpeedMin = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.SBTypeOverview = INT_MODEL(1)
MODEL.SETPERSISTENT.lua.SBOverview3DTilt = INT_MODEL(76)
MODEL.SET.lua.SBpanman = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.SBbtpanman = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.vdjviewcompass = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.gboussole = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.vdjviewcompass_dest = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.vdjviewxenocompass = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.vdjviewxenocompass_dest = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.SBgerincl = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.SBTiltMax = INT_MODEL(65)
MODEL.SETPERSISTENT.lua.SBTiltMin = INT_MODEL(70)
MODEL.SETPERSISTENT.lua.SBZoom = INT_MODEL(250)
MODEL.SETPERSISTENT.lua.vAvoidUTurn = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.SBFiltreNuit = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.SBSetFiltreNuit = INT_MODEL(26)
MODEL.SETPERSISTENT.lua.SBPRView = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.sbgoNavigationTimeout = INT_MODEL(10)
MODEL.SETPERSISTENT.lua.sb_fixpda = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.sb_delayfixpda = INT_MODEL(100)
MODEL.SET.lua.TK_Radar_Auto = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.TKAlertLimit = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.SbNoAlertMob = BOOL_MODEL(false)
MODEL.SET.lua.sbVitesseRadar = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.wDynamicVolumeType = INT_MODEL(0)
MODEL.SETPERSISTENT.lua.wDynamicVolumeMaxSpeedGuidance = INT_MODEL(100)
MODEL.SETPERSISTENT.lua.wDynamicVolumeMasterMax = INT_MODEL(255)
MODEL.SETPERSISTENT.lua.wDynamicVolumeGuidanceMax = INT_MODEL(63)
MODEL.SETPERSISTENT.lua.wDASoundName = WSTRING_MODEL(L"!ding")
MODEL.SETPERSISTENT.lua.wDASoundVolume = INT_MODEL(70)
MODEL.SETPERSISTENT.lua.wSCOnly83 = BOOL_MODEL(false)
MODEL.SET.lua.wSettingDistOn = BOOL_MODEL(false)
MODEL.SET.lua.wSettingDistIcon = INT_MODEL(0)
MODEL.SET.lua.wSettingDistVisual = INT_MODEL(700)
MODEL.SET.lua.wSettingDistSound = INT_MODEL(700)
MODEL.SET.lua.wPoiGroupAltitude = INT_MODEL(0)
MODEL.SET.lua.wSettingDistSoundName = WSTRING_MODEL(L"")
MODEL.SET.lua.wReadOutDASupported = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wDestinationInfoTTS = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wPowerTTS = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wPowerACTTS = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wPowerBatteryTTS = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wPowerLowTTS = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wPowerCritTTS = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wStartExitTTSStart = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wStartExitTTSExit = BOOL_MODEL(false)
MODEL.SET.lua.wSettingDistTTSOn = BOOL_MODEL(false)
MODEL.SET.lua.wUltraSoundTTS = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wCockpitMenuTTS = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wWhereIAmTTSInfo = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wDATTSVoice = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wTurnRestrictionVoice = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wPowerACSoundName = WSTRING_MODEL(L"!ACPowerOn")
MODEL.SETPERSISTENT.lua.wPowerBatterySoundName = WSTRING_MODEL(L"!ACPowerOff")
MODEL.SETPERSISTENT.lua.wPowerLowSoundName = WSTRING_MODEL(L"!ACPowerLow")
MODEL.SETPERSISTENT.lua.wPowerCritSoundName = WSTRING_MODEL(L"!ACPowerCrit")
MODEL.SETPERSISTENT.lua.wPowerSoundVolume = INT_MODEL(150)
MODEL.SETPERSISTENT.lua.wDASS = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.wTurnRestriction = INT_MODEL(2)
MODEL.SET.lua.wReadOutSCSupported = BOOL_MODEL(false)
MODEL.SET.lua.wReadOutDASupported = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.wStartSoundName = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.wExitSoundName = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.wStartExitVolume = INT_MODEL(70)
MODEL.SETPERSISTENT.lua.wQuickKeyPanelsEnabled = BOOL_MODEL(false)
MODEL.SET.lua.wCurrentKeyPanel = WSTRING_MODEL(L"")
MODEL.SET.lua.wQuickKeyPanelSelected = WSTRING_MODEL(L"")
MODEL.SETPERSISTENT.lua.wQuickKeyPanel1 = WSTRING_MODEL(L"Cyrillic")
MODEL.SETPERSISTENT.lua.wQuickKeyPanel2 = WSTRING_MODEL(L"QWERTY")
MODEL.SETPERSISTENT.lua.BdReadOutCityName = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.BdReadOutCityNameExtend = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.TransBouttonArrow = INT_MODEL(16)
MODEL.SETPERSISTENT.lua.MinV = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.CockpitButtonHoms = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.CockpitButtonMedia = BOOL_MODEL(true)
MODEL.SETPERSISTENT.lua.CockpitButtonBas = INT_MODEL(2)
MODEL.SETPERSISTENT.lua.MenuEcranButton = BOOL_MODEL(true)
