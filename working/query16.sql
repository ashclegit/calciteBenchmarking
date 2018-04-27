select * from (select
   count(distinct cs1."cs_order_number") as "order count"
  ,sum(cs1."cs_ext_ship_cost") as "total shipping cost"
  ,sum(cs1."cs_net_profit") as "total net profit"
from
   "postgrestest"."catalog_sales" cs1
  ,"postgrestest"."date_dim" d
  ,"postgrestest"."customer_address" ca
  ,"postgrestest"."call_center" cc
where
    d."d_date" between '1999-2-01' and
           (CAST('1999-2-01' AS date) + INTERVAL '60' day)
and cs1."cs_ship_date_sk" = d."d_date_sk"
and cs1."cs_ship_addr_sk" = ca."ca_address_sk"
and ca."ca_state" = 'IL'
and cs1."cs_call_center_sk" = cc."cc_call_center_sk"
and cc."cc_county" in ('Williamson County','Williamson County','Williamson County','Williamson County',
                  'Williamson County'
)
and exists (select *
            from "postgrestest"."catalog_sales" cs2
            where cs1."cs_order_number" = cs2."cs_order_number"
              and cs1."cs_warehouse_sk" <> cs2."cs_warehouse_sk")
and not exists(select *
               from "postgrestest"."catalog_returns" cr1
               where cs1."cs_order_number" = cr1."cr_order_number")
order by count(distinct cs1."cs_order_number")
 ) as tbl limit 100;
