@tool
class_name Board extends Node2D

@export_category("Settings")
@export_range(1, 32, 1, "or_greater", "prefer_slider") var height: int = 8:
	set(value):
		height = value
		if is_inside_tree(): update_values()
		
@export_range(1, 32, 1, "or_greater", "prefer_slider") var width: int = 8:
	set(value):
		width = value
		if is_inside_tree(): update_values()
		
@export_range(10, 250, 10, "or_greater", "prefer_slider") var tile_size: int = 50:
	set(value):
		tile_size = value
		if is_inside_tree(): update_values()
		
@export_tool_button("CLEAR", "Eraser") var clear_action = clear
@export_tool_button("UPDATE", "Reload") var update_action = update_values

@export_category("Save/Load Board")
@export_tool_button("SAVE", "Save") var save_action = save
@export_multiline("monospace", "no_wrap") var loadable := ""
@export_tool_button("LOAD", "Load") var load_action = load

@export_group("Settings")
@export var char_to_type: Dictionary[Tile.TYPE, String] = {
	Tile.TYPE.EMPTY: "O",
	Tile.TYPE.FILLED: "X",
	Tile.TYPE.NULL: " "
}

var board_arr : Array[Tile] #actual board data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func board(y: int, x: int) -> Tile: #board 2d accessor
	if y >= height or y < 0:
		#print("BOARD Y OUT OF BOUNDS")
		return null
	if x >= width or x < 0:
		#print("BOARD X OUT OF BOUNDS")
		return null
		
	return board_arr[(y * width) + x]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_values() -> void:
	clear()
	
	for y in range(height):
		for x in range(width):
			var new_tile = Tile.new(y, x, tile_size)
			board_arr.append(new_tile)
			add_child(new_tile)
			if Engine.is_editor_hint():
				new_tile.owner = get_tree().edited_scene_root
	
	# link set references
	for y in range(height):
		for x in range(width):
			board(y, x).northwest = board(y-1, x-1)
			board(y, x).north = board(y-1, x)
			board(y, x).northeast = board(y-1, x+1)
			board(y, x).west = board(y, x-1)
			board(y, x).east = board(y, x+1)
			board(y, x).southwest = board(y+1, x-1)
			board(y, x).south = board(y+1, x)
			board(y, x).southeast = board(y+1, x+1)

func clear() -> void:
	for child in get_children():
		child.queue_free()
		
	board_arr.clear()

func save() -> void:
	if board_arr.size() > 0:
		loadable = ""
		
		for y in range(height):
			if y > 0: loadable += "\n"
			for x in range(width):
				print(char_to_type[board(y, x).type])
				loadable += char_to_type[board(y, x).type]
	elif loadable == "" or loadable == "Board not ready or empty!" or loadable == "String is not valid or empty!":
		loadable = "Board not ready or empty!"

func load() -> void:
	if loadable == "Board not ready or empty!" or loadable == "String is not valid or empty!":
		return
	elif loadable == "" or loadable == null:
		loadable = "String is not valid or empty!"
		return
		
	var string_array := loadable.split("\n")
	var x_length := string_array[0].length()
	
	for s in string_array:
		if s.length() != x_length:
			loadable = "String is not valid or empty!"
			return
		for c in s:
			if char_to_type.find_key(c) == null:
				loadable = "String is not valid or empty!"
				return
	
	clear()
	height = string_array.size()
	width = x_length
	
	for y in range(height):
		for x in range(width):
			var new_tile = Tile.new(y, x, tile_size, char_to_type.find_key(string_array[y][x]))
			board_arr.append(new_tile)
			add_child(new_tile)
			if Engine.is_editor_hint():
				new_tile.owner = get_tree().edited_scene_root
			
			
	# link set references
	for y in range(height):
		for x in range(width):
			board(y, x).northwest = board(y-1, x-1)
			board(y, x).north = board(y-1, x)
			board(y, x).northeast = board(y-1, x+1)
			board(y, x).west = board(y, x-1)
			board(y, x).east = board(y, x+1)
			board(y, x).southwest = board(y+1, x-1)
			board(y, x).south = board(y+1, x)
			board(y, x).southeast = board(y+1, x+1)
	
	
