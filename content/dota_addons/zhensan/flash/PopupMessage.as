package  {
	
	// Valve Libaries
    import ValveLib.Globals;
    import ValveLib.ResizeManager;
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;

    import com.GreenSock.TweenLite;
    import com.GreenSock.easing.*;

	public class PopupMessage extends MovieClip {
		// Game API related stuff
        public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
		
		public var msgClip:MovieClip;
		
		public function LumberGold(){
			trace("Popup message is now loaded!");
		}

		public function onLoaded() : void {
			trace("onLoaded function of PopupMessage");
			Globals.instance.resizeManager.AddListener(this);
			
			gameAPI.SubscribeToGameEvent( "show_popup_message", onMessagePopup);
			
		}
		
		public function onMessagePopup(args:Object){
			
			var playerID = args._playerID;
			
			if (globals.Players.GetLocalPlayer() != playerID){ return; }
			
			var loc_x = args._x;
			var loc_y = args._y;
			var loc_z = args._z;
			
			var screenX = globals.Game.WorldToScreenX(loc_x, loc_y, loc_z);
			var screenY = globals.Game.WorldToScreenY(loc_x, loc_y, loc_z);
			
			if (screenX < 0 || screenY < 0){ return; }
			if (screenY > this.stageY * 0.9){ return; }
			
			var msg:String = args._msg;
			if (msg == undefined){ return; }
			
			var msgMC = new MessageClip(screenX, screenY, msg);
			this.msgClip.addChild(msgMC);
			TweenLite.to(
			    msgMC,
			    1,
			    {
			        alpha: 0,
			        y:loc_y - 100,
			        onComplete = function()
			        {
			            // todo, dispose mc
			            this.removeChild(msgMC);
			        }
			    }
			)
		}
				
		public function onResize(re:ResizeManager) : * {
			var rm = Globals.instance.resizeManager;
			var currentRatio:Number =  re.ScreenWidth / re.ScreenHeight;
			var divided:Number;
			visible = true;
			
			var originalHeight:Number = 1080;
					
			if(currentRatio < 1.5)
			{
				// 4:3
				divided = currentRatio * 3 / 4.0;
			}
			else if(re.Is16by9()){
				// 16:9
				divided = currentRatio * 9 / 16.0;
			} else {
				// 16:10
				divided = currentRatio * 10 / 16.0;
			}
							
			var correctedRatio:Number =  re.ScreenHeight / originalHeight * divided;
					
			msgClip.scaleX = correctedRatio / 2;
			msgClip.scaleY = correctedRatio / 2;
		
		}
    }
}
