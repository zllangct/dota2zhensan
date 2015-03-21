/*
	Event:
	"show_popup_image"
	{
		"_playerID"	"short"
		"_x"		"short"
		"_y"		"short"
		"_z"		"short"
		"_image_name"	"string"
	}

*/


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
		
		public function LumberGold(){
			trace("Popup message is now loaded!");
		}

		public function onLoaded() : void {
			trace("onLoaded function of PopupMessage");
			Globals.instance.resizeManager.AddListener(this);
			
			gameAPI.SubscribeToGameEvent( "show_popup_image", onImagePopup);
			
		}
		
		public function onImagePopup(args:Object){
			trace("GAME event catched , trying to deal with message popup")
			var playerID = args._playerID;
			
			if (globals.Players.GetLocalPlayer() != playerID){ return; }
			
			var loc_x = args._x;
			var loc_y = args._y;
			var loc_z = args._z;
			
			var screenX = globals.Game.WorldToScreenX(loc_x, loc_y, loc_z);
			var screenY = globals.Game.WorldToScreenY(loc_x, loc_y, loc_z);
			
			if (screenX < 0 || screenY < 0){ return; }
			if (screenY > this.stageY * 0.9){ return; }
			
			var image_name:String = args._image_name;
			if (msg == undefined){ return; }
			
			trace("=========================================================")
			trace("everything is ok");
			trace("original position" + loc_x + " " + loc_y + " " + loc_z );
			trace( "screen position" + screenX + "/" + screenY);
			trace(", trying to load image" + imageName);
			trace("=========================================================")
			
			var image_mc = new ImageClip(image_name);
			addChild(image_mc);
			
			image_mc.x = screenX;
			image_mc.y = screenY;
			
			TweenLite.to(
			    image_mc,
			    1,
			    {
			        alpha: 0,
			        y:loc_y - 100,
			        scaleX:1.2,
			        scaleY:1.2,
			        onComplete = function()
			        {
			            // todo, dispose mc
			            removeChild(msgMC);
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
/*
package{
	import flash.display.MovieClip;
	import flash.event.Events;
	import flash.net.URLRequest;
	
	public class ImageClip extends MovieClip{
		private loader:Loader;
		
		public function ImageClip(imageName:String){
			trace("ImageClip trying to load image from" + imageName);
			this.loader = new Loader();
			this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onImageLoadComplete);
			this.loader.load(new URLRequest(imageName));
		}
		
		private function onImageLoadComplete(e:Event):void{
			trace("image load finished");
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			
			this.bitMapData = new BitmapData(loaderInfo.width, loaderInfo.height);
			this.bitMapData.draw(loaderInfo.content);
		}
	}
}
*/
