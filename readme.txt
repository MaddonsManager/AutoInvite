[SIZE="3"]AutoInvite 2.3.5[/SIZE]
* [SIZE="1"]New Features![/SIZE]

Created on September 13, 2008 by Martag on the server Greymane

Used to Automatically Invite players into a group/raid based on what and where they say certain "trigger" keys.

There are several options available in the easy to use interface.

To open the interface, type /ai or /autoinvite
Players may also disable or enable the addon at any time via /ai disable or /ai enable.




Interface Options
To enable the addon: Click the "Enable Addon" box

User Invite Queue Manager
  + Now automatically add players to a queue list. 
  + Can manually invite players, remove players, or invite all players

Auto Convert to Raid
  + Will automatically convert the group into a raid when the first person joins.

Guildies Only
  + This will make it so that the addon will only send guild members an invite!

Max number of Players
  + Limit the number of players allowed in the raid!
 
Keys:
  + Type the keys you wish people to use when they whisper you for an invite! You may have multiple keys!
  + Separate the keys by using a semicolon ; 

Messages
  + This is the message that will be sent to the selected channels! 
  + To have your triggers/keys in the message, type <key> where you would like them placed!
 
Where to Spam
  + Select the channels you would like your mesasge to be sent to when you hit the [Spam] button!
  + You can now have a custom channel! 

Listening Channels
  + Can now select where you want the addon to autoinvite from!

Add to Queue:
  + Add currently online guild members or your online friends to  the queue manager!

Auto Promote:
  + Now have your friends send you a whisper with "!promote <your-special-key>" for them to get raid assist!

Black List
  + Add baddies to this list and their whispers will be ignored and they will not be invited!


Please make any suggestions that you may have!
Also, please report any bugs!


[SIZE="1"]
* I understand there is another addon called "AutoInvite", and in no way or form is my AddOn made from this old, outdated AddOn.[/SIZE]


 
[[[ VERSIONS/CHANGE LOG ]]]

* Future Expecations
 ** Automatically respam ever "X" minutes (Restricting to minimum of 2 minutes- I don't like spammers :p )
 ** Add option to kick players below level "X" if raid is full
 ** Saved raid rosters? maybe? Automatically add saved roster to queue manager for invite? maybe?


Version 2.3.2
 * Added Auto Promote
  ** Utilize "!promote <your-key-here>" for your friends to automatically get raid assist
 * Added "Online Friends" button
  ** This will add currently online friends into the queue manager

 * No longer restricts invites to players below level 80
 * Changed: Invite Guild button now automatically uses queue manager
 * changed: Invite Guild, Online Friends buttons will automatically clear the current queue list
 


Version 2.3

 * Added "Clear All" button to Queue List
 * Added "Black List", add players to the list to ignore their trigger key
  ** Access the BlackList via "/ai bl" or the main AutoInvite window
  ** Blacklist included an Remove button with confirmation
 * Added BlackList removal confirmation window
 * Added the option to not listen through whispers(?)
 * Added truncating of "Comments" in the queue manager to stop overflow of text

 * Fixed automatic AIBlackList UI scale
 * Fixed "Guildies Only" checkbox, will no longer automatically be checked on load
 * Fixed trigger key checking (finally)
 * Fixed auto convert to raid (again)
 
 * Item links will no longer show in the "Comments" in the queue manager
  

Version 2.2.5
 * Fixed major bug with inviting players
 * Removed level 80 checking (for now, could readd later), any level will be automatically invited


Version 2.2
 * Added Player Queue Manager
  ** Automatically place players in a queue manager to control who gets invited.
 * Added New timer feature for guild invite/player queue manager for flood control!

Version 2.03.1
 * Corrected AddOn Trying to convert to raid when not the party leader

Version 2.03
 * Updated for Patch 3.2
 * New 'Listening Channels' options
 * Now reads incoming messages correctly for triggers
 * New 'Max Raiders' option, with limiting
 * Can Now Press 'Esc' key to exit the UI
 
Version 1.9.8
 * Addon window now scales according to User's UI scale (Maybe new scale and opacity option later on?)
 * Added "Where to Spam", hitting the [Spam] button will send your message to the selected channels
 * (Re)organized the main interface

Version 1.9.7
 * Updated version for Warcraft 3.1

Version 1.9.6
 * Fixed addon not inviting if "Guildies Only" was unchecked
 * (Useless) Cleaned up some coding

Version 1.9.5
 * New Layout
 * Now Supports Multiple Triggers
 * Can invite if trigger is said in Guild Chat
 * New Option to Auto. Convert to Raid
 * New Option for Guildies only trigger
 * Updated for WOTLK
 
 # Only invites level 80 characters, minimm level option coming soon.

Version 1.9.3
 * No longer tries to invite if user is unable to invite (eg. not raid assistant / party leader / raid leader).
 * Tries to retrieve a fresh guild list before inviting guild members.

Version 1.9.2
 * Updated to work with Patch 3.0
 * No longer tries to convert to raid while enabled, but not raid/party leader.

Version 1.9
 * Now invites only level 70s
 * Keyphrases now saved automatically (they will not always reset back to "invite101" on logout);
 * You can now have your own custom spam message!
  ** Use <key> in your message and it will automatically be replaced by your keyphrase when you spam!
  ** Eg. "Invites have Started! Whisper me with "<key>" to receive an automatic invite!"
 * Layout design changed slightly to accomodate new features.

Version 1.8
 * Fixed "invite guild" not inviting unless already existing party member.
 * Fixed auto converting to raid feature when addon is disabled.
 * Changed description