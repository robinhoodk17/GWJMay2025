extends TextureButton
class_name player_character

signal showing_tooltip
signal hiding_tooltip
@export var is_currently_scout : bool
@export_group("character_stats")
@export var character_name : String = "Karen"
##hit points before death
@export var hp : int = 5
@export var max_hp : int = 5
##how much weight they can carry
@export var strength : int = 5
##tiles moved per turn
@export var speed : int = 2
##can gather wood and stone
@export var raw_resources : bool = true
##can hunt and/or forage
@export var hunting_foraging : bool = true
##can they craft stuff
@export var crafting : bool = true
##amount of damage done per attack
@export var fighting : int = 5
@export var actions_per_turn : int = 1
@export_group("functionality and animation")
@export var tooltip_delay : float = 1.0

@onready var selection_audio: AudioStreamPlayer = $SelectionAudio
@onready var sprite: Control = $sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var selection_label: Label = $sprite/Selection_label
@onready var terrain: TileMapLayer = %Terrain
@onready var tile_map_ui: TileMapLayer = %TileMapUI
@onready var tooltip_timer: Timer = $TooltipTimer
@onready var sprite_2d: Sprite2D = $sprite/Sprite2D

var char_tile: Vector2i
var in_progress: bool = false
var offset : Vector2 = Vector2.ZERO
var currently_selected : bool = false
var tile_sizes : Vector2
var is_center_of_attention : bool = false
var resources : Dictionary[Globals.resource_type, int] = {
	Globals.resource_type.FOOD : 0,
	Globals.resource_type.WATER : 0
}
var action_spent : bool = false
var actions_left : int = actions_per_turn
var dead : bool = false
func _ready() -> void:
	Globals.characters[self] = sprite_2d.texture
	SignalBus.turn_ended.connect(end_turn)
	SignalBus.turn_started.connect(start_turn)
	SignalBus.unit_selected.connect(another_unit_selected)
	SignalBus.unit_moved.connect(move_unit)
	SignalBus.campsite_showing_tooltip.connect(center_of_attention)
	button_up.connect(select_unit)
	tooltip_timer.timeout.connect(show_tooltip)
	mouse_entered.connect(func start_timer(): tooltip_timer.start(tooltip_delay))
	mouse_exited.connect(func start_timer(): tooltip_timer.stop())
	
	tile_sizes = terrain.tile_set.tile_size
	size.x = Globals.button_size
	size.y = Globals.button_size
	global_position = global_position.snapped(terrain.tile_set.tile_size)
	global_position -= size/2
	offset = size/2
	sprite.position += offset
	
	await get_tree().process_frame
	HexNavi.set_current_map(terrain)
	char_tile = HexNavi.global_to_cell(global_position + offset)
	global_position = HexNavi.cell_to_global(char_tile) - offset
	grab_focus()
func center_of_attention(another_one_has_attention : bool) -> void:
	if another_one_has_attention:
		another_unit_selected()
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP
	disabled = another_one_has_attention
	is_center_of_attention = !another_one_has_attention
func show_tooltip() -> void:
	if !is_center_of_attention:
		return
	showing_tooltip.emit()
func another_unit_selected() -> void:
	hiding_tooltip.emit()
	if !currently_selected:
		return
	tile_map_ui.clear()
	focus_entered.emit()
	selection_label.hide()
	currently_selected = false
func select_unit() -> void:
	SignalBus.unit_selected.emit()
	hiding_tooltip.emit()
	if actions_left <= 0 or dead:
		return
	selection_audio.play()
	currently_selected = true
	selection_label.show()
	show_possible_moves()
func show_possible_moves() -> void:
	char_tile = HexNavi.global_to_cell(global_position + offset)
	global_position = HexNavi.cell_to_global(char_tile) - offset
	var possible_moves = HexNavi.get_all_neighbors_in_range(char_tile,speed)
	for i in possible_moves:
		tile_map_ui.set_cell_to_variant(1, i)
func move_unit(_target_cell : Vector2i) -> void:
	hiding_tooltip.emit()
	if !currently_selected:
		return
	if HexNavi.tile_to_id(_target_cell) == -1:
		return
	var tile_path := HexNavi.get_navi_path(char_tile, _target_cell)
	var cost : int = 0
	for tile in tile_path:
		cost += 1
	print_debug(cost)
	if cost > speed + 1:
		return
	tile_map_ui.clear()
	#move the character along the path
	in_progress = true
	var move_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	for tile in tile_path:
		move_tween.tween_property(self, "global_position", HexNavi.cell_to_global(tile) - offset, 0.2)
	await move_tween.finished
	char_tile = HexNavi.global_to_cell(global_position + offset)
	in_progress = false
	actions_left -= 1
	another_unit_selected()
	#global_position = HexNavi.cell_to_global(_target_cell) - offset
func end_turn() -> void:
	hiding_tooltip.emit()
	if is_currently_scout:
		if resources[Globals.resource_type.FOOD] == 0 or resources[Globals.resource_type.WATER] == 0:
			if Globals.character_focused:
				await SignalBus.character_ended_focus
			Globals.character_focused = true
			showing_tooltip.emit()
			SignalBus.unit_died.emit(sprite)
			await get_tree().create_timer(1).timeout
			resources[Globals.resource_type.FOOD] -= 1
			resources[Globals.resource_type.WATER] -= 1
			die()
			return
		resources[Globals.resource_type.FOOD] -= 1
		resources[Globals.resource_type.WATER] -= 1

	else:
		Globals.resources[Globals.resource_type.FOOD] -= 1
		Globals.resources[Globals.resource_type.WATER] -= 1
		if Globals.resources[Globals.resource_type.FOOD] < 0:
			SignalBus.game_over.emit("starvation")
		if Globals.resources[Globals.resource_type.WATER] < 0:
			SignalBus.game_over.emit("thirst")
func start_turn() -> void:
	actions_left = actions_per_turn
func die() -> void:
	Globals.characters.erase(self)
	showing_tooltip.emit()
	dead = true
	await get_tree().create_timer(1).timeout
	hiding_tooltip.emit()
	animation_player.play("die")

func delete_self() -> void:
	Globals.characters.erase(self)
	Globals.character_focused = false
	SignalBus.character_ended_focus.emit()
	queue_free()
