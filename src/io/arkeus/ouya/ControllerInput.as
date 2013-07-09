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

	/**
	 * A class for reading input from controllers. Allows you to pull ready controllers from a queue
	 * of controllers that have been initialized, to allow input from as many controllers as you need.
	 */
	public class ControllerInput {
		private static var controllers:Vector.<GameController> = new Vector.<GameController>;
		private static var readyControllers:Vector.<GameController> = new Vector.<GameController>;
		private static var removedControllers:Vector.<GameController> = new Vector.<GameController>;
		private static var gameInput:GameInput;

		public static var now:uint = getTimer();
		public static var previous:uint = now;

		/**
		 * Initializes the library, adding event listeners as needed. The passed stage is used to add event
		 * listeners for entering frame and for keyboard events.
		 * 
		 * @param stage A reference to the root flash stage.
		 */
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

		/**
		 * Returns the active controller with the passed index.
		 * 
		 * @param index The index of the controller to grab.
		 * @return An active controller.
		 */
		public static function controller(index:uint):GameController {
			return controllers[index];
		}

		/**
		 * Returns whether or not there is a controller that is ready to be polled for input.
		 * 
		 * @return Whether there is a ready controller or not.
		 */
		public static function hasReadyController():Boolean {
			return readyControllers.length > 0;
		}

		/**
		 * Returns a ready controller and activates it (allowing it to be polled for input). This moves the
		 * controller from the "ready controllers" queue to the list of active "controllers".
		 * 
		 * @return The controller, now in a ready state.
		 */
		public static function getReadyController():GameController {
			var readyController:GameController = readyControllers.shift();
			readyController.enable();
			controllers.push(readyController);
			return readyController;
		}

		/**
		 * Returns whether or not one of the currently used controllers has been disconnected. You can check this
		 * queue in order to handle this case gracefully. Also, you can check if the "removed" property of the
		 * controller is true, which also signifies that the controller has been detached from the system and can
		 * no longer be read for input.
		 * 
		 * @return Whether or not there is a detached controller.
		 */
		public static function hasRemovedController():Boolean {
			return removedControllers.length > 0;
		}

		/**
		 * Similar to reading a newly ready controller, this allows you to read a removed controller and handle it
		 * however you'd like.
		 * 
		 * @return The removed controller.
		 */
		public static function getRemovedController():GameController {
			var removedController:GameController = removedControllers.shift();
			removedController.disable();
			return removedController;
		}

		/**
		 * Callback when a device is attached.
		 * 
		 * @param event The GameInputEvent containing the attached deviced.
		 */
		private static function onDeviceAttached(event:GameInputEvent):void {
			attach(event.device);
		}

		/**
		 * Attaches a game device by creating a class that corresponds to the device type
		 * and adding it to the ready controllers list.
		 */
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

		/**
		 * Callback when a device is detached.
		 * 
		 * @param event The GameInputEvent containing the detached deviced.
		 */
		private static function onDeviceDetached(event:GameInputEvent):void {
			detach(event.device);
		}

		/**
		 * Detaches a device by setting the removed attribute to true, removing it from the controllers
		 * list, and adding to the removed controllers list.
		 */
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

		/**
		 * Helper method that takes a group and a target device, removes the device from the group
		 * and returns it. If the controller was not present in the group, returns null instead.
		 * 
		 * @param source The group to remove the controller from.
		 * @param target The game input device to remove and return.
		 * @return The removed controller corresponding to the device, or null if it wasn't present.
		 */
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
