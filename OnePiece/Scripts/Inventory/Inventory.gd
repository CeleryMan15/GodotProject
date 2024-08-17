class_name Inventory
extends Node

var slots : Array[InventorySlot]
@onready var _player = get_parent()
@onready var _info_text : Label = get_node("EquipmentWindow/InfoText")
const coat = preload("res://Scenes/Prefabs/Equipment/coat_equipment.tscn")

func _ready():	
	for new_slot in get_node("Window/SlotContainer").get_children():
		slots.append(new_slot)
		new_slot.set_item(null)
		new_slot.inventory = self
	
	#Add default inventory items
	add_item(coat.instantiate())

func add_item(item : Item):
	for slot in slots:
		if slot.item == null:
			slot.set_item(item)
			break

func display_info_text():
	_info_text.visible = true

func hide_info_text():
	_info_text.visible = false
