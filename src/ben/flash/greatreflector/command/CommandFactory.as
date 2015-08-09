package ben.flash.greatreflector.command 
{
	/**
	 * ...
	 * @author Ben
	 */
	public class CommandFactory 
	{
		/**default command type*/
		public static const TYPE_DEFAULT:int = 0;
		/**select command type*/
		public static const TYPE_SELECT:int = 1;
		
		/**default command*/
		public static var defaultCommand:ICommand;
		/**select command*/
		public static var selectCommand:ICommand;
		
		/**
		 * get the command based on the type
		 * @param	type
		 */
		public static function getCommand(type:int):ICommand
		{
			var command:ICommand;
			switch(type)
			{
				case TYPE_SELECT:
					if (selectCommand == null)
					{
						selectCommand = new SelectCommand();
					}
					command = selectCommand;
					break;
				default:
					if (defaultCommand == null)
					{
						defaultCommand = new Command();
					}
					command = defaultCommand;
					break;
			}
			return command;
		}
		
	}

}