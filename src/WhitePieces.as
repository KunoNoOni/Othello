package
{
	import org.flixel.*;
	
	public class WhitePieces extends FlxSprite
	{
			
		
		public function WhitePieces(X:Number,Y:Number)
		{
			super(X*64,Y*64);
			loadGraphic(Registry.WhitePiece,false,false,64,64,false);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}