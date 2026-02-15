package haxe_ui.core;

import haxe_ui.data.DataSource;

interface IDataComponent {
    public var dataSource(get, set):DataSource<Dynamic>;
}