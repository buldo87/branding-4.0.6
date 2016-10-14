-- Fichier Medi@EvO AL194 & BULDO
-- MapChanger.lua   *****************
MODEL.SETPERSISTENT.lua.CurrentMap = INT_MODEL(3)
MODEL.SET.lua.fournisseur = CSTRING_MODEL("")

do
	MODEL.lua.fournisseur = sc_GetSysEntry("mapchanger", "fournisseur", "")
	if sc_GetSysEntry("mapchanger", "fournisseur", "")  == "here" then 
		MODEL.lua.CurrentMap = 1 
	end
	if sc_GetSysEntry("mapchanger", "fournisseur", "")  == "tomtom" then 
		MODEL.lua.CurrentMap = 0 
	end
	if sc_GetSysEntry("mapchanger", "fournisseur", "")  == "map" then 
		MODEL.lua.CurrentMap = 2 
	end
end

function sc_MapChanger_Onrelease()
	local param = "\"" .. "\\Storage card4\\NNG\\Utility\\mapChanger.mscr" .. "\"" .. " fournisseur=" .. "\"" .. MODEL.lua.CurrentMap() .. "\""
	START_APPLICATION("./Utility/Mortscript.exe", param)
	START_APPLICATION("./Utility/Restart_GPS/restart.exe", "")
end
function sc_MapChanger_Norestart()
	local param = "\"" .. "\\Storage card4\\NNG\\Utility\\mapChanger.mscr" .. "\"" .. " fournisseur=" .. "\"" .. MODEL.lua.CurrentMap() .. "\""
	START_APPLICATION("./Utility/Mortscript.exe", param)

end
function sc_MapChanger_Confirm()
sc_close_local_menu()
	if sc_GetSysEntry("mapchanger", "fournisseur", "")  == "map" then 
		MODEL.screen.msgbox.new.setup(1)
		MODEL.screen.msgbox.new.set_line(1, m_i18n("MapChanger tuning"))
		MODEL.screen.msgbox.new.set_line(2, m_i18n("TomTom maps not found"))
		MODEL.screen.msgbox.new.setup_button(1, "", m_i18n("Cancel"), "", "ico_cancel_mid.bmp#3")
		MODEL.screen.msgbox.create_new()
	else
		MODEL.screen.msgbox.new.setup(3)
		MODEL.screen.msgbox.new.set_line(1, m_i18n("Confirm switching the Maps Supplier"))
		MODEL.screen.msgbox.new.set_line(2, m_i18n("and restart GPS ?"))
		MODEL.screen.msgbox.new.setup_button(1, "sc_MapChanger_Onrelease", m_i18n("Yes"), "", "ico_done_mid.bmp#3")
		MODEL.screen.msgbox.new.setup_button(2, "sc_MapChanger_Norestart", m_i18n("No"), "","ico_done2_mid.bmp#3" )
		MODEL.screen.msgbox.new.setup_button(3, "", m_i18n("Cancel"), "", "ico_cancel_mid.bmp#3")
		MODEL.screen.msgbox.create_new()
	end
end