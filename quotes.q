/ Create sql functions for all the exercises
/ connect to TP
h:hopen `::5010;

/ syms to subscribe to
s:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L
/ table to hold info used in vwap calc
/tquotes:([sym:`$()]size:`int$())
tquotes:([] time: `timespan$(); sym: `$(); company: `$(); bid: `float$(); ask: `float$(); bsize: `int$(); asize:`int$())
/ttrades:(sym:`$(); date: `date$(); price:`float$();size:`int$())

/ action for real-time data
/upd:{[x;y]tquotes+:select sum size by sym from y;}
upd_rt:{[x;y]tquotes,:select time, sym, company, bid, ask,bsize, asize from y;}
/upd:{[x;y]ttrades+:0N!select sym, date, price, size from y;}
upd_replay:{[x;y]if[x~`quote;upd_rt[`quote;select from (quote upsert flip y) where sym in s]];}

/ subscribe to trade table for syms
h(".u.sub";`quote;s);

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `tquotes;}

replay:{[x]
  logf:x[1];
  if[null first logf;:()];
  .[set;x[0]];
  upd::upd_replay;
  0N!"Replaying ",(string logf[0]), " messages from log ", string logf[1];
  -11!logf;
  0N!"Replay done";}


replay h"(.u.sub[`quote;",(.Q.s1 s),"];.u `i`L)";
upd:upd_rt;

/ client function to retrieve vwap
/ e.g. getVWAP[`IBM.N`MSFT.O]
q5:{select from (update masize:max asize by company from tquotes) where masize = asize}
/q1:{select avg price,  vwap:price wavg size from ttrades by sym}

/q1[]