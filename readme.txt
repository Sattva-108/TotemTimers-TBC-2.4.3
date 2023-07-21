TotemTimers 7.1 Readme

This addon displays four timer buttons one for each totem element. 
If you cast a totem it's icon will be set to the appropriate timer button
with the totem's remaining time underneath it.

In previous versions TotemTimers was able to recast a previously cast totem
by clicking on the appropriate timer. This functionality has been removed
by Blizzard with the 2.0 Patch.

TotemTimers 7.0 tries to implement a casting system for totems that will
get as near as possible to the previous recasting and expanding it so that
you should no longer need totems on any other action bars.
Since it is not possible any more to recast the last used totem, totems
will have to be assigned to the four timer buttons manually.
Although this is not recasting per se, this readme and the addon will still
refer to this as recasting.

Each timer button consists of two icons:
The big main icon which indicates which totems are currently active and a
small mini icon which indicates what totem will be cast when you leftclick that button.
To change the totem assigned to that button mouseover it (you can set that behaviour 
to rightclick instead of mouseover, see options below).
A button bar will appear with all totems for the timer's element.
If you leftclick such a totem button it will cast the displayed totem.
If you rightlick a totem button that totem will be assigned to the timer button.
If you middleclick a totem button that totem will be cast and set to the timer button.
Totem ordering of the totem bars can be changed by simply dragging one totem button
onto another one. It will then be put before that.

You can assign two keys to each timer button:
One key simply leftclicks the timer button so that you can recast a totem.
The other opens that timer buttons totem bar. You can then cast a totem by using
a number key (the totem buttons are marked accordingly).
You can also assign a key to Totemic Call.

An additional tracker window has the following trackers:
- Reincarnation timer
- Water/Lightning Shield timer (leftclick to cast Lightning Shield, rightlick for Water Shield)
- Earth Shield Counter (leftclick to cast Earth Shield on focus, rightclick on target, 
  middleclick on targettarget)
- Weapon Buff trackers (you can set the buffs you cast with lc and rc in the options menu)

You can set options using the /tt or /totemtimers command.


--[[
original authors: Donald Ephraim Curtis, Grumpey
current authors:  Zulah, Xianghar
TotemTimers: Movable Totem Timers and Totem Expiration Notification and Totem Casting Bars
This addon is not to be modified without permission from authors.
]]