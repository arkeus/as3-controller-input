/**
 * Simple OUYA joypad class
 * Based on Adobe's official joypad examples
 *
 * Only works for one player, all attached joypads control the game
 *
 * HOW TO USE:
 * This is a static class, so it can be accessed from anywhere in your code.
 * Somewhere in your init function, call:
 *
 * joypad.init(stage);
 *
 * to set up the event listeners. Then anywhere else in code, you can check the following
 * boolean variables
 * joypad.STICK_LEFT (or RIGHT, UP, DOWN)
 * joypad.DPAD_LEFT (etc)
 * joypad.BUTTON_O (or U, Y, A, LEFT or RIGHT)
 *
 * There are also shortcut functions:
 * joypad.anybutton() (checks O, U, Y and A buttons)
 * joypad.pressup() (checks both stick up and dpad up, pressleft/right/down also work)
 *
 * For triggers, right stick, and other stuff, you're on your own
 *
 * Terry Cavanagh
 * distractionware.com
 *
 */

package io.arkeus.ouya.control {
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.ui.Keyboard;
	import flash.ui.GameInput;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	import flash.events.GameInputEvent;

	public class Controller {
		static private var dispObj:DisplayObject;

		static public var BUTTON_O:Boolean = false;
		static public var BUTTON_U:Boolean = false;
		static public var BUTTON_Y:Boolean = false;
		static public var BUTTON_A:Boolean = false;
		static public var BUTTON_LEFT:Boolean = false;
		static public var BUTTON_RIGHT:Boolean = false;
		static public var DPAD_UP:Boolean = false;
		static public var DPAD_DOWN:Boolean = false;
		static public var DPAD_LEFT:Boolean = false;
		static public var DPAD_RIGHT:Boolean = false;
		static public var STICK_UP:Boolean = false;
		static public var STICK_DOWN:Boolean = false;
		static public var STICK_LEFT:Boolean = false;
		static public var STICK_RIGHT:Boolean = false;

		static public var control:GameInputControl;

		static private var gameInput:GameInput;
		static private var _device:GameInputDevice;

		public static function init(obj:DisplayObject):void {
			dispObj = obj;
			dispObj.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true);

			gameInput = new GameInput();
			gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, handleDeviceAttached);
			gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, handleDeviceRemoved);
		}

		protected static function handleDeviceRemoved(event:GameInputEvent):void {
			trace("DETACHED", event);
		}

		public static function anybutton():Boolean {
			if (BUTTON_O || BUTTON_U || BUTTON_Y || BUTTON_A) {
				return true;
			}
			return false;
		}

		public static function pressup():Boolean {
			if (STICK_UP || DPAD_UP) {
				return true;
			}
			return false;
		}

		public static function pressdown():Boolean {
			if (STICK_DOWN || DPAD_DOWN) {
				return true;
			}
			return false;
		}

		public static function pressleft():Boolean {
			if (STICK_LEFT || DPAD_LEFT) {
				return true;
			}
			return false;
		}

		public static function pressright():Boolean {
			if (STICK_RIGHT || DPAD_RIGHT) {
				return true;
			}
			return false;
		}

		protected static function handleDeviceAttached(e:GameInputEvent):void {
			trace("ATTACHED", e);
			GameInputControlName.initialize(e.device);

			var i:int;

			for (var k:Number = 0; k < GameInput.numDevices; k++) {
				_device = GameInput.getDeviceAt(k);
				trace("FOUND DEVICE", _device, k);
				var _controls:Vector.<String> = new Vector.<String>;
				_device.enabled = true;

				for (i = 0; i < _device.numControls; i++) {
					control = _device.getControlAt(i);
					_controls[i] = control.id;
					
					trace("FOUND CONTROL", control.id, control.value);

					if (control.id == "AXIS_0") {
						control.addEventListener(Event.CHANGE, xaxisChangeHandler);
					}
					if (control.id == "AXIS_1") {
						control.addEventListener(Event.CHANGE, yaxisChangeHandler);
					}
					if (control.id == "BUTTON_96") {
						control.addEventListener(Event.CHANGE, buttonOChangeHandler);
					}
					if (control.id == "BUTTON_97") {
						control.addEventListener(Event.CHANGE, buttonAChangeHandler);
					}
					if (control.id == "BUTTON_99") {
						control.addEventListener(Event.CHANGE, buttonUChangeHandler);
					}
					if (control.id == "BUTTON_100") {
						control.addEventListener(Event.CHANGE, buttonYChangeHandler);
					}
					if (control.id == "BUTTON_102") {
						control.addEventListener(Event.CHANGE, buttonlefttriggerChangeHandler);
					}
					if (control.id == "BUTTON_103") {
						control.addEventListener(Event.CHANGE, buttonrighttriggerChangeHandler);
					}
					if (control.id == "BUTTON_19") {
						control.addEventListener(Event.CHANGE, buttondpadupChangeHandler);
					}
					if (control.id == "BUTTON_20") {
						control.addEventListener(Event.CHANGE, buttondpaddownChangeHandler);
					}
					if (control.id == "BUTTON_21") {
						control.addEventListener(Event.CHANGE, buttondpadleftChangeHandler);
					}
					if (control.id == "BUTTON_22") {
						control.addEventListener(Event.CHANGE, buttondpadrightChangeHandler);
					}
				}
			}
		}

		public static function buttondpadupChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value == 1) {
				DPAD_UP = true;
			}
			if (control.value == 0) {
				DPAD_UP = false;
			}
		}

		public static function buttondpaddownChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value == 1) {
				DPAD_DOWN = true;
			}
			if (control.value == 0) {
				DPAD_DOWN = false;
			}
		}

		public static function buttondpadleftChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value == 1) {
				DPAD_LEFT = true;
			}
			if (control.value == 0) {
				DPAD_LEFT = false;
			}
		}

		public static function buttondpadrightChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value == 1) {
				DPAD_RIGHT = true;
			}
			if (control.value == 0) {
				DPAD_RIGHT = false;
			}
		}

		public static function buttonlefttriggerChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value == 1) {
				BUTTON_LEFT = true;
			}
			if (control.value == 0) {
				BUTTON_LEFT = false;
			}
		}

		public static function buttonrighttriggerChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value == 1) {
				BUTTON_RIGHT = true;
			}
			if (control.value == 0) {
				BUTTON_RIGHT = false;
			}
		}

		public static function buttonOChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value == 1) {
				BUTTON_O = true;
			}
			if (control.value == 0) {
				BUTTON_O = false;
			}
		}

		public static function buttonUChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value == 1) {
				BUTTON_U = true;
			}
			if (control.value == 0) {
				BUTTON_U = false;
			}
		}

		public static function buttonYChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value == 1) {
				BUTTON_Y = true;
			}
			if (control.value == 0) {
				BUTTON_Y = false;
			}
		}

		public static function buttonAChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value == 1) {
				BUTTON_A = true;
			}
			if (control.value == 0) {
				BUTTON_A = false;
			}
		}

		public static function xaxisChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value < -0.5) {
				STICK_LEFT = true;
				STICK_RIGHT = false;
			} else if (control.value > 0.5) {
				STICK_LEFT = false;
				STICK_RIGHT = true;
			} else {
				STICK_LEFT = false;
				STICK_RIGHT = false;
			}
		}

		public static function yaxisChangeHandler(e:Event):void {
			control = e.target as GameInputControl;
			if (control.value < -0.5) {
				STICK_UP = false;
				STICK_DOWN = true;
			} else if (control.value > 0.5) {
				STICK_UP = true;
				STICK_DOWN = false;
			} else {
				STICK_UP = false;
				STICK_DOWN = false;
			}
		}

		private static function keyDownListener(ev:KeyboardEvent):void {
			if (ev.keyCode == 27) {
				ev.preventDefault();
			}
			if (ev.keyCode == Keyboard.BACK) {
				ev.preventDefault();
			}
		}
	}
}