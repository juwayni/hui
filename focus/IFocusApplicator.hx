package haxe_ui.focus;

import haxe_ui.core.Component;

interface IFocusApplicator {
    function apply(target:Component):Void;
    function unapply(target:Component):Void;
    var enabled(get, set):Bool;
}