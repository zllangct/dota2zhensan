﻿package {
	// Valve Libaries
    import ValveLib.Globals;
    import ValveLib.ResizeManager;
	
	import flash.display.MovieClip;
	
	import flash.utils.getDefinitionByName;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class Morale extends MovieClip {
		// Game API related stuff
        public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
		
		public var MoraleWei:Number = 10;
		public var MoraleShu:Number = 10;
		
		public var moraleClip:MovieClip;
		public var moraleLabelClip:MovieClip;
		public var correctedRatio:Number;
		public var shuwei:MovieClip;
		public function Morale(){

		}

		public function onLoaded() : void {
			trace("MORALE HUD LAODED!");
			Globals.instance.resizeManager.AddListener(this);
			gameAPI.SubscribeToGameEvent( "morale_update", onMoraleUpdate );
			this.moraleShuLabel.visible = false;
			this.moraleWeiLabel.visible = false;
			moraleClip.tileBad.visible = true;
			moraleClip.tileGood.visible = true;
			moraleClip.tileBad.width = 300;
			//shuwei.visible=true;
			
		}
		
		public function onMoraleUpdate(args:Object){
			trace("ON MORALE UPDATE CALLED");
			
			var ShuUp:Boolean = MoraleShu < args.MoraleShu;
			
			MoraleWei = args.MoraleWei;
			MoraleShu = args.MoraleShu;
			trace("MORALE WEI" + MoraleWei);
			trace("MORALE SHU" + MoraleShu);
			var goodWidth:Number = MoraleShu * 600 / 20;
			if (goodWidth == 0){
				goodWidth = 1;
			}
			moraleClip.tileBad.width = goodWidth;
			moraleClip.tileBad.x=moraleClip.tileGood.x;
			
			// 上升下降的动画
			
			if (ShuUp){
				moraleLabelClip = this.moraleShuLabel;
			}
			else{
				moraleLabelClip = this.moraleWeiLabel;
			}
			moraleLabelClip.visible = true;
			moraleLabelClip.alpha = 0;
			moraleLabelClip.y = 800;
			TweenLite.to(
    			moraleLabelClip,                    //movieclip to be tweened
    			1,                             		//duration
    			{                                	//start of parameter object
        			y:100,                       	//target Y
       				alpha:1,                     	//target alpha
        			ease:Elastic.easeInOut,         //easing function
        			onComplete:function(){       	//onComplete callback
            			trace('tweening done!'); 	//you could even add a new tween here!
						moraleLabelClip.visible = false;
						moraleLabelClip.y = 800;
        			}
    			}
			);
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
				this.scaleX = correctedRatio;
			    this.scaleY = correctedRatio;
				this.moraleClip.x = re.ScreenWidth * 1.1;
				this.moraleClip.y = re.ScreenHeight*0.08;
			}
			else if(re.Is16by9()){
				// 16:9
				divided = currentRatio * 9 / 16.0;
				correctedRatio =  re.ScreenHeight / originalHeight * divided;
				this.scaleX = correctedRatio;
			    this.scaleY = correctedRatio;
				
			} else {
				// 16:10
				divided = currentRatio * 10 / 16.0;
				correctedRatio =  re.ScreenHeight / originalHeight * divided;
				this.moraleClip.x=this.moraleClip.x * 0.9;
				this.scaleX = correctedRatio;
			    this.scaleY = correctedRatio;
				
			}
			
		}
    }
}
