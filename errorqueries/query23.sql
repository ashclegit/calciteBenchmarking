with frequent_ss_items as
 (select substring(i."i_item_desc",1,30) itemdesc,i."i_item_sk" item_sk,d."d_date" solddate,count(*) cnt
  from "postgrestest"."store_sales" ss
      ,"postgrestest"."date_dim" d
      ,"postgrestest"."item" i
  where ss."ss_sold_date_sk" = d."d_date_sk"
    and ss."ss_item_sk" = i."i_item_sk"
    and d."d_year" in (1999,1999+1,1999+2,1999+3)
  group by substring(i."i_item_desc",1,30),i."i_item_sk",d."d_date"
  having count(*) >4),
 max_store_sales as
 (select max(csales) tpcds_cmax
  from (select c."c_customer_sk",sum(ss."ss_quantity"*ss."ss_sales_price") csales
        from "postgrestest"."store_sales" ss
            ,"postgrestest"."customer" c
            ,"postgrestest"."date_dim" d
        where ss."ss_customer_sk" = c."c_customer_sk"
         and ss."ss_sold_date_sk" = d."d_date_sk"
         and d."d_year" in (1999,1999+1,1999+2,1999+3)
        group by c."c_customer_sk")),
 best_ss_customer as
 (select c."c_customer_sk",sum(ss."ss_quantity"*ss."ss_sales_price") ssales
  from "postgrestest"."store_sales" ss
      ,"postgrestest"."customer" c
  where ss."ss_customer_sk" = c."c_customer_sk"
  group by c."c_customer_sk"
  having sum(ss."ss_quantity"*ss."ss_sales_price") > (95/100.0) * (select
  *
from
 max_store_sales))
 select * from ( select  sum(sales)
 from (select cs."cs_quantity"*cs."cs_list_price" sales
       from "postgrestest"."catalog_sales" cs
           ,"postgrestest"."date_dim" d
       where d."d_year" = 1999
         and d."d_moy" = 1
         and cs."cs_sold_date_sk" = d."d_date_sk"
         and cs."cs_item_sk" in (select fss."ITEM_SK" from frequent_ss_items fss)
         and cs."cs_bill_customer_sk" in (select bss."c_customer_sk" from best_ss_customer bss)
      union all
      select ws."ws_quantity"*ws."ws_list_price" sales
       from "postgrestest"."web_sales" ws
           ,"postgrestest"."date_dim" d
       where d."d_year" = 1999
         and d."d_moy" = 1
         and ws."ws_sold_date_sk" = d."d_date_sk"
         and ws."ws_item_sk" in (select fss."ITEM_SK" from frequent_ss_items fss)
         and ws."ws_bill_customer_sk" in (select bss."c_customer_sk" from best_ss_customer bss))
  );
