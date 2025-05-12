extends UiPage

const CHARACTER_INFO = preload("res://ui/game/campsite_ui/character_info.tscn")
const BUILDING_BUTTON = preload("res://ui/game/campsite_ui/building_button.tscn")
@onready var character_container: VBoxContainer = $VBoxContainer/Characters/CharacterContainer
@onready var tech_tree_container: GridContainer = $VBoxContainer/TechTree/TechTreeContainer

#func _ready() -> void:
	#visibility_changed.connect(populate_ui)

func show_ui():
	show()
	await get_tree().process_frame
	if !visible:
		return
	handle_character_UI()
	handle_building_UI()
func handle_building_UI() -> void:
	for i in tech_tree_container.get_children():
		i.queue_free()
	for blueprint : Globals.building_type in Globals.available_blueprints.keys():
		if Globals.available_blueprints[blueprint] != null:
			var new_blueprint : building_button = BUILDING_BUTTON.instantiate()
			new_blueprint.costs = Globals.available_blueprints[blueprint].costs
			new_blueprint.building_name = Globals.available_blueprints[blueprint].building_name
			new_blueprint.portrait = Globals.available_blueprints[blueprint].portrait
			tech_tree_container.add_child(new_blueprint)
func handle_character_UI():
	for i in character_container.get_children():
		i.queue_free()
	for character in Globals.characters.keys():
		var new_char = CHARACTER_INFO.instantiate()
		new_char.pl_char = character
		new_char.char_name = character.character_name
		new_char.portrait_texture = Globals.characters[character]
		new_char.hp = character.hp
		new_char.speed = character.speed
		new_char.strength = character.strength
		new_char.fight = character.fighting
		new_char.foraging = character.hunting_foraging
		new_char.wood = character.raw_resources
		new_char.crafting = character.crafting
		character_container.add_child(new_char)
