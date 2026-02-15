package haxe_ui.containers.menus;

import haxe_ui.core.Component;
import haxe_ui.core.CompositeBuilder;
import haxe_ui.layouts.DefaultLayout;

@:composite(Builder, Layout)
class MenuSeparator extends Component {
}

//***********************************************************************************************************
// Composite Builder
//***********************************************************************************************************
@:dox(hide) @:noCompletion
@:access(haxe_ui.core.Component)
private class Builder extends CompositeBuilder {
    public override function create() {
        super.create();
        var line = new Component();
        line.addClass("menuseparator-line");
        _component.addComponent(line);
    }
}

private class Layout extends DefaultLayout {
}
