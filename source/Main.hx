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
@:headerInclude('stdio.h')
@:cppNamespaceCode('
static void *lock(void *data, void **p_pixels)
{
	unsigned char *pixels = reinterpret_cast<unsigned char *>(data);

        (*p_pixels) = pixels;

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
		InitWindow(1280, 720, "RAYLIB/LIBVLC HAXE!");

		SetTargetFPS(GetMonitorRefreshRate(GetCurrentMonitor()));

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

		var instance:cpp.RawPointer<LibVLC_Instance_T> = LibVLC.create(untyped __cpp__('sizeof(args) / sizeof(*args)'), untyped __cpp__('args'));

		if (instance == null)
		{
			Sys.println('Failed to initialize LibVLC');

			Sys.exit(1);
		}

		var media:cpp.RawPointer<LibVLC_Media_T> = LibVLC.media_new_location(instance, 'https://github.com/GithubSPerez/the-shaggy-mod/raw/main/assets/videos/zoinks.mp4');
		
		var player:cpp.RawPointer<LibVLC_MediaPlayer_T> = LibVLC.media_player_new_from_media(media);

		var texture:Texture2D = LoadTextureFromImage(GenImageColor(1280, 720, WHITE));

		var pixels:cpp.RawPointer<cpp.UInt8> = untyped __cpp__('new unsigned char[{0} * {1} * 4]', texture.width, texture.height);

		LibVLC.video_set_callbacks(player, untyped __cpp__('lock'), untyped __cpp__('unlock'), untyped __cpp__('display'), untyped __cpp__('pixels'));

		LibVLC.video_set_format(player, "RGBA", texture.width, texture.height, texture.width * 4);

		LibVLC.media_player_play(player);

		while (!WindowShouldClose())
		{
			UpdateTexture(texture, cast pixels);
			
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
