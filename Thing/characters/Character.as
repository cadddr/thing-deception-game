﻿package characters {
	import flash.display.MovieClip;
	import GlobalState;
	import rooms.Room;
	import characters.Interactable;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
    import fl.transitions.easing.*;
	import asciiRooms.AsciiRoomBase;
	import fl.VirtualCamera;
	import flash.geom.Point;
	import rooms.RoomBase;
	
	public class Character extends Interactable {
		
		public var policy:Function = null;
		public var currentRoom: RoomBase = null;
		public var previousRoom: RoomBase = null;
		
		public var isDead:Boolean = false;

		private var camera: VirtualCamera;
		public var cameraLayer: MovieClip;

		public function setCameraAndLayer(camera: VirtualCamera, cameraLayer: MovieClip): void {
			this.camera = camera;
			this.cameraLayer = cameraLayer;
		}

		public function set IsVisible(value:Boolean)
		{
			if(value)
				alpha = 1;
			else if(GlobalState.DEBUG)
				alpha = 0.3;
		}

		protected function get ReachableRooms():Array
		{
			return currentRoom.accessibleRooms;
		}
		
		protected function dieAnimation() {}	
		
		public function act()
		{
			if (!isDead)
			{
				if(policy != null)
					{
						policy();
					}
			}
		}

		var tweenX: Tween;
		var tweenY: Tween;

		public function moveTo(x:Number, y:Number) {
			if (camera != null) {
				camera.pinCameraToObject(this);
			}

			gotoAndPlay(1);

			tweenX = new Tween(this, "x", Strong.easeInOut, this.x, x, 1, true);
			tweenY = new Tween(this, "y", Strong.easeInOut, this.y, y, 1, true);

			tweenX.addEventListener(TweenEvent.MOTION_CHANGE, function(e:TweenEvent) {
				// trace("x", e.position);
				if (currentRoom)
				{AsciiRoomBase(currentRoom).applyTileLightingFromSource(currentRoom, e.position, y);}
			})

			tweenY.addEventListener(TweenEvent.MOTION_CHANGE, function(e:TweenEvent) {

				// trace("y", e.position)
				if (currentRoom)
				{AsciiRoomBase(currentRoom).applyTileLightingFromSource(currentRoom, x, e.position);}
			})

			var helper: Function = function (first: Tween, second: Tween): void {
				second.stop();
				first.addEventListener(TweenEvent.MOTION_FINISH, function(e:TweenEvent): void {second.start();});

				second.addEventListener(TweenEvent.MOTION_FINISH, function(e:TweenEvent) {stop();});
			}

			if (Math.abs(x - this.x) > Math.abs(y - this.y)) {helper(tweenX, tweenY);}
			else {helper(tweenY, tweenX);}

			// this.x=x;
			// this.y=y;
		}	
		
		public function enterRoom(room: RoomBase) {
            this.currentRoom = room;
            room.admitCharacter(this);
        }

        public function leaveRoom() {
            //leave previous room & refresh visibility
			if (this.currentRoom)
			{
				this.previousRoom = this.currentRoom;		
				this.currentRoom.releaseCharacter(this)
                this.currentRoom = null;
			}
        }

		public function die()
		{
			leaveRoom();
		}
	}
}
