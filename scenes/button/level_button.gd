extends TextureButton

const HOVER_SCALE  = Vector2(1.1, 1.1)
const DEFAULT_SCALE  = Vector2(1.0, 1.0)

@export var level_number = 1

@onready var level_label = $MC/VBoxContainer/LevelLabel
@onready var score_label = $MC/VBoxContainer/ScoreLabel

var _level_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	level_label.text = str(level_number)
	var best_sc = ScoreManager.get_best_level_score(str(level_number))
	score_label.text = str(best_sc)
	_level_scene = load("res://scenes/level/level_%s.tscn" % level_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	ScoreManager.set_level_selected(level_number)
	get_tree().change_scene_to_packed(_level_scene)


func _on_mouse_entered():
	scale = HOVER_SCALE


func _on_mouse_exited():
	scale = DEFAULT_SCALE
