package base;

import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.Lib;

class StateMachine extends State {
  var stateContainer: GameSprite = new GameSprite();
  var current: State;
  var inTransition: Bool = false;
  var lastTime: Null<Float> = null;
  var rootMachine: Bool = true;

  public function new(?rootMachine: Bool = true) {
    super();
    this.rootMachine = rootMachine;

    addChild(stateContainer);

    addEventListener(Event.ENTER_FRAME, onEnterFrame);
    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
  }

  function onKeyDown(e: KeyboardEvent) {
    if(current != null) {
      current.keyDown(e.keyCode, e.ctrlKey, e.altKey, e.shiftKey);
    }
  }

  function onKeyUp(e: KeyboardEvent) {
    if(current != null) {
      current.keyUp(e.keyCode, e.ctrlKey, e.altKey, e.shiftKey);
    }
  }

  public function setState(state: State, immidiate: Bool = true) {
    if(current != null) {
      current.leave();
      current.machine = null;
      stateContainer.removeChild(current);
    }
    current = state;
    stateContainer.addChild(current);
    current.machine = this;
    current.enter();
  }

  function onAddedToStage(e: Event) {
    if(rootMachine) {
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }
  }

  function onRemovedFromStage(e: Event) {
    if(rootMachine) {
      stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }
  }

  function onEnterFrame(e: Event) {
    if(rootMachine) {
      var currentTime: Int = Lib.getTimer();

      if(lastTime != null) {
        var delta:Float = (currentTime - lastTime) / 1000;
        stateContainer.update(delta);
      }

      lastTime = currentTime;  
    }
  }
}
