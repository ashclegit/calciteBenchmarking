select * from (select  dt."d_year"
       ,i."i_brand_id" brand_id
       ,i."i_brand" brand
       ,sum(ss."ss_ext_sales_price") sum_agg
 from  "postgrestest"."date_dim" dt
      ,"postgrestest"."store_sales" ss
      ,"postgrestest"."item" i
 where dt."d_date_sk" = ss."ss_sold_date_sk"
   and ss."ss_item_sk" = i."i_item_sk"
   and i."i_manufact_id" = 436
   and dt."d_moy"=12
 group by dt."d_year"
      ,i."i_brand"
      ,i."i_brand_id"
 order by dt."d_year"
         ,sum_agg desc
         ,brand_id
  ) as tbl LIMIT 100;
