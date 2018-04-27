with customer_total_return as
 (select wr."wr_returning_customer_sk" as ctr_customer_sk
        ,ca."ca_state" as ctr_state,
        sum(wr."wr_return_amt") as ctr_total_return
 from "postgrestest"."web_returns" wr
     ,"postgrestest"."date_dim" d
     ,"postgrestest"."customer_address" ca
 where wr."wr_returned_date_sk" = d."d_date_sk"
   and d."d_year" =2002
   and wr."wr_returning_addr_sk" = ca."ca_address_sk"
 group by wr."wr_returning_customer_sk"
         ,ca."ca_state")
 select * from ( select  c."c_customer_id",c."c_salutation",c."c_first_name",c."c_last_name",c."c_preferred_cust_flag"
       ,c."c_birth_day",c."c_birth_month",c."c_birth_year",c."c_birth_country",c."c_login",c."c_email_address"
       ,c."c_last_review_date_sk",ctr_total_return
 from customer_total_return ctr1
     ,"postgrestest"."customer_address" ca
     ,"postgrestest"."customer" c
 where ctr1.ctr_total_return > (select avg(ctr_total_return)*1.2
                          from customer_total_return ctr2
                          where ctr1.ctr_state = ctr2.ctr_state)
       and ca."ca_address_sk" = c."c_current_addr_sk"
       and ca."ca_state" = 'IL'
       and ctr1.ctr_customer_sk = c."c_customer_sk"
 order by c."c_customer_id",c."c_salutation",c."c_first_name",c."c_last_name",c."c_preferred_cust_flag"
                  ,c."c_birth_day",c."c_birth_month",c."c_birth_year",c."c_birth_country",c."c_login",c."c_email_address"
                  ,c."c_last_review_date_sk",ctr_total_return
 ) as tbl;
