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
upd:{[x;y]tquotes,:select time, sym, company, bid, ask,bsize, asize from y;}
/upd:{[x;y]ttrades+:0N!select sym, date, price, size from y;}


/ subscribe to trade table for syms
h(".u.sub";`quote;s);

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `tquotes;}

/ client function to retrieve vwap
/ e.g. getVWAP[`IBM.N`MSFT.O]
q5:{select from (update masize:max asize by company from tquotes) where masize = asize}
/q1:{select avg price,  vwap:price wavg size from ttrades by sym}

/q1[]