package haxe_ui.containers;

import haxe_ui.containers.ButtonBar.ButtonBarBuilder;
import haxe_ui.layouts.HorizontalLayout;

@:composite(Layout, Builder)
class HorizontalButtonBar extends ButtonBar {
    public function new() {
        super();
    }
}

//***********************************************************************************************************
// Composite Layout
//***********************************************************************************************************
private class Layout extends HorizontalLayout {
    private override function resizeChildren() {
        super.resizeChildren();

        var max:Float = 0;
        for (child in component.childComponents) {
            if (child.includeInLayout == false) {
                continue;
            }
            
            if (child.height > max) {
                max = child.height;
            }
        }
        
        for (child in component.childComponents) {
            if (child.includeInLayout == false) {
                continue;
            }
            
            if (child.text == null || child.text.length == 0 || child.height < max) {
                child.height = max;
            }
        }
    }
}


//***********************************************************************************************************
// Composite Builder
//***********************************************************************************************************
@:dox(hide) @:noCompletion
@:access(haxe_ui.core.Component)
private class Builder extends ButtonBarBuilder {
    private override function showWarning() { // do nothing
    }
}
