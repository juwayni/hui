package haxe_ui.loaders.image;

import haxe_ui.components.Image;
import haxe_ui.assets.ImageInfo;
import haxe_ui.util.Variant;

class ImageLoaderBase {
    public function new() {
    }

    public function load(resource:Variant, callback:ImageInfo->Void) {

    }

    public function postProcess(resource:Variant, image:Image) {
        
    }
}