extends Control

const NUM_PLAYERS = 4
const COMPRESSION_TYPE = ENetConnection.COMPRESS_RANGE_CODER

@export var Address = "127.0.0.1"
@export var Port = 11111

var peer

func _ready() -> void:
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(ConnectedToServer)
	multiplayer.connection_failed.connect(ConnectionFailed)
	if "--server" in OS.get_cmdline_args():
		HostGame()

func _process(delta: float) -> void:
	pass

func PlayerConnected(id) -> void:
	print("Player connected " + str(id))
	
func PlayerDisconnected(id) -> void:
	print("Player disconnected " + str(id))
	
func ConnectedToServer(id) -> void:
	print("Player connected to server " + str(id))
	SendPlayerInfo.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
	
func ConnectionFailed(id) -> void:
	print("Player couldn't connect " + str(id))
	
@rpc("any_peer")
func SendPlayerInfo(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"health": 5
		}
	if multiplayer.is_server():
		for p in GameManager.Players:
			SendPlayerInfo.rpc(GameManager.Players[p].name, p)
	
@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://scenes/game_arena.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func HostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(Port, NUM_PLAYERS)
	if error != OK:
		print("cannot host: " + str(error))
		return
	peer.get_host().compress(COMPRESSION_TYPE)
	
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players")
	SendPlayerInfo($LineEdit.text, multiplayer.get_unique_id())

func _on_host_button_down() -> void:
	HostGame()

func _on_join_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, Port)
	peer.get_host().compress(COMPRESSION_TYPE)
	multiplayer.set_multiplayer_peer(peer)

func _on_start_button_down() -> void:
	StartGame.rpc()
