-- Fichier Medi@EvO AL194 & BULDO
-- UXManager.lua   *****************

function sc_UXManager_Onrelease()
	START_APPLICATION("./Utility/UXManager/Autorun.exe", "") 	
	doDelayed(300, function() 
		local newMsgBox = MODEL.screen.msgbox.new
		newMsgBox.setup( 3 )
		newMsgBox.set_line( 1, m_i18n("Your preferences will change the next launch of GPS") )
		newMsgBox.set_line( 2, m_i18n("Restart GPS now ?"))
		newMsgBox.setup_button( 1, "sc_restart", m_i18n("Ok"), "","ico_done_mid.bmp#3" )
		newMsgBox.setup_button( 2, "", m_i18n("No"), "","ico_done2_mid.bmp#3" )
		newMsgBox.setup_button( 3, "sc_Annulation", m_i18n("Cancel"), "","ico_cancel_mid.bmp#3" )
		MODEL.screen.msgbox.create_new()
		end
	)
end
function sc_Annulation()
START_APPLICATION("./Utility/UXManager/Annulation.exe", "")
end

function sc_restart()
START_APPLICATION("./Utility/Restart_GPS/restart.exe", "")
end