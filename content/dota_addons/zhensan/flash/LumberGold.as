package  {
	
	// Valve Libaries
    import ValveLib.Globals;
    import ValveLib.ResizeManager;
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class LumberGold extends MovieClip {
		// Game API related stuff
        public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
		
		public var Lumber:Number;
		public var Gold:Number;
		
		public var goldTickTimer:Timer;
		
		public var lumberGoldMovieClip:MovieClip;

		public function LumberGold(){
			trace("LUMBER GOLD HUD constructor!");
		}

		public function onLoaded() : void {
			trace("LUMBER GOLD HUD LAODED!");
			Globals.instance.resizeManager.AddListener(this);
			gameAPI.SubscribeToGameEvent( "lumber_update", onLumberUpdate);
			goldTickTimer = new Timer(1);
			goldTickTimer.addEventListener(TimerEvent.TIMER, onGoldTickTimer);
			goldTickTimer.start();
		}
		public function onGoldTickTimer(e:TimerEvent){
			var playerID = globals.Players.GetLocalPlayer();
			var gold:Number = globals.Players.GetGold(playerID)
			if (gold == undefined){
				gold = 0;
			}
			lumberGoldMovieClip.goldLabel.text = gold;
		}
		public function onLumberUpdate(args:Object){
			var Lumber:Number = args.Lumber;
			var playerID = globals.Players.GetLocalPlayer();
			if (playerID == args.PlayerID){
				lumberGoldMovieClip.lumberLabel.text = Lumber;
			}
		}
		public function replaceWithValveComponent(mc:MovieClip, type:String, keepDimensions:Boolean = false, addAt:int = -1) : MovieClip {
			var parent = mc.parent;
			var oldx = mc.x;
			var oldy = mc.y;
			var oldwidth = mc.width;
			var oldheight = mc.height;
			
			var newObjectClass = getDefinitionByName(type);
			var newObject = new newObjectClass();
			newObject.x = oldx;
			newObject.y = oldy;
			if (keepDimensions) {
				newObject.width = oldwidth;
				newObject.height = oldheight;
			}
			
			parent.removeChild(mc);
			if (addAt == -1)
				parent.addChild(newObject);
			else
				parent.addChildAt(newObject, 0);
			
			return newObject;
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
					
			lumberGoldMovieClip.scaleX = correctedRatio / 2;
			lumberGoldMovieClip.scaleY = correctedRatio / 2;
			lumberGoldMovieClip.x = 1450 * correctedRatio;//re.ScreenWidth * .5;
			lumberGoldMovieClip.y = 10 * correctedRatio;//re.ScreenHeight * .25;
		}
    }
}
