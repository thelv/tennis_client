package Game.Rally.Player.KeyHandler 
{
	
	import flash.events.KeyboardEvent;
	import Game.Rally.Player.LocalPlayer;
	
	public class KeyHandler 
	{
		//vars

			private var localPlayer: LocalPlayer;
			//key codes
			private var keyLeft: int, keyRight: int, keyDown: int, keyUp: int, keyTurnCounterClockWise: int, keyTurnClockWise: int; 
			//pressed keys
			public var keyLeftPressed: Boolean, keyRightPressed: Boolean, keyDownPressed: Boolean, keyUpPressed: Boolean, keyTurnClockWisePressed: Boolean, keyTurnCounterClockWisePressed: Boolean;
		
		//constructor
		
			public function KeyHandler(localPlayer: LocalPlayer, keyLeft: int, keyRight: int, keyDown: int, keyUp: int, keyTurnCounterClockWise: int, keyTurnClockWise: int): void
			{
				//logic
				this.localPlayer = localPlayer;
				
				this.keyLeft=keyLeft;
				this.keyRight=keyRight;
				this.keyDown=keyDown;
				this.keyUp=keyUp;		
				this.keyTurnCounterClockWise=keyTurnCounterClockWise;
				this.keyTurnClockWise = keyTurnClockWise;	
				
				this.keyLeftPressed=false;
				this.keyRightPressed=false;
				this.keyDownPressed=false;
				this.keyUpPressed = false;
				this.keyTurnClockWisePressed = false;
				this.keyTurnCounterClockWisePressed = false;
				
				//ui
				Main.stage.addEventListener(KeyboardEvent.KEY_DOWN, uiKeyDown);
				Main.stage.addEventListener(KeyboardEvent.KEY_UP, uiKeyUp);
			}		
		
		//ui methods
			
			private function uiKeyDown(event:KeyboardEvent): void
			{								
				keyDownF(event.keyCode);
			}
			
			private function uiKeyUp(event:KeyboardEvent): void
			{
				keyUpF(event.keyCode);
			}
			
		//logic methods
			
			private function keyDownF(keyCode: int): void
			{				
				if(keyCode==keyLeft){keyLeftPressed=true;}
				if(keyCode==keyRight){keyRightPressed=true;}
				if(keyCode==keyDown){keyDownPressed=true;}
				if(keyCode==keyUp){keyUpPressed=true;}
				if(keyCode==keyTurnCounterClockWise){keyTurnCounterClockWisePressed=true;}
				if(keyCode==keyTurnClockWise){keyTurnClockWisePressed=true;}
				localPlayer.afterKeyPressedChange();
			}
			
			private function keyUpF(keyCode: int): void
			{
				if (keyCode==keyLeft){keyLeftPressed=false;}
				if (keyCode==keyRight){keyRightPressed=false;}
				if(keyCode==keyDown){keyDownPressed=false;}
				if(keyCode==keyUp){keyUpPressed=false;}
				if (keyCode == keyTurnCounterClockWise){keyTurnCounterClockWisePressed=false;}
				if(keyCode==keyTurnClockWise){keyTurnClockWisePressed=false;}	
				localPlayer.afterKeyPressedChange();
			}
	}

}