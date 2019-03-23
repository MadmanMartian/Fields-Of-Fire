/obj/effect/decal/mecha_wreckage/wuscout
	name = "MA4 Scout Walker wreckage"
	desc = "A demolished Western Union scout walker."
	icon = 'icons/FoF/mech_infantry.dmi'
	icon_state = "WU-scout_dead"
	anchored = 1
	New()
		..()
		var/list/parts = list(
									/obj/item/mecha_parts/part/wuscout_torso,
									/obj/item/mecha_parts/part/wuscout_head,
									/obj/item/mecha_parts/part/wuscout_left_leg,
									/obj/item/mecha_parts/part/wuscout_right_leg)
		for(var/i=0;i<2;i++)
			if(!isemptylist(parts) && prob(40))
				var/part = pick(parts)
				welder_salvage += part
				parts -= part
		return

/obj/effect/decal/mecha_wreckage/wuscout/eb
	name = "GSA2 Scout Walker wreckage"
	desc = "The burnt husk of an Eastern Bloc scout walker."
	icon_state = "EB-scout_dead"
	New()
		..()
		var/list/parts = list(
									/obj/item/mecha_parts/part/ebscout_torso,
									/obj/item/mecha_parts/part/ebscout_head,
									/obj/item/mecha_parts/part/ebscout_left_leg,
									/obj/item/mecha_parts/part/ebscout_right_leg)
		for(var/i=0;i<2;i++)
			if(!isemptylist(parts) && prob(40))
				var/part = pick(parts)
				welder_salvage += part
				parts -= part
		return

/obj/item/mecha_parts/chassis/wuscout
	name = "MA4 Chassis"
	icon = 'icons/FoF/buildmechs.dmi'
	icon_state = "mech_build1"
	origin_tech = list(TECH_MATERIAL = 7)

	New()
		..()
		construct = new /datum/construction/mecha/wuscout_chassis(src)

/datum/construction/mecha/wuscout_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/wuscout_torso),//1
					 list("key"=/obj/item/mecha_parts/part/wuscout_left_leg),//2
					 list("key"=/obj/item/mecha_parts/part/wuscout_right_leg),//3
					 list("key"=/obj/item/mecha_parts/part/wuscout_head),//4
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.overlays += used_atom.icon_state+"+o"
		qdel(used_atom)
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/mecha_parts/chassis/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/mecha/wuscout(const_holder)
		const_holder.icon = 'icons/FoF/buildmechs.dmi'
		const_holder.icon_state = "mech_build2"
		const_holder.set_density(1)
		const_holder.overlays.len = 0
		spawn()
			qdel(src)
		return

/datum/construction/reversible/mecha/wuscout
	result = /obj/mecha/combat/wuscout
	steps = list(
					//1
					list("key"=/obj/item/weapon/weldingtool,
							"backkey"=/obj/item/weapon/wrench,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/stack/material/steel,
					 		"backkey"=/obj/item/weapon/weldingtool,
					 		"desc"="Hydraulic actuator is welded."),
					 //4
					 list("key"=/obj/item/weapon/weldingtool,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="Hydraulic actuator is wrenched"),
					 //5
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Hydraulic actuator is installed"),
					 //6
					 list("key"=/obj/item/actuator/hydraulic,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Pneumatic actuator is secured"),
					 //7
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Pneumatic actuator is installed"),
					 //8
					 list("key"=/obj/item/actuator/pneumatic,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Engine block is secured"),
					 //9
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Engine block is installed"),
					 //10
					 list("key"=/obj/item/engine,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //11
					 list("key"=/obj/item/weapon/wirecutters,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is added"),
					 //12
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //13
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //14
					 list("key"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(14)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "mech_build2"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
					holder.icon_state = "mech_build2"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
					holder.icon_state = "mech_build2"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "mech_build2"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] installs the engine block into [holder].", "You install the engine block into [holder].")
					qdel(used_atom)
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "mech_build2"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] secures the engine block.", "You secure the engine block.")
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] removes the engine block from [holder].", "You remove the engine block from [holder].")
					new /obj/item/engine(get_turf(holder))
					holder.icon_state = "mech_build2"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] installs the pneumatic actuator into [holder].", "You install the pneumatic actuator into [holder].")
					qdel(used_atom)
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] unfastens the engine block.", "You unfasten the engine block.")
					holder.icon_state = "mech_build2"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] secures the pneumatic actuator.", "You secure the pneumatic actuator.")
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] removes the pneumatic actuator from [holder].", "You remove the pneumatic actuator from [holder].")
					new /obj/item/actuator/pneumatic(get_turf(holder))
					holder.icon_state = "mech_build2"
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] installs the hydraulic actuator to [holder].", "You install the hydraulic actuator to [holder].")
					qdel(used_atom)
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] unfastens the pneumatic actuator.", "You unfasten the pneumatic actuator.")
					holder.icon_state = "mech_build2"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] secures the hydraulic actuator.", "You secure the hydraulic actuator.")
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] pries the hydraulic actuator from [holder].", "You pry the hydraulic actuator from [holder].")
					new /obj/item/actuator/hydraulic(get_turf(holder))
					holder.icon_state = "mech_build2"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] welds the hydraulic actuator to [holder].", "You weld the hydraulic actuator to [holder].")
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] unfastens the hydraulic actuator.", "You unfasten the hydraulic actuator.")
					holder.icon_state = "mech_build2"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] cuts the hydraulic actuator from [holder].", "You cut the hydraulic actuator from [holder].")
					holder.icon_state = "mech_build2"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
					holder.icon_state = "mech_build2"
				else
					user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
					var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "mech_build2"
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				else
					user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
					holder.icon_state = "mech_build2"
		return 1

	spawn_result()
		..()
		feedback_inc("mecha_wuscout_created",1)
		return

