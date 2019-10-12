package Game.Rally.Player 
{
	
	import flash.display.Bitmap;
		
	public class PlayerView extends View
	{
		private var player: Player;
		[Embed(source = "../../../../lib/player.png")]
		private var imageClass : Class;
		private var image:Bitmap=new imageClass();
		
		public function PlayerView(player: Player):void
		{
			this.player = player;
			image = new imageClass();
			super(image.width, image.height);
			addChild(image);			
		}		
	}
}