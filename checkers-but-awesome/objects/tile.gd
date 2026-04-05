@tool
class_name Tile extends Sprite2D

#region Textures
const ICON = preload("uid://dgiqw4yimxh3") #placeholder
const BLACK = preload("uid://bmlre8n40l8m4")
const RED = preload("uid://bvw4ed3vfytow")
const WHITE = preload("uid://du3t7qwxyhd4o")
#endregion

#types
enum TYPE {
	EMPTY,
	FILLED,
	NULL
}

@export var type := TYPE.EMPTY:
	set(value):
		type = value
		if is_inside_tree(): update_values()
var y: int
var x: int
var size: int

# link references
@export var northwest: Tile = null
@export var north: Tile = null
@export var northeast: Tile = null
@export var west: Tile = null
@export var east: Tile = null
@export var southwest: Tile = null
@export var south: Tile = null
@export var southeast: Tile = null

func _init(_y: int = y, _x: int = x, _size: int = size, _type := TYPE.EMPTY) -> void:
	y = _y
	x = _x
	size = _size
	type = _type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_values()
	
	var texture_scale := Vector2(float(size) / texture.get_width(), float(size) / texture.get_height())
	scale = texture_scale
	position = Vector2(x * size, y * size)

func load_name() -> void:
	name = "Tile(" + str(y) + "," + str(x) + ")"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_values() -> void:
	load_name()
	
	match type:
		TYPE.EMPTY: texture = WHITE
		TYPE.FILLED: texture = BLACK
		TYPE.NULL: texture = RED
		_: texture = ICON
