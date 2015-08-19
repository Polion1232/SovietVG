/* Clown Items
 * Contains:
 * 		Banana Peels
 *		Soap
 *		Bike Horns
 */

/*
 * Banana Peals
 */
/obj/item/weapon/bananapeel/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if(!M.walking()) return

		if (M.CheckSlip() < 1)
			return

		M.stop_pulling()
		M.simple_message("<span class='notice'> You slipped on the [name]!</span>",
			"<span class='userdanger'>Something is scratching at your feet! Oh god!</span>")
		playsound(get_turf(src), 'sound/misc/slip.ogg', 50, 1, -3)
		M.Stun(2)
		M.Weaken(2)

/*
 * Soap
 */
/obj/item/weapon/soap/Crossed(AM as mob|obj) //EXACTLY the same as bananapeel for now, so it makes sense to put it in the same dm -- Urist
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if(!M.walking()) return

		if (M.CheckSlip() < 1)
			return

		M.stop_pulling()
		M.simple_message("<span class='notice'> You slipped on the [name]!</span>",
			"<span class='userdanger'>Something is scratching at your feet! Oh god!</span>")
		playsound(get_turf(src), 'sound/misc/slip.ogg', 50, 1, -3)
		M.Stun(3)
		M.Weaken(2)

/obj/item/weapon/soap/afterattack(atom/target, mob/user as mob)
	//I couldn't feasibly fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	//Overlay bugs can probably be fixed by updating the user's icon, see watercloset.dm
	if(!user.Adjacent(target))
		return

	if(user.client && (target in user.client.screen) && !(user.l_hand == target || user.r_hand == target))
		user.simple_message("<span class='notice'>You need to take that [target.name] off before cleaning it.</span>",
			"<span class='notice'>You need to take that [target.name] off before destroying it.</span>")

	else if(istype(target,/obj/effect/decal/cleanable))
		user.simple_message("<span class='notice'>You scrub \the [target.name] out.</span>",
			"<span class='warning'>You destroy [pick("an artwork","a valuable artwork","a rare piece of art","a rare piece of modern art")].</span>")
		returnToPool(target)

	else if(istype(target,/turf/simulated))
		var/turf/simulated/T = target
		var/list/cleanables = list()
		for(var/obj/effect/decal/cleanable/CC in T)
			if(!istype(CC) || !CC)
				continue
			cleanables += CC
		if(!cleanables.len)
			user.simple_message("<span class='notice'>You fail to clean anything.</span>",
				"<span class='notice'>There is nothing for you to vandalize.</span>")
			return
		cleanables = shuffle(cleanables)
		var/obj/effect/decal/cleanable/C
		for(var/obj/effect/decal/cleanable/d in cleanables)
			if(d && istype(d))
				C = d
				break
		user.simple_message("<span class='notice'>You scrub \the [C.name] out.</span>",
			"<span class='warning'>You destroy [pick("an artwork","a valuable artwork","a rare piece of art","a rare piece of modern art")].</span>")
		returnToPool(C)
	else
		user.simple_message("<span class='notice'>You clean \the [target.name].</span>",
			"<span class='warning'>You [pick("deface","ruin","stain")] \the [target.name].</span>")
		target.clean_blood()
	return

/obj/item/weapon/soap/attack(mob/target as mob, mob/user as mob)
	if(target && user && ishuman(target) && !target.stat && !user.stat && user.zone_sel &&user.zone_sel.selecting == "mouth" )
		user.visible_message("<span class='warning'>\the [user] washes \the [target]'s mouth out with soap!</span>")
		return
	..()

/*
 * Bike Horns
 */
/obj/item/weapon/bikehorn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(get_turf(src), 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return
