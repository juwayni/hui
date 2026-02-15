package haxe_ui.assets;

import haxe_ui.loaders.image.ImageLoaderBase;
import haxe_ui.backend.ImageData;

typedef ImageInfo = {
    #if svg
    @:optional public var data:ImageData;
    @:optional public var svg:format.SVG;
    #else
    public var data:ImageData;
    #end
    public var width:Int;
    public var height:Int;
    @:noCompletion @:optional public var loader:ImageLoaderBase;
}
