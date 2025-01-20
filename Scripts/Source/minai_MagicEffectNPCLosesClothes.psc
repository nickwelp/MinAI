ScriptName minai_MagicEffectNPCLosesClothes Extends ActiveMagicEffect

Armor[] items																		
Formlist Property MinaiUndressedNPCs Auto

Outfit property Naked auto

Outfit clothedOutfit

bool slow = true
bool surrenderClothes = true

Event OnEffectStart(Actor akTarget, Actor akCaster)
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
		if throwClothesToFloor
            While i < items.Length
                ; skip hair, long hair + circlet 
                if(items[i] && !(i == 1 || i == 11 || i == 12))
                    utility.wait(4) ; wait 5 seconds per item thrown to floor
                    Armor item = items[i]
                    akActor.UnequipItemSlot(i + 30)
                    utility.wait(1) ; wait 5 seconds per item thrown to floor
                    akActor.RemoveItem(item)
                    akActor.PlaceAtMe(item)
                endif
                i += 1
            EndWhile
        else
            While i < items.Length
                if(items[i])
                    utility.wait(4) ; wait 5 seconds per item thrown to floor
                    Armor item = items[i]
                    akActor.UnequipItemSlot(i + 30)
                endif
                i += 1
            EndWhile
        endif
	Else
		akActor.UnequipAll()	
        ; re-equip hair, long hair + circlet
        akActor.EquipItemEx(items[1],0,False,True)
        akActor.EquipItemEx(items[11],0,False,True)
        akActor.EquipItemEx(items[12],0,False,True)
        if(surrenderClothes)
            int i = 0
            while i < items.Length
                if(items[i])
                    ; ignoring hair, long hair and circlet (which may hold body mods)
                    if(!(i == 1 || i == 11 || i == 12))
                        akActor.RemoveItem(items[i], 1)
                        akActor.PlaceAtMe(items[i])
                    endif
                endif
                i += 1
            endwhile
        endif
	Endif
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
