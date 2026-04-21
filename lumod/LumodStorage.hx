package lumod;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

class LumodStorage implements BaseLumodStorage {
	public var cache:Map<String, String> = null;

	public function new(?enableCache:Bool = false) {
		if (enableCache)
			cache = new Map();
	}

	public function existsScript(path:String) {
		if (cache != null && cache.exists(path)) return true;

		return FileSystem.exists(Path.join([Sys.getCwd(), path]));
	}

	public function getScript(path:String) {
		if (cache != null && cache.exists(path)) return cache.get(path); // obtain from cache; avoid unnecessary filesystem calls

		if (!FileSystem.exists(Path.join([Sys.getCwd(), path])))
			return null;

		if (cache == null)
			return File.getContent(Path.join([Sys.getCwd(), path]));

		cache.set(path, File.getContent(Path.join([Sys.getCwd(), path])));
		return cache.get(path);
	}
}

interface BaseLumodStorage {
	public function existsScript(path:String):Bool;
	public function getScript(path:String):String; 
}