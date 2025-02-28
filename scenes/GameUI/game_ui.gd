extends Control

const MAIN = preload("res://scenes/main/main.tscn")
@onready var level_label = $MarginContainer/VBoxContainer/LevelLabel
@onready var level_attemps = $"MarginContainer/VBoxContainer/Level Attemps"
@onready var audio_stream_player = $AudioStreamPlayer
@onready var v_box_container_2 = $MarginContainer/VBoxContainer2
@onready var end_level = $EndLevel



func _ready():
	level_label.text = "LEVEL %s" % ScoreManager._selected_level
	update_attemps(0)
	SignalManager.on_score_updated.connect(update_attemps)
	SignalManager.on_level_complete.connect(level_complete)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Menu") and v_box_container_2.is_visible_in_tree():
		get_tree().change_scene_to_packed(MAIN)

func update_attemps(attemps):
	level_attemps.text = "ATTEMPS %s" % attemps

func level_complete():
	v_box_container_2.show()
	end_level.play()
	
