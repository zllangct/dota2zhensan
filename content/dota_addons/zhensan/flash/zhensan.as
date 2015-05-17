package  {
    
    // Valve Libaries
    import ValveLib.Globals;
    import ValveLib.ResizeManager;
    import flash.events.MouseEvent;
    import flash.display.MovieClip;
    import flash.utils.getDefinitionByName;

    import com.greensock.TweenLite;
    import com.greensock.easing.*;

    public class zhensan extends MovieClip {
        // Game API related stuff
        public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
        public var correctedRatio:Number;

		var tg:Number = 0;

        public function zhensan():void{
            trace("zhensan");
        }

        public function onLoaded() : void {
			visible=true;
			this.list_1.visible=false;
            Globals.instance.resizeManager.AddListener(this);
            this.function_butten_1.visible=true;
			this.function_butten_1.addEventListener(MouseEvent.CLICK,onfunction_butten_click);
			this.addFrameScript(0, this.frame1);
        }
		public function frame1():void{
			this.list_1.yuanjun_butten.addEventListener(MouseEvent.CLICK,yuanjun_butten_click);
			this.list_1.toushi_butten.addEventListener(MouseEvent.CLICK,toushi_butten_click);
			this.list_1.guojiu_butten.addEventListener(MouseEvent.CLICK,guojiu_butten_click);
			this.list_1.baozi_butten.addEventListener(MouseEvent.CLICK,baozi_butten_click);
			this.list_1.shanglu_butten.addEventListener(MouseEvent.CLICK,shanglu_butten_click);
			this.list_1.zhonglu_butten.addEventListener(MouseEvent.CLICK,zhonglu_butten_click);
			this.list_1.xialu_butten.addEventListener(MouseEvent.CLICK,xialu_butten_click);
			
			//////////////////////////////鼠标提示事件
			this.list_1.yuanjun_butten.addEventListener(MouseEvent.MOUSE_OVER,yuanjun_butten_RollOver);
			this.list_1.toushi_butten.addEventListener(MouseEvent.MOUSE_OVER,toushi_butten_RollOver);
			this.list_1.guojiu_butten.addEventListener(MouseEvent.MOUSE_OVER,guojiu_butten_RollOver);
			this.list_1.baozi_butten.addEventListener(MouseEvent.MOUSE_OVER,baozi_butten_RollOver);
			this.list_1.shanglu_butten.addEventListener(MouseEvent.MOUSE_OVER,shanglu_butten_RollOver);
			this.list_1.zhonglu_butten.addEventListener(MouseEvent.MOUSE_OVER,zhonglu_butten_RollOver);
			this.list_1.xialu_butten.addEventListener(MouseEvent.MOUSE_OVER,xialu_butten_RollOver);
			
			this.list_1.yuanjun_butten.addEventListener(MouseEvent.MOUSE_OUT,yuanjun_butten_RollOut);
			this.list_1.toushi_butten.addEventListener(MouseEvent.MOUSE_OUT,toushi_butten_RollOut);
			this.list_1.guojiu_butten.addEventListener(MouseEvent.MOUSE_OUT,guojiu_butten_RollOut);
			this.list_1.baozi_butten.addEventListener(MouseEvent.MOUSE_OUT,baozi_butten_RollOut);
			this.list_1.shanglu_butten.addEventListener(MouseEvent.MOUSE_OUT,shanglu_butten_RollOut);
			this.list_1.zhonglu_butten.addEventListener(MouseEvent.MOUSE_OUT,zhonglu_butten_RollOut);
			this.list_1.xialu_butten.addEventListener(MouseEvent.MOUSE_OUT,xialu_butten_RollOut);
		}
			
	///////////////////////////////////////////////////////////功能事件
	    //援军
		public function yuanjun_butten_click(dd:MouseEvent):void
		{
			this.gameAPI.SendServerCommand("LeftWalking");
	    }
		//投石车 
		public function toushi_butten_click(dd:MouseEvent):void
		{
			this.gameAPI.SendServerCommand("BuyTouShiChe");
			trace("toushiche success !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	    }
		//果酒 
		public function guojiu_butten_click(dd:MouseEvent):void
		{
			this.gameAPI.SendServerCommand("UseGuoJiu");
	    }
		//包子 
		public function baozi_butten_click(dd:MouseEvent):void
		{
			this.gameAPI.SendServerCommand("UseBaoZi");
	    }
		//上路 
		public function shanglu_butten_click(dd:MouseEvent):void
		{
			this.gameAPI.SendServerCommand("chubing_shanglu");
	    }
		//中路 
		public function zhonglu_butten_click(dd:MouseEvent):void
		{
			this.gameAPI.SendServerCommand("chubing_zhonglu");
	    }
		//下路
		public function xialu_butten_click(dd:MouseEvent):void
		{
			this.gameAPI.SendServerCommand("chubing_xialu");
	    }
	///////////////////////////////////////////////////////////控件事件
		public function onfunction_butten_click(dd:MouseEvent):void
		{
			trace("about");
			this.list_1.dialogString.text="";
			if(tg==0){			
				this.list_1.visible=true;
				this.tg=1;
			}else{
				this.list_1.visible=false;
				this.tg=0;
				
			}
	    }
		 //援军
		public function yuanjun_butten_RollOver(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="用金钱和木材做交换，获得吴国的援军支援!";
	    }
		//投石车 
		public function toushi_butten_RollOver(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="购买一辆投石车，出现在离你最近的据点或者温泉旁边.";
	    }
		//果酒 
		public function guojiu_butten_RollOver(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="获得一瓶果酒，恢复一定的魔法值！";
	    }
		//包子 
		public function baozi_butten_RollOver(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="获得一个包子，恢复一定的血量！";
	    }
		//上路 
		public function shanglu_butten_RollOver(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="上路紧急征召一波士兵！";
	    }
		//中路 
		public function zhonglu_butten_RollOver(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="中路紧急征召一波士兵！";
	    }
		//下路
		public function xialu_butten_RollOver(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="下路紧急征召一波士兵！";
	    }
		/////////////////////
		 //援军
		public function yuanjun_butten_RollOut(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="";
	    }
		//投石车 
		public function toushi_butten_RollOut(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="";
	    }
		//果酒 
		public function guojiu_butten_RollOut(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="";
	    }
		//包子 
		public function baozi_butten_RollOut(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="";
	    }
		//上路 
		public function shanglu_butten_RollOut(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="";
	    }
		//中路 
		public function zhonglu_butten_RollOut(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="";
	    }
		//下路
		public function xialu_butten_RollOut(dd:MouseEvent):void
		{
			this.list_1.dialogString.text="";
	    }
		
	///////////////////////////////////////////////////////RESIZE事件
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
				this.function_butten_1.x=re.ScreenWidth*1.3;
				this.function_butten_1.y=this.function_butten_1.y*1;
				this.list_1.x=re.ScreenWidth*1.1;
				this.list_1.y=re.ScreenHeight*0.1+4;
            }
            else if(re.Is16by9()){
                // 16:9
                divided = currentRatio * 9 / 16.0;
				correctedRatio =  re.ScreenHeight / originalHeight * divided;
                this.scaleX = correctedRatio;
			    this.scaleY = correctedRatio;
	            //this.list_1.x=re.ScreenWidth*1.5;
				//this.function_butten_1.x=re.ScreenWidth*1.5;
            } else {
                // 16:10
                divided = currentRatio * 10 / 16.0;
				correctedRatio =  re.ScreenHeight / originalHeight * divided;
                this.scaleX = correctedRatio;
			    this.scaleY = correctedRatio; 
				this.list_1.x=re.ScreenWidth*2.23;
				this.function_butten_1.x=re.ScreenWidth*2.55;
            }           
        }
    }
}
