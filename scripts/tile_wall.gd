class_name Tile_Wall

var highy = 0
var lowy = 0
var cells = {}

var isInFront: bool = false

func add_cell(cell: Vector2i):
	if not cells.has(cell):
		if cells.size() == 0:
			highy = cell.y
			lowy = cell.y
		else:
			if cell.y > highy:
				highy = cell.y
			if cell.y < lowy:
				lowy = cell.y 
		cells[cell] = 1
	pass

func has(cell: Vector2i):
	return cells.has(cell)

func getall():
	return cells
	
func check_first_cell():
	if cells.size() > 0:
		return cells.values()[0]
	else:
		return -1
	
func setAll(value: float):
	if check_first_cell() != value:
		for cell in cells:
			cells[cell] = value
