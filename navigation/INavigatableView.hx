package haxe_ui.navigation;

@:autoBuild(haxe_ui.macros.NavigationMacros.buildNavigatableView())
interface INavigatableView {
    public function applyParams(params:Map<String, Any>):Void;
}