package
{
	import org.flixel.*;
	
	[SWF(width="512", height="600", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class Othello extends FlxGame
	{
		public function Othello()
		{
			super(512,600,TitleState,1);
			//forceDebugger = true;
			//FlxG.visualDebug = true;
			//FlxG.debug = true;
		}
	}
}