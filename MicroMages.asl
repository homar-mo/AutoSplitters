// Micro Mages Autosplitter
// Author : Mo
// Date   : 2019-05-17

state("fceux")
{
	byte passchar1 : 0x436B04, 0x04; // 1-9
	byte passchar2 : 0x436B04, 0x05; // 1-9
	byte passchar3 : 0x436B04, 0x06; // 1-9
	byte passchar4 : 0x436B04, 0x07; // 1-9
	byte level     : 0x436B04, 0xBC; // Max 13 (0x0D)
	byte gamestate : 0x436B04, 0x71; // Game State (1: Play, 2: Pause)
}
state("nestopia")
{
	// base 0x0000 address of ROM : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x68;
	// just add your fceux offset to 0x68 to get the final nestopia offset
	byte passchar1 : "nestopia.exe", 0x1B2BCC, 0, 8, 0xc, 0xc, 0x6C; // 1-9
	byte passchar2 : "nestopia.exe", 0x1B2BCC, 0, 8, 0xc, 0xc, 0x6D; // 1-9
	byte passchar3 : "nestopia.exe", 0x1B2BCC, 0, 8, 0xc, 0xc, 0x6E; // 1-9
	byte passchar4 : "nestopia.exe", 0x1B2BCC, 0, 8, 0xc, 0xc, 0x6F; // 1-9
	byte level     : "nestopia.exe", 0x1B2BCC, 0, 8, 0xc, 0xc, 0x124; // Max 13 (0x0D)
	byte gamestate : "nestopia.exe", 0x1B2BCC, 0, 8, 0xc, 0xc, 0xD9; // Game State (1: Play, 2: Pause)
}

startup
{

	//settings.SetToolTip("onLevelEnd", "Splits on score screen after finish a level");

	settings.Add("Options", true, "Options");

		settings.Add("OnLevel", true, "Split every level", "Options");
		settings.SetToolTip("OnLevel", "If use this the option below is not needed.");

		settings.Add("OnTower", true, "Split after boss", "Options");
		settings.SetToolTip("OnTower", "Use this to split after defeat the tower's boss.");

		settings.Add("AllowPause", false, "Allow Pause", "Options");
		settings.SetToolTip("AllowPause", "Use this to puese the timer when the game is puased (only for Game Time).");
}

init
{
	refreshRate = 60;
}

start
{

	var pass = current.passchar1.ToString() + current.passchar2.ToString() + current.passchar3.ToString() + current.passchar4.ToString();

	if ((current.level == 0x00 && pass == "1511") || // Tower 1-1 (Normal Mode)
		(current.level == 0x03 && pass == "2869") || // Tower 2-1 (Normal Mode)
		(current.level == 0x06 && pass == "3645") || // Tower 3-1 (Normal Mode)
		(current.level == 0x09 && pass == "7641") || // Tower 4-1 (Normal Mode)
		(current.level == 0x00 && pass == "1394") || // Tower 1-1 (Hard Mode)
		(current.level == 0x03 && pass == "6411") || // Tower 2-1 (Hard Mode)
		(current.level == 0x06 && pass == "4913") || // Tower 3-1 (Hard Mode)
		(current.level == 0x09 && pass == "2556") || // Tower 4-1 (Hard Mode)
		(current.level == 0x00 && pass == "7195"))   // Tower 1-1 (Hell Mode)
	{
		return true;
	}
}

reset
{
	var pass = current.passchar1.ToString() + current.passchar2.ToString() + current.passchar3.ToString() + current.passchar4.ToString();

	if (current.level == 0x00 && pass == "0000") { return true; }
}

isLoading 
{
	if (settings["AllowPause"])
	{
		if (current.gamestate == 0x02)
		{
			return true; 
		}
		else if (current.gamestate == 0x01)
		{
			return false;
		}
	}
	else
	{
		return false;
	}
}

update
{
	
}

split
{
	var pass = current.passchar1.ToString() + current.passchar2.ToString() + current.passchar3.ToString() + current.passchar4.ToString();

	if (settings["OnLevel"])
	{
		if (current.level == (old.level + 0x01)) { return true; }
		else if ((current.level == 0x00 && old.level == 0x0C) && pass == "1394") { return true; }
	}
	else if (settings["OnTower"])
	{
		if ((old.level == 0x02 && current.level == 0x03 && pass == "2869") || // Tower 1 (Normal Mode) | Boss, tower 1-3
			(old.level == 0x05 && current.level == 0x06 && pass == "3645") || // Tower 2 (Normal Mode) | Boss, tower 2-3
			(old.level == 0x08 && current.level == 0x09 && pass == "7641") || // Tower 3 (Normal Mode) | Boss, tower 3-3
			(old.level == 0x0D && current.level == 0x00 && pass == "1394") || // Tower 4 (Normal Mode) | Boss, tower 4-4
			(old.level == 0x02 && current.level == 0x03 && pass == "6411") || // Tower 1 (Hard Mode)   | Boss, tower 1-3•
			(old.level == 0x05 && current.level == 0x06 && pass == "4913") || // Tower 2 (Hard Mode)   | Boss, tower 2-3•
			(old.level == 0x08 && current.level == 0x09 && pass == "2556") || // Tower 3 (Hard Mode)   | Boss, tower 3-3•
			(old.level == 0x0D && current.level == 0x0E && pass == "2556") || // Tower 4 (Hard Mode)   | Final Boss (Shoot'em up part)
			(old.level == 0x02 && current.level == 0x03 && pass == "7195") || // Tower 1 (Hell Mode)   | Boss, tower 1-3•
			(old.level == 0x05 && current.level == 0x06 && pass == "7195") || // Tower 2 (Hell Mode)   | Boss, tower 2-3•
			(old.level == 0x08 && current.level == 0x09 && pass == "7195") || // Tower 3 (Hell Mode)   | Boss, tower 3-3•
			(old.level == 0x0C && current.level == 0x0E && pass == "7195"))   // Tower 4 (Hell Mode)   | Final Boss (Shoot'em up part)
		{
			return true;
		}
	}

}