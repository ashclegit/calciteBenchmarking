select * from (select
     i."i_item_id"
    ,i."i_item_desc"
    ,s."s_store_id"
    ,s."s_store_name"
    ,sum(ss."ss_quantity")        as store_sales_quantity
    ,sum(sr."sr_return_quantity") as store_returns_quantity
    ,sum(cs."cs_quantity")        as catalog_sales_quantity
 from
    "postgrestest"."store_sales" ss
   ,"postgrestest"."store_returns" sr
   ,"postgrestest"."catalog_sales" cs
   ,"postgrestest"."date_dim"             d1
   ,"postgrestest"."date_dim"             d2
   ,"postgrestest"."date_dim"             d3
   ,"postgrestest"."store" s
   ,"postgrestest"."item" i
 where
     d1."d_moy"               = 4
 and d1."d_year"              = 1999
 and d1."d_date_sk"           = ss."ss_sold_date_sk"
 and i."i_item_sk"              = ss."ss_item_sk"
 and s."s_store_sk"             = ss."ss_store_sk"
 and ss."ss_customer_sk"         = sr."sr_customer_sk"
 and ss."ss_item_sk"             = sr."sr_item_sk"
 and ss."ss_ticket_number"       = sr."sr_ticket_number"
 and sr."sr_returned_date_sk"    = d2."d_date_sk"
 and d2."d_moy"               between 4 and  4 + 3
 and d2."d_year"              = 1999
 and sr."sr_customer_sk"         = cs."cs_bill_customer_sk"
 and sr."sr_item_sk"             = cs."cs_item_sk"
 and cs."cs_sold_date_sk"        = d3."d_date_sk"
 and d3."d_year"              in (1999,1999+1,1999+2)
 group by
    i."i_item_id"
   ,i."i_item_desc"
   ,s."s_store_id"
   ,s."s_store_name"
 order by
    i."i_item_id"
   ,i."i_item_desc"
   ,s."s_store_id"
   ,s."s_store_name"
  ) as tbl;
