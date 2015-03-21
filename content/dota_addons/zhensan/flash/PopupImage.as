/*
    Event:
    "show_popup_image"
    {
        "_playerID" "short"
        "_x"        "short"
        "_y"        "short"
        "_z"        "short"
        "_image_name"   "string"
    }

*/


package  {
    
    // Valve Libaries
    import ValveLib.Globals;
    import ValveLib.ResizeManager;
    
    import flash.display.MovieClip;
    import flash.utils.getDefinitionByName;

    import com.greensock.TweenLite;
    import com.greensock.easing.*;

    public class PopupImage extends MovieClip {
        // Game API related stuff
        public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
        
        public function PopupImage(){
            trace("Popup image is now loaded!");
        }

        public function onLoaded() : void {
            trace("onLoaded function of Popup image");
            Globals.instance.resizeManager.AddListener(this);
            
            gameAPI.SubscribeToGameEvent( "show_popup_image", onImagePopup);
            gameAPI.SubscribeToGameEvent( "show_popup_image_all", onImagePopupAll);
            // 让这个MC不响应鼠标 todo 待测试
            this.mouseEnabled = false;
            this.mouseChildren = false;
			
        }
        
        public function onImagePopup(args:Object){
            trace("GAME event catched , trying to deal with message popup")
            var playerID = args._playerID;
            
            if (globals.Players.GetLocalPlayer() != playerID){ return; }
			
            createImagePopup(args);
        }
        
        public function onImagePopupAll(args:Object){
            createImagePopup(args);
        }
        
        public function createImagePopup(args:Object){
            
            var loc_x = args._x;
            var loc_y = args._y;
            var loc_z = args._z;
            
            var screenX = globals.Game.WorldToScreenX(loc_x, loc_y, loc_z);
            var screenY = globals.Game.WorldToScreenY(loc_x, loc_y, loc_z);
            
            if (screenX < 0 || screenY < 0){ return; }
            if (screenY > this.stage.height * 0.9){ return; }
            
            var image_name:String = args._image_name;
                        
            trace("=========================================================")
            trace("everything is ok");
            trace("original position" + loc_x + " " + loc_y + " " + loc_z );
            trace( "screen position" + screenX + "/" + screenY);
            trace(", trying to load image" + image_name);
            trace("=========================================================")
            
            var image_mc = new ImageLoader(image_name);
			
            addChild(image_mc);
            
            image_mc.x = screenX;
            image_mc.y = screenY;
            
			var randomScale:Number = Math.random() * 0.2 + 1;
			
            TweenLite.to(
                image_mc,
                1,
                {
                    x:screenX + Math.random() * 50 - 25,
                    y:screenY - 100,
                    scaleX:randomScale,
                    scaleY:randomScale,
					ease:Elastic.easeInOut,         //easing function,
                    onComplete:function(){
                        // todo, dispose mc
                        removeChild(image_mc);
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
            }
            else if(re.Is16by9()){
                // 16:9
                divided = currentRatio * 9 / 16.0;
            } else {
                // 16:10
                divided = currentRatio * 10 / 16.0;
            }
                            
            var correctedRatio:Number =  re.ScreenHeight / originalHeight * divided;
                    
            this.scaleX = correctedRatio;
            this.scaleY = correctedRatio;
        }
    }
}
