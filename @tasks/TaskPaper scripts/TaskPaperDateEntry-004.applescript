property pTitle : "Natural language entry of TaskPaper dates"property pVer : "0.04"property pblnPaste : trueproperty pOK : "OK"property pCancel : "Cancel"property pstrDefault : "now"property pblnTime : true---- To install Mike Taylor and Darshana Chhajed's Python parsedatetime module:-- 	Visit https://github.com/bear/parsedatetime--  		(Licence: https://github.com/bear/parsedatetime/blob/master/LICENSE.txt)--	Download and expand https://github.com/bear/parsedatetime/archive/master.zip--	in Terminal.app cd to the unzipped folder --	(e.g. type cd + space and drag/drop the folder to the Terminal.app command line, then tap return)--	sudo python setup.py installon run	set {strPhrase, blnEsc} to {pstrDefault, false}	--tell application "System Events"	--	set strAPP to item 1 of (get name of processes whose frontmost is true) -- for restoring focus post dialog	--end tell		tell application "TaskPaper"		repeat until blnEsc			set strDefaultTime to my ParseTime(strPhrase, pblnTime)			if pblnTime then				set strTime to "Exclude time"			else				set strTime to "Include time"			end if			try								activate				tell (display dialog "Result in Clipboard:" & tab & strDefaultTime default answer strPhrase buttons {pCancel, strTime, pOK} ¬					cancel button pCancel default button pOK with title pTitle & "  ver. " & pVer)					set {strButton, strPhrase} to {button returned, text returned}					set blnEsc to strButton = pOK					if not blnEsc then set pblnTime to not pblnTime					set strDefaultTime to my ParseTime(strPhrase, pblnTime)				end tell			on error				set blnEsc to true			end try		end repeat		set lstDocs to documents		if lstDocs ≠ {} then			set oDoc to item 1 of lstDocs		end if			end tell	-- tell application strAPP to activate -- restore the focus lost to the dialog (lest we lose the expanded text)		set the clipboard to strDefaultTime		if pblnPaste then		tell application "System Events"			try				click my GetMenuItem("TkPr", {"Edit", "Paste"})			end try		end tell	end if	-- do shell script ("sleep .1")end run-- Use Mike Taylor and Darshana Chhajed's Python parsedatetime module -- to get a parse of a natural language expression as a series of integers {year, month, day, hour, minute}-- (defaults, if parse fails, to current time)on ParseTime(strPhrase, blnTime)	set strTime to ""	if blnTime then set strTime to " %H:%M"		set str to do shell script ¬		"python -c 'import sys, time, parsedatetime as pdt; print time.strftime(\"%Y-%m-%d" & ¬		strTime & "\", time.struct_time(pdt.Calendar().parse(sys.argv[1])[0]))' " & ¬		quoted form of strPhraseend ParseTime-- RETURNS A REFERENCE TO A CLICKABLE MENU ITEM-- E.G. set mnuZoomFit to GetMenuItem("OGfl", {"View", "Zoom", "Zoom to Selection"})-- RETURNS A REFERENCE TO A CLICKABLE MENU ITEM-- E.G. set mnuZoomFit to GetMenuItem("OGfl", {"View", "Zoom", "Zoom to Selection"})on GetMenuItem(strAppCode, lstMenu)	set lngChain to length of lstMenu	if lngChain < 2 then return missing value		tell application "System Events"		set lstApps to application processes where its creator type = strAppCode		if length of lstApps < 1 then return missing value		tell first item of lstApps			-- GET THE TOP LEVEL MENU			set strMenu to item 1 of lstMenu			set oMenu to menu strMenu of menu bar item strMenu of menu bar 1						-- TRAVEL DOWN THROUGH ANY SUB-MENUS			repeat with i from 2 to (lngChain - 1)				set strMenu to item i of lstMenu				set oMenu to menu strMenu of menu item strMenu of oMenu			end repeat						-- AND RETURN THE FINAL MENU ITEM (OR MISSING VALUE, IF UNAVAILABLE)			try				return menu item (item -1 of lstMenu) of oMenu			on error				return missing value			end try		end tell	end tellend GetMenuItemon GUIEnabled()	tell application "System Events"		if UI elements enabled then			return true		else			activate			display dialog "This script depends on enabling access for assistive devices in system preferences" buttons "OK" default button "OK" with title pTitle & "   " & pVer			tell application "System Preferences"				activate				set current pane to pane id "com.apple.preference.universalaccess"			end tell			return false		end if	end tellend GUIEnabled