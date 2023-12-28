package libvlc;

#if !cpp
#error 'LibVLC supports only C++ target platforms.'
#end
import libvlc.Types;

@:include('vlc/vlc.h')
@:unreflective
extern class LibVLC
{
	@:native('libvlc_new')
	static function create(argc:Int, argv:cpp.ConstCharStar):cpp.RawPointer<LibVLC_Instance_T>;

	@:native('libvlc_release')
	static function release(p_instance:cpp.RawPointer<LibVLC_Instance_T>):Void;

	@:native('libvlc_errmsg')
	static function errmsg():cpp.ConstCharStar;

	@:native('libvlc_get_version')
	static function get_version():cpp.ConstCharStar;

	@:native('libvlc_media_new_path')
	static function media_new_path(p_instance:cpp.RawPointer<LibVLC_Instance_T>, path:cpp.ConstCharStar):cpp.RawPointer<LibVLC_Media_T>;

	@:native('libvlc_media_new_location')
	static function media_new_location(p_instance:cpp.RawPointer<LibVLC_Instance_T>, psz_mrl:cpp.ConstCharStar):cpp.RawPointer<LibVLC_Media_T>;

	@:native('libvlc_media_release')
	static function media_release(p_md:cpp.RawPointer<LibVLC_Media_T>):Void;

	@:native('libvlc_media_player_play')
	static function media_player_play(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Int;

	@:native('libvlc_media_player_stop')
	static function media_player_stop(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Void;

	@:native('libvlc_media_player_release')
	static function media_player_release(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Void;

	@:native('libvlc_media_player_new_from_media')
	static function media_player_new_from_media(p_md:cpp.RawPointer<LibVLC_Media_T>):cpp.RawPointer<LibVLC_MediaPlayer_T>;

	@:native('libvlc_video_set_format')
	static function video_set_format(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>, chroma:cpp.ConstCharStar, width:cpp.UInt32, height:cpp.UInt32, pitch:cpp.UInt32):Void;

	@:native('libvlc_video_set_callbacks')
	static function video_set_callbacks(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>, lock:LibVLC_Video_Lock_CB, unlock:LibVLC_Video_Unlock_CB,
		display:LibVLC_Video_Display_CB, opaque:cpp.RawPointer<cpp.Void>):Void;
}
