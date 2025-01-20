scriptname minai_ActionsLibrary extends Quest

; a function where actors throw down their weapons & shield
function Disarm(actor akActor)
    ActorBase akActorBase = akActor.GetActorBase()
    Weapon leftHand = akActor.GetEquippedWeapon(true)
    Weapon rightHand = akActor.GetEquippedWeapon()
    Armor shield = akActor.GetEquippedShield()
    akActor.EquipItemEx(Unarmed, 0, true, true)
    akActor.SetRestrained(true)
    if(rightHand)
        akActor.UnEquipitemEx(rightHand)
        akActor.RemoveItem(rightHand)
        akActor.PlaceAtMe(rightHand)
    endif
    if(leftHand)
        akActor.UnEquipitemEx(leftHand)
        akActor.RemoveItem(leftHand)
        akActor.PlaceAtMe(leftHand)
    endif
    if(shield)
        akActor.UnEquipitemEx(shield)
        akActor.RemoveItem(shield)
        akActor.PlaceAtMe(shield)
    endif
    akActor.SetRestrained(false)
endfunction


function Restrain(actor akActor)
    akActor.SetRestrained(true)
endFunction

function ReleaseRestraint(actor akActor)
    akActor.SetRestrained(false)
endFunction


; lower morality
; by game mechanics this only impacts followers 
; but by describing this to the LLMs it can be made impactful
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


function Cower(string speakerName)
    Actor akActor = AIAgentFunctions.getAgentByName(speakerName)
    akActor.SetIntimidated(true)
endfunction

function CeaseCower(string speakerName)
    Actor akActor = AIAgentFunctions.getAgentByName(speakerName)
    akActor.SetIntimidated(false)
endfunction

function ConcedeInventory(string speakerName)
    Actor akActor = AIAgentFunctions.getAgentByName(speakerName)
    akActor.OpenInventory(true)
endFunction

function Disrobe(string speakerName)
    Actor akActor = AIAgentFunctions.getAgentByName(speakerName)
    If akActor.HasMagicEffect(minai_MagicEffectNOCDisrobes)
		Return																			
	EndIf
	minai_NPCUndressedSpell.Cast(akActor, akActor) 
endFunction

function LoseClothes(string speakerName)
    Actor akActor = AIAgentFunctions.getAgentByName(speakerName)
    If akActor.HasMagicEffect(minai_MagicEffectNPCLosesClothes)
		Return																			
	EndIf
	minai_NPCUndressedSpell.Cast(akActor, akActor) 
endFunction
