select * from (select  i."i_item_id"
       ,i."i_item_desc"
       ,s."s_state"
       ,count(ss."ss_quantity") as store_sales_quantitycount
       ,avg(ss."ss_quantity") as store_sales_quantityave
       ,stddev_samp(ss."ss_quantity") as store_sales_quantitystdev
       ,stddev_samp(ss."ss_quantity")/avg(ss."ss_quantity") as store_sales_quantitycov
       ,count(sr."sr_return_quantity") as store_returns_quantitycount
       ,avg(sr."sr_return_quantity") as store_returns_quantityave
       ,stddev_samp(sr."sr_return_quantity") as store_returns_quantitystdev
       ,stddev_samp(sr."sr_return_quantity")/avg(sr."sr_return_quantity") as store_returns_quantitycov
       ,count(cs."cs_quantity") as catalog_sales_quantitycount ,avg(cs."cs_quantity") as catalog_sales_quantityave
       ,stddev_samp(cs."cs_quantity") as catalog_sales_quantitystdev
       ,stddev_samp(cs."cs_quantity")/avg(cs."cs_quantity") as catalog_sales_quantitycov
 from "postgrestest"."store_sales" ss 
     ,"postgrestest"."store_returns" sr
     ,"postgrestest"."catalog_sales" cs
     ,"postgrestest"."date_dim" d1
     ,"postgrestest"."date_dim" d2
     ,"postgrestest"."date_dim" d3
     ,"postgrestest"."store" s
     ,"postgrestest"."item" i
 where d1."d_quarter_name" = '1998Q1'
   and d1."d_date_sk" = ss."ss_sold_date_sk"
   and i."i_item_sk" = ss."ss_item_sk"
   and s."s_store_sk" = ss."ss_store_sk"
   and ss."ss_customer_sk" = sr."sr_customer_sk"
   and ss."ss_item_sk" = sr."sr_item_sk"
   and ss."ss_ticket_number" = sr."sr_ticket_number"
   and sr."sr_returned_date_sk" = d2."d_date_sk"
   and d2."d_quarter_name" in ('1998Q1','1998Q2','1998Q3')
   and sr."sr_customer_sk" = cs."cs_bill_customer_sk"
   and sr."sr_item_sk" = cs."cs_item_sk"
   and cs."cs_sold_date_sk" = d3."d_date_sk"
   and d3."d_quarter_name" in ('1998Q1','1998Q2','1998Q3')
 group by i."i_item_id"
         ,i."i_item_desc"
         ,s."s_state"
 order by i."i_item_id"
         ,i."i_item_desc"
         ,s."s_state"
 ) as tbl;
