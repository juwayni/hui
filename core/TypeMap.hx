package haxe_ui.core;

import haxe_ui.util.RTTI;

using StringTools;

class TypeMap {
    public static function getTypeInfo(className:String, property:String):String {
        var propInfo = RTTI.getClassProperty(className, property);
        if (propInfo == null) {
            return null;
        }
        
        return propInfo.propertyType;
    }
}