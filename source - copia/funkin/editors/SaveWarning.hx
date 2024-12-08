package funkin.editors;

class SaveWarning {
	public static var showWarning(default, set):Bool;
	public static function set_showWarning(warning:Bool):Bool
		return WindowUtils.preventClosing = showWarning = warning;

	public static var selectionClass:Class<EditorTreeMenu> = null;
	public static var saveFunc:Void->Void = null;

	public static function init() {
		showWarning = false;

		WindowUtils.onClosing = function () {
			if (SaveWarning.showWarning) triggerWarning(true);
		}
	}

	public static var warningFunc:Bool->Void = null;
	public static function triggerWarning(?closingWindow:Bool = false) {
		if (warningFunc != null) warningFunc(closingWindow);

		if (FlxG.state != null && FlxG.state is UIState) {
			FlxG.state.openSubState(new UIWarningSubstate("Unsaved Changes!", "Your changes will be lost if you don't save them. (Can't be recovered)\n\n\nWould you like to Cancel?",
			[
				{
					label: "Cancel",
					color: 0x969533,
					onClick: function (_) {if (closingWindow) WindowUtils.resetClosing();}
				},
				{
					label: closingWindow ? "Exit Game" : "Exit To Menu",
					color: 0x969533,
					onClick: function(_) {
						if (!closingWindow) {
							if (selectionClass != null) FlxG.switchState(Type.createInstance(SaveWarning.selectionClass, []));
							if (closingWindow) WindowUtils.resetClosing();
						} else {
							WindowUtils.preventClosing = false; WindowUtils.resetClosing();
							Sys.exit(0);
						}
					}
				},
				{
					label: closingWindow ? "Save & Exit Game" : "Save & Exit To Menu",
					color: 0x969533,
					onClick: function(_) {
						if (saveFunc != null) saveFunc();
						if (!closingWindow) {
							if (selectionClass != null) FlxG.switchState(Type.createInstance(SaveWarning.selectionClass, []));
							if (closingWindow) WindowUtils.resetClosing();
						} else {
							WindowUtils.preventClosing = false; WindowUtils.resetClosing();
							Sys.exit(0);
						}
					}
				}
			], false));
		}
	}

	public static inline function reset() {
		SaveWarning.showWarning = false;
		SaveWarning.selectionClass = null;
		SaveWarning.saveFunc = null;
		SaveWarning.warningFunc = null;
	}
}