/ Create sql functions for all the exercises
/ connect to TP
h:hopen `::5010;

/ syms to subscribe to
s:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L
/ alerts table
talerts:([] time: `timespan$(); sym: `$(); size: `int$(); variance: `float$(); threshold: `float$())

/ action for real-time data
upd_rt:{[x;y]talerts,:select time, sym, size, variance, threshold from y;}

/number of rows with alerts
upd_replay:{[x;y]if[x~`alerts;upd_rt[`alerts;select from (alerts upsert flip y) where sym in s]];}

/ subscribe to trade table for syms
h(".u.sub";`alerts;s);

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `talerts;}

replay:{[x]
  logf:x[1];
  if[null first logf;:()];
  .[set;x[0]];
  upd::upd_replay;
  0N!"Replaying ",(string logf[0]), " messages from log ", string logf[1];
  -11!logf;
  0N!"Replay done";}


replay h"(.u.sub[`alerts;",(.Q.s1 s),"];.u `i`L)";

upd:upd_rt;
/ client function for query
/ e.g. q2[]
q3_exists:{select from talerts where size>1000000, variance > threshold}
q3:{talerts:: delete from talerts where size > 1000000, variance > threshold}

/interview
/q interview/alerts.q -p 5042
/q3_exists[] -> check if there are any records with condition
/q3[] -> deletes records that satisfy condition