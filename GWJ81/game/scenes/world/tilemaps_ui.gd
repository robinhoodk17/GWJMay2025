extends TileMapLayer

const MAIN_ATLAS_ID : int = 1
const RED := Vector2i(0, 0)
const GREEN := Vector2i(1, 0)
const BLUE := Vector2i(2, 0)
	
func set_cell_to_variant(id : int, cell : Vector2i) -> void:
	var cell_variant
	match id:
		0: cell_variant = RED
		1: cell_variant = GREEN
		2: cell_variant = BLUE
	set_cell(cell,MAIN_ATLAS_ID,cell_variant)

func clear_cells() -> void:
	for pos in get_used_cells():
		clear()
