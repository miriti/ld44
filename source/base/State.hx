package base;

import openfl.Assets;
import openfl.events.Event;
import openfl.Lib;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.ui.Keyboard;

typedef PlayingSoundDescriptor = {
  id: String,
  type: String,
  volume: Float,
  pan: Float,
  sound: Sound,
  channel: SoundChannel,
  position: Float,
  looping: Bool,
  playing: Bool
};

/**
 * TODO:
 * [ ] DRY: playMusic and playSound are essentially the same and can be merged into a single function
 */
class State extends GameSprite {
  public static var globalMute: Bool = false;

  public var mute(default, set): Bool = false;
  public var machine: StateMachine;

  public var keys:Array<Null<Int>> = [for (i in 0...256) null];

  public var nowPlaying: Array<PlayingSoundDescriptor> = [];

  @:isVar
  public var masterVolume(get, set): Float = 1;

  @:isVar
  public var soundVolume(get, set): Float = 1;

  @:isVar
  public var musicVolume(get, set): Float = 1;

  public function new() {
    super();
  }

  /**
   * Mute setter
   */
  function set_mute(value: Bool): Bool {
    if(!mute && value) {
      pauseAll();
    }

    if(mute && !value) {
      resumeAll();
    }

    return globalMute = mute = value;
  }

  public function pauseAll() {
    for(playing in nowPlaying) {
      playing.position = playing.channel.position;
      playing.channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
      playing.channel.stop();
      playing.playing = false;
    }
  }

  public function resumeAll() {
    for(playing in nowPlaying) {
      if(!playing.playing) {
        playing.channel = playing.sound.play(playing.position);
        playing.channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
      }
    }
  }

  public function stopMusic() {
    for(playing in nowPlaying) {
      if(playing.type == 'music') {
        playing.channel.stop();
        nowPlaying.remove(playing);
      }
    }
  }

  public function leave() {
    pauseAll();
  }

  public function enter() {
    resumeAll();
  }

  /**
   * Play something
   * 
   * @param type 
   * @param id 
   * @param vol 
   * @param pan 
   * @param looped 
   * @param position 
   */
  public function play(type: String = 'sound', id: String, ?vol: Float = 1.0, ?pan: Float = 0.0, ?looped: Bool = false, ?position: Float = 0) {
    // TODO
  }

  /**
   * Play Sound Effect
   * 
   * @param id 
   * @param vol 
   * @param pan 
   * @param looped 
   * @param position 
   */
  public function playSound(id: String, ?vol: Float = 1.0, ?pan: Float = 0.0, ?looped: Bool = false, ?position: Float = 0) {
    if(Assets.exists(id)) {
      var sound: Sound = Assets.getSound(id);
      var channel = sound.play(position, new SoundTransform(masterVolume * soundVolume * vol, pan));

      channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);

      var descriptor: PlayingSoundDescriptor = {
        id: id,
        type: 'sound',
        sound: sound,
        channel: channel,
        volume: vol,
        pan: pan,
        position: 0,
        looping: looped,
        playing: true
      };

      nowPlaying.push(descriptor);

      dispatchEvent(new Event('sound_list_update'));

      return descriptor;
    } else {
      trace('Sound effect doesnt exits: ${id}');
    }

    return null;
  }

  /**
   *  Stop playing sound
   *  
   *  @param channel - 
   */
  public function stopSound(descriptor: PlayingSoundDescriptor) {
    removePlaying(descriptor);
    descriptor.channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
    descriptor.channel.stop();
  }


  /**
   * Play Music
   * 
   * @param id 
   * @param looping 
   * @param vol 
   * @param pan 
   */
  public function playMusic(id: String, looping: Bool = true, vol: Float = 1.0, pan: Float = 0.0) {
    if(Assets.exists(id)) {
      var music: Sound = Assets.getSound(id);

      var channel = music.play(new SoundTransform(masterVolume * musicVolume * vol, pan));

      var playing:PlayingSoundDescriptor = {
        id: id,
        type: 'music',
        sound: music,
        channel: channel,
        position: 0,
        looping: looping,
        playing: true,
        volume: vol,
        pan: pan
      };

      nowPlaying.push(playing);

      dispatchEvent(new Event('sound_list_update'));

      channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
      return playing;
    } else {
      trace("Music doesn't exists: ${id}");
      return null;
    }
  }

  /**
   * Remove playing channel
   * 
   * @param channel 
   */
  function removePlaying(descriptor: PlayingSoundDescriptor) {
    nowPlaying.remove(descriptor);
    dispatchEvent(new Event('sound_list_update'));
  }

  /**
   * On Sound Complete Event
   * 
   * @param e 
   */
  function onSoundComplete(e: Event) {
    var channel: SoundChannel = cast e.target;
    var playing: PlayingSoundDescriptor = null;

    for(item in nowPlaying) {
      if(item.channel == channel) {
        playing = item;
        break;
      }
    }

    if(playing != null) {
      if(playing.looping) {
        playing.channel = Assets.getSound(playing.id).play(new SoundTransform(masterVolume * (playing.type == 'sound' ? soundVolume : musicVolume) * playing.volume, playing.pan));
        playing.channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
      } else {
        removePlaying(playing);
      }
    } else {
      trace('Sound not playing');
    }
  }

  override public function keyDown(keyCode: Int, ctrl: Bool, alt: Bool, shift: Bool) {
    keys[keyCode] = keys[keyCode] == null ? Lib.getTimer() : keys[keyCode];
    super.keyDown(keyCode, ctrl, alt, shift);
  }

  override public function keyUp(keyCode: Int, ctrl: Bool, alt: Bool, shift: Bool) {
    keys[keyCode] = null;
    super.keyUp(keyCode, ctrl, alt, shift);
  }

  function get_masterVolume(): Float {
    return (mute || globalMute) ? 0 : masterVolume;
  }

  function set_masterVolume(value: Float): Float {
    if(!(mute || globalMute)) {
      for(p in nowPlaying) {
        if(p.type == 'sound') {
          p.channel.soundTransform = new SoundTransform(soundVolume * p.volume * value, p.pan);
        } else {
          p.channel.soundTransform = new SoundTransform(musicVolume * p.volume * value, p.pan);
        }
      }
    }

    return masterVolume = value;
  }

  function get_soundVolume(): Float {
    return (mute || globalMute) ? 0 : soundVolume;
  }

  function get_musicVolume(): Float {
    return (mute || globalMute) ? 0 : musicVolume;
  }

  function set_soundVolume(value: Float): Float {
    for(p in nowPlaying) {
      if(p.type == 'sound') {
        p.channel.soundTransform = new SoundTransform(masterVolume * p.volume * value, p.pan);
      }
    }
    return soundVolume = value;
  }

  function set_musicVolume(value: Float): Float {
    for(p in nowPlaying) {
      if(p.type == 'music') {
        p.channel.soundTransform = new SoundTransform(masterVolume * p.volume * value, p.pan);
      }
    }
    return musicVolume = value;
  }
}
