package io.arkeus.ouya {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import flash.ui.GameInput;
	import flash.ui.GameInputDevice;
	import flash.utils.getTimer;
	
	import io.arkeus.ouya.controller.GameController;
	import io.arkeus.ouya.controller.OuyaController;
	import io.arkeus.ouya.controller.Xbox360Controller;

	public class ControllerInput {
		private static var controllers:Vector.<GameController> = new Vector.<GameController>;
		private static var readyControllers:Vector.<GameController> = new Vector.<GameController>;
		private static var removedControllers:Vector.<GameController> = new Vector.<GameController>;
		private static var gameInput:GameInput;
		
		public static var now:uint = getTimer();
		public static var previous:uint = now;
		
		public static var errors:Array = [];
		
		public static function initialize(stage:DisplayObject):void {
			gameInput = new GameInput;
			gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, onDeviceAttached);
			gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, onDeviceDetached);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent):void { errors.push("KEY:" + event.keyCode); });
			
			errors.push("Already connected: " + GameInput.numDevices);
			for (var i:uint = 0; i < GameInput.numDevices; i++) {
				attach(GameInput.getDeviceAt(i));
			}
		}
		
		public static function controller(index:uint):GameController {
			return controllers[index];
		}
		
		public static function hasControllerReady():Boolean {
			return readyControllers.length > 0;
		}
		
		public static function enableReadyController():GameController {
			var readyController:GameController = readyControllers.shift();
			readyController.enable();
			controllers.push(readyController);
			return readyController;
		}
		
		private static function onDeviceAttached(event:GameInputEvent):void {
			trace("DEVICE ATTACHED: " + event.device.name);
			attach(event.device);
		}
		
		private static function attach(device:GameInputDevice):void {
			if (device == null) {
				return;
			}
			var controllerClass:Class = parseControllerType(device.name);
			readyControllers.push(new controllerClass(device));
		}
		
		private static function onDeviceDetached(event:GameInputEvent):void {
			
		}
		
		private static function onEnterFrame(event:Event):void {
			previous = now;
			now = getTimer();
		}
		
		private static function parseControllerType(name:String):Class {
			if (name.toLowerCase().indexOf("xbox 360") != -1) {
				return Xbox360Controller;
			} else if (name.toLowerCase().indexOf("ouya") != -1) {
				return OuyaController;
			}
			
			throw new ArgumentError("Unknown device name found: " + name);
		}
	}
}
