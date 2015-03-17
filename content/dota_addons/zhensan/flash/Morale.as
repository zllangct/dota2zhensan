package  {
	
	// Valve Libaries
    import ValveLib.Globals;
    import ValveLib.ResizeManager;
	
	import flash.display.MovieClip;
	
	import flash.utils.getDefinitionByName;
	
	public class Morale extends MovieClip {
		// Game API related stuff
        public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
		
		public var MoraleWei:Number = 10;
		public var MoraleShu:Number = 10;
		
		public var moraleClip:MovieClip;

		public function Morale(){

		}

		public function onLoaded() : void {
			trace("MORALE HUD LAODED!");
			Globals.instance.resizeManager.AddListener(this);
			gameAPI.SubscribeToGameEvent( "morale_update", onMoraleUpdate );
			moraleClip.tileGood.width = 300;
		}
		
		public function onMoraleUpdate(args:Object){
			trace("ON MORALE UPDATE CALLED");
			
			var ShuUp:Boolean = MoraleShu < args.MoraleShu;
			
			MoraleWei = args.MoraleWei;
			MoraleShu = args.MoraleShu;
			trace("MORALE WEI" + MoraleWei);
			trace("MORALE SHU" + MoraleShu);
			var goodWidth:Number = MoraleShu * 30;
			if (goodWidth == 0){
				goodWidth = 1;
			}
			moraleClip.tileGood.width = goodWidth;
			// todo 上升下降的动画
			
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
					
			moraleClip.scaleX = correctedRatio / 2;
			moraleClip.scaleY = correctedRatio / 2;
			moraleClip.x = ( 30 * correctedRatio);//re.ScreenWidth * .5;//
			moraleClip.y = ( 50 * correctedRatio);//re.ScreenHeight * .25;
		}
    }
}
