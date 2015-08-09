package ben.flash.greatreflector.command 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Ben
	 */
	public interface ICommand 
	{
		/**
		 * the callback function of mouse_down event
		 * @param	event
		 */
		function onMouseDown(event:MouseEvent):void;
		
		/**
		 * the callback function of mouse_move event
		 * @param	event
		 * @param	offsetX
		 * @param	offsetY
		 */
		function onMouseMove(event:MouseEvent, offsetX:int, offsetY:int):void;
		
		/**
		 * the callback function of key_down event
		 * @param 	event
		 */
		function onKeyDown(event:KeyboardEvent):void;
		
		/**
		 * called when the command handler is changed
		 */
		function dispose():void;
		
		/**
		 * get information of current command handler
		 * @return
		 */
		function info():String;
	}
	
}