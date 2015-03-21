package
{
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;
     
    public class ImageLoader extends MovieClip
    {
         
        private var loader:Loader;
        private var w:Number;
        private var h:Number;
         
        public function ImageLoader(url:String)
        {
            super();
             
            this.w = 1920;
            this.h = 1080;
             
            loader = new Loader();
             
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
             
            loader.load(new URLRequest(url));
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
            trace("image loader created, trying to load image named: " + url);
            trace(loader);
        }
         
        private function progressHandler(e:ProgressEvent):void {
            var num:uint = (e.bytesLoaded / e.bytesTotal) * 100;
            trace('已加载--' + num + "%");
        }
         
        private function completeHandler(e:Event):void {
            var loader:Loader = Loader(e.target.loader);
            var bitmap:Bitmap = Bitmap(loader.content);
             
//          var bitmap:Bitmap = e.currentTarget.content as Bitmap;
//          trace(bitmap);
             
            trace(bitmap.width + '--' + bitmap.height);
 
            bitmap.x = 0;
            bitmap.y = 0;
             
            this.addChild(bitmap);
        }
    }
}