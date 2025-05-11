extends TextureButton

@onready var resource_acquisition: Area2D = $Node2D/Oxygen_radius/resource_acquisition
@onready var selection_label: Node2D = $Node2D/Selection
@onready var selection_audio: AudioStreamPlayer = $SelectionAudio
@onready var sprite: Control = $Node2D

var acquisition_efficiency : Dictionary[Globals.resource_type, int]
var selected : bool = false
var offset : Vector2 = Vector2.ZERO

func _ready() -> void:
	size.x = Globals.button_size
	size.y = Globals.button_size
	global_position -= size/2
	offset = size/2
	sprite.position += offset
	SignalBus.turn_ended.connect(end_turn)
	button_up.connect(show_campsite_ui)
	await get_tree().process_frame
	grab_focus()

func end_turn() -> void:
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


func _process(delta: float) -> void:
	selection_label.visible = selected
	#global_position = get_global_mouse_position()
	


func show_campsite_ui() -> void:
	selection_audio.play()
	Ui.go_to("CampsiteUI")
