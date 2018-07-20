// Foam
// Similar to smoke, but spreads out more
// metal foams leave behind a foamed metal wall

/obj/effect/effect/foam
	name = "foam"
	icon_state = "foam"
	opacity = FALSE
	anchored = TRUE
	density = FALSE
	layer = OBJ_LAYER + 0.9
	mouse_opacity = FALSE
	animate_movement = FALSE
	var/amount = 3
	var/expand = TRUE
	var/metal = FALSE

/obj/effect/effect/foam/New(var/loc, var/ismetal = FALSE)
	..(loc)
	icon_state = "[ismetal? "m" : ""]foam"
	metal = ismetal
	playsound(src, 'sound/effects/bubbles2.ogg', 80, TRUE, -3)
	spawn(3 + metal * 3)
		process()
		checkReagents()
	spawn(120)
		processing_objects.Remove(src)
		sleep(30)
		if(metal)
			var/obj/structure/foamedmetal/M = new(loc)
			M.metal = metal
			M.updateicon()
		flick("[icon_state]-disolve", src)
		sleep(5)
		qdel(src)
	return

/obj/effect/effect/foam/proc/checkReagents() // transfer any reagents to the floor
	if(!metal && reagents)
		var/turf/T = get_turf(src)
		reagents.touch_turf(T)
		for(var/obj/O in T)
			reagents.touch_obj(O)

/obj/effect/effect/foam/process()
	if(--amount < FALSE)
		return

	for(var/direction in cardinal)
		var/turf/T = get_step(src, direction)
		if(!T)
			continue

		if(!T.Enter(src))
			continue

		var/obj/effect/effect/foam/F = locate() in T
		if(F)
			continue

		F = new(T, metal)
		F.amount = amount
		if(!metal)
			F.create_reagents(10)
			if(reagents)
				for(var/datum/reagent/R in reagents.reagent_list)
					F.reagents.add_reagent(R.id, TRUE, safety = TRUE) //added safety check since reagents in the foam have already had a chance to react

/obj/effect/effect/foam/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume) // foam disolves when heated, except metal foams
	if(!metal && prob(max(0, exposed_temperature - 475)))
		flick("[icon_state]-disolve", src)

		spawn(5)
			qdel(src)

/obj/effect/effect/foam/Crossed(var/atom/movable/AM)
	if(metal)
		return
	if(istype(AM, /mob/living))
		var/mob/living/M = AM
		M.slip("the foam", 6)

/datum/effect/effect/system/foam_spread
	var/amount = 5				// the size of the foam spread.
	var/list/carried_reagents	// the IDs of reagents present when the foam was mixed
	var/metal = FALSE				// FALSE = foam, TRUE = metalfoam, 2 = ironfoam

/datum/effect/effect/system/foam_spread/set_up(amt=5, loca, var/datum/reagents/carry = null, var/metalfoam = FALSE)
	amount = round(sqrt(amt / 3), TRUE)
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

	carried_reagents = list()
	metal = metalfoam

	// bit of a hack here. Foam carries along any reagent also present in the glass it is mixed with (defaults to water if none is present). Rather than actually transfer the reagents, this makes a list of the reagent ids and spawns TRUE unit of that reagent when the foam disolves.

	if(carry && !metal)
		for(var/datum/reagent/R in carry.reagent_list)
			carried_reagents += R.id

/datum/effect/effect/system/foam_spread/start()
	spawn(0)
		var/obj/effect/effect/foam/F = locate() in location
		if(F)
			F.amount += amount
			return

		F = PoolOrNew(/obj/effect/effect/foam, list(location, metal))
		F.amount = amount

		if(!metal) // don't carry other chemicals if a metal foam
			F.create_reagents(10)

			if(carried_reagents)
				for(var/id in carried_reagents)
					F.reagents.add_reagent(id, TRUE, safety = TRUE) //makes a safety call because all reagents should have already reacted anyway
			else
				F.reagents.add_reagent("water", TRUE, safety = TRUE)

// wall formed by metal foams, dense and opaque, but easy to break

/obj/structure/foamedmetal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	density = TRUE
	opacity = TRUE // changed in New()
	anchored = TRUE
	name = "foamed metal"
	desc = "A lightweight foamed metal wall."
	var/metal = TRUE // TRUE = aluminum, 2 = iron

/obj/structure/foamedmetal/New()
	..()
	update_nearby_tiles(1)

/obj/structure/foamedmetal/Destroy()
	density = FALSE
	update_nearby_tiles(1)
	..()

/obj/structure/foamedmetal/proc/updateicon()
	if(metal == TRUE)
		icon_state = "metalfoam"
	else
		icon_state = "ironfoam"

/obj/structure/foamedmetal/ex_act(severity)
	qdel(src)

/obj/structure/foamedmetal/bullet_act()
	if(metal == TRUE || prob(50))
		qdel(src)

/obj/structure/foamedmetal/attack_hand(var/mob/user)
	if ((HULK in user.mutations) || (prob(75 - metal * 25)))
		user.visible_message("<span class='warning'>[user] smashes through the foamed metal.</span>", "<span class='notice'>You smash through the metal foam wall.</span>")
		qdel(src)
	else
		user << "<span class='notice'>You hit the metal foam but bounce off it.</span>"
	return

/obj/structure/foamedmetal/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = I
		G.affecting.loc = loc
		visible_message("<span class='warning'>[G.assailant] smashes [G.affecting] through the foamed metal wall.</span>")
		qdel(I)
		qdel(src)
		return

	if(prob(I.force * 20 - metal * 25))
		user.visible_message("<span class='warning'>[user] smashes through the foamed metal.</span>", "<span class='notice'>You smash through the foamed metal with \the [I].</span>")
		qdel(src)
	else
		user << "<span class='notice'>You hit the metal foam to no effect.</span>"

/obj/structure/foamedmetal/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = FALSE)
	if(air_group)
		return FALSE
	return !density