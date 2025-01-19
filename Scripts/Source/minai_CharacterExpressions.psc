scriptname minai_CharacterExpression extends Quest

; https://ck.uesp.net/wiki/SetExpressionOverride_-_Actor
; 0: Dialogue Anger
; 1: Dialogue Fear
; 2: Dialogue Happy
; 3: Dialogue Sad
; 4: Dialogue Surprise
; 5: Dialogue Puzzled
; 6: Dialogue Disgusted
; 7: Mood Neutral
; 8: Mood Anger
; 9: Mood Fear
; 10: Mood Happy
; 11: Mood Sad
; 12: Mood Surprise
; 13: Mood Puzzled
; 14: Mood Disgusted
; 15: Combat Anger
; 16: Combat Shout
; my readings suggest everything but mood is buggy
; we don't want to trap the animations too long but for flavor
; set the expression strongly and wind it down over time
; if strength < 5 kill it
; use registered timer to manage wind down

actor[] emotingActors 

int[] iNeutralStrengthList
int[] iAngerStrengthList
int[] iFearStrengthList
int[] iHappyStrengthList
int[] iSadStrengthList
int[] iSurpriseStrengthList
int[] iPuzzledStrengthList
int[] iDisgustedStrengthList


; ids of the emotions
int iMoodNeutralId = 7 
int iMoodAngerId = 8 
int iMoodFearId = 9 
int iMoodHappyId = 10 
int iMoodSadId = 11 
int iMoodSurpriseId = 12 
int iMoodPuzzledId = 13 
int iMoodDisgustedId = 14 

; is this character class processing emotions?
bool loopIsActive = false

float decayRate = 0.3

; expression override claims to suppress other facial animations, so lets keep it capped at 50%
float fStrengthMitigator = 0.5


function checkIfActorDoneAndRemove(actor akActor)
    int index = getIndex(akActor)
    if(index>=0)
        bool done = true
        if(iNeutralStrengthList[index] > 5)
            done = false
        endif
        if(iAngerStrengthList[index] > 5)
            done = false
        endif
        if(iFearStrengthList[index] > 5)
            done = false
        endif
        if(iHappyStrengthList[index] > 5)
            done = false
        endif
        if(iSadStrengthList[index] > 5)
            done = false
        endif
        if(iSurpriseStrengthList[index] > 5)
            done = false
        endif
        if(iPuzzledStrengthList[index] > 5)
            done = false
        endif
        if(iDisgustedStrengthList[index] > 5)
            done = false
        endif
        if(done)
            removeEmotingActor(akActor)
        endif
    endif
endfunction

function AddEmotingActor(actor akActor)
    if(emotingActors.Length == 0 || emotingActors.find(akActor)<0)
        int newLength = emotingActors.Length + 1
        Actor[] newActorList = new Actor[newLength]
        int[] iNewNeutralStrengthList = new int[newLength]
        int[] iNewAngerStrengthList = new int[newLength]
        int[] iNewFearStrengthList = new int[newLength]
        int[] iNewHappyStrengthList = new int[newLength]
        int[] iNewSadStrengthList = new int[newLength]
        int[] iNewSurpriseStrengthList = new int[newLength]
        int[] iNewPuzzledStrengthList = new int[newLength]
        int[] iNewDisgustedStrengthList = new int[newLength]
        int i = 0
        while i<emotingActors.Length
            newActorList[i] = emotingActors[i]
            iNewNeutralStrengthList[i] = iNeutralStrengthList[i]
            iNewAngerStrengthList[i] = iAngerStrengthList[i]
            iNewFearStrengthList[i] = iFearStrengthList[i]
            iNewHappyStrengthList[i] = iHappyStrengthList[i]
            iNewSadStrengthList[i] = iSadStrengthList[i]
            iNewSurpriseStrengthList[i] = iSurpriseStrengthList[i]
            iNewPuzzledStrengthList[i] = iPuzzledStrengthList[i]
            iNewDisgustedStrengthList[i] = iDisgustedStrengthList[i]
            i += 1
        endWhile
        newActorList[newLength - 1] = akActor
        iNewNeutralStrengthList[newLength - 1] = 0
        iNewAngerStrengthList[newLength - 1] = 0
        iNewFearStrengthList[newLength - 1] = 0
        iNewHappyStrengthList[newLength - 1] = 0
        iNewSadStrengthList[newLength - 1] = 0
        iNewSurpriseStrengthList[newLength - 1] = 0
        iNewPuzzledStrengthList[newLength - 1] = 0
        iNewDisgustedStrengthList[newLength - 1] = 0
        
        emotingActors = newActorList
        iNeutralStrengthList = iNewNeutralStrengthList
        iAngerStrengthList = iNewAngerStrengthList
        iFearStrengthList = iNewFearStrengthList
        iHappyStrengthList = iNewHappyStrengthList
        iSadStrengthList = iNewSadStrengthList
        iSurpriseStrengthList = iNewSurpriseStrengthList
        iPuzzledStrengthList = iNewPuzzledStrengthList
        iDisgustedStrengthList = iNewDisgustedStrengthList
        
    endif
