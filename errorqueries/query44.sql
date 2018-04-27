select * from (select  asceding."RNK", i1."i_product_name" best_performing, i2."i_product_name" worst_performing
from(select *
     from (select item_sk,rank() over (order by rank_col asc) rnk
           from (select ss."ss_item_sk" item_sk,avg(ss."ss_net_profit") rank_col
                 from "postgrestest"."store_sales" ss
                 where ss."ss_store_sk" = 2
                 group by ss."ss_item_sk"
                 having avg(ss."ss_net_profit") > 0.9*(select avg(ss."ss_net_profit") rank_col
                                                  from "postgrestest"."store_sales"
                                                  where ss."ss_store_sk" = 2
                                                    and ss."ss_hdemo_sk" is null
                                                  group by ss."ss_store_sk"))V1)V11
     where rnk  < 11) asceding,
    (select *
     from (select item_sk,rank() over (order by rank_col desc) rnk
           from (select ss."ss_item_sk" item_sk,avg(ss."ss_net_profit") rank_col
                 from "postgrestest"."store_sales" ss
                 where ss."ss_store_sk" = 2
                 group by ss."ss_item_sk"
                 having avg(ss."ss_net_profit") > 0.9*(select avg(ss."ss_net_profit") rank_col
                                                  from "postgrestest"."store_sales"
                                                  where ss."ss_store_sk" = 2
                                                    and ss."ss_hdemo_sk" is null
                                                  group by ss."ss_store_sk"))V2)V21
     where rnk  < 11) descending,
"postgrestest"."item" i1,
"postgrestest"."item" i2
where asceding."RNK" = descending."RNK"
  and i1."i_item_sk"=asceding."ITEM_SK"
  and i2."i_item_sk"=descending."ITEM_SK"
order by asceding."RNK"
 ) as tbl;
