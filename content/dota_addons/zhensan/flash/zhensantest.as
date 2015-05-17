package  {
	
	// Valve Libaries
    import ValveLib.Globals;
    import ValveLib.ResizeManager;
	
	import flash.display.MovieClip;
	
	import flash.utils.getDefinitionByName;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;


	
	
	public class zhensantest extends MovieClip {
		 // Game API related stuff
        public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
		public var correctedRatio:Number;
		public function zhensantest() {
			// constructor code
			Globals.instance.resizeManager.AddListener(this);
		}
		public function onLoaded() : void {
            trace("################################# success test");
			Globals.instance.resizeManager.AddListener(this);
			visible=true;
			list_1.visible=true;           
            function_butten_1.visible=true;
			 
			//this.function_butten_1.addEventListener(MouseEvent.CLICK,onfunction_butten_click);
			//this.addFrameScript(0, this.frame1);
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
							
			correctedRatio =  re.ScreenHeight / originalHeight * divided;
					
			this.scaleX = correctedRatio;
			this.scaleY = correctedRatio;
			
			
		}
	}
	
}
