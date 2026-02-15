package haxe_ui.containers;

import haxe_ui.layouts.HorizontalContinuousLayout;

/**
 A `Box` component that lays its children out horizontally
**/
@:dox(icon = "/icons/ui-split-panel.png")
class ContinuousHBox extends Box {
    public function new() {
        super();
        layout = new HorizontalContinuousLayout();
    }
}
