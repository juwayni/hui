package haxe_ui.data;

@:autoBuild(haxe_ui.macros.Macros.buildData())
interface IDataItem {
    var onDataSourceChanged:Void->Void;
}
