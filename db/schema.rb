# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_09_25_154014) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "address"
    t.string "phone"
  end

  create_table "couriers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.text "bio"
    t.integer "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.index ["email"], name: "index_couriers_on_email", unique: true
    t.index ["jti"], name: "index_couriers_on_jti"
    t.index ["reset_password_token"], name: "index_couriers_on_reset_password_token", unique: true
  end

  create_table "delivery_orders", force: :cascade do |t|
    t.integer "order_group_id"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vehicle_type"
    t.integer "transport_id"
    t.integer "courier_id"
    t.index ["courier_id"], name: "index_delivery_orders_on_courier_id"
    t.index ["order_group_id"], name: "index_delivery_orders_on_order_group_id"
    t.index ["transport_id"], name: "index_delivery_orders_on_transport_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "quantity"
    t.integer "delivery_order_id"
    t.integer "merchandise_id"
    t.integer "transport_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "merchandise_category_id"
    t.float "price"
    t.string "unit"
    t.index ["delivery_order_id"], name: "index_line_items_on_delivery_order_id"
    t.index ["merchandise_category_id"], name: "index_line_items_on_merchandise_category_id"
    t.index ["merchandise_id"], name: "index_line_items_on_merchandise_id"
    t.index ["transport_id"], name: "index_line_items_on_transport_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_memberships_on_client_id"
    t.index ["tenant_id"], name: "index_memberships_on_tenant_id"
  end

  create_table "merchandise_categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tenant_id"
    t.index ["tenant_id"], name: "index_merchandise_categories_on_tenant_id"
  end

  create_table "merchandises", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.text "description"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "merchandise_category_id"
    t.string "unit"
    t.index ["merchandise_category_id"], name: "index_merchandises_on_merchandise_category_id"
  end

  create_table "order_groups", force: :cascade do |t|
    t.integer "tenant_id"
    t.datetime "start_on"
    t.datetime "completed_on"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
    t.integer "venue_id"
    t.jsonb "recurring"
    t.integer "main_order_group_id"
    t.boolean "manual_update", default: false
    t.index ["client_id"], name: "index_order_groups_on_client_id"
    t.index ["main_order_group_id"], name: "index_order_groups_on_main_order_group_id"
    t.index ["tenant_id"], name: "index_order_groups_on_tenant_id"
    t.index ["venue_id"], name: "index_order_groups_on_venue_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transports", force: :cascade do |t|
    t.string "name"
    t.string "vehicle_type"
    t.integer "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["tenant_id"], name: "index_transports_on_tenant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "tenant_id"
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
    t.index ["client_id"], name: "index_venues_on_client_id"
  end
end
