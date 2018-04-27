select * from (select  i."i_item_id",
        ca."ca_country",
        ca."ca_state",
        ca."ca_county",
        avg( cast(cs."cs_quantity" as decimal(12,2))) agg1,
        avg( cast(cs."cs_list_price" as decimal(12,2))) agg2,
        avg( cast(cs."cs_coupon_amt" as decimal(12,2))) agg3,
        avg( cast(cs."cs_sales_price" as decimal(12,2))) agg4,
        avg( cast(cs."cs_net_profit" as decimal(12,2))) agg5,
        avg( cast(c."c_birth_year" as decimal(12,2))) agg6,
        avg( cast(cd1."cd_dep_count" as decimal(12,2))) agg7
 from "postgrestest"."catalog_sales" cs, "postgrestest"."customer_demographics" cd1,
      "postgrestest"."customer_demographics" cd2, "postgrestest"."customer" c, "postgrestest"."customer_address" ca, "postgrestest"."date_dim" d, "postgrestest"."item" i
 where cs."cs_sold_date_sk" = d."d_date_sk" and
       cs."cs_item_sk" = i."i_item_sk" and
       cs."cs_bill_cdemo_sk" = cd1."cd_demo_sk" and
       cs."cs_bill_customer_sk" = c."c_customer_sk" and
       cd1."cd_gender" = 'M' and
       cd1."cd_education_status" = 'College' and
       c."c_current_cdemo_sk" = cd2."cd_demo_sk" and
       c."c_current_addr_sk" = ca."ca_address_sk" and
       c."c_birth_month" in (9,5,12,4,1,10) and
       d."d_year" = 2001 and
       ca."ca_state" in ('ND','WI','AL'
                   ,'NC','OK','MS','TN')
 group by rollup (i."i_item_id", ca."ca_country", ca."ca_state", ca."ca_county")
 order by ca."ca_country",
        ca."ca_state",
        ca."ca_county",
        i."i_item_id"
  ) as tbl;
