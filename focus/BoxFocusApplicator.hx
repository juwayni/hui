package haxe_ui.focus;

import haxe_ui.Toolkit;
import haxe_ui.containers.Box;
import haxe_ui.core.Component;
import haxe_ui.core.Screen;
import haxe_ui.events.UIEvent;
import haxe_ui.focus.FocusManager;
import haxe_ui.focus.IFocusable;
import haxe_ui.styles.elements.AnimationKeyFrame;
import haxe_ui.styles.elements.Directive;

class BoxFocusApplicator extends FocusApplicator {
    private var _box:Box = null;
    
    private static inline var STYLE_NAME:String = "boxfocusstyle";
    
    public override function apply(target:Component):Void {
        createBox();

        Screen.instance.moveComponentToFront(_box);
        
        trace(target.rootComponent.isReady);
        target.registerEvent(UIEvent.READY, function(_) {
            //animateBox(target);
        });
        
        Toolkit.callLater(function() {
            animateBox(target);
        });
    }
    
    public override function unapply(target:Component):Void {
        //_box.hidden = true;
    }
    
    private function animateBox(target:Component) {
        var animation = Toolkit.styleSheet.findAnimation(STYLE_NAME);
        if (animation == null) {
            Toolkit.styleSheet.parse('
                .$STYLE_NAME {
                    animation: $STYLE_NAME 0.2s ease 0s 1;
                }

                @keyframes $STYLE_NAME {
                    0% {
                    }
                    100% {
                    }
                }
            ', false);
            animation = Toolkit.styleSheet.findAnimation(STYLE_NAME);
        }
        var first:AnimationKeyFrame = animation.keyFrames[0];
        var last:AnimationKeyFrame = animation.keyFrames[animation.keyFrames.length - 1];
        
        first.set(new Directive("left", Value.VDimension(Dimension.PX(_box.screenLeft))));
        first.set(new Directive("top", Value.VDimension(Dimension.PX(_box.screenTop))));
        first.set(new Directive("width", Value.VDimension(Dimension.PX(_box.width))));
        first.set(new Directive("height", Value.VDimension(Dimension.PX(_box.height))));
        
        var x = target.screenLeft;
        var y = target.screenTop;
        var w = target.width;
        var h = target.height;
        
        last.set(new Directive("left", Value.VDimension(Dimension.PX(x))));
        last.set(new Directive("top", Value.VDimension(Dimension.PX(y))));
        last.set(new Directive("width", Value.VDimension(Dimension.PX(w))));
        last.set(new Directive("height", Value.VDimension(Dimension.PX(h))));
        
        _box.onAnimationEnd = function(_) {
            _box.onAnimationEnd = null;
            _box.removeClass(STYLE_NAME);
        }
        
        _box.addClass(STYLE_NAME);
        
        target.registerEvent(UIEvent.RESIZE, function(_) {
            var x = target.screenLeft;
            var y = target.screenTop;
            var w = target.width;
            var h = target.height;
            _box.left = x;
            _box.top = y;
            _box.width = w;
            _box.height = h;
        });
    }
    
    private function createBox() {
        if (_box != null) {
            return;
        }
        
        _box = new Box();
        _box.id = "boxFocus_indicator";
        _box.styleString = "border: 1px solid $accent-color;pointer-events:none;background-color: $accent-color;background-opacity: .2;border-radius: 2px;";
        Screen.instance.addComponent(_box);
        //FocusManager.instance.popView();
        FocusManager.instance.removeView(_box);
    }
}