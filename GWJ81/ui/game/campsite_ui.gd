extends UiPage

const CHARACTER_INFO = preload("res://ui/game/campsite_ui/character_info.tscn")
@onready var character_container: VBoxContainer = $VBoxContainer/Characters/CharacterContainer
@onready var tech_tree_container: VBoxContainer = $VBoxContainer/TechTree/TechTreeContainer

#func _ready() -> void:
	#visibility_changed.connect(populate_ui)

func show_ui():
	show()
	await get_tree().process_frame
	if !visible:
		return
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
