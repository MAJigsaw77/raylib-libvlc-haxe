package;

import RayLib.Colors.*;
import RayLib.Texture2D;
import RayLib.*;

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
	hx::SetTopOfStack((int *)99, true);

	unsigned char *pixels = reinterpret_cast<unsigned char *>(data);

        (*p_pixels) = pixels;

	hx::SetTopOfStack((int *)0, true);

	return NULL;
}')
class Main
{
	public static function main():Void
	{
		var instance:cpp.RawPointer<LibVLC_Instance_T>;
		var media:cpp.RawPointer<LibVLC_Media_T>;
		var player:cpp.RawPointer<LibVLC_MediaPlayer_T>;
		
		InitWindow(1280, 720, "RAYLIB/LIBVLC HAXE!");

		SetTargetFPS(GetMonitorRefreshRate(GetCurrentMonitor()));

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
			"--text-renderer=dummy"
		};');

		instance = LibVLC.create(untyped __cpp__('sizeof(args) / sizeof(*args)'), untyped __cpp__('args'));

		if (instance == null)
		{
			Sys.println('Failed to initialize LibVLC.');

			Sys.exit(1);
		}

		media = LibVLC.media_new_location(instance, 'https://github.com/GithubSPerez/the-shaggy-mod/raw/main/assets/videos/zoinks.mp4');
		
		player = LibVLC.media_player_new_from_media(media);

		LibVLC.media_release(media);

		var texture:Texture2D = LoadTextureFromImage(GenImageColor(1280, 720, WHITE));

		var pixels:cpp.RawPointer<cpp.UInt8> = untyped __cpp__('new unsigned char[{0} * {1} * 4]', texture.width, texture.height);

		LibVLC.video_set_callbacks(player, untyped __cpp__('lock'), null, null, untyped pixels);

		LibVLC.video_set_format(player, "RGBA", texture.width, texture.height, texture.width * 4);

		LibVLC.media_player_play(player);

		while (!WindowShouldClose())
		{
			UpdateTexture(texture, untyped pixels);

			BeginDrawing();
			ClearBackground(RAYWHITE);
			DrawTexture(texture, 0, 0, WHITE);
			DrawFPS(10, 10);
			EndDrawing();
		}

		LibVLC.media_player_stop(player);
		LibVLC.media_player_release(player);

		if (pixels != null)
		{
			untyped __cpp__('delete[] {0}', pixels);

			pixels = null;
		}

		LibVLC.release(instance);

		UnloadTexture(texture);

		CloseWindow();
	}
}
