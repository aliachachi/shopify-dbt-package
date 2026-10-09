import React,{useEffect,useState} from 'react';
import {LineChart,BarChart3,Users,Package,Megaphone,WalletCards,Boxes,TrendingUp,FileText,ChevronRight,CalendarDays,RefreshCw,ShoppingCart,ArrowUpRight,ArrowDownRight} from 'lucide-react';
import {ResponsiveContainer,AreaChart,Area,BarChart,Bar,XAxis,YAxis,Tooltip,CartesianGrid,PieChart,Pie,Cell} from 'recharts';

const API='http://localhost:8787/api';
const menu=[
 ['overview','Executive',LineChart],['sales','Sales',BarChart3],['customers','Customers',Users],
 ['products','Products',Package],['marketing','Marketing',Megaphone],['operations','Operations',Boxes],
 ['finance','Finance',WalletCards],['forecast','Forecast',TrendingUp],['health','Data Health',FileText]
];
const presets=['Last 30 Days','MTD','QTD','Last Quarter','YTD','Last Year'];
const money=v=>new Intl.NumberFormat('en-US',{style:'currency',currency:'USD',maximumFractionDigits:0}).format(v||0);
const num=v=>new Intl.NumberFormat('en-US',{maximumFractionDigits:0}).format(v||0);

function KPI({title,value,delta,sub,Icon,good=true}){return <div className="kpi"><div className="kt"><span>{title}</span><Icon size={16}/></div><b>{value}</b><div className={good?'up':'down'}>{good?<ArrowUpRight size={13}/>:<ArrowDownRight size={13}/>} {delta}<small>{sub}</small></div></div>}
function Empty({title,text}){return <div className="empty"><div className="emptyIcon"><LineChart/></div><h2>{title}</h2><p>{text}</p><span>Designed — waiting for dbt mart</span></div>}

