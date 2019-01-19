#define NO_WINNER "The fighting for the town is still going on."
/obj/map_metadata/little_creek
	ID = MAP_LITTLE_CREEK
	title = "Big Trouble in Little Creek (100x100x2)"
	lobby_icon_state = "wildwest"
	caribbean_blocking_area_types = list(/area/caribbean/no_mans_land/invisible_wall/)
	respawn_delay = 1200
	squad_spawn_locations = FALSE
//	min_autobalance_players = 90
	faction_organization = list(
		CIVILIAN,)
	available_subfactions = list(
		)
	roundend_condition_sides = list(
		list(CIVILIAN) = /area/caribbean/british
		)
	age = "1873"
	faction_distribution_coeffs = list(CIVILIAN = 1)
	battle_name = "Little Creek"
	mission_start_message = "<font size=3>At the small frontier town of <b>Little Creek</b>, the Sheriff recieves a warning: A group of outlaws is about to rob the town's bank! He must organize the bank's defense and prevent them...</font><br><br><big><i>The grace wall will go down in <b>4 minutes</b>. The Outlaws have <b>30 minutes</b> to collect <b>1500 dollars</b> before the Army arrives!</big></i>"
	faction1 = CIVILIAN
	ambience = list('sound/ambience/desert.ogg')
	gamemode = "Bank Robbery"
	songs = list(
		"The Good, the Bad, and the Ugly Theme:1" = 'sound/music/good_bad_ugly.ogg',)
obj/map_metadata/little_creek/job_enabled_specialcheck(var/datum/job/J)
	..()
	if (J.is_cowboy == TRUE)
		. = TRUE
	else
		. = FALSE
/obj/map_metadata/little_creek/faction2_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 2400 || admin_ended_all_grace_periods)

/obj/map_metadata/little_creek/faction1_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 2400 || admin_ended_all_grace_periods)
/obj/map_metadata/little_creek/cross_message(faction)
	return "<font size = 4>The grace wall is lifted!</font>"

/obj/map_metadata/little_creek/reverse_cross_message(faction)
	return ""

/obj/map_metadata/little_creek/update_win_condition()
	if (win_condition_spam_check)
		return FALSE
	for(var/obj/structure/carriage/C in world)
		if (C.storedvalue >= 1500) // total value stored = 2191. So roughly 2/3rds
			var/message = "The Outlaws have sucessfully stolen over 1500 dollars! The robbery was successful!"
			world << "<font size = 4><span class = 'notice'>[message]</span></font>"
			show_global_battle_report(null)
			win_condition_spam_check = TRUE
			ticker.finished = TRUE
			return TRUE
	if (processes.ticker.playtime_elapsed >= 18000)
		ticker.finished = TRUE
		var/message = "The Sheriff's troops have sucessfully defended the Bank! With the Army arriving, the Outlaws retreat!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		return TRUE
#undef NO_WINNER