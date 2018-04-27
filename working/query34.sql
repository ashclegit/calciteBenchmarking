select c."c_last_name"
       ,c."c_first_name"
       ,c."c_salutation"
       ,c."c_preferred_cust_flag"
       ,dn."ss_ticket_number"
       ,cnt from
   (select ss."ss_ticket_number"
          ,ss."ss_customer_sk"
          ,count(*) cnt
    from "postgrestest"."store_sales" ss,"postgrestest"."date_dim" d,"postgrestest"."store" s,"postgrestest"."household_demographics" hd
    where ss."ss_sold_date_sk" = d."d_date_sk"
    and ss."ss_store_sk" = s."s_store_sk"
    and ss."ss_hdemo_sk" = hd."hd_demo_sk"
    and (d."d_dom" between 1 and 3 or d."d_dom" between 25 and 28)
    and (hd."hd_buy_potential" = '>10000' or
         hd."hd_buy_potential" = 'Unknown')
    and hd."hd_vehicle_count" > 0
    and (case when hd."hd_vehicle_count" > 0
        then hd."hd_dep_count"/ hd."hd_vehicle_count"
        else null
        end)  > 1.2
    and d."d_year" in (1998,1998+1,1998+2)
    and s."s_county" in ('Williamson County','Williamson County','Williamson County','Williamson County',
                           'Williamson County','Williamson County','Williamson County','Williamson County')
    group by ss."ss_ticket_number",ss."ss_customer_sk") dn,"postgrestest"."customer" c
    where dn."ss_customer_sk" = c."c_customer_sk"
      and cnt between 15 and 20
    order by c."c_last_name",c."c_first_name",c."c_salutation",c."c_preferred_cust_flag" desc, dn."ss_ticket_number";


    /*query 38*/

    select * from (select  count(*) from (
    select distinct c."c_last_name", c."c_first_name", d."d_date"
    from "postgrestest"."store_sales" ss, "postgrestest"."date_dim" d, "postgrestest"."customer" c
          where ss."ss_sold_date_sk" = d."d_date_sk"
      and ss."ss_customer_sk" = c."c_customer_sk"
      and d."d_month_seq" between 1212 and 1212 + 11
  intersect
    select distinct c."c_last_name", c."c_first_name", d."d_date"
    from "postgrestest"."catalog_sales" cs, "postgrestest"."date_dim" d, "postgrestest"."customer" c
          where cs."cs_sold_date_sk" = d."d_date_sk"
      and cs."cs_bill_customer_sk" = c."c_customer_sk"
      and d."d_month_seq" between 1212 and 1212 + 11
  intersect
    select distinct c."c_last_name", c."c_first_name", d."d_date"
    from "postgrestest"."web_sales" ws, "postgrestest"."date_dim" d, "postgrestest"."customer" c
          where ws."ws_sold_date_sk" = d."d_date_sk"
      and ws."ws_bill_customer_sk" = c."c_customer_sk"
      and d."d_month_seq" between 1212 and 1212 + 11
) hot_cust
 ) as tbl limit 100;
