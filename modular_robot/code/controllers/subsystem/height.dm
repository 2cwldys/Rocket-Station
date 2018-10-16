//Dabber Station 13 Height Imitation System
#define FIRE_PRIORITY_HEIGHT		900
#define INIT_ORDER_HEIGHT			-7
//Used to process height

SUBSYSTEM_DEF(dabber) //this creates a subsystem
	name = "Height" //this gives it a name
	wait = 1 //SS_TICKER OVERRIDE
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING|SS_NO_INIT|SS_TICKER //these flags indicate what it does.
	init_order = INIT_ORDER_HEIGHT
	priority = FIRE_PRIORITY_HEIGHT
	var/list/processing = list() //what do we process NOOB

/datum/controller/subsystem/dabber/fire(resumed = 0) //process subsystem
	var/list/current_run = processing.Copy() //Change the list that we will process to the processing list.
	while(current_run.len) //While the processing list is filled...
		var/mob/thing = current_run[current_run.len] //What item in the processing list do we process? In this case, the last one.
		current_run.len-- //Go to next processing item.
		if(QDELETED(thing)) //If deleted...
			if(istype(thing,/mob))
				if(thing:MyShadow)
					qdel(thing:MyShadow)
					thing:MyShadow = null
			processing -= thing //Remove it from processing if it was deleted
		else //If not..
			thing.height_Process() //Process it's height!

/mob //mob define, creates a mob instance
	var //variables
		heightZ = 0 //height
		ySpeed = 0 //Y Speed (positive is going up, negative downI)
		obj/effect/shadow/MyShadow
	Initialize() //When the player is spawned or initialized.......
		..() //Add this always
		SSdabber.processing += src //Dabber is our subsystem. so it would add the player to the processing list.

/mob/proc/height_Process() //procs are commands which are called from other code, to execute stuff, etc. In this case read line 19 (thing.height_Process()) It's epic right?
	set waitfor = 0 //don't do sleeps.
	if(MyShadow)
		MyShadow.loc = loc
		MyShadow.dir = dir
		MyShadow.icon = icon
		MyShadow.icon_state = icon_state
		MyShadow.overlays = overlays
		MyShadow.vis_contents = vis_contents
		MyShadow.underlays = underlays
	else
		MyShadow = new()
	ySpeed -= 48/256 //ySpeed is decremented, so the player falls down.
	heightZ += ySpeed //moves height by y Speed
	if(heightZ < 0) //If heightz is below 0 (under floor)
		heightZ = 0 //we dont go under the floor
		ySpeed = 0
	pixel_z = round(heightZ)
	return PROCESS_KILL //it's over.

/mob/proc/Jump()
	if(heightZ <= 0) //If height is 0 or below (floor)
		ySpeed = 1252/256 //Jump!
/obj/effect/shadow
	mouse_opacity = 0
	color = "#000000"
	appearance_flags = KEEP_TOGETHER
	alpha = 150
/mob/key_down(_key, client/user)
	switch(_key)
		if("Space")
			Jump()
	..()