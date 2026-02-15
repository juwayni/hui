package haxe_ui.components;

import haxe_ui.core.Component;

/**
    A general purpose spacer component
**/
class Spacer extends Component {
    public function new() {
        super();
        #if (haxeui_openfl && !haxeui_flixel)
        mouseChildren = false;
        #end
    }
}