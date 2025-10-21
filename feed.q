/ TODO: create feeds for all tables
h:neg hopen 5010 /connect to tickerplant
syms:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L /stocks
prices:syms!45.15 191.10 178.50 128.04 341.30 /starting prices
n:1 /number of rows per update
flag:1 /generate 10% of updates for trade and 90% for quote
order_types:("processed"; "queued"; "executed")

getmovement:{[s] rand[0.0001]*prices[s]} /get a random price movement
/generate trade price
getprice:{[s] prices[s]+:rand[1 -1]*getmovement[s]; prices[s]}
getbid:{[s] prices[s]-getmovement[s]} /generate bid price
getask:{[s] prices[s]+getmovement[s]} /generate ask price
/timer function
.z.ts:{
  s:n?syms;
  h(".u.upd";`quote;(n#.z.N;s;n?`AA`BB`CC`DD;getbid'[s];getask'[s];n?1000;n?1000));
  h(".u.upd";`trade;(n#00:00+1?1440;s;n#2024.06.01+1?90;getprice'[s];n?1000));
  h(".u.upd";`alerts;(n#.z.N;s;n?200000+950000;n?2.0+4.0;n?2.0+3.0));
  h(".u.upd";`orders;(n#.z.N;s;n?`traderA`traderB`traderC`traderD;n?`clientA`clientB`clientC`clientD;n?order_types))
  h(".u.upd";`data;(n#.z.N;s;n?`montclair`clifton`glenridge`bloomfield;n?`bulldogs`mustang`ridger`cardinal;n?`football`soccer`tennis`track;n?100))
  }

/trigger timer every 100ms
\t 300