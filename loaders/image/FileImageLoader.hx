package haxe_ui.loaders.image;

import haxe_ui.util.Variant;
import haxe_ui.assets.ImageInfo;

class FileImageLoader extends ImageLoaderBase {
    public override function load(resource:Variant, callback:ImageInfo->Void) {
        var stringResource:String = resource;
        Toolkit.assets.imageFromFile(stringResource.substr(7), function(imageInfo) {
            ToolkitAssets.instance.cacheImage(stringResource, imageInfo);
            callback(imageInfo);
        });
    }
}