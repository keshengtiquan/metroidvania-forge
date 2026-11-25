# 全局场景不要起类名， 会把全局设置里的类名覆盖 
extends Node

enum REVERB_TYPE {NONE, SMALL, MEDIUM, LAGER }
@export var ui_focus_audio: AudioStream
@export var ui_select_audio: AudioStream
@export var ui_cancel_audio: AudioStream
@export var ui_success_audio: AudioStream
@export var ui_error_audio: AudioStream

var current_track: int = 0
var music_tweens: Array[Tween]
var ui_audio_player: AudioStreamPlaybackPolyphonic

@onready var music_1: AudioStreamPlayer = %Music1
@onready var music_2: AudioStreamPlayer = %Music2
@onready var ui: AudioStreamPlayer = %UI


func _ready() -> void:
	ui.play()
	ui_audio_player = ui.get_stream_playback()
	pass 
	
func play_music(audio: AudioStream) -> void:
	# 确认当前的播放器
	var curret_player: AudioStreamPlayer = get_music_player(current_track)
	if curret_player.stream == audio:
		return
	var next_track: int = wrapi(current_track + 1, 0, 2)
	var next_player: AudioStreamPlayer = get_music_player(next_track)
	next_player.stream = audio
	next_player.play() 
	# 音频的淡入淡出
	for t in music_tweens:
		t.kill()
	music_tweens.clear()
	fade_track_out(curret_player)
	fade_track_in(next_player )
	
	current_track = next_track 
	pass

func fade_track_out(player: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 0.0, 1.5)
	tween.tween_callback(player.stop)
	pass


func fade_track_in(player: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 1.0, 1.0) 
	pass



func get_music_player(i: int) -> AudioStreamPlayer:
	if i == 0:
		return music_1
	else: 
		return music_2

func set_reverb(type: REVERB_TYPE) -> void:
	var reverb_fx: AudioEffectReverb = AudioServer.get_bus_effect(1, 0)
	if not reverb_fx:
		return
	AudioServer.set_bus_effect_enabled(1, 0, true)
	match type:
		REVERB_TYPE.NONE:
			AudioServer.set_bus_effect_enabled(1, 0, false)
		REVERB_TYPE.SMALL:
			reverb_fx.room_size = 0.2
		REVERB_TYPE.MEDIUM:
			reverb_fx.room_size = 0.5
		REVERB_TYPE.LAGER:
			reverb_fx.room_size = 0.8
	pass

func play_spatial_sound(audio: AudioStream, pos: Vector2) -> void:
	var ap: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	add_child(ap)
	ap.bus = "SFX"
	ap.global_position = pos
	ap.stream = audio
	ap.finished.connect(ap.queue_free)
	ap.play()
	pass

func player_ui_audio(audio: AudioStream) -> void:
	if ui_audio_player:
		ui_audio_player.play_stream(audio)

func setup_button_audio(node: Node) -> void:
	for c in node.find_children("*", "Button"):
		c.pressed.connect(ui_select)
		c.focus_entered.connect(ui_focus_change)
	pass


#region /// ui func
func ui_focus_change()-> void:
	player_ui_audio(ui_focus_audio)

func ui_select()-> void:
	player_ui_audio(ui_select_audio)

func ui_cancel()-> void:
	player_ui_audio(ui_cancel_audio)

func ui_success()-> void:
	player_ui_audio(ui_success_audio)

func ui_error()-> void:
	player_ui_audio(ui_error_audio)
#endregion
