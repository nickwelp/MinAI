scriptname minai_ActionsTest extends Quest

; this is for testing the actions we send to the Avatars in the game world
; ie if the LLM tells Mousey the Meek that the character should Cower, Mousey 
; then cowers

; this class will go through a list of Actions and apply them to a character 
; and in game we'll observe their actions

minai_Actions Actions
minai_Util MinaiUtil
minai_MainQuestController main

; for enabling and disabling timer
bool isTestRunning = false


function Maintenance(minai_MainQuestController _main)
    main = _main
    MinaiUtil = (Self as Quest) as minai_Util
    Actions = (Self as Quest) as minai_Actions
endFunction

