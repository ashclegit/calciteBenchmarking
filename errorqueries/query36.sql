select * from (select
    sum(ss."ss_net_profit")/sum(ss."ss_ext_sales_price") as gross_margin
   ,i."i_category"
   ,i."i_class"
   ,grouping(i."i_category")+grouping(i."i_class") as lochierarchy
   ,rank() over (
        partition by grouping(i."i_category")+grouping(i."i_class"),
        case when grouping(i."i_class") = 0 then i."i_category" end
        order by sum(ss."ss_net_profit")/sum(ss."ss_ext_sales_price") asc) as rank_within_parent
 from
    "postgrestest"."store_sales" ss
   ,"postgrestest"."date_dim"       d1
   ,"postgrestest"."item" i
   ,"postgrestest"."store" s
 where
    d1."d_year" = 2000
 and d1."d_date_sk" = ss."ss_sold_date_sk"
 and i."i_item_sk"  = ss."ss_item_sk"
 and s."s_store_sk"  = ss."ss_store_sk"
 and s."s_state" in ('TN','TN','TN','TN',
                 'TN','TN','TN','TN')
 group by rollup(i."i_category",i."i_class")) as tbl
 order by
   tbl.lochierarchy desc
  ,case when tbl.lochierarchy = 0 then tbl."i_category" end
  ,tbl.rank_within_parent;

