select * from (select
   s."s_store_name"
  ,s."s_company_id"
  ,s."s_street_number"
  ,s."s_street_name"
  ,s."s_street_type"
  ,s."s_suite_number"
  ,s."s_city"
  ,s."s_county"
  ,s."s_state"
  ,s."s_zip"
  ,sum(case when (sr."sr_returned_date_sk" - ss."ss_sold_date_sk" <= 30 ) then 1 else 0 end)  as "30 days"
  ,sum(case when (sr."sr_returned_date_sk" - ss."ss_sold_date_sk" > 30) and
                 (sr."sr_returned_date_sk" - ss."ss_sold_date_sk" <= 60) then 1 else 0 end )  as "31-60 days"
  ,sum(case when (sr."sr_returned_date_sk" - ss."ss_sold_date_sk" > 60) and
                 (sr."sr_returned_date_sk" - ss."ss_sold_date_sk" <= 90) then 1 else 0 end)  as "61-90 days"
  ,sum(case when (sr."sr_returned_date_sk" - ss."ss_sold_date_sk" > 90) and
                 (sr."sr_returned_date_sk" - ss."ss_sold_date_sk" <= 120) then 1 else 0 end)  as "91-120 days"
  ,sum(case when (sr."sr_returned_date_sk" - ss."ss_sold_date_sk"  > 120) then 1 else 0 end)  as ">120 days"
from
   "postgrestest"."store_sales" ss
  ,"postgrestest"."store_returns" sr
  ,"postgrestest"."store" s
  ,"postgrestest"."date_dim" d1
  ,"postgrestest"."date_dim" d2
where
    d2."d_year" = 2000
and d2."d_moy"  = 9
and ss."ss_ticket_number" = sr."sr_ticket_number"
and ss."ss_item_sk" = sr."sr_item_sk"
and ss."ss_sold_date_sk"   = d1."d_date_sk"
and sr."sr_returned_date_sk"   = d2."d_date_sk"
and ss."ss_customer_sk" = sr."sr_customer_sk"
and ss."ss_store_sk" = s."s_store_sk"
group by
   s."s_store_name"
  ,s."s_company_id"
  ,s."s_street_number"
  ,s."s_street_name"
  ,s."s_street_type"
  ,s."s_suite_number"
  ,s."s_city"
  ,s."s_county"
  ,s."s_state"
  ,s."s_zip"
order by s."s_store_name"
  ,s."s_company_id"
  ,s."s_street_number"
  ,s."s_street_name"
  ,s."s_street_type"
  ,s."s_suite_number"
  ,s."s_city"
  ,s."s_county"
  ,s."s_state"
  ,s."s_zip"
 ) as tbl;
