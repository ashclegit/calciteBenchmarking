with ssr as
 (select s."s_store_id",
        sum(sales_price) as sales,
        sum(profit) as profit,
        sum(return_amt) as returns_amt,
        sum(net_loss) as profit_loss
 from
  ( select  ss."ss_store_sk" as store_sk,
            ss."ss_sold_date_sk"  as date_sk,
            ss."ss_ext_sales_price" as sales_price,
            ss."ss_net_profit" as profit,
            cast(0 as decimal(7,2)) as return_amt,
            cast(0 as decimal(7,2)) as net_loss
    from "postgrestest"."store_sales" ss
    union all
    select sr."sr_store_sk" as store_sk,
           sr."sr_returned_date_sk" as date_sk,
           cast(0 as decimal(7,2)) as sales_price,
           cast(0 as decimal(7,2)) as profit,
           sr."sr_return_amt" as return_amt,
           sr."sr_net_loss" as net_loss
    from "postgrestest"."store_returns" sr 
   ) salesreturns,
     "postgrestest"."date_dim" d,
     "postgrestest"."store" s
 where date_sk = d."d_date_sk"
       and d."d_date" between '1998-08-04'
                  and (CAST('1998-08-04' AS date) +  INTERVAL '14' day)
       and store_sk = s."s_store_sk"
 group by s."s_store_id")
 ,
 csr as
 (select cp."cp_catalog_page_id",
        sum(sales_price) as sales,
        sum(profit) as profit,
        sum(return_amt) as returns_amt,
        sum(net_loss) as profit_loss
 from
  ( select  cs."cs_catalog_page_sk" as page_sk,
            cs."cs_sold_date_sk"  as date_sk,
            cs."cs_ext_sales_price" as sales_price,
            cs."cs_net_profit" as profit,
            cast(0 as decimal(7,2)) as return_amt,
            cast(0 as decimal(7,2)) as net_loss
    from "postgrestest"."catalog_sales" cs
    union all
    select cr."cr_catalog_page_sk" as page_sk,
           cr."cr_returned_date_sk" as date_sk,
           cast(0 as decimal(7,2)) as sales_price,
           cast(0 as decimal(7,2)) as profit,
           cr."cr_return_amount" as return_amt,
           cr."cr_net_loss" as net_loss
    from "postgrestest"."catalog_returns" cr
   ) salesreturns,
     "postgrestest"."date_dim" d,
     "postgrestest"."catalog_page" cp
 where date_sk = d."d_date_sk"
       and d."d_date" between '1998-08-04'
                  and (CAST('1998-08-04' AS date) + INTERVAL '14' day)
       and page_sk = cp."cp_catalog_page_sk"
       group by cp."cp_catalog_page_id")
 ,
 wsr as
 (select web."web_site_id",
        sum(sales_price) as sales,
        sum(profit) as profit,
        sum(return_amt) as returns_amt,
        sum(net_loss) as profit_loss
 from
  ( select  ws."ws_web_site_sk" as wsr_web_site_sk,
            ws."ws_sold_date_sk"  as date_sk,
            ws."ws_ext_sales_price" as sales_price,
            ws."ws_net_profit" as profit,
            cast(0 as decimal(7,2)) as return_amt,
            cast(0 as decimal(7,2)) as net_loss
    from "postgrestest"."web_sales" ws
    union all
    select ws."ws_web_site_sk" as wsr_web_site_sk,
           wr."wr_returned_date_sk" as date_sk,
           cast(0 as decimal(7,2)) as sales_price,
           cast(0 as decimal(7,2)) as profit,
           wr."wr_return_amt" as return_amt,
           wr."wr_net_loss" as net_loss
    from "postgrestest"."web_returns" wr left outer join "postgrestest"."web_sales" ws on
         ( wr."wr_item_sk" = ws."ws_item_sk"
           and wr."wr_order_number" = ws."ws_order_number")
   ) salesreturns,
     "postgrestest"."date_dim" d,
     "postgrestest"."web_site" web
 where date_sk = d."d_date_sk"
       and d."d_date" between '1998-08-04'
                  and (CAST('1998-08-04' AS date) + INTERVAL '14' day)
       and wsr_web_site_sk = web."web_site_sk"
 group by web."web_site_id")
 select * from ( select  channel
        , id
        , sum(sales) as sales
        , sum(returns_amt) as returns_amt1
        , sum(profit) as profit
 from
 (select 'store channel' as channel
        , 'store' || "s_store_id" as id
        , sales
        , returns_amt
        , (profit - profit_loss) as profit
 from   ssr
 union all
 select 'catalog channel' as channel
        , 'catalog_page' || "cp_catalog_page_id" as id
        , sales
        , returns_amt
        , (profit - profit_loss) as profit
 from  csr
 union all
 select 'web channel' as channel
        , 'web_site' || "web_site_id" as id
        , sales
        , returns_amt
        , (profit - profit_loss) as profit
 from   wsr
 ) x
  group by rollup (channel, id)
 order by channel
         ,id
  ) as tbl; 
