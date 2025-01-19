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
actor player
string playerName
bool bHasDefeat
bool bHasSimpleSlavery

; actions have consequences... and the game doesn't save changes to NPC's AI Attributes between saves
; so we need to record new values and update them accordingly

actor[] ActorList
int[] MoralityList
int[] AggressionList
int[] ConfidenceList
int[] AssistanceList
bool[] updatedSinceLastSaveLoad


; class for managing npc emotional expressions
minai_characterExpressions emotionalFacialExpressions


Bool Function HaveSimpleSlavery()
    Int ssIndex = 
    Return 255 != ssIndex
EndFunction

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

int[] function extendIntArray(int val, int[] intArray)
    int[] newArray = new int[intArray.Length + 1]
    int i = 0
    while i < intArray.Length
        newArray[i] = intArray[i]
        i += 1
    endWhile
    newArray[newArray.Length - 1] = val
    return newArray
endFunction


function Maintenance(minai_MainQuestController _main)
    main = _main
    aiff = (Self as Quest) as minai_AIFF
    MinaiUtil = (Self as Quest) as minai_Util
    MinaiUtil.Info("MinAI Actions are loading")
    arousal = (Self as Quest) as minai_Arousal
    emotionalFacialExpressions = (Self as Quest) as minai_characterExpressions
    player = Game.GetPlayer()
    playerName = main.GetActorName(player)
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

    bool isPlayerHumbled = false playerRef.   

    bool isDefeated = false
   
    if bHasDefeat 
        isDefeated = Defeat.IsDefeatActive(akTarget)
        isPlayerHumbled = Defeat.IsDefeatActive(playerRef)
    endif
    ; what action would this character take next?
    if(bIsIntimidated && !isPlayerHumbled)
        aiff.RegisterAction("ExtCmdGrovel", "Grovel", "Grovel before " + playerName, actorName, 1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdAllowArrest", "AllowRestraints",  "Allow self to be restrained", actorName, 1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdDisrobe", "Disrobe", "Take off all your clothes", actorName, 1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdLookPitiful", "BeMeek", "Look meek and pitiful, start begging to assuage the player" , actorName,  1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdGetDressed", "GetDressed", "Put your clothes on" , actorName,  1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdFreezeInTerror", "FreezeInTerror", "Freeze in terror", actorName,  1, 30, 2, 5, 300, True)
    endIf

    if(bWouldBeIntimidated && !bIsIntimidated)
        aiff.RegisterAction("ExtCmdCower", "Cower",  "Cower before " + playerName + " due to threats", actorName, 1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdFreezeInTerror", "FreezeInTerror", "Freeze in terror", actorName,  1, 30, 2, 5, 300, True)
    endif
    if(isPlayerHumbled && bIsIntimidated)
        aiff.RegisterAction("ExtCmdCeaseCower", "CeaseCower", "Cease cowering before " + playerName + "." , actorName, 1, 30, 2, 5, 300, True)
    endif

    ; disrobe cause horny
    ; is a percent score, 1-100
    int arousalScore = arousal.GetActorArousal(akActor)
    if(arousalScore >= 70)
        ; undress doesn't throw clothes on floor
        aiff.RegisterAction("ExtCmdDisrobe", "Undress", "Take off all your clothes", actorName, 1, 30, 2, 5, 300, True)
    endif
endfunction




; lower morality
; by game mechanics this only impacts followers 
; but by describing this to the LLMs it can be made informative
function degenerate(actor akActor)
    int index = ActorList.find(akActor)
    if(index>-1)
        MoralityList[index] = MoralityList[index] - 1
        if(MoralityList[index]<0) 
            MoralityList[index] = 0
        Endif
        akActor.SetActorValue("Morality") = MoralityList[index]
    else 
        addActor(akActor)
        MoralityList[MoralityList.Length - 1] = MoralityList[MoralityList.Length] - 1
        if(MoralityList[MoralityList.Length - 1]<0) 
            MoralityList[MoralityList.Length - 1] = 0
        Endif
        akActor.SetActorValue("Morality") = MoralityList[MoralityList.Length - 1]
    endif
endFunction



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
    Main.Debug("Actions - CommandDispatcher(" + speakerName +", " + command +", " + parameter + ")")
    ; for cowering
    if (command == "ExtCmdCower")
        Cower(speakerName)
        Main.RegisterEvent(speakerName + " is cowering before " + playerName)
    elseif (command == "ExtCmdCeaseCower")
        CeaseCower(speakerName)
        Main.RegisterEvent(speakerName + " has stopped cowering before " + playerName)
    elseif (command == "ExtCmdGrovel")
        Main.RegisterEvent(speakerName + " begins groveling before " + playerName)
    elseif (command == "ExtCmdDisrobe")
        Disrobe(speakerName)    
        Main.RegisterEvent(speakerName + " begins to disrobe.")
    elseif (command == "ExtCmdGetDressed") 
        Main.RegisterAction(speakerName + " begins to get dressed.")
    elseif (command == "ExtCmdLookPitiful")
        Main.RegisterAction(speakerName + " looks absolutely pitiful.")
    elseif (command == "ExtCmdFreezeInTerror")
        Main.RegisterAction(speakerName + " freezes in terror.")
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

function Disrobe(string speakerName)
    ; they only get as naked as your mods allow, ergo sfw
    Actor akActor = AIAgentFunctions.getAgentByName(speakerName)
    Armor helmetArmor = akActor.GetEquippedArmorInSlot(30)
    Armor torsoArmor = akActor.GetEquippedArmorInSlot(32)
    Armor shoesArmor = akActor.GetEquippedArmorInSlot(37)
    Armor shieldArmor = akActor.GetEquippedArmorInSlot(39)
    Armor handsArmor = akActor.GetEquippedArmorInSlot(33)
    Armor forearmsArmor = akActor.GetEquippedArmorInSlot(34)
    Armor ringArmor = akActor.GetEquippedArmorInSlot(36)
    Armor calvesArmor = akActor.GetEquippedArmorInSlot(38)  
    Armor earsArmor = akActor.GetEquippedArmorInSlot(43)
    Armor circletArmor = akActor.GetEquippedArmorInSlot(42)
    akActor.UnequipAll()

    ; gear goes to floor in front of player
    if(helmetArmor)
        akActor.RemoveItem(helmetArmor,1)
        playerRef.PlaceAtMe(helmetArmor)
    endif
    if(torsoArmor)
        akActor.RemoveItem(torsoArmor,1)
        playerRef.PlaceAtMe(torsoArmor)
    endif
    if(shoesArmor)
        akActor.RemoveItem(shoesArmor,1)
        playerRef.PlaceAtMe(shoesArmor)
    endif
    if(shieldArmor)
        akActor.RemoveItem(shieldArmor,1)
        playerRef.PlaceAtMe(shieldArmor)
    endif
    if(handsArmor)
        akActor.RemoveItem(handsArmor,1)
        playerRef.PlaceAtMe(handsArmor)
    endif
    if(forearmsArmor)
        akActor.RemoveItem(forearmsArmor,1)
        playerRef.PlaceAtMe(forearmsArmor)
    endif
    if(ringArmor)
        akActor.RemoveItem(ringArmor,1)
        playerRef.PlaceAtMe(ringArmor)
    endif
    if(calvesArmor)
        akActor.RemoveItem(calvesArmor,1)
        playerRef.PlaceAtMe(calvesArmor)
    endif
    if(earsArmor)
        akActor.RemoveItem(earsArmor,1)
        playerRef.PlaceAtMe(earsArmor)
    endif
    if(circletArmor)
        akActor.RemoveItem(circletArmor,1)
        playerRef.PlaceAtMe(circletArmor)
    endif
endFunction
