package haxe_ui.components;

import haxe_ui.containers.Box;
import haxe_ui.styles.Style;
import haxe_ui.util.Variant;

// TODO: move to behaviours (not really priority as it will probably never have a native counterpart)
class Decorator extends Box {
    public override function set_icon(value:Variant):Variant {
        var image = findComponent(Image);
        if (image == null) {
            image = new Image();
            addComponent(image);
        }
        image.resource = value;
        return value;
    }

    public override function applyStyle(style:Style) {
        super.applyStyle(style);

        if (style.icon != null) {
            this.icon = style.icon;
        }
    }
}