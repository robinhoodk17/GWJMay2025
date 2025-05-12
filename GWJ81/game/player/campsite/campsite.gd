extends TextureButton
class_name campsite

signal showing_tooltip
signal hiding_tooltip

@export_group("tooltip buttons")
@export var move_button : Button
@export var setup_button : Button
@export var build_button : Button
@export var tooltip_delay : float = 0.5
@export var animation_player : AnimationPlayer
@export_group("stats")
@export var move_range : int = 1

@onready var resource_acquisition: Area2D = $Node2D/Oxygen_radius/resource_acquisition
@onready var selection_audio: AudioStreamPlayer = $SelectionAudio
@onready var sprite: Control = $Node2D
@onready var tooltip_timer: Timer = $TooltipTimer
@onready var terrain: TileMapLayer = %Terrain
@onready var tile_map_ui: TileMapLayer = %TileMapUI
@onready var camp: Sprite2D = $Node2D/Camp
@onready var van: Sprite2D = $Node2D/Van

var mobile : bool = false
var acquisition_efficiency : Dictionary[Globals.resource_type, int]
var selected : bool = false
var offset : Vector2 = Vector2.ZERO

var char_tile: Vector2i
var in_progress: bool = false
var currently_selected : bool = false
var tile_sizes : Vector2

func _ready() -> void:
	van.hide()
	move_button.button_up.connect(show_possible_moves)
	setup_button.button_up.connect(change_configuration)
	build_button.button_up.connect(show_campsite_ui)
	
	button_up.connect(show_tooltip)
	#tooltip_timer.timeout.connect(show_tooltip)
	#mouse_entered.connect(func start_timer(): tooltip_timer.start(tooltip_delay))
	#mouse_exited.connect(func start_timer(): tooltip_timer.stop())

	size.x = Globals.button_size
	size.y = Globals.button_size
	global_position -= size/2
	offset = size/2
	sprite.position += offset
	
	SignalBus.turn_ended.connect(end_turn)
	SignalBus.turn_started.connect(start_turn)
	SignalBus.unit_selected.connect(another_unit_selected)
	SignalBus.unit_moved.connect(move_unit)
	
	#button_up.connect(show_options)
	
	await get_tree().process_frame
	HexNavi.set_current_map(terrain)
	char_tile = HexNavi.global_to_cell(global_position + offset)
	global_position = HexNavi.cell_to_global(char_tile) - offset
	grab_focus()

func end_turn() -> void:
	hiding_tooltip.emit()
	for i : Node2D in resource_acquisition.get_overlapping_bodies():
		if i.is_in_group("resource"):
			if i.amount <= 0:
				return
			if acquisition_efficiency.has(i.resource_type):
				Globals.resources[i.resource_type] += 1 * acquisition_efficiency[i.resource_type]
			else:
				Globals.resources[i.resource_type] += 1
			SignalBus.resource_changed.emit(i.resource_type)
			i.amount -= 1
func start_turn() -> void:
	Globals.campsite_spent = false
func show_tooltip() -> void:
	if Globals.campsite_spent:
		return
	showing_tooltip.emit()
func another_unit_selected() -> void:
	hiding_tooltip.emit()
	if !currently_selected:
		return
	tile_map_ui.clear()
	focus_entered.emit()
	currently_selected = false
func show_possible_moves() -> void:
	SignalBus.unit_selected.emit()
	currently_selected = true
	hiding_tooltip.emit()
	char_tile = HexNavi.global_to_cell(global_position + offset)
	global_position = HexNavi.cell_to_global(char_tile) - offset
	var possible_moves = HexNavi.get_all_neighbors_in_range(char_tile,move_range)
	for i in possible_moves:
		tile_map_ui.set_cell_to_variant(1, i)
func move_unit(_target_cell : Vector2i) -> void:
	Globals.campsite_spent = true
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
	if cost > move_range + 1:
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
	another_unit_selected()
func change_configuration() -> void:
	hiding_tooltip.emit()
	if mobile:
		mobile = false
		SignalBus.campsite_mobile.emit(false)
		animation_player.play("settle_down")
		camp.show()
		van.hide()
		Globals.campsite_spent = true
		return
	if !mobile:
		mobile = true
		SignalBus.campsite_mobile.emit(true)
		animation_player.play("pack_up")
		van.show()
		camp.hide()
		Globals.campsite_spent = true
		return

func show_campsite_ui() -> void:
	hiding_tooltip.emit()
	SignalBus.unit_selected.emit()
	selection_audio.play()
	Ui.go_to("CampsiteUI")
