class_name EquipmentSlot
extends Button

var inventory: Inventory
var item : Item

func _ready():
	inventory = get_parent().get_parent()

func set_item(_item : Item):
	item = _item
	if item != null:
		icon = item.get_child(0).texture
		
func remove_item():
	item = null
	icon = null

func _on_pressed():
	#Use Item
	if item != null:
		unequip()
		remove_item()
			
func unequip():
	if inventory._player.velocity != Vector2.ZERO:
		print("Must be standing still to remove equipment")
		return
		
	inventory._player.unequip(item)
	inventory._info_text.text = ""
		
func _on_mouse_entered():
	if item != null:
		inventory._info_text.text = item.description
		inventory.display_info_text()

func _on_mouse_exited():
	if item != null:
		inventory.hide_info_text()
		
