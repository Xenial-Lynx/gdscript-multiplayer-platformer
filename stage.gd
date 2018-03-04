extends Node
var camera

func _ready():
	
	# By default, all nodes in server inherit from master,
	# while all nodes in clients inherit from slave.
		
	if (get_tree().is_network_server()):		
		#If in the server, get control of player 2 to the other peer.
		#This function is tree recursive by default.
		get_node("player2").set_network_master(get_tree().get_network_connected_peers()[0])
		camera = get_node("player1/camera1")
		camera._set_current(true)
	else:
		#If in the client, give control of player 2 to itself. 
		#This function is tree recursive by default.
		get_node("player2").set_network_master(get_tree().get_network_unique_id())
		camera = get_node("player2/camera2")
		camera._set_current(true)
		
	print("unique id: ",get_tree().get_network_unique_id())
