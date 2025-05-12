extends Node

@warning_ignore("unused_signal")
signal oxygen_radius_changed(new_radoius : float)
signal resource_changed(resource : Globals.resource_type)
signal turn_ended()
signal unit_moved(target_cell : Vector2i)
signal unit_selected()
signal unit_died(unit : Node)
signal game_over(reason : String)
signal showing_character(char : player_character)