endfunction

function removeEmotingActor(actor akActor)
    int index = emotingActors.find(akActor)
    if(index>=0)
        akActor.ClearExpressionOverride()
        int newLength = emotingActors.Length - 1
        Actor[] newActorList = new Actor[newLength]
        int[] iNewNeutralStrengthList = new int[newLength]
        int[] iNewAngerStrengthList = new int[newLength]
        int[] iNewFearStrengthList = new int[newLength]
        int[] iNewHappyStrengthList = new int[newLength]
        int[] iNewSadStrengthList = new int[newLength]
        int[] iNewSurpriseStrengthList = new int[newLength]
        int[] iNewPuzzledStrengthList = new int[newLength]
        int[] iNewDisgustedStrengthList = new int[newLength]
        int i = 0
        int indexSansEjectingActor = 0
        while i<emotingActors.Length
            if(i != index)
                newActorList[indexSansEjectingActor] = emotingActors[i]
                iNewNeutralStrengthList[indexSansEjectingActor] = iNeutralStrengthList[i]
                iNewAngerStrengthList[indexSansEjectingActor] = iAngerStrengthList[i]
                iNewFearStrengthList[indexSansEjectingActor] = iFearStrengthList[i]
                iNewHappyStrengthList[indexSansEjectingActor] = iHappyStrengthList[i]
                iNewSadStrengthList[indexSansEjectingActor] = iSadStrengthList[i]
                iNewSurpriseStrengthList[indexSansEjectingActor] = iSurpriseStrengthList[i]
                iNewPuzzledStrengthList[indexSansEjectingActor] = iPuzzledStrengthList[i]
                iNewDisgustedStrengthList[indexSansEjectingActor] = iDisgustedStrengthList[i]
                indexSansEjectingActor += 1
            endIf
            i += 1
        endWhile
        emotingActors = newActorList
        iNeutralStrengthList = iNewNeutralStrengthList
        iAngerStrengthList = iNewAngerStrengthList
        iFearStrengthList = iNewFearStrengthList
        iHappyStrengthList = iNewHappyStrengthList
        iSadStrengthList = iNewSadStrengthList
        iSurpriseStrengthList = iNewSurpriseStrengthList
        iPuzzledStrengthList = iNewPuzzledStrengthList
        iDisgustedStrengthList = iNewDisgustedStrengthList
    endif
endFunction

int function getIndex(actor akActor)
    return emotingActors.find(akActor)
endFunction

int function getIndexOrCreate(actor akActor)
    int index = getIndex(akActor)
    if(index<0)
        AddEmotingActor(akActor)
        return emotingActors.Length - 1
    endif
    return index 
endfunction   

function constructor()
    ; decay must be less than 1, but lets just eat it if its not
    if(decayRate >= 1) 
        decayRate = 0.9
    endif
    ; shouldn't be negative
    if(decayRate<0)
        decayRate = 0.01
    endif

    ; fStrengthMitigator must be 1 or less
    if(fStrengthMitigator>1)
        fStrengthMitigator = 1
    endif
    ; fStrengthMitigator shant be negative
    if(fStrengthMitigator<0)
        fStrengthMitigator = 0
    endif
endFunction

; fear
function feelFear(actor akActor)
    feelFearByAmount(100, akActor)
