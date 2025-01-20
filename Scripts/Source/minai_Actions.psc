scriptname minai_Actions extends Quest

; right now for the "COWER" action, mechanically activating the "IsIntimidated" flag
; if 'intimidated' context should include "do what ever the player orders"
; don't tell other npcs in PC pressence unless there is more NPC who rival and outnumber player+followers
; intimidation assumes a sort of "don't tell"

; de-intimidate if the NPC comes across the PC in bindings, arrested or defeated

minai_Util MinaiUtil
minai_AIFF aiff
minai_MainQuestController main
minai_Arousal arousal
DefeatConfig Defeat
minai_ActionsLibrary actionsLibary


; actor player
Actor Property PlayerRef Auto ;
string playerName
bool bHasDefeat
bool bHasSimpleSlavery

Spell Property minai_SpellNPCDisrobes Auto
Spell Property minai_SpellNPCLosesClothes Auto

MagicEffect Property minai_MagicEffectNPCDisrobes Auto	
MagicEffect Property minai_MagicEffectNPCLosesClothes Auto

; actions have consequences... and the game doesn't save changes to NPC's AI Attributes between saves
; so we need to record new values and update them accordingly
; the granularity on these is not much, so when AI actions are driving changes in value the actions ought to have been dramatic 
Formlist MinaiUndressedNPCs

actor[] ActorList
int[] MoralityList
int[] AggressionList
int[] ConfidenceList
int[] AssistanceList
bool[] updatedSinceLastSaveLoad

function addActor(actor akActor)
    actor[] newlist = new actor[ActorList.Length + 1]
    int[] newMoralityList = new int[ActorList.Length + 1]
    int[] newAggressionList = new int[ActorList.Length + 1]
    int[] newConfidenceList = new int[ActorList.Length + 1]
    int[] newAssistanceList = new int[ActorList.Length + 1]
    int[] newUpdatedSinceLastSaveLoad = new int[ActorList.Length + 1]
    
    int i = 0
    while i < ActorList.Length 
        newList[i] = ActorList[i]
        newMoralityList[i] = MoralityList[i]
        newAggressionList[i] = AggressionList[i]
        newConfidenceList[i] = ConfidenceList[i]
        newAssistanceList[i] = AssistanceList[i]
        newUpdatedSinceLastSaveLoad[i] = updatedSinceLastSaveLoad[i]        
        i += 1
    endWhile
    newList[newList.Length - 1] = akActor
    newMoralityList[newList.Length - 1] = akActor.GetActorValue("Morality")
    newAggressionList[newList.Length - 1] = akActor.GetActorValue("Aggression")
    newConfidenceList[newList.Length - 1] = akActor.GetActorValue("Confidence")
    newAssistanceList[newList.Length - 1] = akActor.GetActorValue("Assistance")
    updatedSinceLastSaveLoad[newList.Length - 1] = true
    ActorList = newList
    MoralityList = newMoralityList
    AggressionList = newAggressionList
    ConfidenceList = newConfidenceList
    AssistanceList = newAssistanceList       
endFunction

function Maintenance(minai_MainQuestController _main)
    main = _main
    aiff = (Self as Quest) as minai_AIFF
    MinaiUtil = (Self as Quest) as minai_Util
    MinaiUtil.Info("MinAI Actions are loading")
    arousal = (Self as Quest) as minai_Arousal
    playerName = main.GetActorName(playerRef)
    actionsLibary = (Self as Quest) as minai_ActionsLibrary
    bHasDefeat = (Game.GetModByName("SexlabDefeat.esp") != 255)
    if bHasDefeat
        Defeat = DefeatUtil.GetDefeat()
    EndIf
    bHasSimpleSlavery = (Game.GetModByName("SimpleSlavery.esp") != 255)
    ; enslave player if player is too drunk maybe??
    ; check on character's ethos

    ; aiff.RegisterAction("ExtCmdHug", "Hug", "Hug the target", "General", 1, 120, 2, 5, 300, bHasSLapp)
    ; string actionName, string mcmName, string mcmDesc, string mcmPage, int enabled, float interval, float exponent, int maxInterval, float decayWindow, bool hasMod, bool forceUpdate=false)
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

