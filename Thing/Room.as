﻿package 
{
	import flash.display.MovieClip;
	import flash.events.*;
	import GlobalState;
	import Character;
	import flash.utils.*;

	public class Room extends MovieClip
	{
		protected var guests:Array = [];
		
		public var accessibleRooms:Array = [];
		public var adjacentRooms:Array = [];
		
		protected var isReachable:Boolean = false;
		
		public function get IsReachable():Boolean
		{
			return isReachable;
		}
		
		public function set IsReachable(value:Boolean)
		{
			isReachable = value;
			
			if(value)
			{
				highlightReachable();
			}
			else
			{
				unhighlight();
			}
		}
		
		public function get Things():Array
		{
			return guests.filter(function(item:*) {return item is Thing});
		}
		
		public function get Players():Array
		{
			return guests.filter(function(item:*) {return item is Player});
		}
		
		public function get InfectedPlayers():Array
		{
			return Players.filter(function(item:*) {return item.IsInfected});
		}

		public function get NonInfectedPlayers()
		{
			return Players.filter(function(item:*){return !item.IsInfected});
		}
		
		//tells how much the things are outnumbered by non-things
		public function get NonInfectedPlayerMargin():int
		{			
			return NonInfectedPlayers.length - Things.length - InfectedPlayers.length;
		}
		
		protected function get VisibleGuests()
		{
			return guests.filter(function(guest:*) {return guest.IsVisible});
		}
		
		public function getRoommates(player:Player)
		{
			return Players.filter(function(item:*){return item != player});
		}
		
		public function get IsTakenOver():Boolean
		{
			return NonInfectedPlayerMargin <= 0;
		}
		
		public function get VisibleThings()
		{
			return Things.filter(function(item:*) {return item.isVisible});
		}

		public function Room()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		
		}
		
		protected function onAddedToStage(e:Event)
		{
			//highlighting
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			//for putting draggable players into rooms
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function onMouseOver(e:MouseEvent)
		{
			if (!GlobalState.draggableCharacter || IsReachable)
			{
				highlightSelected();
			}
			else
			{
				highlightRestricted();
			}
		}

		private function onMouseOut(e:MouseEvent)
		{
			if (IsReachable)
			{
				highlightReachable();
			}
			else
			{
				unhighlight();
			}
		}

		//undrags the player and puts it into the room
		private function onMouseUp(event : MouseEvent)
		{
			if (IsReachable)
			{
				var draggableCharacter = GlobalState.draggableCharacter;

				if (draggableCharacter != null)
				{
					draggableCharacter.finalizeAction();
					putIn(draggableCharacter);
				}
				highlightReachableRooms(false);
			}
		}

		public function unhighlight()
		{
			gotoAndStop(1);
		}

		public function highlightSelected()
		{
			gotoAndStop(2);
		}

		public function highlightReachable()
		{
			gotoAndStop(3);
		}

		public function highlightRestricted()
		{
			gotoAndStop(4);
		}

		public function highlightReachableRooms(shouldHighlight:Boolean) 
		{			
			accessibleRooms.forEach(function(room:*) 
									{
										room.IsReachable = shouldHighlight;
									});
		}

		public function putIn(character:Character)
		{
			register(character);
			
			moveSmoothly(character, computePositionInRoom(character));
		}
		
		public function register(character:Character)
		{
			highlightReachableRooms(false);
			
			//leave previous room
			character.leaveRoom();

			guests.push(character);
			character.currentRoom = this;
			
			Things.forEach(function(thing:*){thing.refreshVisibility()});			
		}
		
		// puts a character at a random location within a room
		protected function computePositionInRoom(whom:Character):Array
		{			
			var margin = 0;
			
			var destinationX = whom.x;
			var destinationY = whom.y;
			
			var semiWidth = whom.width / 2;
			
			if(whom is Player)
				semiWidth = (whom as Player).body.width / 2;
				
			var semiWallWidth = width / 2;
			
			var rightmostX = destinationX + semiWidth;
			var rightmostWallX = x + semiWallWidth;
			
			
			if (rightmostX > rightmostWallX)
			{
				trace("Exceeds width");
				destinationX -= rightmostX - rightmostWallX - margin;
			}
			
			var leftmostX = destinationX - semiWidth;
			var leftmostWallX = x - semiWallWidth;
			
			if (leftmostX < leftmostWallX)
			{
				
				
				stage.addChild(Utils.createPoint(leftmostWallX, -1, 0));
				trace("Unexceeds width. dest=", destinationX, "leftX=", leftmostX, "leftWallX=",leftmostWallX);
				destinationX += leftmostWallX - leftmostX + margin;
				stage.addChild(Utils.createPoint(destinationX - semiWidth));
				
				
				trace(destinationX);
			}
			
			var topmostY = destinationY - whom.scaleY * whom.height / 2;
			var topmostWallY = y - scaleY * height / 2;
			if (topmostY < topmostWallY)
			{
				trace("Exceeds height", scaleY);
				destinationY += topmostWallY - topmostY;
			}
			
			var bottommostY = destinationY + whom.scaleY * whom.height / 2;
			var bottommostWallY = y + scaleY * height / 2;
			if(bottommostY > bottommostWallY)
			{
				trace("Unexceeds height");
				destinationY -= bottommostY - bottommostWallY;
			}
			
			
			/*
			var offset_x = Math.pow(-1, Math.round(Math.random() + 1)) * Math.random() * width / 2;
			var correction_x = offset_x < 0 ? whom.width / 2: -  whom.width / 2;
			var destinationX = x + offset_x + correction_x;

			var offset_y = Math.pow(-1, Math.round(Math.random() + 1)) * Math.random() * height / 2;
			var correction_y = offset_y < 0 ? whom.height / 2: -  whom.height / 2;
			var destinationY = y + offset_y + correction_y;
			*/
			
			
			
			return [destinationX, destinationY];			
		}		
		
		protected function moveSmoothly(whom:MovieClip, destination:Array)
		{
			var destinationX = destination[0];
			var destinationY = destination[1];

			var numSteps = 10;
			var stepX = (destinationX - whom.x) / numSteps;
			var stepY = (destinationY - whom.y) / numSteps;
			const epsilon = 10;
			
			var motionInterval = setInterval(function(whom:*) 
											 {
												 if(Math.abs(whom.x - destinationX) > epsilon)
												 {
													 whom.x += stepX;
												 }
													
												 if(Math.abs(whom.y - destinationY) > epsilon)
												 {
													 whom.y += stepY
												 }
													
												 if(Math.abs(whom.x - destinationX) <= epsilon 
													&& Math.abs(whom.y - destinationY) <= epsilon)
												 {
													 clearInterval(motionInterval);
												 }
													
											 }, 10,
											 whom);
			
		}
		
		public function getOut(character:Character)
		{
			var characterIndex = guests.indexOf(character);
			guests.splice(characterIndex, 1);
			
			Things.forEach(function(thing:*){thing.refreshVisibility()});
		}
		
		public function killGuests()
		{
			//cloning to avoid mutability problems
			var tempChars = guests.concat();
			tempChars.forEach(function(item:*) {item.die()});
		}
		
		public function revealInfectedPlayers()
		{
			guests.forEach(function(item:*) {if (item is Player) item.revealItself()});
		}

		
	}
}