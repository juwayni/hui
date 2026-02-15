package haxe_ui.loaders.image;

import haxe_ui.util.Variant;
import haxe_ui.assets.ImageInfo;

class AssetImageLoader extends ImageLoaderBase {
    public override function load(resource:Variant, callback:ImageInfo->Void) {
        Toolkit.assets.getImage(resource, callback);
    }
}