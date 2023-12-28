package;

import RayLib.Colors.*;
import RayLib.Image;
import RayLib.TextureFilter;
import RayLib.Texture2D;
import RayLib.*;

import haxe.io.Path;
import libvlc.LibVLC;
import libvlc.Types;
#if linux
import sys.FileSystem;
#end

@:headerInclude('assert.h')
@:headerInclude('stdint.h')
@:headerInclude('stdio.h')
@:cppNamespaceCode('
static void *lock(void *data, void **p_pixels)
{
	Texture2D *texture = reinterpret_cast<Texture2D *>(data);

	Image image = LoadImageFromTexture(*texture);

        (*p_pixels) = image.data;

	UnloadImage(image);

	return NULL; /* picture identifier, not needed here */
}

static void unlock(void *data, void *id, void *const *p_pixels)
{
	assert(id == NULL); /* picture identifier, not needed here */
}

static void display(void *data, void *id)
{
	assert(id == NULL); /* picture identifier, not needed here */
}')
class Main
{
	public static function main():Void
	{
		var instance:cpp.RawPointer<LibVLC_Instance_T>;
		var media:cpp.RawPointer<LibVLC_Media_T>;
		var player:cpp.RawPointer<LibVLC_MediaPlayer_T>;

		var texture:Texture2D;
		
		final location:String = Sys.getCwd() + 'video.mp4';
		
		InitWindow(1280, 720, "RAYLIB/LIBVLC HAXE!");

		SetTargetFPS(60);

		#if (windows || macos)
		Sys.putEnv('VLC_PLUGIN_PATH', Path.join([Path.directory(Sys.programPath()), 'plugins']));
		#elseif linux
		var pluginsPath:String = '/usr/local/lib/vlc/plugins';
			
		if (FileSystem.exists(pluginsPath) && FileSystem.isDirectory(pluginsPath))
			Sys.putEnv('VLC_PLUGIN_PATH', pluginsPath);
		else
		{
			pluginsPath = '/usr/lib/vlc/plugins';

			if (FileSystem.exists(pluginsPath) && FileSystem.isDirectory(pluginsPath))
				Sys.putEnv('VLC_PLUGIN_PATH', pluginsPath);
		}
		#end

		untyped __cpp__('const char *args[] = {
			"--drop-late-frames",
			"--intf=dummy",
			"--no-interact",
			"--no-lua",
			"--no-snapshot-preview",
			"--no-spu",
			"--no-stats",
			"--no-video-title-show",
			"--no-xlib",
			#if defined(HX_WINDOWS) || defined(HX_MACOS)
			"--reset-config",
			"--reset-plugins-cache",
			#endif
			"--text-renderer=dummy"
		};');

		instance = LibVLC.create(untyped __cpp__('sizeof(args) / sizeof(*args)'), untyped __cpp__('args'));

		if (instance == null)
			Sys.println('Failed to initialize LibVLC');

		media = LibVLC.media_new_path(instance, #if windows Path.normalize(location).split('/').join('\\') #else Path.normalize(location) #end);
		
		player = LibVLC.media_player_new_from_media(media);

		texture = LoadTextureFromImage(GenImageColor(1280, 720, BLACK));

		LibVLC.video_set_callbacks(player, untyped __cpp__('lock'), untyped __cpp__('unlock'), untyped __cpp__('display'), untyped __cpp__('&texture'));

		LibVLC.video_set_format(player, "RGBA", texture.width, texture.height, texture.width * 4);

		LibVLC.media_player_play(player);

		while (!WindowShouldClose())
		{
			BeginDrawing();

			ClearBackground(RAYWHITE);

			DrawTexture(texture, 0, 0, WHITE);

			DrawFPS(10, 10);

			EndDrawing();
		}

		LibVLC.media_player_stop(player);
		LibVLC.media_player_release(player);
		LibVLC.media_release(media);
		LibVLC.release(instance);

		UnloadTexture(texture);
		CloseWindow();
	}
}
