package haxe_ui.containers;

import haxe_ui.containers.ButtonBar.ButtonBarBuilder;
import haxe_ui.layouts.VerticalLayout;

@:composite(Layout, Builder)
class VerticalButtonBar extends ButtonBar {
    public function new() {
        super();
    }
}

//***********************************************************************************************************
// Composite Layout
//***********************************************************************************************************
private class Layout extends VerticalLayout {
    private override function resizeChildren() {
        super.resizeChildren();

        var max:Float = 0;
        for (child in component.childComponents) {
            if (child.includeInLayout == false) {
                continue;
            }
            
            if (child.width > max) {
                max = child.width;
            }
        }
        
        for (child in component.childComponents) {
            if (child.includeInLayout == false) {
                continue;
            }
            
            if (child.text == null || child.text.length == 0 || child.width < max) {
                child.width = max;
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
