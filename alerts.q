/ Create sql functions for all the exercises
/ connect to TP
h:hopen `::5010;

/ syms to subscribe to
s:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L
/ alerts table
talerts:([] time: `timespan$(); sym: `$(); size: `int$(); variance: `float$(); threshold: `float$())

/ action for real-time data
upd:{[x;y]talerts,:select time, sym, size, variance, threshold from y;}

/ subscribe to trade table for syms
h(".u.sub";`alerts;s);

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `talerts;}

/ client function for query
/ e.g. q2[]
q3_exists:{select from talerts where size>1000000, variance > threshold}
q3:{talerts:: delete from talerts where size > 1000000, variance > threshold}

/q2[]