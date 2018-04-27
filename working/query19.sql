select * from (select  i."i_brand_id" brand_id, i."i_brand" brand, i."i_manufact_id", i."i_manufact",
        sum(ss."ss_ext_sales_price") ext_price
 from "postgrestest"."date_dim" d, "postgrestest"."store_sales" ss, 
 "postgrestest"."item" i,
 "postgrestest"."customer" c,
 "postgrestest"."customer_address" ca,
 "postgrestest"."store" s
 where d."d_date_sk" = ss."ss_sold_date_sk"
   and ss."ss_item_sk" = i."i_item_sk"
   and i."i_manager_id"=7
   and d."d_moy"=11
   and d."d_year"=1999
   and ss."ss_customer_sk" = c."c_customer_sk"
   and c."c_current_addr_sk" = ca."ca_address_sk"
   and substring(ca."ca_zip",1,5) <> substring(s."s_zip",1,5)
   and ss."ss_store_sk" = s."s_store_sk"
 group by i."i_brand"
      ,i."i_brand_id"
      ,i."i_manufact_id"
      ,i."i_manufact"
 order by ext_price desc
         ,i."i_brand"
         ,i."i_brand_id"
         ,i."i_manufact_id"
         ,i."i_manufact"
 ) as tbl limit 10;
