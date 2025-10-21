/ Create sql functions for all the exercises
/ connect to TP
h:hopen `::5010;

/ syms to subscribe to
s:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L
/ alerts table
torders:([] time: `timespan$(); sym: `$(); trader: `$(); clientname: `$(); order_type: ())

/ action for real-time data
upd:{[x;y]torders,:select time, sym, trader, clientname, order_type from y;}

/ subscribe to trade table for syms
h(".u.sub";`orders;s);

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `torders;}

/ client function for query
/ e.g. q2[]
q4:{exec trader, clientname from torders where order_type like "executed"}

/q2[]