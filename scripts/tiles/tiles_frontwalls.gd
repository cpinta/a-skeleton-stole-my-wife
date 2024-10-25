extends TileMapLayer
class_name Tiles_FrontWalls

@onready var player: Player = Game.player
var player_coords: Vector2i
var cells_alpha = {}
var yrange: int = 4
var coords = get_used_cells()
var cellsUsedInWalls = {}
var walls: Array[Tile_Wall]

func _ready():
	var i:int = 0
	while cellsUsedInWalls.size() < coords.size():
		print(coords[i]," ",cellsUsedInWalls.has(coords[i]), " ",i)
		while cellsUsedInWalls.has(coords[i]) and i < coords.size()-1:
			i += 1
		print(coords[i]," ",cellsUsedInWalls.has(coords[i]), " ",i)
		var curWall: Tile_Wall = Tile_Wall.new()
		detect_all_cells_in_wall(curWall, coords[i])
		walls.append(curWall)
	pass

func _tile_data_runtime_update(coords, tile_data):
	tile_data.modulate.a = cells_alpha.get(coords, 1.0)
	
#Warning: Make sure this function only return true when needed. 
#Any tile processed at runtime without a need for it will imply a significant performance penalty.
func _use_tile_data_runtime_update(coords):
	return cells_alpha.has(coords)

func _process(delta):
	if player != null:
		player_coords = local_to_map(player.global_position)
		
		cells_alpha[coords[0]] = 0.3
		#transparent_cell_and_neighbors(coords[0])
		cells_alpha.clear()
		for wall in walls:
			if wall.lowy > player_coords.y - yrange:
				print(wall.lowy," ",wall.highy," ",player_coords.y)
				wall.setAll(0.3)
			else:
				wall.setAll(1)
			cells_alpha.merge(wall.getall())
		notify_runtime_tile_data_update()
		#for coord in coords:
			#if coord.y <= player_coords.y + yrange:
				#cells_alpha[coord] = 0.3
			#else:
				#cells_alpha[coord] = 1.0
			#if coord.y > player_coords.y:
				#cells_alpha[coord] = 1.0
			#notify_runtime_tile_data_update()
	else:
		player = Game.player

func detect_all_cells_in_wall(wall: Tile_Wall, coord:Vector2i):
	for neighbor in get_surrounding_cells(coord):
		if coords.has(neighbor):
			if wall.has(neighbor):
				pass
			else:
				wall.add_cell(neighbor)
				cellsUsedInWalls[neighbor] = 1
				detect_all_cells_in_wall(wall, neighbor)
			pass
	pass
