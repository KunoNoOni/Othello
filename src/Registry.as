package
{
	import org.flixel.*;

	public class Registry
	{
		//public static var levelIndex:int = 0;

		[Embed(source = 'Sprites/board.png')] static public var Board:Class;
		[Embed(source = 'Sprites/back.png')] static public var Back:Class;
		[Embed(source = 'Sprites/whitePiece.png')] static public var WhitePiece:Class;
		[Embed(source = 'Sprites/blackPiece.png')] static public var BlackPiece:Class;
		[Embed(source = 'Sprites/cursor.png')] static public var Cursor:Class;
		
		
		//[Embed(source = 'Maps/mapCSV_Group1_set1P1.csv', mimeType = 'application/octet-stream')] static public var set1P1:Class;
		
		//[Embed(source = 'sounds/jump.mp3')] static public var _jump:Class;
		
		
		public function Registry()
		{
		}
	}
}