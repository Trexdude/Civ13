/mob/living/simple_animal/parrot
	name = "Parrot"
	desc = "A parrot. Maybe it can sit on your shoulder?."
	icon = 'icons/mob/animal.dmi'
	icon_state = "parrot_sit"
	icon_living = "parrot_sit"
	icon_dead = "parrot_dead"
	speak_emote = list("squawks")
	health = 25
	maxHealth = 25
	attacktext = "bitten"
	melee_damage_lower = 2
	melee_damage_upper = 5
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "hits"
	meat_amount = 2
	mob_size = MOB_SMALL
	possession_candidate = TRUE

/mob/living/simple_animal/turkey_f
	name = "\improper turkey"
	desc = "A common american animal. Good for meat."
	icon_state = "turkey-hen"
	icon_living = "turkey-hen"
	icon_dead = "turkey-hen-dead"
	speak = list("Cluck!","Gluglugluglu!","GLU GLU.")
	speak_emote = list("clucks","gubles")
	emote_hear = list("gubles")
	emote_see = list("pecks at the ground","flaps its wings viciously")
	speak_chance = 2
	turns_per_move = 3
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	meat_amount = 3
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"
	health = 12
	pass_flags = PASSTABLE
	mob_size = MOB_SMALL

/mob/living/simple_animal/turkey_m
	name = "\improper turkey"
	desc = "A common american animal. Good for meat."
	icon_state = "turkey-tom"
	icon_living = "turkey-tom"
	icon_dead = "turkey-tom-dead"
	speak = list("Cluck!","Gluglugluglu!","GLU GLU.")
	speak_emote = list("clucks","gubles")
	emote_hear = list("gubles")
	emote_see = list("pecks at the ground","flaps its wings viciously")
	speak_chance = 2
	turns_per_move = 3
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	meat_amount = 3
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"
	health = 12
	harm_intent_damage = 4
	pass_flags = PASSTABLE
	mob_size = MOB_SMALL

/mob/living/simple_animal/goose
	name = "\improper goose"
	desc = "A common american migratory bird. Quite dangerous."
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose-dead"
	speak = list("HONK!","SSSS!","HONK HONK HONK!")
	speak_emote = list("honks","hisses")
	emote_hear = list("honks")
	emote_see = list("pecks at the ground","flaps its wings viciously")
	speak_chance = 2
	turns_per_move = 3
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	meat_amount = 3
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"
	health = 12
	harm_intent_damage = 7
	pass_flags = PASSTABLE
	mob_size = MOB_SMALL