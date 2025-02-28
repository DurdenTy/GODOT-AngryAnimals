extends Node


var _attemps = 0
var _cup_hit = 0
var _total_cups = 0
var _level_number = 0

func _ready():
	_total_cups = get_tree().get_nodes_in_group("Cups").size()
	_level_number = ScoreManager.get_level_selected()
	SignalManager.on_attempt_made.connect(on_attemp_made)
	SignalManager.on_cup_destroyed.connect(on_cup_destroyed)


func on_attemp_made():
	_attemps += 1
	SignalManager.on_score_updated.emit(_attemps)
	
func on_cup_destroyed():
	_cup_hit += 1
	if _cup_hit == _total_cups:
		SignalManager.on_level_complete.emit()
		ScoreManager.set_score_for_level(_attemps, str(_level_number))
