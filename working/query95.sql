-- start query 95 in stream 0 using template query95.tpl
-- \timing on

with ws_wh as
(select ws1."ws_order_number",ws1."ws_warehouse_sk" WH1,ws2."ws_warehouse_sk" WH2
 from "web_sales" ws1,"web_sales" ws2
 where ws1."ws_order_number" = ws2."ws_order_number"
   and ws1."ws_warehouse_sk" <> ws2."ws_warehouse_sk")
 select  
   count(distinct "ws_order_number") as "order count"
  ,sum("ws_ext_ship_cost") as "total shipping cost"
  ,sum("ws_net_profit") as "total net profit"
from
   "postgrestest"."web_sales" ws
  ,"postgrestest"."date_dim" d
  ,"postgrestest"."customer_address" ca
  ,"postgrestest"."web_site" w
where
    "d_date" between '1999-5-01' and (cast('1999-6-30' as date))
--           (cast('1999-5-01' as date) + interval '60' day)
and ws."ws_ship_date_sk" = "d_date_sk"
and ws."ws_ship_addr_sk" = "ca_address_sk"
and "ca_state" = 'MT'
and ws."ws_web_site_sk" = "web_site_sk"
and "web_company_name" = 'pri'
and ws."ws_order_number" in (select "ws_order_number"
                            from ws_wh)
and ws."ws_order_number" in (select "wr_order_number"
                            from "web_returns",ws_wh
                            where "wr_order_number" = ws_wh."ws_order_number")
order by count(distinct "ws_order_number")
limit 100;

-- \timing off
-- end query 95 in stream 0 using template query95.tpl
-- done
