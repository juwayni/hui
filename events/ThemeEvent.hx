package haxe_ui.events;
import haxe_ui.events.UIEvent;

class ThemeEvent extends UIEvent {
    public static final THEME_CHANGED:EventType<ThemeEvent> = EventType.name("themechanged");
}