/ Create sql functions for all the exercises
/ connect to TP
h:hopen `::5010;

/ syms to subscribe to
s:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L
/ alerts table
torders:([] time: `timespan$(); sym: `$(); trader: `$(); clientname: `$(); order_type: ())

/ action for real-time data
upd_rt:{[x;y]torders,:select time, sym, trader, clientname, order_type from y;}

upd_replay:{[x;y]if[x~`orders;upd_rt[`orders;select from (orders upsert flip y) where sym in s]];}

/ subscribe to trade table for syms
h(".u.sub";`orders;s);

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `torders;}

replay:{[x]
  logf:x[1];
  if[null first logf;:()];
  .[set;x[0]];
  upd::upd_replay;
  0N!"Replaying ",(string logf[0]), " messages from log ", string logf[1];
  -11!logf;
  0N!"Replay done";}


replay h"(.u.sub[`orders;",(.Q.s1 s),"];.u `i`L)";
upd:upd_rt;

/ client function for query
/ e.g. q2[]
q4:{exec trader, clientname from torders where order_type like "executed"}

/q2[]