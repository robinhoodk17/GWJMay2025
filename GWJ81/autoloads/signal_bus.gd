extends Node

@warning_ignore("unused_signal")
signal oxygen_radius_changed(new_radoius : float)
signal resource_changed(resource : Globals.resource_type)
signal turn_ended()
signal turn_started()
signal unit_moved(target_cell : Vector2i)
signal unit_selected()
signal unit_died(unit : Node)
signal game_over(reason : String)
signal showing_character(pl_char : player_character)
signal campsite_mobile(true_or_false : bool)
signal character_ended_focus
signal campsite_showing_tooltip(yes_or_no : bool)
