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

; class for managing npc emotional expressions
minai_characterExpressions emotionalFacialExpressions


Bool Function HaveSimpleSlavery()
    Int ssIndex = 
    Return 255 != ssIndex
EndFunction


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
    string actorName = main.GetActorName(akActor)
    bool bIsIntimidated = akActor.IsIntimidatedbyPlayer()
    bool bWouldBeIntimidated = akActor.GetIntimidateSuccess()

    bool isPlayerHumbled = false playerRef.   

    bool isDefeated = false
    ; what action would this character take next?
   
    if bHasDefeat 
        isDefeated = Defeat.IsDefeatActive(akTarget)
        isPlayerHumbled = Defeat.IsDefeatActive(playerRef)
    endif

    if isPlayerHumbled
        if bIsIntimidated
            aiff.RegisterAction("ExtCmdCeaseCower", "CeaseCower", "Cease cowering before " + playerName + "." , actorName, 1, 30, 2, 5, 300, True)
        endif
    endif

    if(bIsIntimidated)
        aiff.RegisterAction("ExtCmdGrovel", "Grovel", "Grovel before " + playerName + " due to " + playerName + "'s threats", actorName, 1, 30, 2, 5, 300, True)
        ; aiff.RegisterAction("ExtCmdCeaseCower", "CeaseCower", "Cease cowering before " + playerName + "." , actorName, 1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdAllowArrest", "AllowRestraints",  "Allow self to be restrained", actorName, 1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdDisrobe", "Disrobe", "Take off all your clothes", actorName, 1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdLookPitiful", "BeMeek", "Look meek and pitiful to assuage the player" , actorName,  1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdGetDressed", "GetDressed", "Put your clothes on" , actorName,  1, 30, 2, 5, 300, True)
        aiff.RegisterAction("ExtCmdFreezeInTerror", "FreezeInTerror", "Freeze in terror", actorName,  1, 30, 2, 5, 300, True)
    endIf
    if(bWouldBeIntimidated && !bIsIntimidated)
        aiff.RegisterAction("ExtCmdCower", "Cower",  "Cower before " + playerName + " due to threats", actorName, 1, 30, 2, 5, 300, True)
    endif
    if(isPlayerHumbled && bIsIntimidated)
        aiff.RegisterAction("ExtCmdCeaseCower", "CeaseCower", "Cease cowering before " + playerName + "." , actorName, 1, 30, 2, 5, 300, True)
    endif

    ; is a percent score, 1-100
    int arousalScore = arousal.GetActorArousal(akActor)
    if(arousalScore >= 70)
        aiff.RegisterAction("ExtCmdDisrobe", "Disrobe", "Take off all your clothes", actorName, 1, 30, 2, 5, 300, True)
    endif

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

; Aggression
; Related to faction relations , will determine when the actor will initiate combat.
; Type 	Value 	Description
; Unaggressive 	0 	Will not initiate combat.
; Aggressive 	1 	Will attack enemies on sight.
; Very Aggressive 	2 	Will attack enemies and neutrals on sight.
; Frenzied 	3 	Will attack anyone on sight. Actors are rarely set as mad by default, it is rather the result of a spell or a script (example, the “Madness” spell).


; Confidence

; Will determine when the actor will avoid or flee from threats.
; Type 	Value 	Description
; Cowardly 	0 	Will always flee/avoid threats. Cowardly actors NEVER engage in combat under any circumstances. Confidence cannot be lower than 0.
; Cautious 	1 	Will flee/avoid threats until the actor is stronger than that threat.
; Average 	2 	Will flee/avoid threats if outmatched.
; Brave 	3 	Will flee/avoid threats if severely outmatched.
; Foolhardy 	4 	Will never flee/avoid threats.
; Assistance

; Determines when the actor will assist his friends and allies (see Factions ).
; Type 	Value 	Description
; Helps Nobody 	0 	Won't help anyone.
; Helps Allies 	1 	Will only help allies.
; Helps Friends and Allies 	2 	Will help friends and allies.


; Mood

; Not used.


; Energy

; A value from 0 to 100. Energy determines how many times the actor will move to a new location when subject to a Sandbox package .


; Morality

; If this actor is the player's companion (Follower), and the latter orders him to commit a crime, morality will determine whether the actor will ultimately commit it.
; Type 	Value 	Description
; Any Crime 	0 	The actor will commit any crime.
; Violence Against Enemies 	1 	The actor will commit "property" crimes (theft, trespassing), and violent crimes when ordered to attack an enemy (only). Rarely used.
; Property Crime Only 	2 	The actor will commit “property” crimes (theft, trespassing), but will never commit violent crimes. Rarely used.
; No Crime 	3 	The actor will refuse to commit any crime.




; List of Actor Values

; The current list of Actor Values is:

;     Attributes
;         Health
;         Magicka
;         Stamina
;     Skills
;         OneHanded
;         TwoHanded
;         Marksman (Archery)
;         Block
;         Smithing
;         HeavyArmor
;         LightArmor
;         Pickpocket
;         Lockpicking
;         Sneak
;         Alchemy
;         Speechcraft (Speech)
;         Alteration
;         Conjuration
;         Destruction
;         Illusion
;         Restoration
;         Enchanting
;         <skillname>Mod
;             SkillMod values are changed by perks and fortify skill enchantments. The automatic perk PerkSkillBoosts translates those into actual game effects.
;         <skillname>PowerMod
;             SkillPowerMod values are changed by fortify skill potions. The automatic perk AlchemySkillBoosts translates those into actual game effects. The effect is usually the same as increasing the skill level of the associated skill, except for the magic schools: Alteration = duration, Conjuration = duration, Destruction = magnitude, Illusion = magnitude, Restoration = magnitude.


;     AI Data
;         Aggression
;         Confidence
;         Energy
;         Morality
;         Mood
;         Assistance
;         WaitingForPlayer


;     Other Statistics
;         HealRate
;         MagickaRate
;         StaminaRate
;         attackDamageMult (try 5 for good ex.)
;         SpeedMult
;         ShoutRecoveryMult (Handles the shout cooldowns)
;         WeaponSpeedMult (values of 1 to 5 work well, 0 to reset)
;         InventoryWeight
;         CarryWeight
;         CritChance
;         MeleeDamage
;         UnarmedDamage
;         Mass
;         VoicePoints
;         VoiceRate
;         DamageResist
;         DiseaseResist
;         PoisonResist
;         FireResist
;         ElectricResist
;         FrostResist
;         MagicResist
;         Paralysis
;         Invisibility
;         NightEye
;         DetectLifeRange
;         WaterBreathing
;         WaterWalking
;         JumpingBonus
;         AbsorbChance
;         WardPower
;         WardDeflection
;         EquippedItemCharge
;         EquippedStaffCharge
;         ArmorPerks
;         ShieldPerks
;         BowSpeedBonus
;         DragonSouls


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
    elseif (command == "ExtCmdGrovel")
        Main.RegisterEvent(speakerName + " begins groveling before " + playerName)
    elseif (command == "ExtCmdDisrobe")    
        Main.RegisterEvent(speakerName + " begins to disrobe.")
    elseif (command == "ExtCmdGetDressed") 
        Main.RegisterAction(speakerName + " begins to get dressed.")
    elseif (command == "ExtCmdLookPitiful")
        Main.RegisterAction(speakerName + " looks absolutely pitiful.")
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
