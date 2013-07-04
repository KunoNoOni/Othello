package
{
	import org.flixel.*;
	//import org.flixel.plugin.photonstorm.*;
	
	public class MouseCursor extends FlxSprite
	{
		//Variables got here
		
		public function MouseCursor(X:Number, Y:Number)
		{
			super(X*64,Y*64);
			loadGraphic(Registry.Cursor,false,false,64,64,false);
			
			
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}