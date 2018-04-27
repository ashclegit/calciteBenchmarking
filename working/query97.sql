-- start query 97 in stream 0 using template query97.tpl
--\timing on

with ssci as (
select "ss_customer_sk" CUSTOMER_SK
      ,"ss_item_sk" ITEM_SK
from "store_sales","date_dim"
where "ss_sold_date_sk" = "d_date_sk"
  and "d_month_seq" between 1208 and 1208 + 11
group by "ss_customer_sk"
        ,"ss_item_sk"),
csci as(
 select "cs_bill_customer_sk" CUSTOMER_SK
      ,"cs_item_sk" ITEM_SK
from "catalog_sales","date_dim"
where "cs_sold_date_sk" = "d_date_sk"
  and "d_month_seq" between 1208 and 1208 + 11
group by "cs_bill_customer_sk"
        ,"cs_item_sk")
 select  sum(case when ssci.CUSTOMER_SK is not null and csci.CUSTOMER_SK is null then 1 else 0 end) store_only
      ,sum(case when ssci.CUSTOMER_SK is null and csci.CUSTOMER_SK is not null then 1 else 0 end) catalog_only
      ,sum(case when ssci.CUSTOMER_SK is not null and csci.CUSTOMER_SK is not null then 1 else 0 end) store_and_catalog
from ssci full outer join csci on (ssci.CUSTOMER_SK=csci.CUSTOMER_SK
                               and ssci.ITEM_SK = csci.ITEM_SK)
limit 100;

--\timing off
-- end query 97 in stream 0 using template query97.tpl
-- done
