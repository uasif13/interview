/ Create sql functions for all the exercises
/ connect to TP
h:hopen `::5010;

/ syms to subscribe to
s:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L
/ table to hold info used in vwap calc
ttrades:([] time: `timespan$(); sym: `$(); date:`date$(); price:`float$();size:`int$())
/ttrades:(sym:`$(); date: `date$(); price:`float$();size:`int$())

/ action for real-time data
upd_rt:{[x;y]ttrades,:select time, sym, date, price, size from y;}
/upd:{[x;y]ttrades+:0N!select sym, date, price, size from y;}

/ action for data received from log file
upd_replay:{[x;y]if[x~`trade;upd_rt[`trade;select from (trade upsert flip y) where sym in s]];}
/ subscribe to trade table for syms
h(".u.sub";`trade;s);

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `ttrades;}

replay:{[x]
  logf:x[1];
  if[null first logf;:()];
  .[set;x[0]];
  upd::upd_replay;
  0N!"Replaying ",(string logf[0]), " messages from log ", string logf[1];
  -11!logf;
  0N!"Replay done";}


replay h"(.u.sub[`trade;",(.Q.s1 s),"];.u `i`L)";
upd:upd_rt;

/ client function to retrieve vwap
/ e.g. getVWAP[`IBM.N`MSFT.O]
q1:{select avg price,  vwap:size wavg price by sym from ttrades}
q2:{update shareval: price*size from ttrades where not (null price) | (null size)}
/q1:{select avg price,  vwap:price wavg size from ttrades by sym}

/q interview/trades.q -p PORT
/q1[]