/obj/item/mecha_parts/chassis/wuscout/eb
	name = "GSA2 Chassis"
	icon = 'icons/FoF/buildmechs.dmi'
	icon_state = "mech_build1"
	origin_tech = list(TECH_MATERIAL = 7)

	New()
		..()
		construct = new /datum/construction/mecha/wuscout_chassis/eb(src)

/datum/construction/mecha/wuscout_chassis/eb
	steps = list(list("key"=/obj/item/mecha_parts/part/ebscout_torso),//1
					 list("key"=/obj/item/mecha_parts/part/ebscout_left_leg),//2
					 list("key"=/obj/item/mecha_parts/part/ebscout_right_leg),//3
					 list("key"=/obj/item/mecha_parts/part/ebscout_head),//4
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.overlays += used_atom.icon_state+"+o"
		qdel(used_atom)
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/mecha_parts/chassis/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/mecha/wuscout/eb(const_holder)
		const_holder.icon = 'icons/FoF/buildmechs.dmi'
		const_holder.icon_state = "mech_build2"
		const_holder.set_density(1)
		const_holder.overlays.len = 0
		spawn()
			qdel(src)
		return

/datum/construction/reversible/mecha/wuscout/eb
	result = /obj/mecha/combat/wuscout/eb

/obj/item/mecha_parts/part/wuscout_torso
	name = "MA4 Torso"
	icon = 'icons/FoF/mech_parts.dmi'
	icon_state = "wuscout_torso"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_BIO = 3, TECH_ENGINEERING = 3)
	randpixel = 8

/obj/item/mecha_parts/part/wuscout_head
	name = "MA4 Head"
	icon = 'icons/FoF/mech_parts.dmi'
	icon_state = "wuscout_head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	randpixel = 8

obj/item/mecha_parts/part/wuscout_left_leg
	name = "MA4 Left Leg"
	icon = 'icons/FoF/mech_parts.dmi'
	icon_state = "wuscout_leftleg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	randpixel = 8

/obj/item/mecha_parts/part/wuscout_right_leg
	name = "MA4 Right Leg"
	icon = 'icons/FoF/mech_parts.dmi'
	icon_state = "wuscout_rightleg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	randpixel = 8

/obj/item/mecha_parts/part/ebscout_torso
	name = "GSA2 Torso"
	icon = 'icons/FoF/mech_parts.dmi'
	icon_state = "ebscout_torso"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_BIO = 3, TECH_ENGINEERING = 3)
	randpixel = 8

/obj/item/mecha_parts/part/ebscout_head
	name = "GSA2 Head"
	icon = 'icons/FoF/mech_parts.dmi'
	icon_state = "ebscout_head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_BIO = 3, TECH_ENGINEERING = 3)
	randpixel = 8

/obj/item/mecha_parts/part/ebscout_left_leg
	name = "GSA2 Left Leg"
	icon = 'icons/FoF/mech_parts.dmi'
	icon_state = "ebscout_leftleg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_BIO = 3, TECH_ENGINEERING = 3)
	randpixel = 8

/obj/item/mecha_parts/part/ebscout_right_leg
	name = "GSA2 Right Leg"
	icon = 'icons/FoF/mech_parts.dmi'
	icon_state = "ebscout_rightleg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_BIO = 3, TECH_ENGINEERING = 3)
	randpixel = 8

/obj/mecha/combat/wuscout
	name = "MA4 Scout Walker"
	desc = "The fourth iteration of the assaut mécanique. A lightly armored walker built to traverse the battlefield and lay down small arms fire either alone or grouped with infantry elements."
	icon = 'icons/FoF/mech_infantry.dmi'
	icon_state = "WU-scout"
	initial_icon = "WU-scout"
	opacity = 0
	health = 300
	max_temperature = 5000
	internal_damage_threshold = 45
	deflect_chance = 25
	step_in = 2.5
	cargo_capacity = 6
	max_equip = 2
	wreckage = /obj/effect/decal/mecha_wreckage/wuscout
	damage_absorption = list("brute"=0.8,"fire"=1.5,"bullet"=0.8,"laser"=1,"energy"=1,"bomb"=1.5)

/obj/mecha/combat/wuscout/eb
	name = "GSA2 Scout Walker"
	desc = "A robust design of light assault scout walker, the Gepanzerte Scout-Angriffsmaschine has remained unchanged for centuries and was built to operate as a lone element or support infantry."
	icon_state = "EB-scout"
	wreckage = /obj/effect/decal/mecha_wreckage/wuscout/eb

/obj/mecha/combat/wuscout/New()
	..() //internal storage for moving crates. think supply mule.
	var/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/HC = new /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
	HC.attach(src)

/obj/mecha/combat/wuscout/Destroy()
	for(var/atom/movable/A in src.cargo)
		A.loc = loc
		var/turf/T = loc
		if(istype(T))
			T.Entered(A)
		step_rand(A)
	cargo.Cut()
	..()