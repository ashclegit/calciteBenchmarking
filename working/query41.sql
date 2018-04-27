select * from (select  distinct(i1."i_product_name")
 from "postgrestest"."item" i1
 where i1."i_manufact_id" between 742 and 742+40
   and (select count(*) as item_cnt
        from "postgrestest"."item" i
        where (i."i_manufact" = i1."i_manufact" and
        ((i1."i_category" = 'Women' and
        (i1."i_color" = 'orchid' or i1."i_color" = 'papaya') and
        (i1."i_units" = 'Pound' or i1."i_units" = 'Lb') and
        (i1."i_size" = 'petite' or i1."i_size" = 'medium')
        ) or
        (i1."i_category" = 'Women' and
        (i1."i_color" = 'burlywood' or i1."i_color" = 'navy') and
        (i1."i_units" = 'Bundle' or i1."i_units" = 'Each') and
        (i1."i_size" = 'N/A' or i1."i_size" = 'extra large')
        ) or
        (i1."i_category" = 'Men' and
        (i1."i_color" = 'bisque' or i1."i_color" = 'azure') and
        (i1."i_units" = 'N/A' or i1."i_units" = 'Tsp') and
        (i1."i_size" = 'small' or i1."i_size" = 'large')
        ) or
        (i1."i_category" = 'Men' and
        (i1."i_color" = 'chocolate' or i1."i_color" = 'cornflower') and
        (i1."i_units" = 'Bunch' or i1."i_units" = 'Gross') and
        (i1."i_size" = 'petite' or i1."i_size" = 'medium')
        ))) or
       (i."i_manufact" = i1."i_manufact" and
        ((i1."i_category" = 'Women' and
        (i1."i_color" = 'salmon' or i1."i_color" = 'midnight') and
        (i1."i_units" = 'Oz' or i1."i_units" = 'Box') and
        (i1."i_size" = 'petite' or i1."i_size" = 'medium')
        ) or
        (i1."i_category" = 'Women' and
        (i1."i_color" = 'snow' or i1."i_color" = 'steel') and
        (i1."i_units" = 'Carton' or i1."i_units" = 'Tbl') and
        (i1."i_size" = 'N/A' or i1."i_size" = 'extra large')
        ) or
        (i1."i_category" = 'Men' and
        (i1."i_color" = 'purple' or i1."i_color" = 'gainsboro') and
        (i1."i_units" = 'Dram' or i1."i_units" = 'Unknown') and
        (i1."i_size" = 'small' or i1."i_size" = 'large')
        ) or
        (i1."i_category" = 'Men' and
        (i1."i_color" = 'metallic' or i1."i_color" = 'forest') and
        (i1."i_units" = 'Gram' or i1."i_units" = 'Ounce') and
        (i1."i_size" = 'petite' or i1."i_size" = 'medium')
        )))) > 0
 order by i1."i_product_name"
  ) as tbl;
