# CFO Gold Hinge Dashboard

React/Vite frontend + Node/Express API for BigQuery.

## Run
1. `npm install`
2. `cd api && npm install && cd ..`
3. Set `GOOGLE_APPLICATION_CREDENTIALS` to a service-account JSON with BigQuery access.
4. Terminal 1: `npm run dev`
5. Terminal 2: `npm run api`

Frontend: http://localhost:5173
API: http://localhost:8787

The API reads:
- kpi_sales_monthly
- kpi_customer_monthly
- kpi_product_monthly
- mart_channel_monthly
