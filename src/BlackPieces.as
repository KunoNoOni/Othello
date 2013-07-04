package
{
	import org.flixel.*;
	
	public class BlackPieces extends FlxSprite
	{
			
		
		public function BlackPieces(X:Number,Y:Number)
		{
			super(X*64,Y*64);
			loadGraphic(Registry.BlackPiece,false,false,64,64,false);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}