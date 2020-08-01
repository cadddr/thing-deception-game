﻿package  {

	import flash.display.MovieClip;
	import ui.LevelSelectionScreen;
	import flash.events.Event;
	import fl.VirtualCamera;
	import asciiRooms.AsciiWallTile;
	import flash.system.Security;

	//todo: hovering players can be underneath other objects
	//todo: players can plant bombs to the rooms there are not in
	public class ThingApp extends MovieClip {
		var camera: VirtualCamera;
		var cameraLayer: MovieClip;
		var cameraLayer2: MovieClip;
	
		public function ThingApp() {
			camera = VirtualCamera.getCamera(root)
			cameraLayer = MovieClip(getChildByName("Layer_1"));
			cameraLayer2 = MovieClip(getChildByName("Layer_2"));

			stage.addChild(new LevelSelectionScreen(camera, cameraLayer, cameraLayer2));
		}
	}

}
