@tool
class_name Tile extends Sprite2D

#region Textures
const ICON = preload("uid://dgiqw4yimxh3") #placeholder
const BLACK = preload("uid://brnwttvfed8oy")
const TEAL = preload("uid://dfb2xgfoofrw")
const WHITE = preload("uid://ykkd0vn8m4rr")
const PLAYER_PIECE = preload("uid://bls100m1vwsiq")
#endregion

enum TYPE {
	EMPTY,
	FILLED,
	NULL
}

@export var type : TYPE = TYPE.EMPTY:
	set(value):
		type = value
		if is_inside_tree(): update_values()

@export var highlighted := false

var y: int
var x: int
@export var size: int

@export_tool_button("Get Valid Moves", "PathFollow2D") var moves_action = get_possible_moves

@export_group("Link References")
@export var northwest: Tile = null
@export var north: Tile = null
@export var northeast: Tile = null
@export var west: Tile = null
@export var east: Tile = null
@export var southwest: Tile = null
@export var south: Tile = null
@export var southeast: Tile = null

var area : Area2D
var collision : CollisionShape2D

func set_props(_y: int = y, _x: int = x, _size: int = size, _type: TYPE = type) -> void:
	y = _y
	x = _x
	size = _size
	type = _type
	# Automatically update visuals when properties change
	if is_inside_tree(): 
		update_values()

func _ready() -> void:
	if not is_instance_valid(area):
		area = Area2D.new()
		add_child(area)
		area.input_event.connect(_on_input_event)
		if Engine.is_editor_hint():
			area.owner = get_tree().edited_scene_root
			
	if not is_instance_valid(collision):
		collision = CollisionShape2D.new()
		collision.shape = RectangleShape2D.new()
		area.add_child(collision)
		if Engine.is_editor_hint():
			collision.owner = get_tree().edited_scene_root
	 
	update_values()

func load_name() -> void:
	name = "Tile(" + str(y) + "," + str(x) + ")"

func _process(_delta: float) -> void:
	if highlighted:
		if modulate == Color.WHITE:
			var tween = create_tween()
			tween.tween_property(self, "modulate", Color(0.992, 1.0, 0.427, 1.0), 0.25)
		elif modulate == Color(0.992, 1.0, 0.427, 1.0):
			var tween = create_tween()
			tween.tween_property(self, "modulate", Color.WHITE, 0.25)
	else:
		modulate = Color.WHITE
	pass

func update_values() -> void:
	load_name()
	
	match type:
		TYPE.EMPTY: texture = WHITE
		TYPE.FILLED: texture = BLACK
		TYPE.NULL: texture = TEAL
		_: texture = ICON
		
	# Moving scale and position calculations here so they update dynamically 
	# when the editor changes the Board settings
	if texture:
		var texture_scale := Vector2(float(size) / texture.get_width(), float(size) / texture.get_height())
		scale = texture_scale
	
	position = Vector2(x * size, y * size)
	
	collision.shape.size = Vector2(float(size), float(size))
		
func _to_string() -> String:
	return "(" + str(y) + "," + str(x) + "): " + str(type)
	
func get_possible_moves() -> Array[TakePath]:
	#var surrounding: Array[Tile] = [northwest, north, northeast, west, east, southwest, south, southeast]
	# lookup for possible move, and the piece it would take ([new position, taken piece])
	var possible_moves: Array[TakePath] = []
	
	# there has to be a better way to do this
	# oh well #myowngrave
	
	# UP+LEFT
	if is_instance_valid(northwest) and northwest.type == TYPE.FILLED:
		#check for next piece
		if is_instance_valid(northwest.northwest) and northwest.northwest.type == TYPE.EMPTY:
			possible_moves.append(TakePath.new(self, northwest.northwest, northwest))
		#bounce off the wall possibility
		if (not is_instance_valid(northwest.northwest) or northwest.northwest.type == TYPE.NULL) and (not is_instance_valid(northwest.west) or northwest.west.type == TYPE.NULL):
			if is_instance_valid(northwest.northeast) and northwest.northeast.type == TYPE.EMPTY:
				possible_moves.append(TakePath.new(self, northwest.northeast, northwest))
					
	# UP
	if is_instance_valid(north) and north.type == TYPE.FILLED:
		if is_instance_valid(north.north) and north.north.type == TYPE.EMPTY:
			possible_moves.append(TakePath.new(self, north.north, north))
			
	# UP+RIGHT
	if is_instance_valid(northeast) and northeast.type == TYPE.FILLED:
		#check for next piece
		if is_instance_valid(northeast.northeast) and northeast.northeast.type == TYPE.EMPTY:
			possible_moves.append(TakePath.new(self, northeast.northeast, northeast))
		#bounce off the wall possibility
		if (not is_instance_valid(northeast.northeast) or northeast.northeast.type == TYPE.NULL) and (not is_instance_valid(northeast.east) or northeast.east.type == TYPE.NULL):
			if is_instance_valid(northeast.northwest) and northeast.northwest.type == TYPE.EMPTY:
				possible_moves.append(TakePath.new(self, northeast.northwest, northeast))
	
	# LEFT
	if is_instance_valid(west) and west.type == TYPE.FILLED:
		if is_instance_valid(west.west) and west.west.type == TYPE.EMPTY:
			possible_moves.append(TakePath.new(self, west.west, west))
			
	# RIGHT
	if is_instance_valid(east) and east.type == TYPE.FILLED:
		if is_instance_valid(east.east) and east.east.type == TYPE.EMPTY:
			possible_moves.append(TakePath.new(self, east.east, east))
			
	# DOWN+LEFT
	if is_instance_valid(southwest) and southwest.type == TYPE.FILLED:
		#check for next piece
		if is_instance_valid(southwest.southwest) and southwest.southwest.type == TYPE.EMPTY:
			possible_moves.append(TakePath.new(self, southwest.southwest, southwest))
		#bounce off the wall possibility
		if (not is_instance_valid(southwest.southwest) or southwest.southwest.type == TYPE.NULL) and (not is_instance_valid(southwest.west) or southwest.west.type == TYPE.NULL):
			if is_instance_valid(southwest.southeast) and southwest.southeast.type == TYPE.EMPTY:
				possible_moves.append(TakePath.new(self, southwest.southeast, southwest))
					
	# DOWN
	if is_instance_valid(south) and south.type == TYPE.FILLED:
		if is_instance_valid(south.south) and south.south.type == TYPE.EMPTY:
			possible_moves.append(TakePath.new(self, south.south, south))
			
	# DOWN+RIGHT
	if is_instance_valid(southeast) and southeast.type == TYPE.FILLED:
		#check for next piece
		if is_instance_valid(southeast.southeast) and southeast.southeast.type == TYPE.EMPTY:
			possible_moves.append(TakePath.new(self, southeast.southeast, southeast))
		#bounce off the wall possibility
		if (not is_instance_valid(southeast.southeast) or southeast.southeast.type == TYPE.NULL) and (not is_instance_valid(southeast.east) or southeast.east.type == TYPE.NULL):
			if is_instance_valid(southeast.southwest) and southeast.southwest.type == TYPE.EMPTY:
				possible_moves.append(TakePath.new(self, southeast.southwest, southeast))
	
	
	print(possible_moves)
	
	for p: TakePath in possible_moves:
		p.show_path()
	
	return possible_moves

func _on_input_event(viewport: Node, event: InputEvent, shape_idk: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Sprite clicked!")
		# Add your logic here
