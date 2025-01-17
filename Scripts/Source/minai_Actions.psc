scriptname minai_Actions extends Quest

; right now for the "COWER" action, mechanically activating the "IsIntimidated" flag
; if 'intimidated' context should include "do what ever the player orders"
; don't tell other npcs in PC pressence unless there is more NPC who rival and outnumber player+followers
; intimidation assumes a sort of "don't tell"

; de-intimidate if the NPC comes across the PC in bindings, arrested or defeated
; inform LLM context if player would intimidate the NPC if player desired in the ACTION description

minai_Util MinaiUtil
minai_AIFF aiff
minai_MainQuestController main
actor player
string playerName

function Maintenance(minai_MainQuestController _main)
    main = _main
    aiff = (Self as Quest) as minai_AIFF
    MinaiUtil = (Self as Quest) as minai_Util
    MinaiUtil.Info("MinAI Actions are loading")
    player = Game.GetPlayer()
    playerName = main.GetActorName(player)
    ; cowering

    aiff.RegisterAction("ExtCmdCower", "Cower", "Cower before " + playerName + " due to " + playerName + "'s threats", "General", 1, 30, 2, 5, 300, True)
    aiff.RegisterAction("ExtCmdCeaseCower", "CeaseCeaseCower", "Cease cowering before " + playerName + "." , "General", 1, 0, 2, 5, 60, True)

EndFunction

Event CommandDispatcher(String speakerName,String  command, String parameter)
    if !bHasAIFF
        return
    EndIf
    Main.Debug("Actions - CommandDispatcher(" + speakerName +", " + command +", " + parameter + ")")
    if (command == "ExtCmdStartLooting")
        StartLooting()
        Main.RegisterEvent(speakerName + " started looting the area")
    elseif (command == "ExtCmdStopLooting")
        StartLooting()
        Main.RegisterEvent(speakerName + " stopped looting the area")
    EndIf
EndEvent



