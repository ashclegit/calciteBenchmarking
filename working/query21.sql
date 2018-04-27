select * from (select  *
 from(select w."w_warehouse_name"
            ,i."i_item_id"
            ,sum(case when (cast(d."d_date" as date) < cast ('1998-04-08' as date))
                        then inv."inv_quantity_on_hand"
                      else 0 end) as inv_before
            ,sum(case when (cast(d."d_date" as date) >= cast ('1998-04-08' as date))
                      then inv."inv_quantity_on_hand"
                      else 0 end) as inv_after
   from "postgrestest"."inventory" inv
       ,"postgrestest"."warehouse" w
       ,"postgrestest"."item" i
       ,"postgrestest"."date_dim" d
   where i."i_current_price" between 0.99 and 1.49
     and i."i_item_sk"          = inv."inv_item_sk"
     and inv."inv_warehouse_sk"   = w."w_warehouse_sk"
     and inv."inv_date_sk"    = d."d_date_sk"
     and d."d_date" between (cast ('1998-04-08' as date) -  INTERVAL '30' day)
                    and (cast ('1998-04-08' as date) +  INTERVAL '30' day)
   group by w."w_warehouse_name", i."i_item_id") x
 where (case when inv_before > 0
             then inv_after / inv_before
             else null
             end) between 2.0/3.0 and 3.0/2.0
 order by x."w_warehouse_name"
         ,x."i_item_id"
  ) as tbl limit 100;
