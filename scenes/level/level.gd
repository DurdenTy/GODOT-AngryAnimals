extends Node2D

const ANIMAL = preload("res://scenes/animal/Animal.tscn")
@onready var animal_start = $AnimalStart
const MAIN = preload("res://scenes/main/main.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	add_animal()
	SignalManager.on_animal_died.connect(add_animal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_packed(MAIN)

func animal_died():
	print("Animal died!	")
	
func add_animal():
	var animal = ANIMAL.instantiate()
	animal.position = animal_start.position
	add_child(animal)