endFunction
function feelFearByAmount(int strength, actor akActor)
    int index = getIndexOrCreate(akActor)
    iFearStrengthList[index] += strength
    if(iFearStrengthList[index]>100)
        iFearStrengthList[index] = 100
    endif
    akActor.SetExpressionOverride(iMoodFearId, (iFearStrengthList[index]*100/getTotalStrength(akActor))  * fStrengthMitigator)
    if(!loopIsActive)
        loopIsActive = true
        RegisterForUpdateGameTime(1/30)
    endIf
endFunction

; for the man with no fear
function feelNoFear(actor akActor)
    int index = getIndex(akActor)
    if(index>-1)
        iFearStrengthList[index] = 0
    Endif
    checkIfActorDoneAndRemove(akActor)
    checkIfTimerDone()
endFunction

; feel neutral, i guess like desaturating a color
function feelNeutral(actor akActor)
    feelNeutralByAmount(100, akActor)
endFunction
function feelNeutralByAmount(int strength, actor akActor)
    int index = getIndexOrCreate(akActor)
    iNeutralStrengthList[index] += strength
    if(iNeutralStrengthList[index]>100)
        iNeutralStrengthList[index] = 100
    endif
    akActor.SetExpressionOverride(iMoodNeutralId, (iNeutralStrengthList[index]*100/getTotalStrength(akActor))  * fStrengthMitigator)
    if(!loopIsActive)
        loopIsActive = true
        RegisterForUpdateGameTime(1/30)
    endIf
endFunction

; for the man with no xanax
function feelNoNeutral(actor akActor)
    int index = getIndex(akActor)
    if(index>-1)
        iFearNeutralList[index] = 0
    endif
    checkIfActorDoneAndRemove(akActor)
    checkIfTimerDone()
endFunction

; anger
function feelAnger(actor akActor)
    feelAngerByAmount(100, akActor)
endFunction
function feelAngerByAmount(int strength, actor akActor)
    int index = getIndexOrCreate(akActor)
    iAngerStrengthList[index] += strength
    if(iAngerStrengthList[index]>100)
        iAngerStrengthList[index] = 100
    endif
    akActor.SetExpressionOverride(iMoodAngerId, (iAngerStrengthList[index]*100/getTotalStrength(akActor))  * fStrengthMitigator)
    if(!loopIsActive)
        loopIsActive = true
        RegisterForUpdateGameTime(1/30)
    endIf
endFunction

; 
function feelNoAnger(actor akActor)
    int index = getIndex(akActor)
    if(index>-1)
        iFearAngerList[index] = 0
    endif
    checkIfActorDoneAndRemove(akActor)
    checkIfTimerDone()
endFunction

; happy
function feelHappy(actor akActor)
    feelHappyByAmount(100, akActor)
endFunction
function feelHappyByAmount(int strength, actor akActor)
    int index = getIndexOrCreate(akActor)
    iHappyStrengthList[index] += strength
    if(iHappyStrengthList[index]>100)
        iHappyStrengthList[index] = 100
    endif
    akActor.SetExpressionOverride(iMoodHappyId, (iHappyStrengthList[index]*100/getTotalStrength(akActor))  * fStrengthMitigator)

    if(!loopIsActive)
        loopIsActive = true
        RegisterForUpdateGameTime(1/30)
    endIf
endFunction

; 
function feelNoHappy(actor akActor)
    int index = getIndex(akActor)
    if(index>-1)
        iFearHappyList[index] = 0
    endif
    checkIfActorDoneAndRemove(akActor)
    checkIfTimerDone()
endFunction

; sad
function feelSad(actor akActor)
    feelSadByAmount(100, akActor)
endFunction
function feelSadByAmount(int strength, actor akActor)
    int index = getIndexOrCreate(akActor)
    iSadStrengthList[index] += strength
    if(iSadStrengthList[index]>100)
        iSadStrengthList[index] = 100
    endif
    akActor.SetExpressionOverride(iMoodSadId, (iSadStrengthList[index]*100/getTotalStrength(akActor))  * fStrengthMitigator)
    if(!loopIsActive)
        loopIsActive = true
        RegisterForUpdateGameTime(1/30)
    endIf
endFunction

;
function feelNoSad(actor akActor)
    iFeaint index = getIndex(akActor)
        if(index>-1)rSad =
            List[] 0
    checkIfTimerDone(index)
endFunctionendif
; surprise
function feelSurprise(actor akActor)
    feelSurpriseByAmount(100, akActor)
