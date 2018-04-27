
 select * from (select  i."i_item_id"
       ,i."i_item_desc"
       ,i."i_category"
       ,i."i_class"
       ,i."i_current_price"
       ,sum(cs."cs_ext_sales_price") as itemrevenue
       ,sum(cs."cs_ext_sales_price")*100/sum(sum(cs."cs_ext_sales_price")) over
           (partition by i."i_class") as revenueratio
 from   "postgrestest"."catalog_sales" cs
     ,"postgrestest"."item" i
     ,"postgrestest"."date_dim" d
 where cs."cs_item_sk" = i."i_item_sk"
   and i."i_category" in ('Jewelry', 'Sports', 'Books')
   and cs."cs_sold_date_sk" = d."d_date_sk"
 and d."d_date" between '2001-01-12'
                                and (cast('2001-01-12' as date) + INTERVAL '30' day)
 group by i."i_item_id"
         ,i."i_item_desc"
         ,i."i_category"
         ,i."i_class"
         ,i."i_current_price"
 order by i."i_category"
         ,i."i_class"
         ,i."i_item_id"
         ,i."i_item_desc"
         ,revenueratio
 )as tbl limit 100;
