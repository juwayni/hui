package haxe_ui.components;

import haxe_ui.components.Rule.RuleBuilder;

@:composite(Builder)
class VerticalRule extends Rule {
    public function new() {
        super();
    }
}

//***********************************************************************************************************
// Composite Builder
//***********************************************************************************************************
@:dox(hide) @:noCompletion
private class Builder extends RuleBuilder {
    private override function showWarning() { // do nothing
    }
}