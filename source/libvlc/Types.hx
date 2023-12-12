package libvlc;

#if !cpp
#error 'LibVLC supports only C++ target platforms.'
#end

@:buildXml('
<target id="haxe">
	<section if="linux">
		<lib name="-lvlc" />
		<lib name="-lvlccore" />
	</section>
</target>')
class Types {}

@:include('vlc/vlc.h')
@:native('libvlc_instance_t')
extern class LibVLC_Instance_T {}

@:include('vlc/vlc.h')
@:native('libvlc_media_t')
extern class LibVLC_Media_T {}

@:include('vlc/vlc.h')
@:native('libvlc_media_player_t')
extern class LibVLC_MediaPlayer_T {}

typedef LibVLC_Video_Lock_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, p_pixels:cpp.RawPointer<cpp.RawPointer<cpp.Void>>) -> cpp.RawPointer<cpp.Void>>;
typedef LibVLC_Video_Unlock_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, id:cpp.RawPointer<cpp.Void>, p_pixels:VoidStarConstStar) -> Void>;
typedef LibVLC_Video_Display_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>, picture:cpp.RawPointer<cpp.Void>) -> Void>;

@:native('void *const *')
extern class VoidStarConstStar {}
