-- 1. EXTENSIONES Y CONFIGURACIÓN BASE
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ==========================================
-- DOMINIO: PERSONAS, USUARIOS Y CLIENTES
-- ==========================================

CREATE TABLE yue_person (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_names VARCHAR(100),
    surnames VARCHAR(100),
    document_type VARCHAR(20),
    document_number VARCHAR(50),
    birth_date DATE,
    person_type VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

CREATE TABLE yue_user (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id UUID REFERENCES yue_person(id) ON DELETE CASCADE,
    username VARCHAR(255),
    password_hash TEXT,
    role VARCHAR(20),
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE yue_client (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id UUID REFERENCES yue_person(id) ON DELETE CASCADE,
    email VARCHAR(255),
    phone VARCHAR(20),
    client_type VARCHAR(20),
    is_guest BOOLEAN,
    marketing_opt_in BOOLEAN,
    privacy_mode BOOLEAN,
    data_policy_version VARCHAR(50),
    consent_ip_address VARCHAR(45),
    consent_source VARCHAR(45),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

CREATE TABLE yue_address (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID REFERENCES yue_client(id) ON DELETE CASCADE,
    country VARCHAR(100),
    state VARCHAR(100),
    city VARCHAR(100),
    mailing_address VARCHAR(200),
    detail TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);d

-- ==========================================
-- DOMINIO: CATÁLOGO Y PRODUCTOS
-- ==========================================

CREATE TABLE yue_category (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id UUID REFERENCES yue_category(id) ON DELETE SET NULL,
    name VARCHAR(50),
    slug VARCHAR(150),
    is_active BOOLEAN,
    sort_order INTEGER,
    description TEXT
);

CREATE TABLE yue_product (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(200),
    slug VARCHAR(255),
    short_description TEXT,
    description TEXT,
    product_type VARCHAR(50),
    base_price INTEGER,
    brand VARCHAR(100),
    status VARCHAR(20),
    body_safe BOOLEAN,
    requires_variant_selection BOOLEAN,
    published_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

CREATE TABLE yue_product_category (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES yue_product(id) ON DELETE CASCADE,
    category_id UUID REFERENCES yue_category(id) ON DELETE CASCADE,
    is_primary BOOLEAN
);

CREATE TABLE yue_product_media (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES yue_product(id) ON DELETE CASCADE,
    url TEXT,
    type VARCHAR(20),
    is_primary BOOLEAN,
    sort_order INTEGER,
    status VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

CREATE TABLE yue_tag (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50),
    code VARCHAR(50),
    background_color VARCHAR(7),
    text_color VARCHAR(7),
    priority INTEGER
);

CREATE TABLE yue_product_tag (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES yue_product(id) ON DELETE CASCADE,
    tag_id UUID REFERENCES yue_tag(id) ON DELETE CASCADE,
    starts_at TIMESTAMP WITH TIME ZONE,
    ends_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE yue_product_variant (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES yue_product(id) ON DELETE CASCADE,
    sku VARCHAR(100),
    barcode VARCHAR(100),
    price INTEGER,
    compare_at_price INTEGER,
    cost INTEGER,
    stock_quantity INTEGER,
    reserved_quantity INTEGER,
    allow_backorder BOOLEAN,
    weight_grams INTEGER,
    is_default BOOLEAN,
    is_active BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- ==========================================
-- DOMINIO: ATRIBUTOS Y OPCIONES DE PRODUCTO
-- ==========================================

CREATE TABLE yue_product_option (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES yue_product(id) ON DELETE CASCADE,
    name VARCHAR(50),
    display_type VARCHAR(20),
    sort_order INTEGER,
    is_required BOOLEAN
);

CREATE TABLE yue_product_option_value (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    option_id UUID REFERENCES yue_product_option(id) ON DELETE CASCADE,
    label VARCHAR(50),
    value VARCHAR(50),
    color_hex VARCHAR(20),
    img_url VARCHAR(255),
    sort_order INTEGER,
    is_active BOOLEAN
);

CREATE TABLE yue_variant_option_value (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    variant_id UUID REFERENCES yue_product_variant(id) ON DELETE CASCADE,
    option_value_id UUID REFERENCES yue_product_option_value(id) ON DELETE CASCADE,
    is_primary BOOLEAN
);

CREATE TABLE yue_attribute_definition (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_type VARCHAR(50),
    code VARCHAR(50),
    label VARCHAR(100),
    data_type VARCHAR(20),
    unit VARCHAR(20),
    group_name VARCHAR(50),
    is_filterable BOOLEAN,
    is_visible BOOLEAN,
    sort_order INTEGER
);

CREATE TABLE yue_product_attribute_value (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES yue_product(id) ON DELETE CASCADE,
    variant_id UUID REFERENCES yue_product_variant(id) ON DELETE CASCADE,
    attribute_definition_id UUID REFERENCES yue_attribute_definition(id) ON DELETE CASCADE,
    text_value TEXT,
    number_value NUMERIC(10,2),
    boolean_value BOOLEAN,
    option_value VARCHAR(100)
);

CREATE TABLE yue_product_recommendation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_product_id UUID REFERENCES yue_product(id) ON DELETE CASCADE,
    target_product_id UUID REFERENCES yue_product(id) ON DELETE CASCADE,
    recommendation_type VARCHAR(50),
    priority INTEGER,
    is_active BOOLEAN
);

-- ==========================================
-- DOMINIO: POLÍTICAS DE TIENDA
-- ==========================================

CREATE TABLE yue_store_policy (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50),
    version VARCHAR(20),
    title VARCHAR(100),
    content TEXT,
    icon_url VARCHAR(255),
    is_global BOOLEAN,
    is_active BOOLEAN,
    sort_order INTEGER,
    published_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE yue_product_policy_override (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES yue_product(id) ON DELETE CASCADE,
    policy_id UUID REFERENCES yue_store_policy(id) ON DELETE CASCADE,
    custom_summary TEXT,
    is_excluded BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- ==========================================
-- DOMINIO: CARRITO, ÓRDENES Y PAGOS
-- ==========================================

CREATE TABLE yue_cart (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES yue_user(id) ON DELETE SET NULL,
    session_id VARCHAR(255),
    status VARCHAR(20),
    currency VARCHAR(3),
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

CREATE TABLE yue_cart_item (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cart_id UUID REFERENCES yue_cart(id) ON DELETE CASCADE,
    product_id UUID REFERENCES yue_product(id) ON DELETE CASCADE,
    variant_id UUID REFERENCES yue_product_variant(id) ON DELETE CASCADE,
    quantity INTEGER,
    unit_price INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

CREATE TABLE yue_order (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID REFERENCES yue_client(id) ON DELETE RESTRICT,
    cart_id UUID REFERENCES yue_cart(id) ON DELETE SET NULL,
    status VARCHAR(20),
    currency VARCHAR(3),
    subtotal INTEGER,
    shipping_cost INTEGER,
    discount_total INTEGER,
    total_amount INTEGER,
    shipping_address_snapshot JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

CREATE TABLE yue_order_item (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES yue_order(id) ON DELETE CASCADE,
    product_id UUID REFERENCES yue_product(id) ON DELETE RESTRICT,
    variant_id UUID REFERENCES yue_product_variant(id) ON DELETE RESTRICT,
    product_name_snapshot VARCHAR(255),
    sku_snapshot VARCHAR(100),
    quantity INTEGER,
    unit_price INTEGER,
    total_price INTEGER
);

CREATE TABLE yue_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES yue_order(id) ON DELETE RESTRICT,
    verified_by UUID REFERENCES yue_user(id) ON DELETE SET NULL,
    payment_method VARCHAR(50),
    status VARCHAR(20),
    receipt_url VARCHAR(255),
    transaction_reference VARCHAR(255),
    amount INTEGER,
    verified_at TIMESTAMP WITH TIME ZONE
);

-- ==========================================
-- DOMINIO: INVENTARIO
-- ==========================================

CREATE TABLE yue_inventory_movement (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    variant_id UUID REFERENCES yue_product_variant(id) ON DELETE CASCADE,
    reference_id UUID,
    movement_type VARCHAR(50),
    quantity INTEGER,
    previous_quantity INTEGER,
    new_quantity INTEGER,
    reference_type VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);