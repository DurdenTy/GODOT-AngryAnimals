extends RigidBody2D

enum ANIMAL_STATE { READY, DRAG, RELEASE }
@onready var label = $Label


var _state: ANIMAL_STATE = ANIMAL_STATE.READY

func _physics_process(delta):
	update(delta)
	label.text = "%s" % ANIMAL_STATE.keys()[_state]
	

func set_new_state(new_state):
	_state = new_state
	if _state == ANIMAL_STATE.RELEASE:
		freeze = false
	elif _state == ANIMAL_STATE.DRAG:
		pass
	

func detect_release():
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released("drag"):
			set_new_state(ANIMAL_STATE.RELEASE)
			return true
	return false


func update_drag():
	
	if detect_release():
		return
	
	var gmp = get_global_mouse_position()
	position = gmp


func update(delta):
	match _state:
		ANIMAL_STATE.DRAG:
			update_drag()




func die():
	queue_free()
	set_process(false)
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	SignalManager.on_animal_died.emit()
	die()


func _on_input_event(viewport, event, shape_idx):
	if _state == ANIMAL_STATE.READY and  event.is_action_pressed("drag"):
		set_new_state(ANIMAL_STATE.DRAG)
