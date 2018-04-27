 select * from (select  i."i_item_id"
      ,i."i_item_desc"
      ,i."i_category"
      ,i."i_class"
      ,i."i_current_price"
      ,sum(ws."ws_ext_sales_price") as itemrevenue
      ,sum(ws."ws_ext_sales_price")*100/sum(sum(ws."ws_ext_sales_price")) over
          (partition by i."i_class") as revenueratio
from
        "postgrestest"."web_sales" ws
        ,"postgrestest"."item" i
        ,"postgrestest"."date_dim" d
where
        ws."ws_item_sk" = i."i_item_sk"
        and i."i_category" in ('Jewelry', 'Sports', 'Books')
        and ws."ws_sold_date_sk" = d."d_date_sk"
        and d."d_date" between '2001-01-12'
                                and (CAST('2001-01-12' AS date) +  INTERVAL '30' day )
group by
        i."i_item_id"
        ,i."i_item_desc"
        ,i."i_category"
        ,i."i_class"
        ,i."i_current_price"
order by
        i."i_category"
        ,i."i_class"
        ,i."i_item_id"
        ,i."i_item_desc"
        ,revenueratio
 ) as tbl LIMIT 100;
