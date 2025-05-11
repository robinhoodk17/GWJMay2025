extends CharacterBody2D
class_name game_camera

@export var move : GUIDEAction
@export var next_unit : GUIDEAction
@onready var campsite: TextureButton = %Campsite

func _ready() -> void:
	next_unit.triggered.connect(_next_unit)
	SignalBus.unit_died.connect(unit_died)

func _physics_process(delta: float) -> void:
	var direction : Vector2 = move.value_axis_2d
	velocity = direction * Globals.camera_speed
	move_and_slide()

func _next_unit() -> void:
	global_position = campsite.global_position

func unit_died(unit) -> void:
	global_position = unit.global_position
