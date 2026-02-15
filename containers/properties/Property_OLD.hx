package haxe_ui.containers.properties;

import haxe_ui.behaviours.DataBehaviour;
import haxe_ui.behaviours.DefaultBehaviour;
import haxe_ui.components.Label;
import haxe_ui.core.Component;
import haxe_ui.core.CompositeBuilder;
import haxe_ui.core.IDataComponent;
import haxe_ui.core.IValueComponent;
import haxe_ui.data.ArrayDataSource;
import haxe_ui.data.DataSource;
import haxe_ui.util.Variant;

@:composite(PropertyBuilder)
class Property_OLD extends HBox implements IDataComponent {
    @:clonable @:behaviour(LabelBehaviour)              public var label:String;
    @:clonable @:behaviour(DefaultBehaviour, "text")    public var type:String;
    @:behaviour(DataSourceBehaviour)                    public var dataSource:DataSource<Dynamic>;
    @:clonable @:behaviour(PropertyValueBehaviour)      public var value:Dynamic;
    @:clonable @:behaviour(DefaultBehaviour)            public var step:Null<Float>;
    @:clonable @:behaviour(DefaultBehaviour)            public var forceStep:Null<Bool>;
    @:clonable @:behaviour(DefaultBehaviour)            public var min:Null<Float>;
    @:clonable @:behaviour(DefaultBehaviour)            public var max:Null<Float>;
    @:clonable @:behaviour(DefaultBehaviour)            public var precision:Null<Int>;
}

//***********************************************************************************************************
// Behaviours
//***********************************************************************************************************
@:dox(hide) @:noCompletion
@:access(haxe_ui.core.Component)
private class LabelBehaviour extends DefaultBehaviour {
    private var _property:Property_OLD;

    public function new(property:Property_OLD) {
        super(property);
        _property = property;
    }

    public override function set(value:Variant) {
        super.set(value);
        var builder = cast(_property._compositeBuilder, PropertyBuilder);
        if (builder.label != null) {
            builder.label.text = value;
        }
    }
}

@:dox(hide) @:noCompletion
@:access(haxe_ui.core.Component)
private class DataSourceBehaviour extends DefaultBehaviour {
    private var _property:Property_OLD;

    public function new(property:Property_OLD) {
        super(property);
        _property = property;
    }

    public override function get():Variant {
        if (_value == null) {
            _value = new ArrayDataSource<Dynamic>();
        }
        return _value;
    }

    public override function set(value:Variant) {
        super.set(value);
        var builder = cast(_property._compositeBuilder, PropertyBuilder);
        if (builder.editor != null && (builder.editor is IDataComponent)) {
            cast(builder.editor, IDataComponent).dataSource = value;
        }
    }
}

@:dox(hide) @:noCompletion
@:access(haxe_ui.core.Component)
private class PropertyValueBehaviour extends DataBehaviour {
    private var _property:Property_OLD;

    public function new(property:Property_OLD) {
        super(property);
        _property = property;
    }
    
    public override function set(value:Variant) {
        var builder = cast(_property._compositeBuilder, PropertyBuilder);
        _value = value;
        if (builder.actualEditor != null) {
            builder.actualEditor.value = Variant.toDynamic(_value);
        }
        
        invalidateData();
    }

    public override function get():Variant {
        var builder = cast(_property._compositeBuilder, PropertyBuilder);
        if (builder.actualEditor != null) {
            return builder.actualEditor.value;
        }
        return _value;
    }
    
    public override function getDynamic():Dynamic {
        var builder = cast(_property._compositeBuilder, PropertyBuilder);
        if (builder.actualEditor != null) {
            return builder.actualEditor.value;
        }
        return Variant.toDynamic(_value);
    }
    
    public override function validateData() {
        var builder = cast(_property._compositeBuilder, PropertyBuilder);
        if (builder.actualEditor != null) {
            builder.actualEditor.value = Variant.toDynamic(_value);
        }
    }
}

//***********************************************************************************************************
// Builder
//***********************************************************************************************************
@:noCompletion
class PropertyBuilder extends CompositeBuilder {
    public var editor:Component = null;
    public var label:Label = null;
    
    public override function addComponent(child:Component):Component {
        var v = cast(_component, Property_OLD).value;
        if ((child is IValueComponent)) {
            editor = child;
            editor.value = v;
        } else {
            child.walkComponents(function(c) {
                if ((c is IValueComponent)) {
                    editor = child;
                    c.value = v;
                }
                return (editor == null);
            });
        }
        return child;
    }
    
    public var actualEditor(get, null):Component;
    private function get_actualEditor():Component {
        if (editor == null) {
            return null;
        }
        var r = null;
        if ((editor is IValueComponent)) {
            r = editor;
        } else {
            editor.walkComponents(function(c) {
                if ((c is IValueComponent)) {
                    r = c;
                }
                return (r == null);
            });
        }
        return r;
    }
}
