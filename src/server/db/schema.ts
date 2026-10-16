import { pgTable, uuid, varchar, text, boolean, timestamp, integer, date, numeric, jsonb, foreignKey, primaryKey } from "drizzle-orm/pg-core"
import { sql } from "drizzle-orm"



export const yueAddress = pgTable("yue_address", {
	id: uuid().defaultRandom().primaryKey(),
	clientId: uuid("client_id").references(() => yueClient.id, { onDelete: "cascade" } ),
	country: varchar({ length: 100 }),
	state: varchar({ length: 100 }),
	city: varchar({ length: 100 }),
	mailingAddress: varchar("mailing_address", { length: 200 }),
	detail: text(),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
	updatedAt: timestamp("updated_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
});

export const yueAttributeDefinition = pgTable("yue_attribute_definition", {
	id: uuid().defaultRandom().primaryKey(),
	productType: varchar("product_type", { length: 50 }),
	code: varchar({ length: 50 }),
	label: varchar({ length: 100 }),
	dataType: varchar("data_type", { length: 20 }),
	unit: varchar({ length: 20 }),
	groupName: varchar("group_name", { length: 50 }),
	isFilterable: boolean("is_filterable"),
	isVisible: boolean("is_visible"),
	sortOrder: integer("sort_order"),
});

export const yueCart = pgTable("yue_cart", {
	id: uuid().defaultRandom().primaryKey(),
	userId: uuid("user_id").references(() => yueUser.id, { onDelete: "set null" } ),
	sessionId: varchar("session_id", { length: 255 }),
	status: varchar({ length: 20 }),
	currency: varchar({ length: 3 }),
	expiresAt: timestamp("expires_at", { withTimezone: true }),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
	updatedAt: timestamp("updated_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
});

export const yueCartItem = pgTable("yue_cart_item", {
	id: uuid().defaultRandom().primaryKey(),
	cartId: uuid("cart_id").references(() => yueCart.id, { onDelete: "cascade" } ),
	productId: uuid("product_id").references(() => yueProduct.id, { onDelete: "cascade" } ),
	variantId: uuid("variant_id").references(() => yueProductVariant.id, { onDelete: "cascade" } ),
	quantity: integer(),
	unitPrice: integer("unit_price"),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
	updatedAt: timestamp("updated_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
});

export const yueCategory = pgTable("yue_category", {
	id: uuid().defaultRandom().primaryKey(),
	parentId: uuid("parent_id"),
	name: varchar({ length: 50 }),
	slug: varchar({ length: 150 }),
	isActive: boolean("is_active"),
	sortOrder: integer("sort_order"),
	description: text(),
}, (table) => [
	foreignKey({
		columns: [table.parentId],
		foreignColumns: [table.id],
		name: "yue_category_parent_id_fkey"
	}).onDelete("set null"),
]);

export const yueClient = pgTable("yue_client", {
	id: uuid().defaultRandom().primaryKey(),
	personId: uuid("person_id").references(() => yuePerson.id, { onDelete: "cascade" } ),
	email: varchar({ length: 255 }),
	phone: varchar({ length: 20 }),
	clientType: varchar("client_type", { length: 20 }),
	isGuest: boolean("is_guest"),
	marketingOptIn: boolean("marketing_opt_in"),
	privacyMode: boolean("privacy_mode"),
	dataPolicyVersion: varchar("data_policy_version", { length: 50 }),
	consentIpAddress: varchar("consent_ip_address", { length: 45 }),
	consentSource: varchar("consent_source", { length: 45 }),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
	updatedAt: timestamp("updated_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
});

export const yueInventoryMovement = pgTable("yue_inventory_movement", {
	id: uuid().defaultRandom().primaryKey(),
	variantId: uuid("variant_id").references(() => yueProductVariant.id, { onDelete: "cascade" } ),
	referenceId: uuid("reference_id"),
	movementType: varchar("movement_type", { length: 50 }),
	quantity: integer(),
	previousQuantity: integer("previous_quantity"),
	newQuantity: integer("new_quantity"),
	referenceType: varchar("reference_type", { length: 50 }),
	notes: text(),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
});

export const yueOrder = pgTable("yue_order", {
	id: uuid().defaultRandom().primaryKey(),
	clientId: uuid("client_id").references(() => yueClient.id, { onDelete: "restrict" } ),
	cartId: uuid("cart_id").references(() => yueCart.id, { onDelete: "set null" } ),
	status: varchar({ length: 20 }),
	currency: varchar({ length: 3 }),
	subtotal: integer(),
	shippingCost: integer("shipping_cost"),
	discountTotal: integer("discount_total"),
	totalAmount: integer("total_amount"),
	shippingAddressSnapshot: jsonb("shipping_address_snapshot"),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
	updatedAt: timestamp("updated_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
});

export const yueOrderItem = pgTable("yue_order_item", {
	id: uuid().defaultRandom().primaryKey(),
	orderId: uuid("order_id").references(() => yueOrder.id, { onDelete: "cascade" } ),
	productId: uuid("product_id").references(() => yueProduct.id, { onDelete: "restrict" } ),
	variantId: uuid("variant_id").references(() => yueProductVariant.id, { onDelete: "restrict" } ),
	productNameSnapshot: varchar("product_name_snapshot", { length: 255 }),
	skuSnapshot: varchar("sku_snapshot", { length: 100 }),
	quantity: integer(),
	unitPrice: integer("unit_price"),
	totalPrice: integer("total_price"),
});

export const yuePayments = pgTable("yue_payments", {
	id: uuid().defaultRandom().primaryKey(),
	orderId: uuid("order_id").references(() => yueOrder.id, { onDelete: "restrict" } ),
	verifiedBy: uuid("verified_by").references(() => yueUser.id, { onDelete: "set null" } ),
	paymentMethod: varchar("payment_method", { length: 50 }),
	status: varchar({ length: 20 }),
	receiptUrl: varchar("receipt_url", { length: 255 }),
	transactionReference: varchar("transaction_reference", { length: 255 }),
	amount: integer(),
	verifiedAt: timestamp("verified_at", { withTimezone: true }),
});

export const yuePerson = pgTable("yue_person", {
	id: uuid().defaultRandom().primaryKey(),
	firstNames: varchar("first_names", { length: 100 }),
	surnames: varchar({ length: 100 }),
	documentType: varchar("document_type", { length: 20 }),
	documentNumber: varchar("document_number", { length: 50 }),
	birthDate: date("birth_date"),
	personType: varchar("person_type", { length: 20 }),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
	updatedAt: timestamp("updated_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
});

export const yueProduct = pgTable("yue_product", {
	id: uuid().defaultRandom().primaryKey(),
	name: varchar({ length: 200 }),
	slug: varchar({ length: 255 }),
	shortDescription: text("short_description"),
	description: text(),
	productType: varchar("product_type", { length: 50 }),
	basePrice: integer("base_price"),
	brand: varchar({ length: 100 }),
	status: varchar({ length: 20 }),
	bodySafe: boolean("body_safe"),
	requiresVariantSelection: boolean("requires_variant_selection"),
	publishedDate: date("published_date"),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
	updatedAt: timestamp("updated_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
});

export const yueProductAttributeValue = pgTable("yue_product_attribute_value", {
	id: uuid().defaultRandom().primaryKey(),
	productId: uuid("product_id").references(() => yueProduct.id, { onDelete: "cascade" } ),
	variantId: uuid("variant_id").references(() => yueProductVariant.id, { onDelete: "cascade" } ),
	attributeDefinitionId: uuid("attribute_definition_id").references(() => yueAttributeDefinition.id, { onDelete: "cascade" } ),
	textValue: text("text_value"),
	numberValue: numeric("number_value", { precision: 10, scale: 2 }),
	booleanValue: boolean("boolean_value"),
	optionValue: varchar("option_value", { length: 100 }),
});

export const yueProductCategory = pgTable("yue_product_category", {
	id: uuid().defaultRandom().primaryKey(),
	productId: uuid("product_id").references(() => yueProduct.id, { onDelete: "cascade" } ),
	categoryId: uuid("category_id").references(() => yueCategory.id, { onDelete: "cascade" } ),
	isPrimary: boolean("is_primary"),
});

export const yueProductMedia = pgTable("yue_product_media", {
	id: uuid().defaultRandom().primaryKey(),
	productId: uuid("product_id").references(() => yueProduct.id, { onDelete: "cascade" } ),
	url: text(),
	type: varchar({ length: 20 }),
	isPrimary: boolean("is_primary"),
	sortOrder: integer("sort_order"),
	status: varchar({ length: 20 }),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
	updatedAt: timestamp("updated_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
});

export const yueProductOption = pgTable("yue_product_option", {
	id: uuid().defaultRandom().primaryKey(),
	productId: uuid("product_id").references(() => yueProduct.id, { onDelete: "cascade" } ),
	name: varchar({ length: 50 }),
	displayType: varchar("display_type", { length: 20 }),
	sortOrder: integer("sort_order"),
	isRequired: boolean("is_required"),
});

export const yueProductOptionValue = pgTable("yue_product_option_value", {
	id: uuid().defaultRandom().primaryKey(),
	optionId: uuid("option_id").references(() => yueProductOption.id, { onDelete: "cascade" } ),
	label: varchar({ length: 50 }),
	value: varchar({ length: 50 }),
	colorHex: varchar("color_hex", { length: 20 }),
	imgUrl: varchar("img_url", { length: 255 }),
	sortOrder: integer("sort_order"),
	isActive: boolean("is_active"),
});

export const yueProductPolicyOverride = pgTable("yue_product_policy_override", {
	id: uuid().defaultRandom().primaryKey(),
	productId: uuid("product_id").references(() => yueProduct.id, { onDelete: "cascade" } ),
	policyId: uuid("policy_id").references(() => yueStorePolicy.id, { onDelete: "cascade" } ),
	customSummary: text("custom_summary"),
	isExcluded: boolean("is_excluded"),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
});

export const yueProductRecommendation = pgTable("yue_product_recommendation", {
	id: uuid().defaultRandom().primaryKey(),
	sourceProductId: uuid("source_product_id").references(() => yueProduct.id, { onDelete: "cascade" } ),
	targetProductId: uuid("target_product_id").references(() => yueProduct.id, { onDelete: "cascade" } ),
	recommendationType: varchar("recommendation_type", { length: 50 }),
	priority: integer(),
	isActive: boolean("is_active"),
});

export const yueProductTag = pgTable("yue_product_tag", {
	id: uuid().defaultRandom().primaryKey(),
	productId: uuid("product_id").references(() => yueProduct.id, { onDelete: "cascade" } ),
	tagId: uuid("tag_id").references(() => yueTag.id, { onDelete: "cascade" } ),
	startsAt: timestamp("starts_at", { withTimezone: true }),
	endsAt: timestamp("ends_at", { withTimezone: true }),
});

export const yueProductVariant = pgTable("yue_product_variant", {
	id: uuid().defaultRandom().primaryKey(),
	productId: uuid("product_id").references(() => yueProduct.id, { onDelete: "cascade" } ),
	sku: varchar({ length: 100 }),
	barcode: varchar({ length: 100 }),
	price: integer(),
	compareAtPrice: integer("compare_at_price"),
	cost: integer(),
	stockQuantity: integer("stock_quantity"),
	reservedQuantity: integer("reserved_quantity"),
	allowBackorder: boolean("allow_backorder"),
	weightGrams: integer("weight_grams"),
	isDefault: boolean("is_default"),
	isActive: boolean("is_active"),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
	updatedAt: timestamp("updated_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
});

export const yueStorePolicy = pgTable("yue_store_policy", {
	id: uuid().defaultRandom().primaryKey(),
	code: varchar({ length: 50 }),
	version: varchar({ length: 20 }),
	title: varchar({ length: 100 }),
	content: text(),
	iconUrl: varchar("icon_url", { length: 255 }),
	isGlobal: boolean("is_global"),
	isActive: boolean("is_active"),
	sortOrder: integer("sort_order"),
	publishedAt: timestamp("published_at", { withTimezone: true }),
});

export const yueTag = pgTable("yue_tag", {
	id: uuid().defaultRandom().primaryKey(),
	name: varchar({ length: 50 }),
	code: varchar({ length: 50 }),
	backgroundColor: varchar("background_color", { length: 7 }),
	textColor: varchar("text_color", { length: 7 }),
	priority: integer(),
});

export const yueUser = pgTable("yue_user", {
	id: uuid().defaultRandom().primaryKey(),
	personId: uuid("person_id").references(() => yuePerson.id, { onDelete: "cascade" } ),
	username: varchar({ length: 255 }),
	passwordHash: text("password_hash"),
	role: varchar({ length: 20 }),
	lastLogin: timestamp("last_login", { withTimezone: true }),
	createdAt: timestamp("created_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
	updatedAt: timestamp("updated_at", { withTimezone: true }).default(sql`timezone('utc'::text, now())`),
	deletedAt: timestamp("deleted_at", { withTimezone: true }),
});

export const yueVariantOptionValue = pgTable("yue_variant_option_value", {
	id: uuid().defaultRandom().primaryKey(),
	variantId: uuid("variant_id").references(() => yueProductVariant.id, { onDelete: "cascade" } ),
	optionValueId: uuid("option_value_id").references(() => yueProductOptionValue.id, { onDelete: "cascade" } ),
	isPrimary: boolean("is_primary"),
});