export default function App(){
 const [page,setPage]=useState('sales'),[preset,setPreset]=useState('Last 30 Days'),[d,setD]=useState({sales:[],customers:[],products:[],channels:[]}),[loading,setLoading]=useState(true);
 async function load(){setLoading(true);try{const r=await fetch(API+'/dashboard');setD(await r.json())}catch(e){console.error(e)}finally{setLoading(false)}}
 useEffect(()=>{load()},[]);
 const s=d.sales||[],c=d.customers||[],p=d.products||[],ch=d.channels||[],last=s.at(-1)||{},prev=s.at(-2)||{};
 const revDelta=prev.revenue?((last.revenue-prev.revenue)/prev.revenue*100):0,ordDelta=prev.orders?((last.orders-prev.orders)/prev.orders*100):0;
 const aov=last.orders?last.revenue/last.orders:0,units=p.reduce((x,r)=>x+(r.units_sold||0),0),top=[...p].sort((a,b)=>(b.net_sales||0)-(a.net_sales||0)).slice(0,8);
 const pageTitle=menu.find(x=>x[0]===page)?.[1]||'Sales';
 const content=(page==='sales'||page==='overview')?<><div className="kpis">
 <KPI title="Revenue" value={money(last.revenue)} delta={`${revDelta>=0?'+':''}${revDelta.toFixed(1)}%`} sub="MoM" Icon={TrendingUp} good={revDelta>=0}/>
 <KPI title="Orders" value={num(last.orders)} delta={`${ordDelta>=0?'+':''}${ordDelta.toFixed(1)}%`} sub="MoM" Icon={ShoppingCart} good={ordDelta>=0}/>
 <KPI title="AOV" value={money(aov)} delta="current" sub="period" Icon={WalletCards}/>
 <KPI title="Units Sold" value={num(units)} delta="modeled" sub="period" Icon={Package}/>
 <KPI title="Customers" value={num(c.at(-1)?.active_customers)} delta="active" sub="period" Icon={Users}/>
 </div>
 <div className="narrative"><strong>CFO NARRATIVE</strong><p><b>Sales signal:</b> latest modeled period shows <b>{money(last.revenue)}</b> revenue across <b>{num(last.orders)}</b> orders. Next question: <b>why</b> did it move?</p><button>Explain drivers <ChevronRight size={14}/></button></div>
 <div className="grid">
  <Card title="Revenue & Orders" sub="Trend → direction"><ResponsiveContainer><AreaChart data={s}><CartesianGrid vertical={false} strokeDasharray="3 3"/><XAxis dataKey="month" tickFormatter={x=>String(x).slice(0,7)}/><YAxis yAxisId="r" tickFormatter={x=>`$${Math.round(x/1000)}k`}/><YAxis yAxisId="o" orientation="right"/><Tooltip/><Area yAxisId="r" type="monotone" dataKey="revenue" fillOpacity=".12" strokeWidth={2}/><Area yAxisId="o" type="monotone" dataKey="orders" fillOpacity="0" strokeWidth={2}/></AreaChart></ResponsiveContainer></Card>
  <Card title="Revenue by Channel" sub="Drill: source → campaign"><ResponsiveContainer><BarChart data={ch.slice(-8)}><CartesianGrid vertical={false} strokeDasharray="3 3"/><XAxis dataKey="source_name"/><YAxis tickFormatter={x=>`$${Math.round(x/1000)}k`}/><Tooltip formatter={money}/><Bar dataKey="revenue" radius={[5,5,0,0]}/></BarChart></ResponsiveContainer></Card>
  <Card title="Top Products" sub="Drill: product → SKU"><ResponsiveContainer><BarChart data={top} layout="vertical"><CartesianGrid horizontal={false} strokeDasharray="3 3"/><XAxis type="number" tickFormatter={x=>`$${Math.round(x/1000)}k`}/><YAxis type="category" dataKey="sku" width={90}/><Tooltip formatter={money}/><Bar dataKey="net_sales" radius={[0,5,5,0]}/></BarChart></ResponsiveContainer></Card>
  <Card title="Customer Mix" sub="New vs returning"><ResponsiveContainer><PieChart><Pie data={[{name:'New',value:c.reduce((x,r)=>x+(r.new_customer_orders||0),0)},{name:'Returning',value:c.reduce((x,r)=>x+(r.returning_customer_orders||0),0)}]} dataKey="value" innerRadius={45} outerRadius={75}><Cell/><Cell/></Pie><Tooltip/></PieChart></ResponsiveContainer></Card>
 </div></>:<Empty title={pageTitle} text={
 page==='customers'?'Next: cohorts, new vs returning revenue, repeat rate, first-order AOV and CLV.':
 page==='products'?'Next: SKU revenue, units, ASP, contribution and product affinity.':
 page==='marketing'?'Activate with Meta/Google/TikTok marts: spend → traffic → revenue → contribution.':
 page==='operations'?'Activate with ShipBob marts: demand → inventory → fulfillment → customer impact.':
 page==='finance'?'Activate after QBO reconciliation: revenue → gross profit → OpEx → net income → cash.':
 page==='forecast'?'Activate with forecast/budget marts: actual → forecast → variance → action.':
 'Planned: freshness, row counts, reconciliation gates and source failures.'}/>;
 return <div className="app"><aside><div className="brand"><i>C</i><b>CFO<small>EXPERTISE</small></b></div><div className="client">CLIENT<strong>Gold Hinge</strong><em>● Live</em></div><nav>{menu.map(([id,label,Icon])=><button className={page===id?'active':''} onClick={()=>setPage(id)} key={id}><Icon size={17}/>{label}{page===id&&<ChevronRight size={13}/>}</button>)}</nav><footer>● BigQuery connected<br/><small>dbt • goldhinge_dbt</small></footer></aside>
 <main><header><div><small>EXECUTIVE DECISION SYSTEM</small><h1>{pageTitle}</h1></div><div className="controls"><div><CalendarDays size={15}/><select value={preset} onChange={e=>setPreset(e.target.value)}>{presets.map(x=><option key={x}>{x}</option>)}</select></div><button onClick={load}><RefreshCw size={15}/>{loading?'Loading':'Refresh'}</button></div></header><section>{content}</section></main></div>
}
function Card({title,sub,children}){return <div className="card"><div className="cardhead"><div><b>{title}</b><small>{sub}</small></div><span>⋯</span></div><div className="chart">{children}</div></div>}
