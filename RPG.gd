extends Control

@export var attacks : Node
var currentPartOfTree : Node
var actionPoints = 5
# Called when the node enters the scene tree for the first time.
func moveToTree(part):
	return func():
			currentPartOfTree = part
			renderOptions()

func runActionScript(part : Action):
	return func():
			if actionPoints < part.action_point_requirement:
				$Flavortext.text = "-You don't have enough AP.\n"
				return
			actionPoints -= part.action_point_requirement
			var target = [$EnemyChar] if part.Target else [$PlayerChar]
			await part.run_action(target)
			renderOptions()

func renderOptions():
	for i in $ActionsSelect.get_children():
		i.queue_free()
	if $EnemyChar.health > 0 and not $EnemyChar.ally: 
		for i in currentPartOfTree.get_children():
			var button = Button.new()
			button.text = i.name
			button.connect(&"pressed", runActionScript(i) if i is Action else moveToTree(i))
			$ActionsSelect.add_child(button)
	if currentPartOfTree == attacks:
		var button = Button.new()
		button.text = "End Battle" if $EnemyChar.health <= 0 or $EnemyChar.ally else "End Turn"
		button.connect(&"pressed", endTurn)
		$ActionsSelect.add_child(button)
	else: 
		var button = Button.new()
		button.text = "Back"
		button.connect(&"pressed", moveToTree(attacks))
		$ActionsSelect.add_child(button)
	$Enemy.max_value = $EnemyChar.maxHealth
	$Enemy.value = $EnemyChar.health
	$Player.max_value = $PlayerChar.maxHealth
	$Player.value = $PlayerChar.health
	$Enemy/Info.text = "Enemy \nHP: %d" % $EnemyChar.health 
	$Player/Info.text = "You \nHP: {hp} AP: {ap}".format({"hp":str($PlayerChar.health), "ap":str(actionPoints)})

func initiateTurn():
	currentPartOfTree = attacks
	actionPoints = 5
	renderOptions()
func _ready():
	initiateTurn()

func endTurn():
	$PlayerChar.health -= randi_range(0, 10)
	if $EnemyChar.health <= 0 or $EnemyChar.ally:
		get_tree().change_scene_to_file("res://Win.tscn")
	elif $PlayerChar.health <= 0:
		get_tree().change_scene_to_file("res://Lose.tscn")
	$Flavortext.text = ""
	initiateTurn()
	
