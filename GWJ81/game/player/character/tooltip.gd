extends Panel

@onready var character: player_character = $"../.."

func _ready() -> void:
	character.showing_tooltip.connect(handle_tooltip)
	character.hiding_tooltip.connect(hide)
	hide()

func handle_tooltip() -> void:
	show()
