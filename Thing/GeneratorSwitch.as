﻿package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.motion.MotionEvent;
	import GlobalState;
	import GenRoom;
	public class GeneratorSwitch extends MovieClip {
		
		
		public function GeneratorSwitch() 
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, highlight);
			this.addEventListener(MouseEvent.MOUSE_OUT, unhighlight);
			
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			myselection.gotoAndStop(1);
		}
		
		private function highlight(e:MouseEvent)
		{
			if(GlobalState.draggableCharacter 
			   && GlobalState.draggableCharacter.currentRoom is GenRoom)
				myselection.gotoAndPlay(1);
		}
		
		private function unhighlight(e:MouseEvent)
		{
			myselection.gotoAndStop(1);
		}
		
		private function onMouseUp(e:MouseEvent)
		{
			if(GlobalState.draggableCharacter)
				   if(GlobalState.draggableCharacter.currentRoom is GenRoom)
				   {
					   switchPower(true);
					   GlobalState.draggableCharacter.finalizeAction();
				   }
		}
		
		public function switchPower(switchOn:Boolean)
		{			
			   trace("Light has been switched to", switchOn ? "on": "off");
			   GlobalState.isLightOn = switchOn;
			   stage.color = int(switchOn) * 0xffffff;
		
			   GlobalState.things.forEach(function(item:*) {item.refreshVisibility()});  
			   
			   gotoAndStop(switchOn ? 1 : 2);
			   myselection.gotoAndStop(1);
		}
	}
	
}
