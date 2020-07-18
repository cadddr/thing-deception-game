﻿package asciiRooms {
	
	import flash.display.MovieClip;
	import rooms.*
	
	public class AsciiGeneratorRoom extends AsciiSmallSquareRoom implements GeneratorRoomInterface {
		
		
		
		public function AsciiGeneratorRoom() {
			asciiFloor = new AsciiFloor();
		}
		
		public function getLightSwitch(): MovieClip {
			return asciiLightSwitch;
		}
	}
	
}
