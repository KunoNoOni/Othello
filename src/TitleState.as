package
{
	import org.flixel.*;
		
	public class TitleState extends FlxState
	{
		//Variables got here
		private var back:FlxSprite = new FlxSprite();
		private var wp:WhitePieces;
		private var bp:BlackPieces;
		
		
		public function TitleState()
		{
			super();
			
			back.loadGraphic(Registry.Back,false,false,512,1000);
			add(back);
			wp = new WhitePieces(3,3)
			add(wp);
			bp = new BlackPieces(4,3);
			add(bp)
			wp = new WhitePieces(4,4);
			add(wp);
			bp = new BlackPieces(3,4);
			add(bp)
			
		}
		
		override public function create():void
		{
			
			var logo1:FlxText = new FlxText(FlxG.width*0.5-175,FlxG.height*0.5-235, 300, "Othell");
			logo1.setFormat(null,50,0x000000, "center");
			add(logo1);
			
			var logo:FlxText = new FlxText(FlxG.width*0.5-170,FlxG.height*0.5-240, 300, "Othell");
			logo.setFormat(null,50,0xFFFFFF, "center");
			add(logo);
			
			var logo3:FlxText = new FlxText(FlxG.width*0.5-65,FlxG.height*0.5-235, 300, "O");
			logo3.setFormat(null,50,0xFFFFFF, "center");
			add(logo3);
			
			var logo2:FlxText = new FlxText(FlxG.width*0.5-60,FlxG.height*0.5-240, 300, "O");
			logo2.setFormat(null,50,0x000000, "center");
			add(logo2);
			
			var instruct2:FlxText = new FlxText(FlxG.width*0.5-253,FlxG.height-47, 500, "CLICK MOUSE BUTTON TO START");
			instruct2.setFormat(null,20,0x000000, "center");
			add(instruct2);
			
			var instruct:FlxText = new FlxText(FlxG.width*0.5-250,FlxG.height-50, 500, "CLICK MOUSE BUTTON TO START");
			instruct.setFormat(null,20,0xFFFFFF, "center");
			add(instruct);
		}
		
		override public function update():void
		{
			if(FlxG.mouse.justReleased())
			{
				FlxG.switchState(new PlayState());
			}	
			super.update();
		}
	}
}