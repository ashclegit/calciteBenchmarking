select * from (select  ca."ca_zip", ca."ca_county", sum(ws."ws_sales_price")
 from "postgrestest"."web_sales" ws, "postgrestest"."customer" c, "postgrestest"."customer_address" ca, "postgrestest"."date_dim" d, "postgrestest"."item" i
 where ws."ws_bill_customer_sk" = c."c_customer_sk"
        and c."c_current_addr_sk" = ca."ca_address_sk"
        and ws."ws_item_sk" = i."i_item_sk"
        and ( substring(ca."ca_zip",1,5) in ('85669', '86197','88274','83405','86475', '85392', '85460', '80348', '81792')
              or
              i."i_item_id" in (select i."i_item_id"
                             from "postgrestest"."item"  i  --aliased  as "i"
                             where i."i_item_sk" in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29)
                             )
            )
        and ws."ws_sold_date_sk" = d."d_date_sk"
        and d."d_qoy" = 2 and d."d_year" = 2000
 group by ca."ca_zip", ca."ca_county"
 order by ca."ca_zip", ca."ca_county"
  ) as tbl;
