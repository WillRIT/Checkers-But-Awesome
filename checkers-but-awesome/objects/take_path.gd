class_name TakePath

var start : Tile
var take : Tile
var end : Tile

func _init(_start: Tile, _end: Tile, _take: Tile) -> void:
	start = _start
	take = _take
	end = _end

func show_path() -> void:
	end.highlighted = true
	
func hide_path() -> void:
	end.highlighted = false

func _to_string() -> String:
	return "Start: " + str(start) + ", End: " + str(end) + ". Took: " + str(take)
