﻿package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import Globals;
	
	public class Room extends MovieClip {
		
		public var id : int;
		var destroyed : Boolean = false;
		var type : String;
		var characters : Array = []
		
		
		public function Room(id : int = -1, type : String = "regular") 
		{
			this.id = id;
			this.type = type;			
			
			//highlighting
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);			
			
			//for putting draggable players into rooms
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseOver(e:MouseEvent)
		{
			gotoAndStop(2);
		}
		
		private function onMouseOut(e:MouseEvent)
		{
			gotoAndStop(1);
			
			if(Globals.draggableCharacter != null)
				characters.splice(characters.indexOf(Globals.draggableCharacter as Player), 1);
		}
		
		//undrags the player and puts it into the room
		private function onMouseUp(event : MouseEvent)
		{
			var draggableCharacter = Globals.draggableCharacter as Player;
			
			if(draggableCharacter != null)
			{
				draggableCharacter.alreadyActed = true;
				draggableCharacter.stopDrag();
				draggableCharacter.mouseEnabled = true;
			    
				putIn(draggableCharacter);
			    Globals.draggableCharacter = null;
			}	
			
			resetReachableRoomsColoring();
			
		}
		
		private function resetReachableRoomsColoring()
		{
			for (var i:int = 0; i < Globals.rooms.length; i++)
			{
				if (Globals.rooms[i] != this)
					Globals.rooms[i].gotoAndStop(1);
			}
		}
		
		public function putIn(character:MovieClip)
		{			
			characters.push(character);
			character.currentRoom = this;
			
			if (this is Room7)
				positionInCorridor7(character, this); 
			else if (this is Room8)
				positionInCorridor8(character, this); 
			else
				positionInRoom(character, this);
			
		}
		
		// puts a character at a random location within a specified room
		private function positionInRoom(whom : MovieClip, where : MovieClip)
		{							
			var offset_x = Math.pow(-1, Math.round(Math.random() + 1)) * Math.random() * where.width / 2;
			var correction_x = offset_x < 0 ? whom.width / 2 : - whom.width / 2
								
			whom.x = where.x + offset_x + correction_x;			
			
			var offset_y = Math.pow(-1, Math.round(Math.random() + 1)) * Math.random() * where.height / 2;
			var correction_y = offset_y < 0 ? whom.height / 2 : - whom.height / 2
			
			whom.y = where.y + offset_y + correction_y;	
		}
		
		private function positionInCorridor7(whom : MovieClip, where : MovieClip)
		{
			const wideness = 39.25;
			var offset_x = 0;
			var offset_y = 0;
			var correction_x = 0;
			var correction_y = 0;
			
			//to ensure iid of the character distribution between the two parts of the corridor
			if(Math.random() >= 0.5)
			{
				//pick an x
				offset_x = Math.random() * where.width;	
				
				//x floor
				//correction_x = (offset_x - where.x) < whom.width / 2 ? whom.width / 2 : correction_x;
				
				//choose an y restricted to chosen x
				if (offset_x < wideness)
				{
					offset_y = Math.random() * where.height;
					
					// x ceil at the little adjacent corridor
					//correction_x = (wideness - offset_x) < whom.width / 2 ? whom.width / 2 : correction_x
				}
				else 
				{
					offset_y = Math.random() * wideness;		
					
					//x ceil
					//correction_x = (where.x - offset_x) < whom.width / 2 ? whom.width / 2 : correction_x;
				}
			}
			
			else
			{
				//pick an y
				offset_y = Math.random() * where.height;						
				
				//choose an x restricted to chosen y
				if (offset_y < wideness)
					offset_x = Math.random() * where.width;
				else 
					offset_x = Math.random() * wideness;	
			}
			
			whom.x = where.x + offset_x;	
			whom.y = where.y + offset_y;
		}
		
		private function positionInCorridor8(whom : MovieClip, where : MovieClip)
		{
			const wideness = 39.25;
			var offset_x = 0;
			var offset_y = 0;
			
			//to ensure iid of the character distribution between the two parts of the corridor
			if(Math.random() >= 0.5)
			{
				//pick an x
				offset_x = Math.random() * where.width;	
				
				//choose an y restricted to chosen x
				if (offset_x < wideness)
				{
					offset_y = Math.random() * where.height;
				}
				else 
				{
					offset_y = Math.random() * wideness;		
				}
			}
			
			else
			{
				//pick an y
				offset_y = Math.random() * where.height;						
				
				//choose an x restricted to chosen y
				if (offset_y < wideness)
					offset_x = Math.random() * where.width;
				else 
					offset_x = Math.random() * wideness;	
			}
			
			whom.x = where.x - offset_x;	
			whom.y = where.y - offset_y;
		}
	}
	
}
