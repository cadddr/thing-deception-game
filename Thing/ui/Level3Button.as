﻿package ui {
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import levels.Level3;
	
	
	public class Level3Button extends SimpleButton {
		
		public function Level3Button() {
			this.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
					stage.addChild(new Level3());
			});
		}
	}
}