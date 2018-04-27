select * from (select  i."i_item_id"
       ,i."i_item_desc"
       ,i."i_current_price"
 from "postgrestest"."item" i, "postgrestest"."inventory" inv, "postgrestest"."date_dim" d, "postgrestest"."catalog_sales" cs
 where i."i_current_price" between 22 and 22 + 30
 and inv."inv_item_sk" = i."i_item_sk"
 and d."d_date_sk"=inv."inv_date_sk"
 and d."d_date" between cast('2001-06-02' as date) and (cast('2001-06-02' as date) +  INTERVAL '60' day)
 and i."i_manufact_id" in (678,964,918,849)
 and inv."inv_quantity_on_hand" between 100 and 500
 and cs."cs_item_sk" = i."i_item_sk"
 group by i."i_item_id",i."i_item_desc",i."i_current_price"
 order by i."i_item_id"
  ) as tbl limit 100;


/*query 43 */
select * from (select  s."s_store_name", s."s_store_id",
        sum(case when (d."d_day_name"='Sunday') then ss."ss_sales_price" else null end) sun_sales,
        sum(case when (d."d_day_name"='Monday') then ss."ss_sales_price" else null end) mon_sales,
        sum(case when (d."d_day_name"='Tuesday') then ss."ss_sales_price" else  null end) tue_sales,
        sum(case when (d."d_day_name"='Wednesday') then ss."ss_sales_price" else null end) wed_sales,
        sum(case when (d."d_day_name"='Thursday') then ss."ss_sales_price" else null end) thu_sales,
        sum(case when (d."d_day_name"='Friday') then ss."ss_sales_price" else null end) fri_sales,
        sum(case when (d."d_day_name"='Saturday') then ss."ss_sales_price" else null end) sat_sales
 from "postgrestest"."date_dim" d, "postgrestest"."store_sales" ss, "postgrestest"."store" s
 where d."d_date_sk" = ss."ss_sold_date_sk" and
       s."s_store_sk" = ss."ss_store_sk" and
       s."s_gmt_offset" = -5 and
       d."d_year" = 1998
 group by s."s_store_name", s."s_store_id"
 order by s."s_store_name", s."s_store_id",sun_sales,mon_sales,tue_sales,wed_sales,thu_sales,fri_sales,sat_sales
  ) as tbl;
