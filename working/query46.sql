/*long running*/
select * from (select  c."c_last_name"
       ,c."c_first_name"
       ,current_addr."ca_city"
       ,bought_city
       ,dn."ss_ticket_number"
       ,amt,profit
 from
   (select ss."ss_ticket_number"
          ,ss."ss_customer_sk"
          ,ca."ca_city" bought_city
          ,sum(ss."ss_coupon_amt") amt
          ,sum(ss."ss_net_profit") profit
    from "postgrestest"."store_sales" ss,"postgrestest"."date_dim" d,"postgrestest"."store" s,"postgrestest"."household_demographics" hd,"postgrestest"."customer_address" ca
    where ss."ss_sold_date_sk" = d."d_date_sk"
    and ss."ss_store_sk" = s."s_store_sk"
    and ss."ss_hdemo_sk" = hd."hd_demo_sk"
    and ss."ss_addr_sk" = ca."ca_address_sk"
    and (hd."hd_dep_count" = 5 or
         hd."hd_vehicle_count"= 3)
    and d."d_dow" in (6,0)
    and d."d_year" in (1999,1999+1,1999+2)
    and s."s_city" in ('Midway','Fairview','Fairview','Midway','Fairview')
    group by ss."ss_ticket_number",ss."ss_customer_sk",ss."ss_addr_sk",ca."ca_city") dn,"postgrestest"."customer" c,"postgrestest"."customer_address" current_addr
    where dn."ss_customer_sk" = c."c_customer_sk"
      and c."c_current_addr_sk" = current_addr."ca_address_sk"
      and current_addr."ca_city" <> bought_city
  order by c."c_last_name"
          ,c."c_first_name"
          ,current_addr."ca_city"
          ,bought_city
          ,dn."ss_ticket_number"
   ) as tbl;

