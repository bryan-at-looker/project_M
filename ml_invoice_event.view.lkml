# view: ml_invoice_event {
#   derived_table: {
#       sql: WITH invoice_table as (
#         SELECT
#           id as invoice_id
#         , created_at as invoiced_at
#         , DATEADD(day, 30, created_at) invoice_due_at
#         , sold_at as paid_at
#         , product_brand as customer
#         , product_sku as customer_id
#         , FLOOR(cost*1000) as invoice_amount
#         , COALESCE(split_part(product_name,' ',4), 'Ongoing') as project_name
#         , CASE WHEN product_department = 'Women' Then 'Fixed' ELSE 'Flexible' END
#   FROM public.inventory_items
#   )
#   SELECT 'Invoiced' as type
#         , invoice_id
#         , invoiced_at as invoice_or_paid
#         , invoice_amount
#   FROM invoice_table
#   UNION
#   SELECT 'Paid' as type
#         , invoice_id
#         , paid_at as invoice_or_paid
#         , invoice_amount
#   FROM invoice_table
#   WHERE paid_at is not null
# ;;
#   }

#   dimension: type {
#     type: string
#     sql: ${TABLE}.type ;;
#   }

#   dimension: invoice_id {
#     type: string
#     sql: ${TABLE}.invoice_id ;;
#   }

#   dimension_group: event {
#     type: time
#     timeframes: [raw, date, week, quarter, year]
#     sql: ${TABLE}.invoice_or_paid ;;
#   }

#   dimension: invoice_amount {
#     type: string
#     sql: ${TABLE}.invoice_amount ;;
#   }

#   measure: total_invoiced {
#     type: sum
#     sql: ${invoice_amount} ;;
#     filters: {field: type value: "Invoiced"}
#     value_format_name: usd_0
#   }

#   measure: total_paid {
#     type: sum
#     sql: ${invoice_amount} ;;
#     filters: {field: type value: "Paid"}
#     value_format_name: usd_0
#   }

#   measure: net_owed {
#     type: running_total
#     sql: ${total_invoiced} - ${total_paid} ;;
#     value_format_name: usd_0
#   }

#   measure: count {
#     type: count
#   }

# }
