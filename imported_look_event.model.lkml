connection: "connection_name"

include: "/thelook_event/thelook.model.lkml"
include: "/thelook_event/*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }


explore: inventory_items2 {
  join: products {
    relationship: many_to_one
    sql_on: ${inventory_items2.product_id} = ${products.id} ;;
  }
}

view: inventory_items2 {
  extends: [inventory_items]

  dimension: month_name_year {
    type: string
    group_label: "Created Date"
    sql: ${created_month_name} || ' ' || ${created_year} ;;
    order_by_field: created_month
  }

  dimension: week {
    type: string
    sql: CASE WHEN ${created_day_of_month} < 8 THEN 'Week 1'
              WHEN ${created_day_of_month} < 15 THEN 'Week 2'
              WHEN ${created_day_of_month} < 22 THEN 'Week 3'
              WHEN ${created_day_of_month} < 29 THEN 'Week 4'
              ELSE 'Week 5' END
              ;;
  }

  measure: week_1 {
    type: sum
    sql: ${cost} ;;
    filters: { field: week value: "Week 1" }
    value_format_name: usd
  }

  measure: week_2 {
    type: sum
    sql: ${cost} ;;
    filters: { field: week value: "Week 2" }
    value_format_name: usd
  }

  measure: week_3 {
    type: sum
    sql: ${cost} ;;
    filters: { field: week value: "Week 3" }
    value_format_name: usd
  }

  measure: week_4 {
    type: sum
    sql: ${cost} ;;
    filters: { field: week value: "Week 4" }
    value_format_name: usd
  }

  measure: week_5 {
    type: sum
    sql: ${cost} ;;
    filters: { field: week value: "Week 5" }
    value_format_name: usd
  }

  measure: total {
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month, month_name, raw, day_of_month, year]
    sql: ${TABLE}.created_at ;;
  }

}
