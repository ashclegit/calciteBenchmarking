with ws_wh as
(select ws1."ws_order_number",ws1."ws_warehouse_sk" wh1,ws2."ws_warehouse_sk" wh2
from "postgrestest"."web_sales" ws1,"postgrestest"."web_sales" ws2
where ws1."ws_order_number" = ws2."ws_order_number"
  and ws1."ws_warehouse_sk" <> ws2."ws_warehouse_sk")
select
  count(distinct ws."ws_order_number") as "order count"
 ,sum(ws."ws_ext_ship_cost") as "total shipping cost"
 ,sum(ws."ws_net_profit") as "total net profit"
from
  "postgrestest"."web_sales" ws
 ,"postgrestest"."date_dim" d
 ,"postgrestest"."customer_address" ca
 ,"postgrestest"."web_site" web
where
   d."d_date" between '1999-5-01' and
          (cast('1999-5-01' as date) + INTERVAL '60' day)
and ws."ws_ship_date_sk" = d."d_date_sk"
and ws."ws_ship_addr_sk" = ca."ca_address_sk"
and ca."ca_state" = 'MT'
and ws."ws_web_site_sk" = web."web_site_sk"
and web."web_company_name" = 'pri'
and ws."ws_order_number" in (select ws."ws_order_number"
                           from ws_wh)
and ws."ws_order_number" in (select wr."wr_order_number"
                           from "postgrestest"."web_returns" wr,ws_wh 
                           where wr."wr_order_number" = ws_wh."ws_order_number")
order by count(distinct ws."ws_order_number")
limit 10;
