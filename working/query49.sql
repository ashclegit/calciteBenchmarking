select * from (select  channel, item, return_ratio, return_rank, currency_rank from
 (select
 'web' as channel
 ,web."ITEM"
 ,web."RETURN_RATIO"
 ,web."RETURN_RANK"
 ,web."CURRENCY_RANK"
 from (
        select
         item
        ,return_ratio
        ,currency_ratio
        ,rank() over (order by return_ratio) as return_rank
        ,rank() over (order by currency_ratio) as currency_rank
        from
        (       select ws."ws_item_sk" as item
                ,(cast(sum(coalesce(wr."wr_return_quantity",0)) as decimal(15,4))/
                cast(sum(coalesce(ws."ws_quantity",0)) as decimal(15,4) )) as return_ratio
                ,(cast(sum(coalesce(wr."wr_return_amt",0)) as decimal(15,4))/
                cast(sum(coalesce(ws."ws_net_paid",0)) as decimal(15,4) )) as currency_ratio
                from
                 "postgrestest"."web_sales" ws left outer join "postgrestest"."web_returns" wr
                        on (ws."ws_order_number" = wr."wr_order_number" and
                        ws."ws_item_sk" = wr."wr_item_sk")
                 ,"postgrestest"."date_dim" d
                where
                        wr."wr_return_amt" > 10000
                        and ws."ws_net_profit" > 1
                         and ws."ws_net_paid" > 0
                         and ws."ws_quantity" > 0
                         and ws."ws_sold_date_sk" = d."d_date_sk"
                         and d."d_year" = 2000
                         and d."d_moy" = 12
                group by ws."ws_item_sk"
        ) in_web
 ) web
 where
 (
 web."RETURN_RANK" <= 10
 or
 web."CURRENCY_RANK" <= 10
 )
 union
  select
 'catalog' as channel
 ,catalog."ITEM"
 ,catalog."RETURN_RATIO"
 ,catalog."RETURN_RANK"
 ,catalog."CURRENCY_RANK"
 from (
        select
         item
        ,return_ratio
        ,currency_ratio
        ,rank() over (order by return_ratio) as return_rank
        ,rank() over (order by currency_ratio) as currency_rank
        from
        (       select cs."cs_item_sk" as item
                ,(cast(sum(coalesce(cr."cr_return_quantity",0)) as decimal(15,4))/
                cast(sum(coalesce(cs."cs_quantity",0)) as decimal(15,4) )) as return_ratio
                ,(cast(sum(coalesce(cr."cr_return_amount",0)) as decimal(15,4))/
                cast(sum(coalesce(cs."cs_net_paid",0)) as decimal(15,4) )) as currency_ratio
                from
                 "postgrestest"."catalog_sales" cs left outer join "postgrestest"."catalog_returns" cr
                        on (cs."cs_order_number" = cr."cr_order_number" and
                        cs."cs_item_sk" = cr."cr_item_sk")
                 ,"postgrestest"."date_dim" d
                where
                        cr."cr_return_amount" > 10000
                        and cs."cs_net_profit" > 1
                         and cs."cs_net_paid" > 0
                         and cs."cs_quantity" > 0
                         and cs."cs_sold_date_sk" = d."d_date_sk"
                         and d."d_year" = 2000
                         and d."d_moy" = 12
                group by cs."cs_item_sk"
        ) in_cat
 ) catalog
 where
 (
 catalog."RETURN_RANK" <= 10
 or
 catalog."CURRENCY_RANK" <= 10
 )
 union
 select
 'store' as channel
 ,store."ITEM"
 ,store."RETURN_RATIO"
 ,store."RETURN_RANK"
 ,store."CURRENCY_RANK"
 from (
        select
         item
        ,return_ratio
        ,currency_ratio
        ,rank() over (order by return_ratio) as return_rank
        ,rank() over (order by currency_ratio) as currency_rank
        from
        (       select sts."ss_item_sk" as item
                ,(cast(sum(coalesce(sr."sr_return_quantity",0)) as decimal(15,4))/cast(sum(coalesce(sts."ss_quantity",0)) as decimal(15,4) )) as return_ratio
                ,(cast(sum(coalesce(sr."sr_return_amt",0)) as decimal(15,4))/cast(sum(coalesce(sts."ss_net_paid",0)) as decimal(15,4) )) as currency_ratio
                from
                "postgrestest"."store_sales" sts left outer join "postgrestest"."store_returns" sr
                        on (sts."ss_ticket_number" = sr."sr_ticket_number" and sts."ss_item_sk" = sr."sr_item_sk")
                ,"postgrestest"."date_dim" d
                where
                        sr."sr_return_amt" > 10000
                        and sts."ss_net_profit" > 1
                         and sts."ss_net_paid" > 0
                         and sts."ss_quantity" > 0
                         and sts."ss_sold_date_sk" = d."d_date_sk"
                         and d."d_year" = 2000
                         and d."d_moy" = 12
                group by sts."ss_item_sk"
        ) in_store
 ) store
 where  (
 store."RETURN_RANK" <= 10
 or
  store."CURRENCY_RANK" <= 10
 )
 ) as innertbl
 order by 1,4,5,2
  ) as tbl;
