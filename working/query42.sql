/*query 42*/
select * from (select  d."d_year"
        ,i."i_category_id"
        ,i."i_category"
        ,sum(ss."ss_ext_sales_price")
 from   "postgrestest"."date_dim" d
        ,"postgrestest"."store_sales" ss
        ,"postgrestest"."item" i 
 where d."d_date_sk" = ss."ss_sold_date_sk"
        and ss."ss_item_sk" = i."i_item_sk"
        and i."i_manager_id" = 1
        and d."d_moy"=12
        and d."d_year"=1998
 group by       d."d_year"
                ,i."i_category_id"
                ,i."i_category"
 order by       sum(ss."ss_ext_sales_price") desc,d."d_year"
                ,i."i_category_id"
                ,i."i_category"
 ) as tbl;
