with customer_total_return as
(select sr."sr_customer_sk" as ctr_customer_sk
,sr."sr_store_sk" as ctr_store_sk
,sum(sr."sr_fee") as ctr_total_return
from "postgrestest"."store_returns" sr
,"postgrestest"."date_dim" d
where sr."sr_returned_date_sk" = d."d_date_sk"
and d."d_year" =2000
group by sr."sr_customer_sk"
,sr."sr_store_sk")
select * from ( select  c."c_customer_id"
from customer_total_return ctr1
,"postgrestest"."store" s
,"postgrestest"."customer" c
where ctr1.ctr_total_return > (select avg(ctr_total_return)*1.2
from customer_total_return ctr2
where ctr1.ctr_store_sk = ctr2.ctr_store_sk)
and s."s_store_sk" = ctr1.ctr_store_sk
and s."s_state" = 'TN'
and ctr1.ctr_customer_sk = c."c_customer_sk"
order by c."c_customer_id"
 ) as tbl;
