package funkin.backend.scripting.events;

final class FreeplaySongSelectEvent extends CancellableEvent {
	/**
	 * Song name that is about to be played
	 */
	public var song:String;
	/**
	 * Difficulty name
	 */
	public var difficulty:String;
	/**
	 * Whenever opponent mode is enabled or not.
	 */
	public var opponentMode:Bool;
	/**
	 * Whenever coop mode is enabled.
	 */
	public var coopMode:Bool;
}