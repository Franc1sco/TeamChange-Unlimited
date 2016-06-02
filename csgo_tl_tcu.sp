// some code of "Team Limit Bypass" by zephyrus

#include <sourcemod>
#include <sdktools>
#include <cstrike>

new g_iTSpawns=-1;
new g_iCTSpawns=-1;

public Plugin:myinfo = 
{
	name = "[CSGO] Team Limit Bypass and TeamChange Unlimited",
	author = "Franc1sco franug",
	description = "Features of teamlimits and teamchange unlimited",
	version = "2.0",
	url = ""
};

public OnPluginStart()
{
	AddCommandListener(Command_JoinTeam, "jointeam"); 
}

public OnMapStart()
{
	// Give plugins a chance to create new spawns
	CreateTimer(0.5, Timer_OnMapStart, _, TIMER_FLAG_NO_MAPCHANGE);
}

public Action:Timer_OnMapStart(Handle:timer, any:data)
{
	g_iTSpawns=0;
	g_iCTSpawns=0;

	new ent = -1;
	while((ent = FindEntityByClassname(ent, "info_player_counterterrorist")) != -1) ++g_iCTSpawns;
	ent = -1;
	while((ent = FindEntityByClassname(ent, "info_player_terrorist")) != -1) ++g_iTSpawns;
}

public Action:Command_JoinTeam(client, const String:command[], argc)
{
	if(!argc || !client || !IsClientInGame(client))
		return Plugin_Continue;

	decl String:m_szTeam[8];
	GetCmdArg(1, m_szTeam, sizeof(m_szTeam));
	new m_iTeam = StringToInt(m_szTeam);

	if((CS_TEAM_SPECTATOR<=m_iTeam<=CS_TEAM_CT) && GetClientTeam(client) != m_iTeam)
	{
		new m_iTs = GetTeamClientCount(CS_TEAM_T);
		new m_iCTs = GetTeamClientCount(CS_TEAM_CT);
		
		if(CS_TEAM_T == m_iTeam && m_iTs < g_iTSpawns) ChangeClientTeam(client, m_iTeam);
		else if(CS_TEAM_CT == m_iTeam && m_iCTs < g_iCTSpawns) ChangeClientTeam(client, m_iTeam);
		else if(CS_TEAM_SPECTATOR == m_iTeam) ChangeClientTeam(client, m_iTeam);
		
		return Plugin_Handled;
	}
	return Plugin_Continue;
}