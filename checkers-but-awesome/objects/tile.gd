@tool
class_name Tile extends Sprite2D

#region Textures
const ICON = preload("uid://dgiqw4yimxh3") #placeholder
const BLACK = preload("uid://brnwttvfed8oy")
const RED = preload("uid://dfb2xgfoofrw")
const WHITE = preload("uid://ykkd0vn8m4rr")
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

var y: int
var x: int
var size: int

@export_group("Link References")
@export var northwest: Tile = null
@export var north: Tile = null
@export var northeast: Tile = null
@export var west: Tile = null
@export var east: Tile = null
@export var southwest: Tile = null
@export var south: Tile = null
@export var southeast: Tile = null

func set_props(_y: int = y, _x: int = x, _size: int = size, _type: TYPE = type) -> void:
	y = _y
	x = _x
	size = _size
	type = _type
	# Automatically update visuals when properties change
	if is_inside_tree(): 
		update_values()

func _ready() -> void:
	update_values()

func load_name() -> void:
	name = "Tile(" + str(y) + "," + str(x) + ")"

func _process(_delta: float) -> void:
	pass

func update_values() -> void:
	load_name()
	
	match type:
		TYPE.EMPTY: texture = WHITE
		TYPE.FILLED: texture = BLACK
		TYPE.NULL: texture = RED
		_: texture = ICON
		
	# Moving scale and position calculations here so they update dynamically 
	# when the editor changes the Board settings
	if texture:
		var texture_scale := Vector2(float(size) / texture.get_width(), float(size) / texture.get_height())
		scale = texture_scale
	
	position = Vector2(x * size, y * size)
		
func _to_string() -> String:
	return "(" + str(y) + "," + str(x) + "): " + str(type)
