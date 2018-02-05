# view: ml_invoices {
#   derived_table: {
#     sql: WITH invoice_table as (
#       SELECT
#         id as invoice_id
#       , created_at as invoiced_at
#       , DATEADD(day, 7, created_at) as invoice_due_at
#       , sold_at as paid_at
#       , product_brand as customer
#       , product_sku as customer_id
#       , FLOOR(cost*1000) as invoice_amount
#       , COALESCE(split_part(product_name,' ',4), 'Ongoing') as project_name
#       , CASE WHEN product_department = 'Women' Then 'Fixed' ELSE 'Flexible' END as invoice_type
# FROM public.inventory_items
# )
# SELECT * FROM invoice_table
# ;;
#   }

# #   sql_table_name: invoice_table ;;

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   measure: total_invoiced {
#     type: sum
#     sql: ${invoice_amount} ;;
#     drill_fields: [detail*]
#     value_format_name: usd
#   }

#   measure: total_paid {
#     type: sum
#     sql: ${invoice_amount} ;;
#     drill_fields: [detail*]
#     filters: {field: is_paid value: "Yes" }
#   }

#   dimension: invoice_id {
#     type: string
#     sql: ${TABLE}.invoice_id ;;
#   }

#   dimension_group: invoiced {
#     type: time
#     timeframes: [raw, date, week, month, quarter, year]
#     sql: ${TABLE}.invoiced_at ;;
#   }
#   dimension_group: invoice_due {
#     type: time
#     timeframes: [raw, date, week, month, quarter, year]
#     sql: ${TABLE}.invoice_due_at ;;
#   }

#   dimension_group: paid {
#     type: time
#     timeframes: [raw, date, week, month, quarter, year]
#     sql: ${TABLE}.paid_at ;;
#   }

#   dimension_group: paid_or_invoiced {
#     type: time
#     timeframes: [raw, date, week, month, quarter, year]
#     sql: COALESCE(${paid_raw},${invoiced_raw}) ;;
#   }

#   dimension: paid_late_invoiced {
#     type: string
#     case: {
#       when: {label: "Paid"     sql:${paid_raw} IS NOT NULL ;; }
#       when: {label: "Invoiced" sql:CURRENT_TIMESTAMP <= ${invoice_due_raw} ;; }
#       when: {label: "Late"     sql: CURRENT_TIMESTAMP > ${invoice_due_raw}   ;; }
#     }
#   }

#   dimension: is_paid {
#     type: yesno
#     sql: ${paid_raw} IS NOT NULL ;;
#   }

#   dimension: customer {
#     type: string
#     sql: ${TABLE}.customer ;;
#   }

#   dimension: customer_id {
#     type: string
#     sql: ${TABLE}.customer_id ;;
#   }

#   dimension: invoice_amount {
#     type: string
#     sql: ${TABLE}.invoice_amount ;;
#   }

#   dimension: project_name {
#     type: string
#     sql: ${TABLE}.project_name ;;
#   }

#   dimension: invoice_type {
#     type: string
#     sql: ${TABLE}.invoice_type ;;
#   }

#   set: detail {
#     fields: [
#       invoice_id,
#       invoiced_date,
#       paid_date,
#       customer,
#       customer_id,
#       invoice_amount,
#       project_name
#     ]
#   }
# }
