scriptname minai_Actions extends Quest

; right now for the "COWER" action, mechanically activating the "IsIntimidated" flag
; if 'intimidated' context should include "do what ever the player orders"
; don't tell other npcs in PC pressence unless there is more NPC who rival and outnumber player+followers
; intimidation assumes a sort of "don't tell"

; de-intimidate if the NPC comes across the PC in bindings, arrested or defeated

minai_Util MinaiUtil
minai_AIFF aiff
minai_MainQuestController main
actor player
string playerName

; class for managing npc emotional expressions
minai_characterExpressions emotionalFacialExpressions

function Maintenance(minai_MainQuestController _main)
    main = _main
    aiff = (Self as Quest) as minai_AIFF
    MinaiUtil = (Self as Quest) as minai_Util
    MinaiUtil.Info("MinAI Actions are loading")
    emotionalFacialExpressions = (Self as Quest) as minai_characterExpressions
    player = Game.GetPlayer()
    playerName = main.GetActorName(player)
    
    ; cowering
    aiff.RegisterAction("ExtCmdCower", "Cower", "Cower before " + playerName + " due to " + playerName + "'s threats", "General", 1, 30, 2, 5, 300, True)
    aiff.RegisterAction("ExtCmdCeaseCower", "CeaseCower", "Cease cowering before " + playerName + "." , "General", 1, 30, 2, 5, 300, True)

    ; strip 
    ; have something to cower people into right
    aiff.RegisterAction("ExtCmdDisrobe", "Disrobe", "Take off all your clothes", "General", 1, 30, 2, 5, 300, True)
    aiff.RegisterAction("ExtCmdGetDressed", "GetDressed", "Put clothes on" , "General",  1, 30, 2, 5, 300, True)

    ; Event OnRegisterAction(string actionName, string actionPrompt, string mcmDescription, string targetDescription, string targetEnum, int enabled, float cooldown, int ttl)
    ;     Info("OnRegisterAction(" + actionName + " => " + enabled + " (Cooldown: " + cooldown + ")): " + actionPrompt)
    ;     if bHasCHIM
    ;           minCHIM.RegisterAction("ExtCmd"+actionName, actionName, mcmDescription, "External", enabled, cooldown, 2, 5, 300, true)
    ;       minCHIM.StoreAction(actionName, actionPrompt, enabled, ttl, targetDescription, targetEnum)
    ;     elseif bHasMantella
    ;       ; Nothing to do for mantella.
    ;     endif
    ;   EndEvent

EndFunction

Event CommandDispatcher(String speakerName,String  command, String parameter)
    if !bHasAIFF
        return
    EndIf
    Main.Debug("Actions - CommandDispatcher(" + speakerName +", " + command +", " + parameter + ")")
    ; i hope to figure out more actions we can gain from the game engine and add them here
    ; things like doFavor need more research
    
    ; for cowering
    if (command == "ExtCmdCower")
        Cower(speakerName)
        Main.RegisterEvent(speakerName + " is cowering before " + playerName)
    elseif (command == "ExtCmdCeaseCower")
        CeaseCower(speakerName)
        Main.RegisterEvent(speakerName + " has stopped cowering before " + playerName)
    EndIf
EndEvent

function Cower(string speakerName)
    Actor akActor = AIAgentFunctions.getAgentByName(speakerName)
    akActor.SetIntimidated(true)
    emotionalFacialExpressions.feelFear(akActor)
    emotionalFacialExpressions.feelSad(akActor)
endfunction

function CeaseCower(string speakerName)
    Actor akActor = AIAgentFunctions.getAgentByName(speakerName)
    akActor.SetIntimidated(true)
    emotionalFacialExpressions.feelAnger(akActor)
    emotionalFacialExpressions.feelDisgusted(akActor)
endfunction
