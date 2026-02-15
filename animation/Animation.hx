package haxe_ui.animation;

import haxe_ui.core.Component;

class Animation {
    public var target:Component;
    public function new(target:Component) {
        this.target = target;
    }
    
    public function build(builder:AnimationBuilder) {
    }
}