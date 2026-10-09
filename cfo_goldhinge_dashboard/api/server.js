import express from 'express'; import cors from 'cors'; import {BigQuery} from '@google-cloud/bigquery';
const app=express(),bq=new BigQuery({projectId:'cfo-data-dev'}),ds='goldhinge_dbt';
app.use(cors());
async function q(sql){const [rows]=await bq.query({query:sql,useLegacySql:false});return rows}
app.get('/api/health',(req,res)=>res.json({ok:true,project:'cfo-data-dev',dataset:ds}));
app.get('/api/dashboard',async(req,res)=>{try{const [sales,customers,products,channels]=await Promise.all([
q(`SELECT CAST(month AS STRING) month,revenue,orders FROM \`cfo-data-dev.${ds}.kpi_sales_monthly\` ORDER BY month`),
q(`SELECT CAST(month AS STRING) month,active_customers,new_customer_orders,returning_customer_orders,revenue,orders FROM \`cfo-data-dev.${ds}.kpi_customer_monthly\` ORDER BY month`),
q(`SELECT CAST(month AS STRING) month,product_id,variant_id,sku,orders,units_sold,gross_sales,discounts,net_sales FROM \`cfo-data-dev.${ds}.kpi_product_monthly\` ORDER BY month`),
q(`SELECT CAST(month AS STRING) month,source_name,orders,revenue,discounts,taxes FROM \`cfo-data-dev.${ds}.mart_channel_monthly\` ORDER BY month`)]);
res.json({sales,customers,products,channels})}catch(e){console.error(e);res.status(500).json({error:e.message})}});
app.listen(8787,()=>console.log('API: http://localhost:8787'));