package io.arkeus.ouya {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.GameInput;
	import flash.ui.GameInputDevice;
	import flash.ui.Keyboard;
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

		public static function initialize(stage:DisplayObject):void {
			gameInput = new GameInput;
			gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, onDeviceAttached);
			gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, onDeviceDetached);

			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

			for (var i:uint = 0; i < GameInput.numDevices; i++) {
				attach(GameInput.getDeviceAt(i));
			}
		}

		public static function controller(index:uint):GameController {
			return controllers[index];
		}

		public static function hasReadyController():Boolean {
			return readyControllers.length > 0;
		}

		public static function getReadyController():GameController {
			var readyController:GameController = readyControllers.shift();
			readyController.enable();
			controllers.push(readyController);
			return readyController;
		}

		public static function hasRemovedController():Boolean {
			return removedControllers.length > 0;
		}

		public static function getRemovedController():GameController {
			var removedController:GameController = removedControllers.shift();
			removedController.disable();
			return removedController;
		}

		private static function onDeviceAttached(event:GameInputEvent):void {
			attach(event.device);
		}

		private static function attach(device:GameInputDevice):void {
			if (device == null) {
				return;
			}
			var controllerClass:Class = parseControllerType(device.name);
			if (controllerClass == null) {
				// Unknown device
				return;
			}
			readyControllers.push(new controllerClass(device));
		}

		private static function onDeviceDetached(event:GameInputEvent):void {
			detach(event.device);
		}

		private static function detach(device:GameInputDevice):void {
			if (device == null) {
				return;
			}
			var detachedController:GameController = findAndRemoveDevice(controllers, device) || findAndRemoveDevice(readyControllers, device);
			if (detachedController == null) {
				return;
			}
			detachedController.remove();
			removedControllers.push(detachedController);
		}

		private static function findAndRemoveDevice(source:Vector.<GameController>, target:GameInputDevice):GameController {
			var result:GameController = null;
			for each (var controller:GameController in source) {
				if (controller.device == target) {
					result = controller;
					break;
				}
			}

			if (result != null) {
				source.splice(source.indexOf(result), 1);
				return result;
			}

			return null;
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

			return null;
		}

		private static function onKeyDown(event:KeyboardEvent):void {
			if (event.keyCode == 27 || event.keyCode == Keyboard.BACK) {
				event.preventDefault();
			}
		}
	}
}
