-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
CREATE TABLE "yue_address" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"client_id" uuid,
	"country" varchar(100),
	"state" varchar(100),
	"city" varchar(100),
	"mailing_address" varchar(200),
	"detail" text,
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now()),
	"updated_at" timestamp with time zone DEFAULT timezone('utc'::text, now())
);
--> statement-breakpoint
CREATE TABLE "yue_attribute_definition" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"product_type" varchar(50),
	"code" varchar(50),
	"label" varchar(100),
	"data_type" varchar(20),
	"unit" varchar(20),
	"group_name" varchar(50),
	"is_filterable" boolean,
	"is_visible" boolean,
	"sort_order" integer
);
--> statement-breakpoint
CREATE TABLE "yue_cart" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"user_id" uuid,
	"session_id" varchar(255),
	"status" varchar(20),
	"currency" varchar(3),
	"expires_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now()),
	"updated_at" timestamp with time zone DEFAULT timezone('utc'::text, now())
);
--> statement-breakpoint
CREATE TABLE "yue_cart_item" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"cart_id" uuid,
	"product_id" uuid,
	"variant_id" uuid,
	"quantity" integer,
	"unit_price" integer,
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now()),
	"updated_at" timestamp with time zone DEFAULT timezone('utc'::text, now())
);
--> statement-breakpoint
CREATE TABLE "yue_category" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"parent_id" uuid,
	"name" varchar(50),
	"slug" varchar(150),
	"is_active" boolean,
	"sort_order" integer,
	"description" text
);
--> statement-breakpoint
CREATE TABLE "yue_client" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"person_id" uuid,
	"email" varchar(255),
	"phone" varchar(20),
	"client_type" varchar(20),
	"is_guest" boolean,
	"marketing_opt_in" boolean,
	"privacy_mode" boolean,
	"data_policy_version" varchar(50),
	"consent_ip_address" varchar(45),
	"consent_source" varchar(45),
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now()),
	"updated_at" timestamp with time zone DEFAULT timezone('utc'::text, now())
);
--> statement-breakpoint
CREATE TABLE "yue_inventory_movement" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"variant_id" uuid,
	"reference_id" uuid,
	"movement_type" varchar(50),
	"quantity" integer,
	"previous_quantity" integer,
	"new_quantity" integer,
	"reference_type" varchar(50),
	"notes" text,
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now())
);
--> statement-breakpoint
CREATE TABLE "yue_order" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"client_id" uuid,
	"cart_id" uuid,
	"status" varchar(20),
	"currency" varchar(3),
	"subtotal" integer,
	"shipping_cost" integer,
	"discount_total" integer,
	"total_amount" integer,
	"shipping_address_snapshot" jsonb,
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now()),
	"updated_at" timestamp with time zone DEFAULT timezone('utc'::text, now())
);
--> statement-breakpoint
CREATE TABLE "yue_order_item" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"order_id" uuid,
	"product_id" uuid,
	"variant_id" uuid,
	"product_name_snapshot" varchar(255),
	"sku_snapshot" varchar(100),
	"quantity" integer,
	"unit_price" integer,
	"total_price" integer
);
--> statement-breakpoint
CREATE TABLE "yue_payments" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"order_id" uuid,
	"verified_by" uuid,
	"payment_method" varchar(50),
	"status" varchar(20),
	"receipt_url" varchar(255),
	"transaction_reference" varchar(255),
	"amount" integer,
	"verified_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "yue_person" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"first_names" varchar(100),
	"surnames" varchar(100),
	"document_type" varchar(20),
	"document_number" varchar(50),
	"birth_date" date,
	"person_type" varchar(20),
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now()),
	"updated_at" timestamp with time zone DEFAULT timezone('utc'::text, now())
);
--> statement-breakpoint
CREATE TABLE "yue_product" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"name" varchar(200),
	"slug" varchar(255),
	"short_description" text,
	"description" text,
	"product_type" varchar(50),
	"base_price" integer,
	"brand" varchar(100),
	"status" varchar(20),
	"body_safe" boolean,
	"requires_variant_selection" boolean,
	"published_date" date,
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now()),
	"updated_at" timestamp with time zone DEFAULT timezone('utc'::text, now())
);
--> statement-breakpoint
CREATE TABLE "yue_product_attribute_value" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"product_id" uuid,
	"variant_id" uuid,
	"attribute_definition_id" uuid,
	"text_value" text,
	"number_value" numeric(10,2),
	"boolean_value" boolean,
	"option_value" varchar(100)
);
--> statement-breakpoint
CREATE TABLE "yue_product_category" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"product_id" uuid,
	"category_id" uuid,
	"is_primary" boolean
);
--> statement-breakpoint
CREATE TABLE "yue_product_media" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"product_id" uuid,
	"url" text,
	"type" varchar(20),
	"is_primary" boolean,
	"sort_order" integer,
	"status" varchar(20),
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now()),
	"updated_at" timestamp with time zone DEFAULT timezone('utc'::text, now())
);
--> statement-breakpoint
CREATE TABLE "yue_product_option" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"product_id" uuid,
	"name" varchar(50),
	"display_type" varchar(20),
	"sort_order" integer,
	"is_required" boolean
);
--> statement-breakpoint
CREATE TABLE "yue_product_option_value" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"option_id" uuid,
	"label" varchar(50),
	"value" varchar(50),
	"color_hex" varchar(20),
	"img_url" varchar(255),
	"sort_order" integer,
	"is_active" boolean
);
--> statement-breakpoint
CREATE TABLE "yue_product_policy_override" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"product_id" uuid,
	"policy_id" uuid,
	"custom_summary" text,
	"is_excluded" boolean,
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now())
);
--> statement-breakpoint
CREATE TABLE "yue_product_recommendation" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"source_product_id" uuid,
	"target_product_id" uuid,
	"recommendation_type" varchar(50),
	"priority" integer,
	"is_active" boolean
);
--> statement-breakpoint
CREATE TABLE "yue_product_tag" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"product_id" uuid,
	"tag_id" uuid,
	"starts_at" timestamp with time zone,
	"ends_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "yue_product_variant" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"product_id" uuid,
	"sku" varchar(100),
	"barcode" varchar(100),
	"price" integer,
	"compare_at_price" integer,
	"cost" integer,
	"stock_quantity" integer,
	"reserved_quantity" integer,
	"allow_backorder" boolean,
	"weight_grams" integer,
	"is_default" boolean,
	"is_active" boolean,
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now()),
	"updated_at" timestamp with time zone DEFAULT timezone('utc'::text, now())
);
--> statement-breakpoint
CREATE TABLE "yue_store_policy" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"code" varchar(50),
	"version" varchar(20),
	"title" varchar(100),
	"content" text,
	"icon_url" varchar(255),
	"is_global" boolean,
	"is_active" boolean,
	"sort_order" integer,
	"published_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "yue_tag" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"name" varchar(50),
	"code" varchar(50),
	"background_color" varchar(7),
	"text_color" varchar(7),
	"priority" integer
);
--> statement-breakpoint
CREATE TABLE "yue_user" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"person_id" uuid,
	"username" varchar(255),
	"password_hash" text,
	"role" varchar(20),
	"last_login" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT timezone('utc'::text, now()),
	"updated_at" timestamp with time zone DEFAULT timezone('utc'::text, now()),
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "yue_variant_option_value" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"variant_id" uuid,
	"option_value_id" uuid,
	"is_primary" boolean
);
--> statement-breakpoint
ALTER TABLE "yue_user" ADD CONSTRAINT "yue_user_person_id_fkey" FOREIGN KEY ("person_id") REFERENCES "yue_person"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_client" ADD CONSTRAINT "yue_client_person_id_fkey" FOREIGN KEY ("person_id") REFERENCES "yue_person"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_address" ADD CONSTRAINT "yue_address_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "yue_client"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_category" ADD CONSTRAINT "yue_category_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "yue_category"("id") ON DELETE SET NULL;--> statement-breakpoint
ALTER TABLE "yue_product_category" ADD CONSTRAINT "yue_product_category_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "yue_category"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_category" ADD CONSTRAINT "yue_product_category_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "yue_product"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_media" ADD CONSTRAINT "yue_product_media_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "yue_product"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_tag" ADD CONSTRAINT "yue_product_tag_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "yue_product"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_tag" ADD CONSTRAINT "yue_product_tag_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "yue_tag"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_variant" ADD CONSTRAINT "yue_product_variant_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "yue_product"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_option" ADD CONSTRAINT "yue_product_option_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "yue_product"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_option_value" ADD CONSTRAINT "yue_product_option_value_option_id_fkey" FOREIGN KEY ("option_id") REFERENCES "yue_product_option"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_variant_option_value" ADD CONSTRAINT "yue_variant_option_value_option_value_id_fkey" FOREIGN KEY ("option_value_id") REFERENCES "yue_product_option_value"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_variant_option_value" ADD CONSTRAINT "yue_variant_option_value_variant_id_fkey" FOREIGN KEY ("variant_id") REFERENCES "yue_product_variant"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_attribute_value" ADD CONSTRAINT "yue_product_attribute_value_attribute_definition_id_fkey" FOREIGN KEY ("attribute_definition_id") REFERENCES "yue_attribute_definition"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_attribute_value" ADD CONSTRAINT "yue_product_attribute_value_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "yue_product"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_attribute_value" ADD CONSTRAINT "yue_product_attribute_value_variant_id_fkey" FOREIGN KEY ("variant_id") REFERENCES "yue_product_variant"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_recommendation" ADD CONSTRAINT "yue_product_recommendation_source_product_id_fkey" FOREIGN KEY ("source_product_id") REFERENCES "yue_product"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_recommendation" ADD CONSTRAINT "yue_product_recommendation_target_product_id_fkey" FOREIGN KEY ("target_product_id") REFERENCES "yue_product"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_policy_override" ADD CONSTRAINT "yue_product_policy_override_policy_id_fkey" FOREIGN KEY ("policy_id") REFERENCES "yue_store_policy"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_product_policy_override" ADD CONSTRAINT "yue_product_policy_override_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "yue_product"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_cart" ADD CONSTRAINT "yue_cart_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "yue_user"("id") ON DELETE SET NULL;--> statement-breakpoint
ALTER TABLE "yue_cart_item" ADD CONSTRAINT "yue_cart_item_cart_id_fkey" FOREIGN KEY ("cart_id") REFERENCES "yue_cart"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_cart_item" ADD CONSTRAINT "yue_cart_item_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "yue_product"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_cart_item" ADD CONSTRAINT "yue_cart_item_variant_id_fkey" FOREIGN KEY ("variant_id") REFERENCES "yue_product_variant"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_order" ADD CONSTRAINT "yue_order_cart_id_fkey" FOREIGN KEY ("cart_id") REFERENCES "yue_cart"("id") ON DELETE SET NULL;--> statement-breakpoint
ALTER TABLE "yue_order" ADD CONSTRAINT "yue_order_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "yue_client"("id") ON DELETE RESTRICT;--> statement-breakpoint
ALTER TABLE "yue_order_item" ADD CONSTRAINT "yue_order_item_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "yue_order"("id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "yue_order_item" ADD CONSTRAINT "yue_order_item_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "yue_product"("id") ON DELETE RESTRICT;--> statement-breakpoint
ALTER TABLE "yue_order_item" ADD CONSTRAINT "yue_order_item_variant_id_fkey" FOREIGN KEY ("variant_id") REFERENCES "yue_product_variant"("id") ON DELETE RESTRICT;--> statement-breakpoint
ALTER TABLE "yue_payments" ADD CONSTRAINT "yue_payments_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "yue_order"("id") ON DELETE RESTRICT;--> statement-breakpoint
ALTER TABLE "yue_payments" ADD CONSTRAINT "yue_payments_verified_by_fkey" FOREIGN KEY ("verified_by") REFERENCES "yue_user"("id") ON DELETE SET NULL;--> statement-breakpoint
ALTER TABLE "yue_inventory_movement" ADD CONSTRAINT "yue_inventory_movement_variant_id_fkey" FOREIGN KEY ("variant_id") REFERENCES "yue_product_variant"("id") ON DELETE CASCADE;
*/