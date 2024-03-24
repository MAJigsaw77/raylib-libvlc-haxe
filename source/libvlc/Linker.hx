package libvlc;

import haxe.io.Path;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.xml.Printer;
import sys.FileSystem;

class Linker
{
	public static macro function xml():Array<Field>
	{
		var pos:Position = Context.currentPos();

		var sourcePath:String = Path.directory(Context.getPosInfos(pos).file);

		if (!Path.isAbsolute(sourcePath))
			sourcePath = FileSystem.absolutePath(sourcePath);

		sourcePath = Path.removeTrailingSlashes(Path.normalize(sourcePath));

		var includeElement:Xml = Xml.createElement('include');

		includeElement.set('name', Path.join([sourcePath, 'Build.xml']));

		@:privateAccess
		{
			var printer:Printer = new Printer(true);

			printer.writeNode(includeElement, '\n');

			Context.getLocalClass().get().meta.add(':buildXml', [{
				expr: EConst(CString(printer.output.toString())),
				pos: pos
			}], pos);
		}

		return Context.getBuildFields();
	}
}
