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
		
		//public var lumberGoldMovieClip:MovieClip;
        public var correctedRatio:Number;
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
			// TODO：这里有个BUG，会导致scaleform无限报错，需要再看看是什么原因
			var playerID = globals.Players.GetLocalPlayer();
			var gold:Number = globals.Players.GetGold(playerID); // 本来少了分号，等回家重新编译一下看能否解决问题。
			
			lumberGoldMovieClip.goldLabel.text = gold.toString();
					
		}
		public function onLumberUpdate(args:Object){
			var Lumber:Number = args.Lumber;
			var playerID = globals.Players.GetLocalPlayer();
			if (playerID == args.PlayerID){
				lumberGoldMovieClip.lumberLabel.text = Lumber.toString();
			}
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
				correctedRatio =  re.ScreenHeight / originalHeight * divided;
				this.lumberGoldMovieClip.scaleX = correctedRatio/2;
			    this.lumberGoldMovieClip.scaleY = correctedRatio/2;
				this.lumberGoldMovieClip.x = 25;
				this.lumberGoldMovieClip.y =  re.ScreenHeight*0.06+4;
			}
			else if(re.Is16by9()){
				// 16:9
				divided = currentRatio * 9 / 16.0;
				correctedRatio =  re.ScreenHeight / originalHeight * divided;
				this.scaleX = correctedRatio;
			    this.scaleY = correctedRatio;
				this.lumberGoldMovieClip.x = 25+re.ScreenWidth*0.14;
				this.lumberGoldMovieClip.y =  re.ScreenHeight*0.02+4;
			} else {
				// 16:10
				divided = currentRatio * 10 / 16.0;
				correctedRatio =  re.ScreenHeight / originalHeight * divided;
				this.scaleX = correctedRatio;
			    this.scaleY = correctedRatio;
				this.lumberGoldMovieClip.x = re.ScreenWidth*0.1/correctedRatio;
				this.lumberGoldMovieClip.y =  re.ScreenHeight*0.02/correctedRatio+2;
			}
							
			
			
				
			
			
		}
    }
}
