select * from (select
   w."w_state"
  ,i."i_item_id"
  ,sum(case when (cast(d."d_date" as timestamp(0)) < cast ('1998-04-08' as timestamp(0)))
                then cs."cs_sales_price" - coalesce(cr."cr_refunded_cash",0) else 0 end) as sales_before
  ,sum(case when (cast(d."d_date" as timestamp(0)) >= cast ('1998-04-08' as timestamp(0)))
                then cs."cs_sales_price" - coalesce(cr."cr_refunded_cash",0) else 0 end) as sales_after
 from
   "postgrestest"."catalog_sales" cs left outer join "postgrestest"."catalog_returns" cr on
       (cs."cs_order_number" = cr."cr_order_number"
        and cs."cs_item_sk" = cr."cr_item_sk")
  ,"postgrestest"."warehouse" w
  ,"postgrestest"."item" i
  ,"postgrestest"."date_dim" d
 where
     i."i_current_price" between 0.99 and 1.49
 and i."i_item_sk"          = cs."cs_item_sk"
 and cs."cs_warehouse_sk"    = w."w_warehouse_sk"
 and cs."cs_sold_date_sk"    = d."d_date_sk"
 and d."d_date" between (cast ('1998-04-08' as date) -  INTERVAL '30' day)
                and (cast ('1998-04-08' as date) +  INTERVAL '30' day)
 group by
    w."w_state",i."i_item_id"
 order by w."w_state",i."i_item_id"
 ) as tbl limit 100;
