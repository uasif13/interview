/ Create sql functions for all the exercises
/ connect to TP
h:hopen `::5010;

/ syms to subscribe to
s:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L
/ alerts table
tdata:([] time: `timespan$(); sym: `$(); school: `$(); team: `$(); sports: `$(); score: `int$())

/ action for real-time data
upd:{[x;y]tdata,:select time, sym, school, team, sports, score from y;}

/ subscribe to trade table for syms
h(".u.sub";`data;s);

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `tdata;}

/ client function for query
/ e.g. q2[]
q6:{select sports!score by school, team from tdata}

/q2[]