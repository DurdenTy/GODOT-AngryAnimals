extends Node2D

const ANIMAL = preload("res://scenes/animal/Animal.tscn")
@onready var animal_start = $AnimalStart
# Called when the node enters the scene tree for the first time.
func _ready():
	add_animal()
	SignalManager.on_animal_died.connect(add_animal)

func animal_died():
	print("Animal died!	")
	
func add_animal():
	var animal = ANIMAL.instantiate()
	animal.position = animal_start.position
	add_child(animal)