function SetContext(actor akActor)
    examineActor(akActor)
    string actorName = main.GetActorName(akActor)
    bool bIsIntimidated = akActor.IsIntimidatedbyPlayer()
    bool bWouldBeIntimidated = akActor.GetIntimidateSuccess()

    bool isPlayerHumbled = false
    bool isDefeated = false
   
    if bHasDefeat 
        isDefeated = Defeat.IsDefeatActive(akTarget)
        isPlayerHumbled = Defeat.IsDefeatActive(playerRef)
    endif
    ; what action would this character take next?
    if(bIsIntimidated && !isPlayerHumbled)
        aiff.RegisterAction("ExtCmdGrovel", "Grovel", "Grovel before " + playerName, actorName, 1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdDisrobe", "Disrobe", "Take off all your clothes", actorName, 1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdGetDressed", "GetDressed", "Put your clothes on" , actorName,  1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdFreezeInTerror", "FreezeInTerror", "Freeze in terror", actorName,  1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdConcedeInventory", "ConcedeInventory", "Give up all your material goods", actorName,  1, 30, 2, 5, 300, True)
    endIf

    if(bWouldBeIntimidated && !bIsIntimidated)
        aiff.RegisterAction("ExtCmdCower", "Cower",  "Cower before " + playerName + " due to threats", actorName, 1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdFreezeInTerror", "FreezeInTerror", "Freeze in terror", actorName,  1, 30, 2, 5, 300, True)
    endif
    if(isPlayerHumbled && bIsIntimidated)
        aiff.RegisterAction("ExtCmdCeaseCower", "CeaseCower", "Cease cowering before " + playerName + "." , actorName, 1, 30, 2, 5, 300, True)
    endif

    ; is a percent score, 1-100
    int arousalScore = arousal.GetActorArousal(akActor)
    if(arousalScore >= 70)
        ; undress doesn't throw clothes on floor
        aiff.RegisterAction("ExtCmdUndress", "Undress", "Take off all your clothes", actorName, 1, 30, 2, 5, 300, True)
    endif
endfunction







; for handling the fact that changes to AI values don't persist across saves,we'll 
; reimprint the actors when they come back on the scene via AIFF setcontext
function examineActor(actor akActor)
    int index = ActorList.find(akActor)
    if(index<0)
        ; nothing worth doing
    else 
        if(!updatedSinceLastSaveLoad[index])
            akActor.SetActorValue("Morality") = MoralityList[index]
            akActor.SetActorValue("Aggression") = AggressionList[index]
            akActor.SetActorValue("Confidence") = ConfidenceList[index]
            akActor.SetActorValue("Assistance") = AssistanceList[index]
            updatedSinceLastSaveLoad[index] = true
        endif
    endif
endfunction


; flag NPCs as having been umimprinted with their updated AI attributes
; after loading from save
Event OnPlayerLoadGame()
    int i = 0
    while i < updatedSinceLastSaveLoad.Length
        updatedSinceLastSaveLoad[i] = false
        i += 1
    endwhile
endEvent


    ; Changes to the below actor values, if modified with SetActorValue - Actor for instance, will not persist in consecutive saves. 
    ; SendAssaultAlarm()

    ; SendModEvent("PlayerRefEnslaved")

;  drug the player???

        ; will be set to restrained, then will follow PC
        
        ; aiff.RegisterAction("ExtCmdCower", "Cower",  "Cower before " + playerName + " due to threats", "General", 1, 30, 2, 5, 300, True)

        ;  ; cowering
;  aiff.RegisterAction("ExtCmdCower", "Cower", "Cower before " + playerName + " due to threats", "General", 1, 30, 2, 5, 300, True)
;  ; those those who have already been cowered
;  ; for those finding their bravery
;  ; strip - have something to cower people into right
;  ; get dressed again
;  ; look pitiful for when the player is done with them


; SetDontMove(Bool abDontMove)

;     Flags/unflags this actor as "don't move".

; https://ck.uesp.net/wiki/GetKnockedStateGetKnockedState
; Jump to navigation
; Jump to search

; This function returns 1 if the run-on entity is an actor and is knocked down for any reason (e.g. paralysis or being ragdolled). The function returns 0 otherwise.
; Categories:

;     Console CommandsCondition Functions

; Game.GetPlayer().UnequipAll()

; Prisoner.SetRestrained()


; ; Set the prisoner's outfit to rags
; Prisoner.SetOutfit(RagsOutfit)


; ; Set the prisoner's sleep outfit to rags too
; Prisoner.SetOutfit(RagsOutfit, true)



Event CommandDispatcher(String speakerName,String  command, String parameter)
    if !bHasAIFF
        return
    EndIf
    actor akActor = AIAgentFunctions.getAgentByName(speakerName)
    Main.Debug("Actions - CommandDispatcher(" + speakerName +", " + command +", " + parameter + ")")
    ; for cowering
    if (command == "ExtCmdCower")
        actionsLibary.Cower(akActor)
        Main.RegisterEvent(speakerName + " is cowering before " + playerName)
    elseif (command == "ExtCmdCeaseCower")
        actionsLibary.CeaseCower(akActor)
        Main.RegisterEvent(speakerName + " has stopped cowering before " + playerName)
    elseif (command == "ExtCmdGrovel")
        Main.RegisterEvent(speakerName + " begins groveling before " + playerName)
    elseif (command == "ExtCmdDisrobe") ; retains clothes
        actionsLibary.Disrobe(akActor)    
        Main.RegisterEvent(speakerName + " begins to disrobe.")
    elseif (command == "ExtCmdDisrobeItimidated")
        actionsLibary.LoseClothes(akActor)
        Main.RegisterEvent(speakerName + " in a panic throws off their possessions.")
    elseif (command == "ExtCmdConcedeInventory") ; retains clothes
        actionsLibary.ConcedeInventory(akActor)    
        Main.RegisterEvent(speakerName + " concedes all their possessions.")
    elseif (command == "ExtCmdGetDressed") 
        Main.RegisterAction(speakerName + " begins to get dressed.")
    elseif (command == "ExtCmdFreezeInTerror")
        actionsLibary.Restrain()
        Main.RegisterAction(speakerName + " freezes in terror.")
    EndIf
EndEvent
