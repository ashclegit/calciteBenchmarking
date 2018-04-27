with ss as (
 select
          i."i_manufact_id",sum(ss."ss_ext_sales_price") total_sales
 from
        "postgrestest"."store_sales" ss,
        "postgrestest"."date_dim" d,
         "postgrestest"."customer_address" ca,
         "postgrestest"."item" i
 where
         i."i_manufact_id" in (select
  i."i_manufact_id"
from
 "postgrestest"."item" i
where i."i_category" in ('Books'))
 and     ss."ss_item_sk"              = i."i_item_sk"
 and     ss."ss_sold_date_sk"         = d."d_date_sk"
 and     d."d_year"                  = 1999
 and     d."d_moy"                   = 3
 and     ss."ss_addr_sk"              = ca."ca_address_sk"
 and     ca."ca_gmt_offset"           = -5
 group by i."i_manufact_id"),
 cs as (
 select
          i."i_manufact_id",sum(cs."cs_ext_sales_price") total_sales
 from
        "postgrestest"."catalog_sales" cs,
        "postgrestest"."date_dim" d,
         "postgrestest"."customer_address" ca,
         "postgrestest"."item" i
 where
         i."i_manufact_id"               in (select
  i."i_manufact_id"
from
 "postgrestest"."item"
where i."i_category" in ('Books'))
 and     cs."cs_item_sk"              = i."i_item_sk"
 and     cs."cs_sold_date_sk"         = d."d_date_sk"
 and     d."d_year"                  = 1999
 and     d."d_moy"                   = 3
 and     cs."cs_bill_addr_sk"         = ca."ca_address_sk"
 and     ca."ca_gmt_offset"           = -5
 group by i."i_manufact_id"),
 ws as (
 select
          i."i_manufact_id",sum(ws."ws_ext_sales_price") total_sales
 from
        "postgrestest"."web_sales" ws,
        "postgrestest"."date_dim" d,
         "postgrestest"."customer_address" ca,
         "postgrestest"."item" i
 where
         i."i_manufact_id"               in (select
  i."i_manufact_id"
from
 "postgrestest"."item" i
where i."i_category" in ('Books'))
 and     ws."ws_item_sk"              = i."i_item_sk"
 and     ws."ws_sold_date_sk"         = d."d_date_sk"
 and     d."d_year"                  = 1999
 and     d."d_moy"                   = 3
  and     ws."ws_bill_addr_sk"         = ca."ca_address_sk"
 and     ca."ca_gmt_offset"           = -5
 group by i."i_manufact_id")
 select * from ( select  i_manufact_id ,sum(total_sales) total_sales
 from  (select * from ss
        union all
        select * from cs
        union all
        select * from ws) tmp1
 group by i."i_manufact_id"
 order by total_sales
 ) as tbl;
