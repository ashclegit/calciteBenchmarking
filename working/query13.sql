/*insuffecient OS memory*/
select avg(ss."ss_quantity")
       ,avg(ss."ss_ext_sales_price")
       ,avg(ss."ss_ext_wholesale_cost")
       ,sum(ss."ss_ext_wholesale_cost")
 from "postgrestest"."store_sales" ss
     ,"postgrestest"."store" s
     ,"postgrestest"."customer_demographics" cd
     ,"postgrestest"."household_demographics" hd
     ,"postgrestest"."customer_address" ca
     ,"postgrestest"."date_dim" d
 where s."s_store_sk" = ss."ss_store_sk"
 and  ss."ss_sold_date_sk" = d."d_date_sk" and d."d_year" = 2001
 and((ss."ss_hdemo_sk"=hd."hd_demo_sk"
  and cd."cd_demo_sk" = ss."ss_cdemo_sk"
  and cd."cd_marital_status" = 'D'
  and cd."cd_education_status" = '2 yr Degree'
  and ss."ss_sales_price" between 100.00 and 150.00
  and hd."hd_dep_count" = 3
     )or
     (ss."ss_hdemo_sk"=hd."hd_demo_sk"
  and cd."cd_demo_sk" = ss."ss_cdemo_sk"
  and cd."cd_marital_status" = 'S'
  and cd."cd_education_status" = 'Secondary'
  and ss."ss_sales_price" between 50.00 and 100.00
  and hd."hd_dep_count" = 1
     ) or
     (ss."ss_hdemo_sk"=hd."hd_demo_sk"
  and cd."cd_demo_sk" = ss."ss_cdemo_sk"
  and cd."cd_marital_status" = 'W'
  and cd."cd_education_status" = 'Advanced Degree'
  and ss."ss_sales_price" between 150.00 and 200.00
  and hd."hd_dep_count" = 1
     ))
 and((ss."ss_addr_sk" = ca."ca_address_sk"
  and ca."ca_country" = 'United States'
  and ca."ca_state" in ('CO', 'IL', 'MN')
  and ss."ss_net_profit" between 100 and 200
     ) or
     (ss."ss_addr_sk" = ca."ca_address_sk"
  and ca."ca_country" = 'United States'
  and ca."ca_state" in ('OH', 'MT', 'NM')
  and ss."ss_net_profit" between 150 and 300  
     ) or
     (ss."ss_addr_sk" = ca."ca_address_sk"
  and ca."ca_country" = 'United States'
  and ca."ca_state" in ('TX', 'MO', 'MI')
  and ss."ss_net_profit" between 50 and 250
     ));
