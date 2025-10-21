/ trades table
dts:2024.06.01+1000000?90
tms:1000000?24:00
syms:1000000?`aapl`goog`nvda`meta`tsla
vols:10*1+1000000?1000
pxs:90.0+(1000000?2001)%100
trades:([] date:dts;time:tms;sym:syms;size:vols;price:pxs)
trades:update price:3*price from trades where sym=`aapl
trades:update price:3*price from trades where sym=`goog
trades:update price:2*price from trades where sym=`nvda
trades:update price:7*price from trades where sym=`meta
trades:update price:4*price from trades where sym=`tsla
mktrades:{[tickers;sz] 
    date:2024.06.01+sz?90; 
    time:sz?24:00; 
    sym:sz?tickers;size:10*1+sz?1000;
    price:90.0+(sz?2001)%100; 
    t:([] date; time; sym; size; price); 
    t:`date`time xasc t; 
    t:update price:3*price from t where sym=`goog; 
    t:update price: 3*price from t where sym=`aapl;
    t:update price: 2*price from t where sym=`nvda;
    t:update price:7*price from t where sym=`meta; 
    t:update price:4*price from t where sym=`tsla;t}
trades:mktrades[`aapl`goog`nvda`meta`tsla;1000000]

/orders table
mkorders: {[size]
	trader:size?`ta`tb`tc`td`te;
	clientname:size?`ca`cb`cc`cd`ce;
  order_type:size?("queued";"processing";"executed");
	t: ([] trader:`symbol$(); clientname: `symbol$(); order_type:((`char))$());
  t: ([] trader; clientname; order_type);t}
orders:mkorders[1000000]

/alerts table
mkAlerts_size:100000
size:900000+mkAlerts_size?200000
variance: 3.0+mkAlerts_size?2.0
threshold: 3.0+mkAlerts_size?2.0
alerts: ([] size; variance; threshold)

/quotes table
quotes_size:1000000
company: quotes_size?`goog`aapl`meta`nvda
size: 1000+quotes_size?500
quotes: ([] company; size)

/data table
data_size:10
school: data_size?`montclair`clifton`glenridge`bloomfield`newark
team: data_size?`bulldogs`mustang`ridger`warhawk`raider
sports: data_size?`football`soccer`tennis`track`basketball
score: 50+data_size?11
data:([] school; team; sports; score)



