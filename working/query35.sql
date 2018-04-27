select * from (select
  ca."ca_state",
  cd."cd_gender",
  cd."cd_marital_status",
  cd."cd_dep_count",
  count(*) cnt1,
  avg(cd."cd_dep_count"),
  max(cd."cd_dep_count"),
  sum(cd."cd_dep_count"),
  cd."cd_dep_employed_count",
  count(*) cnt2,
  avg(cd."cd_dep_employed_count"),
  max(cd."cd_dep_employed_count"),
  sum(cd."cd_dep_employed_count"),
  cd."cd_dep_college_count",
  count(*) cnt3,
  avg(cd."cd_dep_college_count"),
  max(cd."cd_dep_college_count"),
  sum(cd."cd_dep_college_count")
 from
  "postgrestest"."customer" c,
  "postgrestest"."customer_address" ca,
  "postgrestest"."customer_demographics" cd
 where
  c."c_current_addr_sk" = ca."ca_address_sk" and
  cd."cd_demo_sk" = c."c_current_cdemo_sk" and
  exists (select *
          from "postgrestest"."store_sales" ss,"postgrestest"."date_dim" d
          where c."c_customer_sk" = ss."ss_customer_sk" and
                ss."ss_sold_date_sk" = d."d_date_sk" and
                d."d_year" = 1999 and
                d."d_qoy" < 4) and
   (exists (select *
            from "postgrestest"."web_sales" ws,"postgrestest"."date_dim" d
            where c."c_customer_sk" = ws."ws_bill_customer_sk" and
                  ws."ws_sold_date_sk" = d."d_date_sk" and
                  d."d_year" = 1999 and
                  d."d_qoy" < 4) or
    exists (select *
            from "postgrestest"."catalog_sales" cs,"postgrestest"."date_dim" d
            where c."c_customer_sk" = cs."cs_ship_customer_sk" and
                  cs."cs_sold_date_sk" = d."d_date_sk" and
                  d."d_year" = 1999 and
                  d."d_qoy" < 4))
 group by ca."ca_state",
          cd."cd_gender",
          cd."cd_marital_status",
          cd."cd_dep_count",
          cd."cd_dep_employed_count",
          cd."cd_dep_college_count"
 order by ca."ca_state",
          cd."cd_gender",
          cd."cd_marital_status",
          cd."cd_dep_count",
          cd."cd_dep_employed_count",
          cd."cd_dep_college_count"
  ) as tbl;
