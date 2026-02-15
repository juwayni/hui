package haxe_ui;

import haxe_ui.backend.CallLaterImpl;

class CallLater extends CallLaterImpl {
    public function new(fn:Void->Void) {
        super(fn);
    }
}