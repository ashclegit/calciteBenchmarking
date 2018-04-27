select * from (select  i."i_item_id",
        avg(cs."cs_quantity") agg1,
        avg(cs."cs_list_price") agg2,
        avg(cs."cs_coupon_amt") agg3,
        avg(cs."cs_sales_price") agg4
 from "postgrestest"."catalog_sales" cs, "postgrestest"."customer_demographics" cd, "postgrestest"."date_dim" d, "postgrestest"."item" i, "postgrestest"."promotion" p
 where cs."cs_sold_date_sk" = d."d_date_sk" and
       cs."cs_item_sk" = i."i_item_sk" and
       cs."cs_bill_cdemo_sk" = cd."cd_demo_sk" and
       cs."cs_promo_sk" = p."p_promo_sk" and
       cd."cd_gender" = 'F' and
       cd."cd_marital_status" = 'W' and
       cd."cd_education_status" = 'Primary' and
       (p."p_channel_email" = 'N' or p."p_channel_event" = 'N') and
       d."d_year" = 1998
 group by i."i_item_id"
 order by i."i_item_id"
  ) as tbl;
