package haxe_ui.components;

import haxe_ui.containers.HBox;
import haxe_ui.util.Variant;

@:xml('
<hbox>
    <image id="linkIcon" verticalAlign="center" hidden="true" />
    <link id="link" verticalAlign="center" hidden="true" />
</hbox>
')
class IconLink extends HBox {
    public override function get_text():String {
        return link.text;
    }

    public override function set_text(value:String):String {
        link.text = value;
        link.show();
        return value;
    }

    public override function get_icon():Variant {
        return linkIcon.resource;
    }

    public override function set_icon(value:Variant):Variant {
        linkIcon.resource = value;
        linkIcon.show();
        return value;
    }
}