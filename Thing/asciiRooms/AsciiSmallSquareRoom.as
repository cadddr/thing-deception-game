﻿package asciiRooms {
	
	import flash.display.MovieClip;
	import rooms.Room;
	import characters.*;
	import flash.events.*;
	import items.AsciiGeneratorSwitch;
	import flash.geom.ColorTransform;
	import GlobalState;
	import asciiRooms.AsciiTile;
	import flash.events.MouseEvent;
	
	
	public class AsciiSmallSquareRoom extends Room {
		var tileWidth = 25;
		var tileHeight = 40.25;
		
		public function AsciiSmallSquareRoom() {

			addEventListener(MouseEvent.MOUSE_MOVE, interactOnMouseMove);
		}

		protected function interactOnMouseMove(e:MouseEvent) {
			for(var i:int = 0; i < numChildren; i++) {
				var child = getChildAt(i);
				if (child is AsciiWallTile) {
					child.applyLighting(e.stageX, e.stageY);
				}
			}
			for(var i:int = 0; i < asciiFloor.numChildren; i++) {
				var child = asciiFloor.getChildAt(i);
				if (child is AsciiFloorTile) {
					child.applyLighting(e.stageX, e.stageY);
				}
			}
		}
		
		override protected function computePositionInRoom(whomX: Number, whomY: Number, whomW: Number, whomH: Number): Array {
			if (whomX - this.x < tileWidth || whomY - this.y < tileHeight) {
				whomX = this.x + tileWidth + Math.floor(Math.random() * (this.width - 2 * tileWidth));
				whomY = this.y + tileHeight + Math.floor(Math.random() * (this.height - 2 * tileHeight));
			}
			
			//this assumes room positions are snapped to tile grid
			return [whomX - whomX % tileWidth, whomY - whomY % tileHeight];
		}

		override protected function interactOnMouseUp(event: MouseEvent): void {}

		//undrags the player and puts it into the room
		override protected function interactOnMouseClick(event: MouseEvent): void {
			trace("on mouse click", this);
			if (IsReachable) {
				var draggableCharacter = GlobalState.draggableCharacter;

				if (draggableCharacter != null) {
					draggableCharacter.finalizeAction();
					// draggableCharacter.x = event.stageX
					// draggableCharacter.y = ;
					putIn(draggableCharacter, event.stageX, event.stageY);

				}

				highlightReachableRooms(false);
			}
		}

		override protected function interactOnMouseOver(e: MouseEvent): void {
			if (GlobalState.draggableCharacter) {
				if (IsReachable) {
					highlightSelected();
				} else {
					highlightRestricted();
				}
			}
		}

		override public function unhighlight() {
			// asciiFloor.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 31, 64, 104);
		}

		override public function highlightSelected() {
			// asciiFloor.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 255, 255);
		}

		override public function highlightReachable() {
			// asciiFloor.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 242, 175, 101);
		}

		override public function highlightRestricted() {
			// asciiFloor.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 228, 63, 90);
		}
	}
}
