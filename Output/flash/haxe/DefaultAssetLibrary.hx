package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.text.Font;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import haxe.Unserializer;
import openfl.Assets;

#if (flash || js)
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLLoader;
#end

#if ios
import openfl.utils.SystemPath;
#end


class DefaultAssetLibrary extends AssetLibrary {
	
	
	public static var className (default, null) = new Map <String, Dynamic> ();
	public static var path (default, null) = new Map <String, String> ();
	public static var type (default, null) = new Map <String, AssetType> ();
	
	
	public function new () {
		
		super ();
		
		#if flash
		
		className.set ("fonts/OpenSans-Bold.ttf", __ASSET__fonts_opensans_bold_ttf);
		type.set ("fonts/OpenSans-Bold.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("fonts/OpenSans-ExtraBold.ttf", __ASSET__fonts_opensans_extrabold_ttf);
		type.set ("fonts/OpenSans-ExtraBold.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("fonts/OpenSans-ExtraBoldItalic.ttf", __ASSET__fonts_opensans_extrabolditalic_ttf);
		type.set ("fonts/OpenSans-ExtraBoldItalic.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("fonts/OpenSans-Light.ttf", __ASSET__fonts_opensans_light_ttf);
		type.set ("fonts/OpenSans-Light.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("fonts/OpenSans-Regular.ttf", __ASSET__fonts_opensans_regular_ttf);
		type.set ("fonts/OpenSans-Regular.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("fonts/OpenSans-Semibold.ttf", __ASSET__fonts_opensans_semibold_ttf);
		type.set ("fonts/OpenSans-Semibold.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("svg/btn_grey_click.svg", __ASSET__svg_btn_grey_click_svg);
		type.set ("svg/btn_grey_click.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/btn_grey_hover.svg", __ASSET__svg_btn_grey_hover_svg);
		type.set ("svg/btn_grey_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/btn_grey_normal.svg", __ASSET__svg_btn_grey_normal_svg);
		type.set ("svg/btn_grey_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/btn_white_click.svg", __ASSET__svg_btn_white_click_svg);
		type.set ("svg/btn_white_click.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/btn_white_hover.svg", __ASSET__svg_btn_white_hover_svg);
		type.set ("svg/btn_white_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/btn_white_normal.svg", __ASSET__svg_btn_white_normal_svg);
		type.set ("svg/btn_white_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/cb_grey_hover.svg", __ASSET__svg_cb_grey_hover_svg);
		type.set ("svg/cb_grey_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/cb_grey_normal.svg", __ASSET__svg_cb_grey_normal_svg);
		type.set ("svg/cb_grey_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/cb_grey_un_hover.svg", __ASSET__svg_cb_grey_un_hover_svg);
		type.set ("svg/cb_grey_un_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/cb_grey_un_normal.svg", __ASSET__svg_cb_grey_un_normal_svg);
		type.set ("svg/cb_grey_un_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/cb_white_hover.svg", __ASSET__svg_cb_white_hover_svg);
		type.set ("svg/cb_white_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/cb_white_normal.svg", __ASSET__svg_cb_white_normal_svg);
		type.set ("svg/cb_white_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/cb_white_un_hover.svg", __ASSET__svg_cb_white_un_hover_svg);
		type.set ("svg/cb_white_un_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("svg/cb_white_un_normal.svg", __ASSET__svg_cb_white_un_normal_svg);
		type.set ("svg/cb_white_un_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		
		
		#elseif html5
		
		className.set ("fonts/OpenSans-Bold.ttf", __ASSET__fonts_opensans_bold_ttf);
		type.set ("fonts/OpenSans-Bold.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("fonts/OpenSans-ExtraBold.ttf", __ASSET__fonts_opensans_extrabold_ttf);
		type.set ("fonts/OpenSans-ExtraBold.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("fonts/OpenSans-ExtraBoldItalic.ttf", __ASSET__fonts_opensans_extrabolditalic_ttf);
		type.set ("fonts/OpenSans-ExtraBoldItalic.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("fonts/OpenSans-Light.ttf", __ASSET__fonts_opensans_light_ttf);
		type.set ("fonts/OpenSans-Light.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("fonts/OpenSans-Regular.ttf", __ASSET__fonts_opensans_regular_ttf);
		type.set ("fonts/OpenSans-Regular.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("fonts/OpenSans-Semibold.ttf", __ASSET__fonts_opensans_semibold_ttf);
		type.set ("fonts/OpenSans-Semibold.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		path.set ("svg/btn_grey_click.svg", "svg/btn_grey_click.svg");
		type.set ("svg/btn_grey_click.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/btn_grey_hover.svg", "svg/btn_grey_hover.svg");
		type.set ("svg/btn_grey_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/btn_grey_normal.svg", "svg/btn_grey_normal.svg");
		type.set ("svg/btn_grey_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/btn_white_click.svg", "svg/btn_white_click.svg");
		type.set ("svg/btn_white_click.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/btn_white_hover.svg", "svg/btn_white_hover.svg");
		type.set ("svg/btn_white_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/btn_white_normal.svg", "svg/btn_white_normal.svg");
		type.set ("svg/btn_white_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/cb_grey_hover.svg", "svg/cb_grey_hover.svg");
		type.set ("svg/cb_grey_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/cb_grey_normal.svg", "svg/cb_grey_normal.svg");
		type.set ("svg/cb_grey_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/cb_grey_un_hover.svg", "svg/cb_grey_un_hover.svg");
		type.set ("svg/cb_grey_un_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/cb_grey_un_normal.svg", "svg/cb_grey_un_normal.svg");
		type.set ("svg/cb_grey_un_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/cb_white_hover.svg", "svg/cb_white_hover.svg");
		type.set ("svg/cb_white_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/cb_white_normal.svg", "svg/cb_white_normal.svg");
		type.set ("svg/cb_white_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/cb_white_un_hover.svg", "svg/cb_white_un_hover.svg");
		type.set ("svg/cb_white_un_hover.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		path.set ("svg/cb_white_un_normal.svg", "svg/cb_white_un_normal.svg");
		type.set ("svg/cb_white_un_normal.svg", Reflect.field (AssetType, "text".toUpperCase ()));
		
		
		#else
		
		try {
			
			#if blackberry
			var bytes = ByteArray.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = ByteArray.readFile ("../res/manifest");
			#elseif emscripten
			var bytes = ByteArray.readFile ("assets/manifest");
			#else
			var bytes = ByteArray.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				bytes.position = 0;
				
				if (bytes.length > 0) {
					
					var data = bytes.readUTFBytes (bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<AssetData> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							path.set (asset.id, asset.path);
							type.set (asset.id, asset.type);
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest");
				
			}
			
		} catch (e:Dynamic) {
			
			trace ("Warning: Could not load asset manifest");
			
		}
		
		#end
		
	}
	
	
	public override function exists (id:String, type:AssetType):Bool {
		
		var assetType = DefaultAssetLibrary.type.get (id);
		
		#if pixi
		
		if (assetType == IMAGE) {
			
			return true;
			
		} else {
			
			return false;
			
		}
		
		#end
		
		if (assetType != null) {
			
			if (assetType == type || ((type == SOUND || type == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if ((assetType == BINARY || assetType == TEXT) && type == BINARY) {
				
				return true;
				
			} else if (path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (type == BINARY || type == null) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getBitmapData (id:String):BitmapData {
		
		#if pixi
		
		return BitmapData.fromImage (path.get (id));
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), BitmapData);
		
		#elseif js
		
		return cast (ApplicationMain.loaders.get (path.get (id)).contentLoaderInfo.content, Bitmap).bitmapData;
		
		#else
		
		return BitmapData.load (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):ByteArray {
		
		#if pixi
		
		return null;
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), ByteArray);
		
		#elseif js
		
		var bytes:ByteArray = null;
		var data = ApplicationMain.urlLoaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			bytes = new ByteArray ();
			bytes.writeUTFBytes (data);
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}

		if (bytes != null) {
			
			bytes.position = 0;
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		return ByteArray.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if pixi
		
		return null;
		
		#elseif (flash || js)
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		return new Font (path.get (id));
		
		#end
		
	}
	
	
	public override function getMusic (id:String):Sound {
		
		#if pixi
		
		//return null;		
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}
	
	
	public override function getPath (id:String):String {
		
		#if ios
		
		return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		#else
		
		return path.get (id);
		
		#end
		
	}
	
	
	public override function getSound (id:String):Sound {
		
		#if pixi
		
		return null;
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return new Sound (new URLRequest (path.get (id)), null, type.get (id) == MUSIC);
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:AssetType):Bool {
		
		#if flash
		
		if (type != AssetType.MUSIC && type != AssetType.SOUND) {
			
			return className.exists (id);
			
		}
		
		#end
		
		return true;
		
	}
	
	
	public override function loadBitmapData (id:String, handler:BitmapData -> Void):Void {
		
		#if pixi
		
		handler (getBitmapData (id));
		
		#elseif (flash || js)
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBitmapData (id));
			
		}
		
		#else
		
		handler (getBitmapData (id));
		
		#end
		
	}
	
	
	public override function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		#if pixi
		
		handler (getBytes (id));
		
		#elseif (flash || js)
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = new ByteArray ();
				bytes.writeUTFBytes (event.currentTarget.data);
				bytes.position = 0;
				
				handler (bytes);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBytes (id));
			
		}
		
		#else
		
		handler (getBytes (id));
		
		#end
		
	}
	
	
	public override function loadFont (id:String, handler:Font -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getFont (id));
			
		//}
		
		#else
		
		handler (getFont (id));
		
		#end
		
	}
	
	
	public override function loadMusic (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getMusic (id));
			
		//}
		
		#else
		
		handler (getMusic (id));
		
		#end
		
	}
	
	
	public override function loadSound (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getSound (id));
			
		//}
		
		#else
		
		handler (getSound (id));
		
		#end
		
	}
	
	
}


#if pixi
#elseif flash

class __ASSET__fonts_opensans_bold_ttf extends flash.text.Font { }
class __ASSET__fonts_opensans_extrabold_ttf extends flash.text.Font { }
class __ASSET__fonts_opensans_extrabolditalic_ttf extends flash.text.Font { }
class __ASSET__fonts_opensans_light_ttf extends flash.text.Font { }
class __ASSET__fonts_opensans_regular_ttf extends flash.text.Font { }
class __ASSET__fonts_opensans_semibold_ttf extends flash.text.Font { }
class __ASSET__svg_btn_grey_click_svg extends flash.utils.ByteArray { }
class __ASSET__svg_btn_grey_hover_svg extends flash.utils.ByteArray { }
class __ASSET__svg_btn_grey_normal_svg extends flash.utils.ByteArray { }
class __ASSET__svg_btn_white_click_svg extends flash.utils.ByteArray { }
class __ASSET__svg_btn_white_hover_svg extends flash.utils.ByteArray { }
class __ASSET__svg_btn_white_normal_svg extends flash.utils.ByteArray { }
class __ASSET__svg_cb_grey_hover_svg extends flash.utils.ByteArray { }
class __ASSET__svg_cb_grey_normal_svg extends flash.utils.ByteArray { }
class __ASSET__svg_cb_grey_un_hover_svg extends flash.utils.ByteArray { }
class __ASSET__svg_cb_grey_un_normal_svg extends flash.utils.ByteArray { }
class __ASSET__svg_cb_white_hover_svg extends flash.utils.ByteArray { }
class __ASSET__svg_cb_white_normal_svg extends flash.utils.ByteArray { }
class __ASSET__svg_cb_white_un_hover_svg extends flash.utils.ByteArray { }
class __ASSET__svg_cb_white_un_normal_svg extends flash.utils.ByteArray { }


#elseif html5

class __ASSET__fonts_opensans_bold_ttf extends flash.text.Font { }
class __ASSET__fonts_opensans_extrabold_ttf extends flash.text.Font { }
class __ASSET__fonts_opensans_extrabolditalic_ttf extends flash.text.Font { }
class __ASSET__fonts_opensans_light_ttf extends flash.text.Font { }
class __ASSET__fonts_opensans_regular_ttf extends flash.text.Font { }
class __ASSET__fonts_opensans_semibold_ttf extends flash.text.Font { }
















#end