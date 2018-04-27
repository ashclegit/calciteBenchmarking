with year_total as (
 select c."c_customer_id" customer_id
       ,c."c_first_name" customer_first_name
       ,c."c_last_name" customer_last_name
       ,c."c_preferred_cust_flag" customer_preferred_cust_flag
       ,c."c_birth_country" customer_birth_country
       ,c."c_login" customer_login
       ,c."c_email_address" customer_email_address
       ,d."d_year" dyear
       ,sum(ss."ss_ext_list_price"-ss."ss_ext_discount_amt") year_total
       ,'s' sale_type
 from "postgrestest"."customer" c
     ,"postgrestest"."store_sales" ss
     ,"postgrestest"."date_dim" d
 where c."c_customer_sk" = ss."ss_customer_sk"
   and ss."ss_sold_date_sk" = d."d_date_sk"
 group by c."c_customer_id"
         ,c."c_first_name"
         ,c."c_last_name"
         ,c."c_preferred_cust_flag"
         ,c."c_birth_country"
         ,c."c_login"
         ,c."c_email_address"
         ,d."d_year"
 union all
 select c."c_customer_id" customer_id
       ,c."c_first_name" customer_first_name
       ,c."c_last_name" customer_last_name
       ,c."c_preferred_cust_flag" customer_preferred_cust_flag
       ,c."c_birth_country" customer_birth_country
       ,c."c_login" customer_login
       ,c."c_email_address" customer_email_address
       ,d."d_year" dyear
       ,sum(ws."ws_ext_list_price"-ws."ws_ext_discount_amt") year_total
       ,'w' sale_type
 from "postgrestest"."customer" c
     ,"postgrestest"."web_sales" ws
     ,"postgrestest"."date_dim" d
 where c."c_customer_sk" = ws."ws_bill_customer_sk"
   and ws."ws_sold_date_sk" = d."d_date_sk"
 group by c."c_customer_id"
         ,c."c_first_name"
         ,c."c_last_name"
         ,c."c_preferred_cust_flag"
         ,c."c_birth_country"
         ,c."c_login"
         ,c."c_email_address"
         ,d."d_year"
         )
 select * from ( select
                  t_s_secyear.customer_id
                 ,t_s_secyear.customer_first_name
                 ,t_s_secyear.customer_last_name 
                 ,t_s_secyear.customer_email_address
 from year_total t_s_firstyear
     ,year_total t_s_secyear
     ,year_total t_w_firstyear
     ,year_total t_w_secyear
 where t_s_secyear.customer_id = t_s_firstyear.customer_id
         and t_s_firstyear.customer_id = t_w_secyear.customer_id
         and t_s_firstyear.customer_id = t_w_firstyear.customer_id
         and t_s_firstyear.sale_type = 's'
         and t_w_firstyear.sale_type = 'w'
         and t_s_secyear.sale_type = 's'
         and t_w_secyear.sale_type = 'w'
         and t_s_firstyear.dyear = 2001
         and t_s_secyear.dyear = 2001+1
         and t_w_firstyear.dyear = 2001
         and t_w_secyear.dyear = 2001+1
         and t_s_firstyear.year_total > 0
         and t_w_firstyear.year_total > 0
         and case when t_w_firstyear.year_total > 0 then t_w_secyear.year_total / t_w_firstyear.year_total else 0.0 end
             > case when t_s_firstyear.year_total > 0 then t_s_secyear.year_total / t_s_firstyear.year_total else 0.0 end
 order by t_s_secyear.customer_id
         ,t_s_secyear.customer_first_name
         ,t_s_secyear.customer_last_name
         ,t_s_secyear.customer_email_address
 ) as tbl;
