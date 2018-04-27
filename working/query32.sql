select * from (select  sum(cs."cs_ext_discount_amt")  as "excess discount amount"
from
   "postgrestest"."catalog_sales" cs
   ,"postgrestest"."item" i
   ,"postgrestest"."date_dim" d
where
i."i_manufact_id" = 269
and i."i_item_sk" = cs."cs_item_sk"
and d."d_date" between '1998-03-18' and
        (cast('1998-03-18' as date ) + INTERVAL '90' day)
and d."d_date_sk" = cs."cs_sold_date_sk"
and cs."cs_ext_discount_amt"
     > (
         select
            1.3 * avg(cs."cs_ext_discount_amt")
         from
            "postgrestest"."catalog_sales" cs
           ,"postgrestest"."date_dim" d
         where
              cs."cs_item_sk" = i."i_item_sk"
          and d."d_date" between '1998-03-18' and
                             (cast('1998-03-18' as date) + INTERVAL '90' day)
          and d."d_date_sk" = cs."cs_sold_date_sk"
      )
 ) as tbl limit 100;
