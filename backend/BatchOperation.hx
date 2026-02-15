package haxe_ui.backend;

import haxe_ui.core.Component;
import haxe_ui.components.Canvas;

@:enum @:unreflective
enum BatchOperation {
    DrawStyle(c:ComponentImpl);
    DrawImage(c:ComponentImpl);
    DrawText(c:ComponentImpl);
    DrawCustom(c:ComponentImpl);
    DrawComponentGraphics(c:Canvas);
    ApplyScissor(x:Int, y:Int, w:Int, h:Int);
    ClearScissor;
}
