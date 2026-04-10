@tool
class_name Board extends Node2D

var _is_loading := false # Flag to prevent setter cascades

@export_category("Settings")
@export_range(1, 32, 1, "or_greater", "prefer_slider") var height: int = 8:
	set(value):
		height = value
		if is_inside_tree() and not _is_loading: update_values()
		
@export_range(1, 32, 1, "or_greater", "prefer_slider") var width: int = 8:
	set(value):
		width = value
		if is_inside_tree() and not _is_loading: update_values()
		
@export_range(10, 250, 10, "or_greater", "prefer_slider") var tile_size: int = 50:
	set(value):
		tile_size = value
		if is_inside_tree() and not _is_loading: update_values()
		
@export_tool_button("CLEAR", "Eraser") var clear_action = clear
@export_tool_button("UPDATE", "Reload") var update_action = update_values

@export_category("Save/Load Board")
@export_tool_button("SAVE", "Save") var save_action = save
@export_multiline("monospace", "no_wrap") var loadable := ""
@export_tool_button("LOAD", "Load") var load_action = load_string

@export_group("Settings")
@export var char_to_type: Dictionary[Tile.TYPE, String] = {
	Tile.TYPE.EMPTY: "O",
	Tile.TYPE.FILLED: "X",
	Tile.TYPE.PLAYER: "#",
	Tile.TYPE.DEAD: ".",
	Tile.TYPE.NULL: " "
}

var board_arr : Array[Tile] = []

var current_possible_moves : Array[TakePath] = []

func _ready() -> void:
	if Engine.is_editor_hint() and board_arr.is_empty():
		update_values()
		load_string()

func board(y: int, x: int) -> Tile: 
	if y >= height or y < 0: return null
	if x >= width or x < 0: return null
	
	var index = (y * width) + x
	if index >= board_arr.size(): return null
	return board_arr[index]
	
func board_set(y: int, x: int, tile: Tile) -> void:
	var index = (y * width) + x
	if index < board_arr.size():
		board_arr[index] = tile

func _process(_delta: float) -> void:
	pass

func update_values() -> void:
	if _is_loading: return # Don't update if halfway through loading a string
	
	var new_board_arr : Array[Tile] = []
	new_board_arr.resize(height * width)
	
	for old_tile in board_arr:
		if old_tile != null:
			if old_tile.y >= height or old_tile.x >= width:
				# detach and queue deletion to avoid LocalVector errors
				remove_child(old_tile)
				old_tile.queue_free() 
			else:
				var new_index = (old_tile.y * width) + old_tile.x
				new_board_arr[new_index] = old_tile
	
	board_arr = new_board_arr
	
	for y in range(height):
		for x in range(width):
			var index = (y * width) + x
			if board_arr[index] == null:
				var new_tile = Tile.new()
				new_tile.board = self
				board_arr[index] = new_tile
				add_child(new_tile)
				new_tile.set_props(y, x, tile_size)
				if Engine.is_editor_hint():
					new_tile.owner = get_tree().edited_scene_root
			else:
				board_arr[index].set_props(y, x, tile_size, board_arr[index].type)
	
	for y in range(height):
		for x in range(width):
			var current = board(y, x)
			if current:
				current.northwest = board(y-1, x-1)
				current.north = board(y-1, x)
				current.northeast = board(y-1, x+1)
				current.west = board(y, x-1)
				current.east = board(y, x+1)
				current.southwest = board(y+1, x-1)
				current.south = board(y+1, x)
				current.southeast = board(y+1, x+1)

func clear() -> void:
	for child in get_children():
		if child is Tile: # Only delete tiles
			remove_child(child)
			child.queue_free()
	board_arr.clear()

func save() -> void:
	if board_arr.size() > 0:
		var new_loadable = ""
		for y in range(height):
			if y > 0: new_loadable += "\n"
			for x in range(width):
				var t = board(y, x)
				if t != null:
					new_loadable += char_to_type.get(t.type, " ")
				else:
					new_loadable += char_to_type[Tile.TYPE.NULL]
		loadable = new_loadable
	else:
		loadable = "Board not ready or empty!"

func load_string() -> void:
	if loadable in ["Board not ready or empty!", "String is not valid or empty!", "", null]:
		loadable = "String is not valid or empty!"
		return
		
	# strip carriage returns to prevent invisible string indexing bugs
	var clean_loadable = loadable.replace("\r", "")
	var string_array := clean_loadable.split("\n")
	if string_array.is_empty() or string_array[0].length() == 0:
		loadable = "String is not valid or empty!"
		return
		
	var x_length := string_array[0].length()
	
	for s in string_array:
		if s.length() != x_length:
			loadable = "String is not valid or empty!"
			return
		for c in s:
			if char_to_type.find_key(c) == null:
				loadable = "String is not valid or empty!"
				return
	
	# block setters from interfering with array math
	_is_loading = true 
	
	clear()
	height = string_array.size()
	width = x_length
	
	board_arr.resize(height * width)
	
	for y in range(height):
		for x in range(width):
			var new_tile = Tile.new()
			new_tile.board = self
			var parsed_type = char_to_type.find_key(string_array[y][x])
			
			# add to scene first so is_inside_tree() is true when setting properties
			add_child(new_tile) 
			if Engine.is_editor_hint():
				new_tile.owner = get_tree().edited_scene_root
				
			new_tile.set_props(y, x, tile_size, parsed_type) 
			board_set(y, x, new_tile)
			
	# re-enable setters and safely trigger link update
	_is_loading = false
	update_values()

func clear_highlights() -> void:
	for t: Tile in board_arr:
		t.highlighted = false
