package modchart.core.macros;

import format.abc.Data.ABCData;
#if macro
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.macro.Expr.FieldType;

class Macro
{
	// this macro is actually runned but __modchartStorage is not used
	// since it seems we cannot reuse a draw item
	// TODO: figure out why cannot resue a draw item and fix it
	/*
	@:noUsing
	public static function buildNoteClass():Array<Field>
	{
		// fields from the current class (Note)
		final fields:Array<Field> = Context.getBuildFields();
		final curPosition = Context.currentPos();

		var storageField:Field = null;

		fields.push(storageField = {
			name: "__modchartStorage",
			access: [APrivate],
			kind: FieldType.FVar(macro:Null<modchart.core.util.Constants.ModchartStorage>, macro $v{null}),
			pos: curPosition
		});

		fields.map(field -> {
			if (field.name == 'destroy')
			{
				var lastExpr:Expr;
				
				switch(field.kind)
				{
					case FFun(ed):
						lastExpr = ed.expr;
					default:
						// do nothing
				}

				field.kind = FieldType.FFun({
					expr: macro {
						__modchartStorage?.drawItem?.dispose();
						${lastExpr};
					},
					args: []
				});
			}
		});

		return fields;
	}*/
	public static function addZProperty():Array<Field>
	{
		var fields = Context.getBuildFields();

		fields.push({
			name: "_z",
			access: [APublic],
			kind: FieldType.FVar(macro:Float, macro $v{0}),
			pos: Context.currentPos()
		});

		return fields;
	}
	/*
	public static function generateModList()
	{
		final modifierList:Array<Class<Modifier>> = CompileTime.getClassList('modchart.modifiers', true, modchart.Modifier);
		final mappedModifiers:Map<String, Class<Modifier>> = [];

		for (i in 0...modifierList.length)
		{
			final modifierClass = modifierList[i];

			if (Meta.getType(modifierClass) != null)
				continue;

			var modifierName = Type.getClassName(modifierClass);
			modifierName = modifierName.substring(modifierName.lastIndexOf('.') + 1);
			mappedModifiers[modifierName.toLowerCase()] = modifierClass;
		}

		MODIFIER_LIST = mappedModifiers;

		Context.info('---- Modifiers Founded ----\n$mappedModifiers');
		return fields;
	}*/

}
#end