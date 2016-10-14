-- settingA.lua MEDI@EvO AL194 & BULDO

MODEL.SETPERSISTENT.lua.SURV = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.TRDM = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.BOUS = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.SPEA = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.VFlash = BOOL_MODEL(false)
MODEL.SETPERSISTENT.lua.MAP = BOOL_MODEL(false)

function sc_AboutMN_Onrelease()
	txtTitle.TEXT = m_i18n("")
	sc_NextStateAnim(st_AboutMN, "horz_scroll", 1, "")
end
createState("st_AboutMN")
st_AboutMN:useLayers(backgroundLayersNoFooter, ui_FooterAbout)
function sc_ShowMenuPlus()
	sc_NextStateAnim(st_MenuPlus, "horz_scroll", 1, "")
end


function sc_Memory_Onrelease()
	txtTitle.TEXT = m_i18n("About memory")
	sc_NextStateAnim(st_AboutMemory, "horz_scroll", 1, "")
end

createState("st_AboutMemory")
st_AboutMemory:useLayers(backgroundLayers, ui_AnimationLogo, ui_AboutMemory)
function sc_ShowMenuPlus()
	sc_NextStateAnim(st_MenuPlus, "horz_scroll", 1, "")
end

createState("st_MenuPlus")
st_MenuPlus:useLayers(backgroundLayers, ui_HorizontalMenu, ui_AnimationLogo, ui_ExeOut)
function st_MenuPlus.init()
	ui.vHorizontalMenuFilter = "menuplus"
	txtTitle:SET(m_i18n("Additional settings"))
end

