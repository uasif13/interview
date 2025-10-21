/ Create sql functions for all the exercises
/ connect to TP
h:hopen `::5010;

/ syms to subscribe to
s:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L
/ table to hold info used in vwap calc
ttrades:([] time: `timespan$(); sym: `$(); date:`date$(); price:`float$();size:`int$())
/ttrades:(sym:`$(); date: `date$(); price:`float$();size:`int$())

/ action for real-time data
upd:{[x;y]ttrades,:select time, sym, date, price, size from y;}
/upd:{[x;y]ttrades+:0N!select sym, date, price, size from y;}


/ subscribe to trade table for syms
h(".u.sub";`trade;s);

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `ttrades;}

/ client function to retrieve vwap
/ e.g. getVWAP[`IBM.N`MSFT.O]
q1:{select avg price,  vwap:size wavg price by sym from ttrades}
q2:{update shareval: price*size from ttrades where not (null price) | (null size)}
/q1:{select avg price,  vwap:price wavg size from ttrades by sym}

/q1[]