ScriptName minai_NPCUndressedMagicEffect Extends ActiveMagicEffect
; Formlist	Property	dz_undressed_NPCs	Auto		
Formlist Property MinaiUndressedNPCs Auto
Armor items[]

Outfit property Naked auto
Outfit clothedOutfit

bool slow = true
bool surrenderClothes = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
    nakedOutfit = new Outfit
	GoToState("")
	Undress(akTarget)
EndEvent

Event OnBeginState()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	GetDressed(akActor)
EndEvent

Function Undress(Actor akActor)
    ActorObject akActorBase = akActor.GetBaseObject()
    clothedOutfit = akActorBase.GetOutfit()
	items = New Armor[32]
    items = GetSlotItems(akActor)
    akActor.SetRestrained(true)
    ;;; slowly undress going item by item with waits in between
	If slow
        While i < items.Length
            if(items[i])
                utility.wait(4) ; wait 5 seconds per item thrown to floor
                Armor item = items[i]
                akActor.UnequipItemSlot(i + 30)
            endif
            i += 1
        EndWhile
    endif
    nakedOutfit = akActorBase.GetOutfit()
    akActorBase.SetOutfit(Naked)
	MinaiUndressedNPCs.AddForm(akActor)
    akActor.SetRestrained(false)
EndFunction

Function GetDressed(Actor akActor)
    ActorBase akActorBase = akActor.GetActorBase()
    akActor.SetRestrained(true)
    if(slow)
        int i = 0
        while i < items.length
            if(akActor.GetItemCount(items[i])>0)
                akActor.EquipItemEx(Items[i],0,False,True)
                utility.wait(3) 
            Endif
            i += i++
        endwhile
    endif
    akActorBase.SetOutfit(clothedOutfit)
    akActor.SetRestrained(false)
	MinaiUndressedNPCs.RemoveAddedForm(akActor)
EndFunction

Armor[] Function GetSlotItems(Actor akActor)
	Armor[] temp
	temp = New Armor[32]
	Int i = 0
	While i < temp.Length
		temp[i] = akActor.GetEquippedArmorInSlot(i + 30)
		i += 1
	EndWhile
	Return temp
EndFunction
