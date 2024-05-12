extends GridContainer
class_name QuestGrid

@export var database: QuestDatabase


func _ready():
	columns = 6
	_setup_database()
	_setup_grid()


func _setup_database():
	if not database:
		return

	for quest in database.quests:
		if quest.status == 2:
			QuestSystem.completed.add_quest(quest)
		elif quest.status == 1:
			QuestSystem.active.add_quest(quest)
		else:
			QuestSystem.available.add_quest(quest)


func _setup_grid():
	for quest in QuestSystem.get_active_quests():
		var obj: Button = Button.new()
		obj.text = quest.quest_name
		obj.connect("pressed", _slot_pressed.bind(quest))
		add_child(obj)


func _slot_pressed(quest: Quest):
	print_debug(quest)
