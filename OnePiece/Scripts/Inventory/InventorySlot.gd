class_name InventorySlot
extends Button

var inventory: Inventory
var item : Item

func set_item(_item : Item):
	item = _item
	if item != null:
		icon = item.get_child(0).texture

func _on_pressed():
	#Use Item
	if item != null:
		if item.type == "Equipment":
			equip_item()
			
func equip_item():
	if inventory._player.velocity != Vector2.ZERO:
		print("Must be standing still to don equipment")
		return
		
	inventory._player.equip(item)
		
func _on_mouse_entered():
	if item != null:
		inventory._info_text.text = item.description
		inventory.display_info_text()

func _on_mouse_exited():
	if item != null:
		inventory.hide_info_text()
		
