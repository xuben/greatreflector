package ben.flash.greatreflector.command 
{
	import ben.flash.greatreflector.effect.Filters;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class SelectCommand extends Command 
	{
		// current selected display object
		private var _obj:DisplayObject;
		// filter of current selected display object
		private var _objFilters:Array;
		
		public function SelectCommand() 
		{
			super();
		}
		
		override public function onMouseDown(event:MouseEvent):void
		{
			// get new selection
			var obj:DisplayObject = find(event);
			
			select(obj);
		}
		
		/**
		 * find the best matched display object
		 * @param	event
		 * @return
		 */
		private function find(event:MouseEvent):DisplayObject
		{
			// get the stage object
			var stage:Stage = (event.target as DisplayObject).stage;
			if (stage)
			{
				var objs:Array = stage.getObjectsUnderPoint(new Point(event.stageX, event.stageY));
				// the returned objs are ordered by depth
				if (objs.length > 0)
				{
					return objs[objs.length - 1];
				}
			}
			return null;
		}
		
		/**
		 * set current selected display object
		 * @param	obj
		 */
		private function select(obj:DisplayObject):void
		{
			// selection not changed
			if (obj == _obj)
			{
				return;
			}
			
			// clear previous seletion
			unselect();
			
			// set new selection
			_obj = obj;
			if (_obj)
			{
				_objFilters = _obj.filters;
				_obj.filters = [Filters.glowFilter1];
			}
			
			trace("[SelectCommand]: selection changed");
		}
		
		/**
		 * clear selection of current display object
		 */
		private function unselect():void
		{
			if (_obj)
			{
				_obj.filters = _objFilters;
				_obj = null;
				_objFilters = null;
			}
		}
		
		override public function onMouseMove(event:MouseEvent, offsetX:int, offsetY:int):void
		{
			if (_obj)
			{
				_obj.x += offsetX;
				_obj.y += offsetY;
			}
		}
		
		/**
		 * select parent of the given display object
		 * @param	obj
		 */
		private function selectParent(obj:DisplayObject):void
		{
			if (obj && obj.parent && !(obj.parent is Stage))
			{
				select(obj.parent);
			}
		}
		
		/**
		 * select the toppest child of the given display object
		 * @param	obj
		 */
		private function selectTopChild(obj:DisplayObject):void
		{
			if (obj && obj is DisplayObjectContainer)
			{
				var objContainer:DisplayObjectContainer = obj as DisplayObjectContainer;
				if (objContainer.numChildren > 0)
				{
					select(objContainer.getChildAt(objContainer.numChildren - 1));
				}
			}
		}
		
		/**
		 * select sibling of the given display object
		 * @param	obj
		 * @param	indexOffset
		 */
		private function selectSibling(obj:DisplayObject, indexOffset:int):void
		{
			if (obj == null || obj.parent == null || indexOffset == 0)
			{
				return;
			}
			
			var currentIndex:int = obj.parent.getChildIndex(obj);
			var index:int = currentIndex + indexOffset;
			// index out of range
			if (index < 0 || index >= obj.parent.numChildren)
			{
				return;
			}
			// exclude GreatReflector
			else if (obj.parent is Stage && index == obj.parent.numChildren - 1)
			{
				return;
			}
			select(obj.parent.getChildAt(index));
		}
		
		override public function onKeyDown(event:KeyboardEvent):void
		{
			if (_obj == null)
			{
				return;
			}
			switch(event.keyCode)
			{
				case Keyboard.UP: // select parent display object
					selectParent(_obj);
					break;
				case Keyboard.DOWN: // select toppest child
					selectTopChild(_obj);
					break;
				case Keyboard.LEFT: // select deeper sibling
					selectSibling(_obj, -1);
					break;
				case Keyboard.RIGHT: // select shallower sibling
					selectSibling(_obj, 1);
					break;
				case Keyboard.W: // move 1 pixel up
					_obj.y -= 1;
					break;
				case Keyboard.A: // move 1 pixel left
					_obj.x -= 1;
					break;
				case Keyboard.S: // move 1 pixel down
					_obj.y += 1;
					break;
				case Keyboard.D: // move 1 pixel right
					_obj.x += 1;
					break;
				default:
					break;
			}
		}
		
		override public function dispose():void
		{
			// clear seletion
			unselect();
		}
		
		override public function info():String
		{
			if (_obj)
			{
				return "x: " + _obj.x + ", y: " + _obj.y;
			}
			return "";
		}
	}

}