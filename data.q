/ Create sql functions for all the exercises
/ connect to TP
h:hopen `::5010;

/ syms to subscribe to
s:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L
/ alerts table
tdata:([] time: `timespan$(); sym: `$(); school: `$(); team: `$(); sports: `$(); score: `int$())

/ action for real-time data
upd_rt:{[x;y]tdata,:select time, sym, school, team, sports, score from y;}

upd_replay:{[x;y]if[x~`data;upd_rt[`data;select from (data upsert flip y) where sym in s]];}

/ subscribe to trade table for syms
h(".u.sub";`data;s);

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `tdata;}

replay:{[x]
  logf:x[1];
  if[null first logf;:()];
  .[set;x[0]];
  upd::upd_replay;
  0N!"Replaying ",(string logf[0]), " messages from log ", string logf[1];
  -11!logf;
  0N!"Replay done";}


replay h"(.u.sub[`data;",(.Q.s1 s),"];.u `i`L)";
upd:upd_rt;

/ client function for query
/ e.g. q2[]
q6:{select sports!score by school, team from tdata}

/interview
/q interview/data.q -p 5045
/q6[]