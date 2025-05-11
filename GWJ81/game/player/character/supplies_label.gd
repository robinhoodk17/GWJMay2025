extends Label

@export var resource : Globals.resource_type = Globals.resource_type.WOOD
@onready var character: player_character = $"../../../../.."

func _ready() -> void:
	character.showing_tooltip.connect(update_count)
	character.hiding_tooltip.connect(hide)


func update_count() -> void:
	show()
	text = str(character.resources[resource])
