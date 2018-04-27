/*query 6*/ /*gc limit exceeded*/
select * from (select  a."ca_state" state, count(*) cnt
 from "postgrestest"."customer_address" a
     ,"postgrestest"."customer" c
     ,"postgrestest"."store_sales" s
     ,"postgrestest"."date_dim" d
     ,"postgrestest"."item" i
 where       a."ca_address_sk" = c."c_current_addr_sk"
        and c."c_customer_sk" = s."ss_customer_sk"
        and s."ss_sold_date_sk" = d."d_date_sk"
        and s."ss_item_sk" = i."i_item_sk"
        and d."d_month_seq" =
             (select distinct (d."d_month_seq")
              from "postgrestest"."date_dim"
               where d."d_year" = 2000
                and d."d_moy" = 2 )
        and i."i_current_price" > 1.2 *
             (select avg(j."i_current_price")
             from "postgrestest"."item" j
             where j."i_category" = i."i_category")
 group by a."ca_state"
 having count(*) >= 10
 order by cnt, a."ca_state"
  ) as tbl;
