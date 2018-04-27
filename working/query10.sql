
select * from (select
  cd."cd_gender",
  cd."cd_marital_status",
  cd."cd_education_status",
  count(*) cnt1,
  cd."cd_purchase_estimate",
  count(*) cnt2,
  cd."cd_credit_rating",
  count(*) cnt3,
  cd."cd_dep_count",
  count(*) cnt4,
  cd."cd_dep_employed_count",
  count(*) cnt5,
  cd."cd_dep_college_count",
  count(*) cnt6
 from
  "postgrestest"."customer" c,"postgrestest"."customer_address" ca,"postgrestest"."customer_demographics" cd
 where
  c."c_current_addr_sk" = ca."ca_address_sk" and
  ca."ca_county" in ('Walker County','Richland County','Gaines County','Douglas County','Dona Ana County') and
  cd."cd_demo_sk" = c."c_current_cdemo_sk" and
  exists (select *
          from "postgrestest"."store_sales" ss,"postgrestest"."date_dim" d
          where c."c_customer_sk" = ss."ss_customer_sk" and
                ss."ss_sold_date_sk" = d."d_date_sk" and
                d."d_year" = 2002 and
                d."d_moy" between 4 and 4+3) and
   (exists (select *
            from "postgrestest"."web_sales" ws,"postgrestest"."date_dim" d
            where c."c_customer_sk" = ws."ws_bill_customer_sk" and
                  ws."ws_sold_date_sk" = d."d_date_sk" and
                  d."d_year" = 2002 and
                  d."d_moy" between 4 ANd 4+3) or
    exists (select *
            from "postgrestest"."catalog_sales" cs,"postgrestest"."date_dim" d
            where c."c_customer_sk" = cs."cs_ship_customer_sk" and
                  cs."cs_sold_date_sk" = d."d_date_sk" and
                  d."d_year" = 2002 and
                  d."d_moy" between 4 and 4+3))
 group by cd."cd_gender",
          cd."cd_marital_status",
          cd."cd_education_status",
          cd."cd_purchase_estimate",
          cd."cd_credit_rating",
          cd."cd_dep_count",
          cd."cd_dep_employed_count", 
          cd."cd_dep_college_count"
 order by cd."cd_gender",
          cd."cd_marital_status",
          cd."cd_education_status",
          cd."cd_purchase_estimate",
          cd."cd_credit_rating",
          cd."cd_dep_count",
          cd."cd_dep_employed_count",
          cd."cd_dep_college_count"
 ) as tbl;