endFunction
function feelSurpriseByAmount(int strength, actor akActor)
    int index = getIndexOrCreate(akActor)
    iSurpriseStrengthList[index] += strength
    if(iSurpriseStrengthList[index]>100)
        iSurpriseStrengthList[index] = 100
    endif
    akActor.SetExpressionOverride(iMoodSurpriseId, (iSurpriseStrengthList[index]*100/getTotalStrength(akActor))  * fStrengthMitigator)
    if(!loopIsActive)
        loopIsActive = true
        RegisterForUpdateGameTime(1/30)
    endIf
endFunction

;
function feelNoSurprise(actor akActor)
    int index = getIndex(akActor)
    if(index>-1)
        iFearSurpriseList[index] = 0
    endif
    checkIfActorDoneAndRemove(akActor)
    checkIfTimerDone()
endFunction

; puzzled
function feelPuzzled(actor akActor)
    feelPuzzledByAmount(100, akActor)
endFunction
function feelPuzzledByAmount(int strength, actor akActor)
    int index = getIndexOrCreate(akActor)
    iPuzzledStrengthList[index] += strength
    if(iPuzzledStrengthList[index]>100)
        iPuzzledStrengthList[index] = 100
    endif
    akActor.SetExpressionOverride(iMoodPuzzledId, (iPuzzledStrengthList[index]*100/getTotalStrength(akActor))  * fStrengthMitigator)
    if(!loopIsActive)
        loopIsActive = true
        RegisterForUpdateGameTime(1/30)
    endIf
endFunction

;
function feelNoPuzzled(actor akActor)
    int index = getIndex(akActor)
    if(index>-1)
        iFearPuzzledList[index] = 0
    endif
    checkIfActorDoneAndRemove(akActor)
    checkIfTimerDone()
endFunction

; disgusted
function feelDisgusted(actor akActor)
    feelDisgustedByAmount(100, akActor)
endFunction
function feelDisgustedByAmount(int strength, actor akActor)
    int index = getIndexOrCreate(akActor)
    iDisgustedStrengthList[index] += strength
    if(iDisgustedStrengthList[index]>100)
        iDisgustedStrengthList[index] = 100
    endif
    akActor.SetExpressionOverride(iMoodDisgustedId, (iDisgustedStrengthList[index]*100/getTotalStrength(akActor))  * fStrengthMitigator)
    if(!loopIsActive)
        loopIsActive = true
        RegisterForUpdateGameTime(1/30)
    endIf
endFunction

;
function feelNoDisgusted(actor akActor)
    int index = getIndex(akActor)
    if(index>-1)
        iFearDisgustedList[index] = 0
    endif
    checkIfActorDoneAndRemove(akActor)
    checkIfTimerDone()
endFunction

; check if ok to kill the timer
function checkIfTimerDone()
    if(emotingActors.Length == 0)
        UnregisterForUpdateGameTime()
        loopIsActive = false
    endIf
endFunction

; actor done emoting, remove from list
function checkIfRemoveActor(actor akActor)
    bool removeActor = true
    int index = emotingActors.Find(akActor)
    if(index>0)
        if(iFearStrengthList[index] > 5) 
            removeActor = false
        endIf
        if(iNeutralStrengthList[index] > 5)
            removeActor = false
        endIf
        if(iAngerStrengthList[index] > 5)
            removeActor = false
        endIf
        if(iHappyStrengthList[index] > 5)
            removeActor = false
        endIf
        if(iSadStrengthList[index] > 5)
            removeActor = false
        endIf
        if(iSurpriseStrengthList[index] > 5)
            removeActor = false
        endIf
        if(iPuzzledStrengthList[index] > 5)
            removeActor = false
        endIf
        if(iDisgustedStrengthList[index] > 5)
            removeActor = false
        endIf
    endif
endfunction



; total the emotion values
int function getTotalStrength(akActoractor akActor)
    int index = getIndex(akActor)
    if(index<0) return 0 
    return iNeutralStrength[index] + iAngerStrength[index] + iFearStrength[index] + iHappyStrength[index] + iSadStrength[index] + iSurpriseStrength[index] + iPuzzledStrength[index] + iDisgustedStrength[index]
endFunction

