with inv as
(select foo."w_warehouse_name",foo."w_warehouse_sk",foo."i_item_sk",foo."d_moy"
       ,stdev,mean, case mean when 0 then null else stdev/mean end cov
 from(select w."w_warehouse_name",w."w_warehouse_sk",i."i_item_sk",d."d_moy"
            ,stddev_samp(inv."inv_quantity_on_hand") stdev,avg(inv."inv_quantity_on_hand") mean
      from "postgrestest"."inventory" inv
          ,"postgrestest"."item" i
          ,"postgrestest"."warehouse" w
          ,"postgrestest"."date_dim" d
      where inv."inv_item_sk" = i."i_item_sk"
        and inv."inv_warehouse_sk" = w."w_warehouse_sk"
        and inv."inv_date_sk" = d."d_date_sk"
        and d."d_year" =1998
      group by w."w_warehouse_name",w."w_warehouse_sk",i."i_item_sk",d."d_moy") foo
 where case mean when 0 then 0 else stdev/mean end > 1)
select inv1."w_warehouse_sk",inv1."i_item_sk",inv1."d_moy",inv1."MEAN", inv1."COV"
        ,inv2."w_warehouse_sk",inv2."i_item_sk",inv2."d_moy",inv2."MEAN", inv2."COV"
from inv inv1,inv inv2
where inv1."i_item_sk" = inv2."i_item_sk"
  and inv1."w_warehouse_sk" =  inv2."w_warehouse_sk"
  and inv1."d_moy"=4
  and inv2."d_moy"=4+1
order by inv1."w_warehouse_sk",inv1."i_item_sk",inv1."d_moy",inv1."MEAN",inv1."COV"
        ,inv2."d_moy",inv2."MEAN", inv2."COV"
;
