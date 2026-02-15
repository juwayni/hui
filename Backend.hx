package haxe_ui;

import haxe_ui.backend.BackendImpl;

class Backend extends BackendImpl {
    public static var id(get, null):String;
    private static function get_id():String {
        return BackendImpl.id;
    }
}