; because of how we registered, this event occurs every 2 minutes of game time		
Event OnUpdateGameTime() 
    iNeutralStrength = ((1-decay) * iNeutralStrength) as int
    iAngerStrength = ((1-decay) * iAngerStrength) as int
    iFearStrength = ((1-decay) * iFearStrength) as int
    iHappyStrength = ((1-decay) * iHappyStrength) as int
    iSadStrength = ((1-decay) * iSadStrength) as int
    iSurpriseStrength = ((1-decay) * iSurpriseStrength) as int
    iPuzzledStrength = ((1-decay) * iPuzzledStrength) as int
    iDisgustedStrength = ((1-decay) * iDisgustedStrength) as int
    ; avoid long tail smidgens of a fraction of emotion
    if(iNeutralStrength<5)
        iNeutralStrength = 0
    endIf
    if(iAngerStrength<5)
        iAngerStrength = 0
    endIf
    if(iFearStrength<5)
        iFearStrength = 0
    endIf
    if(iHappyStrength<5)
        iHappyStrength = 0
    endIf
    if(iSadStrength<5)
        iSadStrength = 0
    endIf
    if(iSurpriseStrength<5)
        iSurpriseStrength = 0
    endIf
    if(iPuzzledStrength<5)
        iPuzzledStrength = 0
    endIf
    if(iDisgustedStrength<5)
        iDisgustedStrength = 0
    endIf

    int iNormalizedNeutralStrength = iNeutralStrength
    int iNormalizedAngerStrength = iAngerStrength
    int iNormalizedFearStrength = iFearStrength
    int iNormalizedHappyStrength = iHappyStrength
    int iNormalizedSadStrength = iSadStrength
    int iNormalizedSurpriseStrength = iSurpriseStrength
    int iNormalizedPuzzledStrength = iPuzzledStrength
    int iNormalizedDisgustedStrength = iDisgustedStrength

    ; these emotions should only go to 100
    ; we need to normalize this if the emotions go over 100
    int iTotalStrength = getTotalStrength(akActor)
    if(iTotalStrength > 100)
        iNeutralStrength = iNeutralStrength * 100 / iTotalStrength 
        iAngerStrength = iAngerStrength * 100 / iTotalStrength
        iFearStrength = iFearStrength * 100 / iTotalStrength
        iHappyStrength = iHappyStrength * 100 / iTotalStrength
        iSadStrength = iSadStrength * 100 / iTotalStrength
        iSurpriseStrength = iSurpriseStrength * 100 / iTotalStrength
        iPuzzledStrength = iPuzzledStrength * 100 / iTotalStrength
        iDisgustedStrength = iDisgustedStrength * 100 / iTotalStrength
    endif

    if(iNeutralStrength!=0)
        akActor.SetExpressionOverride(iMoodNeutralId, iNeutralStrength * fStrengthMitigator)
    endif
    if(iAngerStrength!=0)
        akActor.SetExpressionOverride(iMoodAngerId, iAngerStrength * fStrengthMitigator) 
    endif
    if(iFearStrength!=0)
        akActor.SetExpressionOverride(iMoodFearId, iFearStrength * fStrengthMitigator) 
    endif
    if(iHappyStrength!=0)
        akActor.SetExpressionOverride(iMoodHappyId, iHappyStrength * fStrengthMitigator) 
    endif
    if(iSadStrength!=0)
        akActor.SetExpressionOverride(iMoodSadId, iSadStrength * fStrengthMitigator) 
    endif
    if(iSurpriseStrength!=0)
        akActor.SetExpressionOverride(iMoodSurpriseId, iSurpriseStrength * fStrengthMitigator) 
    endif
    if(iPuzzledStrength!=0)
        akActor.SetExpressionOverride(iMoodPuzzledId, iPuzzledStrength * fStrengthMitigator) 
    endif
    if(iDisgustedStrength!=0)
        akActor.SetExpressionOverride(iMoodDisgustedId, iDisgustedStrength * fStrengthMitigator) 
    endif
    checkIfTimerDone()
endEvent


; zero out all emotions and kill any animation claims
function end()
    iNeutralStrength = 0
    iAngerStrength = 0
    iFearStrength = 0
    iHappyStrength = 0
    iSadStrength = 0
    iSurpriseStrength = 0
    iPuzzledStrength = 0
    iDisgustedStrength = 0
    checkIfTimerDone()
endFunction