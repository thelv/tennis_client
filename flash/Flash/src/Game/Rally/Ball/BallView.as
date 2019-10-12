package Game.Rally.Ball 
{

	import flash.display.Bitmap;
	
	public class BallView extends View
	{
		private var ball: Ball;;
		[Embed(source = "../../../../lib/ball.png")]
		private var imageClass : Class;
		private var image:Bitmap=new imageClass();
		
		public function BallView(ball: Ball):void
		{
			this.ball = ball;
			image = new imageClass();
			super(image.width, image.height);
			addChild(image);
		}
	}

}