 with v1 as(
 select i."i_category", i."i_brand",
        s."s_store_name", s."s_company_name",
        d."d_year", d."d_moy",
        sum(ss."ss_sales_price") sum_sales,
        avg(sum(ss."ss_sales_price")) over
          (partition by i."i_category", i."i_brand",
                     s."s_store_name", s."s_company_name", d."d_year")
          avg_monthly_sales,
        rank() over
          (partition by i."i_category", i."i_brand",
                     s."s_store_name", s."s_company_name"
           order by d."d_year", d."d_moy") rn
 from "postgrestest"."item" i , "postgrestest"."store_sales" ss, "postgrestest"."date_dim" d, "postgrestest"."store" s
 where ss."ss_item_sk" = i."i_item_sk" and
       ss."ss_sold_date_sk" = d."d_date_sk" and
       ss."ss_store_sk" = s."s_store_sk" and
       (
         d."d_year" = 2000 or
         ( d."d_year" = 2000-1 and d."d_moy" =12) or
         ( d."d_year" = 2000+1 and d."d_moy" =1)
       )
 group by i."i_category", i."i_brand",
          s."s_store_name", s."s_company_name",
          d."d_year", d."d_moy"),
 v2 as(
 select v1."i_category"
        ,v1."d_year", v1."d_moy"
        ,v1.avg_monthly_sales
        ,v1.sum_sales, v1_lag.sum_sales psum, v1_lead.sum_sales nsum
 from v1, v1 v1_lag, v1 v1_lead
 where v1."i_category" = v1_lag."i_category" and
       v1."i_category" = v1_lead."i_category" and
       v1."i_brand" = v1_lag."i_brand" and
       v1."i_brand" = v1_lead."i_brand" and
       v1."s_store_name" = v1_lag."s_store_name" and
       v1."s_store_name" = v1_lead."s_store_name" and
       v1."s_company_name" = v1_lag."s_company_name" and
       v1."s_company_name" = v1_lead."s_company_name" and
       v1.rn = v1_lag.rn + 1 and
       v1.rn = v1_lead.rn - 1)
 select * from ( select  *
 from v2
 where  v2."d_year" = 2000 and
        v2.avg_monthly_sales > 0 and
        case when v2.avg_monthly_sales > 0 then abs(v2.sum_sales - v2.avg_monthly_sales) / v2.avg_monthly_sales else null end > 0.1
 order by v2.sum_sales - v2.avg_monthly_sales, 3
  ) as tbl;
