extends Control

@onready var bar = preload("res://bar.tscn")
@onready var graph_container = $GraphContainer

var array_to_sort := []
var num_array := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_num_array(200,1,100)
	var max : float = num_array.max()
	for i in num_array:
		add_bar(i/max*graph_container.size.y)
	
	pass # Replace with function body.

func add_bar(height):
	var new_bar = bar.instantiate()
	new_bar.value = height
	new_bar.set_height()
	array_to_sort.push_back(new_bar)
	graph_container.add_child(new_bar)
	new_bar.index = new_bar.get_index()

func create_num_array(length, min, max):
	num_array = []
	for i in range(length):
		num_array.push_back(i+1)
	num_array.shuffle()


func bubble_sort(arr : Array):
	var counter = 0
	var n = arr.size()
	var current_bar_1=arr[0]
	var current_bar_2=arr[1]
	for i in range(n):
		var swapped = false
		for j in range(0, n-i-1):
			if arr[j].value > arr[j+1].value:
				counter+=1
				swap(j, j+1)
				swapped = true
				current_bar_1.set_color(Color.WHITE)
				current_bar_2.set_color(Color.WHITE)
				current_bar_1 = arr[j]
				current_bar_2 = arr[j+1]
				current_bar_1.set_color(Color.GREEN)
				current_bar_2.set_color(Color.GREEN)
				if counter %5 == 0:
					await get_tree().create_timer(0.01).timeout
					update_scene_tree()
				
		if swapped == false:
			current_bar_1.set_color(Color.WHITE)
			current_bar_2.set_color(Color.WHITE)
			update_scene_tree()
			break
			
	
func swap(first, second):
	var temp1 = array_to_sort[first]
	var temp2 = array_to_sort[second]
	temp1.index = second
	temp2.index = first
	array_to_sort[first] = temp2
	array_to_sort[second] = temp1


func quick_sort(array:Array, low:int, high:int):
	print("QuickSort from %s to %s" %[low,high])
	if low<high:
		var pi = await partition(array, low, high)
		
		await quick_sort(array, low, pi-1)
		
		await quick_sort(array, pi+1, high)
		
func partition(array:Array, low:int, high:int):
	var counter = 0
	print("partition from %s to %s" %[low,high])
	# Choose the rightmost element as pivot
	var pivot = array[high].value 
	array[high].set_color(Color.RED)
	var i = low -1
	var current_bar_1 = array[low]
	var current_bar_2 = array[low]
	for j in range(low, high):
		#show color
		if current_bar_1.color == Color.GREEN:
			current_bar_1.set_color(Color.WHITE)
		current_bar_1 = array[j]
		current_bar_1.set_color(Color.GREEN)
		#show color
		if array[j].value  <= pivot:
			i = i+1
			swap(i,j)
			#show color
			if current_bar_2.color == Color.BLUE:
				current_bar_2.set_color(Color.WHITE)
			current_bar_2 = array[i]
			current_bar_1 = array[j]
			current_bar_1.set_color(Color.GREEN)
			current_bar_2.set_color(Color.BLUE)
		#frame skip
		counter+=1
		if counter%1==0:
			update_scene_tree()
			await get_tree().create_timer(0.01).timeout
			
		#
	swap(i+1,high)
	#show color
	array[i+1].set_color(Color.WHITE)
	array[high].set_color(Color.WHITE)
	current_bar_1.set_color(Color.WHITE)
	current_bar_2.set_color(Color.WHITE)
	update_scene_tree()
	#
	return i+1

func _on_button_pressed() -> void:
	#bubble_sort(array_to_sort)
	quick_sort(array_to_sort,0,array_to_sort.size()-1)
	
func update_scene_tree():
	for i in array_to_sort:
		graph_container.move_child(i, i.index)
	
	
	
	
	
	
	
