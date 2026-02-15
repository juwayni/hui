package haxe_ui.validators;

import haxe_ui.core.Component;

interface IValidator {
    public var invalidMessage:String;
    public function setup(component:Component):Void;
    public function validate(component:Component):Null<Bool>;
    public function setProperty(name:String, value:Any):Void;
}