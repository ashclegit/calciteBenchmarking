with ssales as
(select c."c_last_name"
      ,c."c_first_name"
      ,s."s_store_name"
      ,ca."ca_state"
      ,s."s_state"
      ,i."i_color"
      ,i."i_current_price"
      ,i."i_manager_id"
      ,i."i_units"
      ,i."i_size"
      ,sum(ss."ss_sales_price") netpaid
from "postgrestest"."store_sales" ss
    ,"postgrestest"."store_returns" sr
    ,"postgrestest"."store" s
    ,"postgrestest"."item" i
    ,"postgrestest"."customer" c
    ,"postgrestest"."customer_address" ca
where ss."ss_ticket_number" = sr."sr_ticket_number"
  and ss."ss_item_sk" = sr."sr_item_sk"
  and ss."ss_customer_sk" = c."c_customer_sk"
  and ss."ss_item_sk" = i."i_item_sk"
  and ss."ss_store_sk" = s."s_store_sk"
  and c."c_current_addr_sk" = ca."ca_address_sk"
  and c."c_birth_country" <> upper(ca."ca_country")
  and s."s_zip" = ca."ca_zip"
and s."s_market_id"=7
group by c."c_last_name"
        ,c."c_first_name"
        ,s."s_store_name"
        ,ca."ca_state"
        ,s."s_state"
        ,i."i_color"
        ,i."i_current_price"
        ,i."i_manager_id"
        ,i."i_units"
        ,i."i_size")
select ssales."c_last_name"
      ,ssales."c_first_name"
      ,ssales."s_store_name"
      ,sum(netpaid) paid
from ssales
where ssales."i_color" = 'orchid'
group by ssales."c_last_name"
        ,ssales."c_first_name"
        ,ssales."s_store_name"
having sum(netpaid) > (select 0.05*avg(netpaid)
                                 from ssales)
order by ssales."c_last_name"
        ,ssales."c_first_name"
        ,ssales."s_store_name"
;

with ssales as
(select c."c_last_name"
      ,c."c_first_name"
      ,s."s_store_name"
      ,ca."ca_state"
      ,s."s_state"
      ,i."i_color"
      ,i."i_current_price"
      ,i."i_manager_id"
      ,i."i_units"
      ,i."i_size"
      ,sum(ss."ss_sales_price") netpaid
from "postgrestest"."store_sales" ss
    ,"postgrestest"."store_returns" sr
    ,"postgrestest"."store" s
    ,"postgrestest"."item" i
    ,"postgrestest"."customer" c
    ,"postgrestest"."customer_address" ca
where ss."ss_ticket_number" = sr."sr_ticket_number"
  and ss."ss_item_sk" = sr."sr_item_sk"
  and ss."ss_customer_sk" = c."c_customer_sk"
  and ss."ss_item_sk" = i."i_item_sk"
  and ss."ss_store_sk" = s."s_store_sk"
  and c."c_current_addr_sk" = ca."ca_address_sk"
  and c."c_birth_country" <> upper(ca."ca_country")
  and s."s_zip" = ca."ca_zip"
and s."s_market_id"=7
group by c."c_last_name"
        ,c."c_first_name"
        ,s."s_store_name"
        ,ca."ca_state"
        ,s."s_state"
        ,i."i_color"
        ,i."i_current_price"
        ,i."i_manager_id"
        ,i."i_units"
        ,i."i_size")
select ssales."c_last_name"
      ,ssales."c_first_name"
      ,ssales."s_store_name"
      ,sum(netpaid) paid
from ssales
where ssales."i_color" = 'chiffon'
group by ssales."c_last_name"
        ,ssales."c_first_name"
        ,ssales."s_store_name"
having sum(netpaid) > (select 0.05*avg(netpaid)
                                 from ssales)
order by ssales."c_last_name"
        ,ssales."c_first_name"
        ,ssales."s_store_name"
;

