extends Node

const DEFAULT_SCORE = 1000
const SCORE_PATH = "res://score.dat"


var _selected_level = 1
var _level_scores = {}

func _ready():
	load_save()
	
	
func get_level_selected():
	return _selected_level
	
func set_level_selected(ls):
	_selected_level = ls

func check_key_exist(level):
	if _level_scores.has(level) == false:
		_level_scores[level] = DEFAULT_SCORE

func set_score_for_level(score, level):
	check_key_exist(level)
	if _level_scores[level] > score:
		_level_scores[level] = score
		save()
	
func get_best_level_score(level):
	check_key_exist(level)
	return _level_scores[level]


func save():
	var file = FileAccess.open(SCORE_PATH, FileAccess.WRITE)
	var score_json_file = JSON.stringify(_level_scores)
	file.store_string(score_json_file)

func load_save():
	var file = FileAccess.open(SCORE_PATH, FileAccess.READ)
	if file == null:
		save()
	var data = file.get_as_text()
	_level_scores = JSON.parse_string(data)
