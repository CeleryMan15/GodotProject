extends CharacterBody2D

@onready var _animation = get_node("Animation")
@onready var _equipment = get_node("Equipment")
@onready var _inventory_ui = get_node("Inventory")
@onready var _equipment_window = get_node("Inventory/EquipmentWindow")
@export var speed = 400

var input_direction : Vector2
var current_animation : String

func _ready():
	toggle_inventory_visible()

func unequip(item : Item):
	if item.equipment_type == "Coat":
		_equipment.get_child(0).sprite_frames = null
		_equipment.get_child(1).sprite_frames = null
		_equipment.get_child(2).sprite_frames = null

func handle_equipment_slots(item : Item):
	if item.equipment_type == "Weapon":
		#Figure out a way to have player choose left or right weapon (Hopefully drag?)
		pass
	
	if item.equipment_type == "Head":
		_equipment_window.get_child(0).set_item(item)
	elif item.equipment_type == "Coat":
		_equipment_window.get_child(1).set_item(item)
	elif item.equipment_type == "Legs":
		_equipment_window.get_child(2).set_item(item)
	
func set_equipment_sprite_frames(item : Item):
	if item.equipment_type == "Coat":
		_equipment.get_child(0).sprite_frames = item.get_child(1).sprite_frames
		_equipment.get_child(1).sprite_frames = item.get_child(2).sprite_frames
		_equipment.get_child(2).sprite_frames = item.get_child(3).sprite_frames
	
func handle_equipment_animation(item : Item):
	set_equipment_sprite_frames(item)
	
	#Reset player animation, so equipment animations align with player
	for animated_sprite in _animation.get_children():
		animated_sprite.stop()
		animated_sprite.play("Idle")
	
	#Align equipment animations with player
	for equipment in _equipment.get_children():
		if equipment.sprite_frames != null:
			equipment.stop()
			equipment.play("Idle")

func equip(item : Item):
	handle_equipment_slots(item)
	handle_equipment_animation(item)

func flip_sprite(x_direction):
	if x_direction > 0:
		for animated_sprite in _animation.get_children():
			animated_sprite.flip_h = false
		
	elif x_direction < 0:
		for animated_sprite in _animation.get_children():
			animated_sprite.flip_h = true
		
	for equipment in _equipment.get_children():
		if equipment.sprite_frames != null:
			equipment.flip_h = _animation.get_child(0).flip_h #Choose first child of animation because all animated sprites should be synced anyway.

func handle_animation():
	if input_direction != Vector2.ZERO:
		current_animation = "Run"
	else:
		current_animation = "Idle"
		
	for animated_sprite in _animation.get_children():
		animated_sprite.play(current_animation)
		
	for equipment in _equipment.get_children():
		if equipment.sprite_frames != null:
			equipment.play(current_animation)
	
func handle_inventory():
	if Input.is_action_just_pressed("Inventory"):
		toggle_inventory_visible()
	
func toggle_inventory_visible():
	for inventory_window in _inventory_ui.get_children():
		inventory_window.visible = !inventory_window.visible
	
func get_input():
	input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	flip_sprite(input_direction.x)
	handle_animation()
	handle_inventory()
	
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
