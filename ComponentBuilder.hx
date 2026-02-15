package haxe_ui;

import haxe.macro.Expr;

@:access(haxe_ui.macros.ComponentMacros)
class ComponentBuilder {
    macro public static function build(resourcePath:String, params:Expr = null):Array<Field> {
        return haxe_ui.macros.ComponentMacros.buildCommon(resourcePath, params);
    }
    
    macro public static function fromFile(filePath:String, params:Expr = null):Expr {
        return haxe_ui.macros.ComponentMacros.buildComponentCommon(filePath, params);
    }
    
    macro public static function fromString(source:String, params:Expr = null):Expr {
        return haxe_ui.macros.ComponentMacros.buildFromStringCommon(source, params);
    }
    
}