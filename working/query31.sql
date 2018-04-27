/*query 31*/ /*long running*/
 with ss as
 (select ca."ca_county",d."d_qoy", d."d_year",sum(ss."ss_ext_sales_price") as store_sales
 from "postgrestest"."store_sales" ss,"postgrestest"."date_dim" d,"postgrestest"."customer_address" ca
 where ss."ss_sold_date_sk" = d."d_date_sk"
  and ss."ss_addr_sk"=ca."ca_address_sk"
 group by ca."ca_county",d."d_qoy", d."d_year"),
 ws as
 (select ca."ca_county",d."d_qoy", d."d_year",sum(ws."ws_ext_sales_price") as web_sales
 from "postgrestest"."web_sales" ws,"postgrestest"."date_dim" d,"postgrestest"."customer_address" ca
 where ws."ws_sold_date_sk" = d."d_date_sk"
  and ws."ws_bill_addr_sk"=ca."ca_address_sk"
 group by ca."ca_county",d."d_qoy", d."d_year")
 select
        ss1."ca_county"
       ,ss1."d_year"
       ,ws2."WEB_SALES"/ws1."WEB_SALES" web_q1_q2_increase
       ,ss2."STORE_SALES"/ss1."STORE_SALES" store_q1_q2_increase
       ,ws3."WEB_SALES"/ws2."WEB_SALES" web_q2_q3_increase
       ,ss3."STORE_SALES"/ss2."STORE_SALES" store_q2_q3_increase
 from
        ss ss1
       ,ss ss2
       ,ss ss3
       ,ws ws1
       ,ws ws2
       ,ws ws3
 where
    ss1."d_qoy" = 1
    and ss1."d_year" = 2000
    and ss1."ca_county" = ss2."ca_county"
    and ss2."d_qoy" = 2
    and ss2."d_year" = 2000
 and ss2."ca_county" = ss3."ca_county"
    and ss3."d_qoy" = 3
    and ss3."d_year" = 2000
    and ss1."ca_county" = ws1."ca_county"
    and ws1."d_qoy" = 1
    and ws1."d_year" = 2000
    and ws1."ca_county" = ws2."ca_county"
    and ws2."d_qoy" = 2
    and ws2."d_year" = 2000
    and ws1."ca_county" = ws3."ca_county"
    and ws3."d_qoy" = 3
    and ws3."d_year" =2000
    and case when ws1."WEB_SALES" > 0 then ws2."WEB_SALES"/ws1."WEB_SALES" else null end
       > case when ss1."STORE_SALES" > 0 then ss2."STORE_SALES"/ss1."STORE_SALES" else null end
    and case when ws2."WEB_SALES" > 0 then ws3."WEB_SALES"/ws2."WEB_SALES" else null end
       > case when ss2."STORE_SALES" > 0 then ss3."STORE_SALES"/ss2."STORE_SALES" else null end
 order by ss1."d_year";
