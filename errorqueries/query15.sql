select * from (select  c."ca_zip"
       ,sum(a."cs_sales_price") 
 from "postgrestest"."catalog_sales" a
     ,"postgrestest"."customer" b
     ,"postgrestest"."customer_address" c
     ,"postgrestest"."date_dim" d
 where a."cs_bill_customer_sk" = b."c_customer_sk"
        and b."c_current_addr_sk" = c."ca_address_sk"
        and ( substring(c."ca_zip",1,5) in ('85669', '86197','88274','83405','86475',
                                   '85392', '85460', '80348', '81792')
              or c."ca_state" in ('CA','WA','GA')
              or a."cs_sales_price" > 500)
        and a."cs_sold_date_sk" = d."d_date_sk"
        and d."d_qoy" = 2 and d."d_year" = 2000
 group by c."ca_zip"
 order by c."ca_zip"
  ) as tbl;

