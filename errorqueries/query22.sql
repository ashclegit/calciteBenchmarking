/*query22*/ 

select * from (select  i."i_product_name"
             ,i."i_brand"
             ,i."i_class"
             ,i."i_category"
             ,avg(inv."inv_quantity_on_hand") qoh
       from "postgrestest"."inventory" inv
           ,"postgrestest"."date_dim" d
           ,"postgrestest"."item" i
       where inv."inv_date_sk"=d."d_date_sk"
              and inv."inv_item_sk"=i."i_item_sk"
              and d."d_month_seq" between 1212 and 1212 + 11
       group by rollup(i."i_product_name"
                       ,i."i_brand"
                       ,i."i_class"
                       ,i."i_category")
order by qoh, i."i_product_name", i."i_brand", i."i_class", i."i_category"
 ) as tbl;

