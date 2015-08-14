package ben.flash.greatreflector.effect 
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author Ben
	 */
	public class Filters 
	{
		/**
		 * black color glow filter
		 */
		public static var glowFilter1:GlowFilter = new GlowFilter(0x000000, 1, 6, 6, 10);
		/**
		 * a filter make color darker
		 */
		public static var lightFilter1:ColorMatrixFilter = new ColorMatrixFilter([
			1, 0, 0, 0, -100, 0, 1, 0, 0, -100, 0, 0, 1, 0, -100, 0, 0, 0, 1, 0
		]);
		/**
		 * a filter make color brighter
		 */
		public static var lightFilter2:ColorMatrixFilter = new ColorMatrixFilter([
			1, 0, 0, 0, 100, 0, 1, 0, 0, 100, 0, 0, 1, 0, 100, 0, 0, 0, 1, 0
		]);
	}

}