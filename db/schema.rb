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

ActiveRecord::Schema[8.0].define(version: 2025_07_27_101315) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_recipes", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "recipe_id", null: false
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "recipe_id"], name: "index_course_recipes_on_course_id_and_recipe_id", unique: true
    t.index ["course_id"], name: "index_course_recipes_on_course_id"
    t.index ["recipe_id"], name: "index_course_recipes_on_recipe_id"
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "meal_id", null: false
    t.string "name", null: false
    t.integer "order_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_courses_on_meal_id"
    t.index ["order_number"], name: "index_courses_on_order_number"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_favorites_on_recipe_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "guests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "comments"
    t.boolean "is_household_member", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_household_member"], name: "index_guests_on_is_household_member"
    t.index ["user_id", "name"], name: "index_guests_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_guests_on_user_id"
  end

  create_table "ingredient_dictionaries", force: :cascade do |t|
    t.string "name", null: false
    t.string "plural_form"
    t.string "category"
    t.boolean "approved", default: true
    t.integer "submitted_by"
    t.string "gender"
    t.text "aliases"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_ingredient_dictionaries_on_approved"
    t.index ["category"], name: "index_ingredient_dictionaries_on_category"
    t.index ["name"], name: "index_ingredient_dictionaries_on_name", unique: true
    t.index ["plural_form"], name: "index_ingredient_dictionaries_on_plural_form"
  end

  create_table "ingredient_parsing_logs", force: :cascade do |t|
    t.bigint "recipe_id"
    t.bigint "user_id"
    t.text "original_text"
    t.json "results"
    t.integer "ingredients_found"
    t.integer "ingredients_added"
    t.float "confidence_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_ingredient_parsing_logs_on_created_at"
    t.index ["recipe_id"], name: "index_ingredient_parsing_logs_on_recipe_id"
    t.index ["user_id"], name: "index_ingredient_parsing_logs_on_user_id"
  end

  create_table "ingredient_submissions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "recipe_id"
    t.string "ingredient_name", null: false
    t.string "detected_unit"
    t.string "detected_quantity"
    t.string "context"
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_name"], name: "index_ingredient_submissions_on_ingredient_name"
    t.index ["recipe_id"], name: "index_ingredient_submissions_on_recipe_id"
    t.index ["status"], name: "index_ingredient_submissions_on_status"
    t.index ["user_id"], name: "index_ingredient_submissions_on_user_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "name"
    t.decimal "quantity"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_ingredients_on_recipe_id"
  end

  create_table "meal_guests", force: :cascade do |t|
    t.bigint "meal_id", null: false
    t.bigint "guest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_id"], name: "index_meal_guests_on_guest_id"
    t.index ["meal_id", "guest_id"], name: "index_meal_guests_on_meal_id_and_guest_id", unique: true
    t.index ["meal_id"], name: "index_meal_guests_on_meal_id"
  end

  create_table "meals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date", null: false
    t.string "meal_type", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_meals_on_date"
    t.index ["meal_type"], name: "index_meals_on_meal_type"
    t.index ["user_id"], name: "index_meals_on_user_id"
  end

  create_table "recipe_steps", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.integer "step_number"
    t.text "instruction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_steps_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "preparation_time"
    t.integer "cooking_time"
    t.integer "servings"
    t.string "difficulty"
    t.boolean "is_public", default: true
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "parsed_ingredients"
    t.datetime "ingredients_parsed_at"
    t.string "parsing_version"
    t.index ["is_public"], name: "index_recipes_on_is_public"
    t.index ["slug"], name: "index_recipes_on_slug", unique: true
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username"
    t.text "bio"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "course_recipes", "courses"
  add_foreign_key "course_recipes", "recipes"
  add_foreign_key "courses", "meals"
  add_foreign_key "favorites", "recipes"
  add_foreign_key "favorites", "users"
  add_foreign_key "guests", "users"
  add_foreign_key "ingredient_parsing_logs", "recipes"
  add_foreign_key "ingredient_parsing_logs", "users"
  add_foreign_key "ingredient_submissions", "recipes"
  add_foreign_key "ingredient_submissions", "users"
  add_foreign_key "ingredients", "recipes"
  add_foreign_key "meal_guests", "guests"
  add_foreign_key "meal_guests", "meals"
  add_foreign_key "meals", "users"
  add_foreign_key "recipe_steps", "recipes"
  add_foreign_key "recipes", "users"
  add_foreign_key "taggings", "tags"
end
