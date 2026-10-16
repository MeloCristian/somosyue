import { defineRelations } from "drizzle-orm";
import * as schema from "./schema";

export const relations = defineRelations(schema, (r) => ({
	yueAddress: {
		yueClient: r.one.yueClient({
			from: r.yueAddress.clientId,
			to: r.yueClient.id
		}),
	},
	yueClient: {
		yueAddresses: r.many.yueAddress(),
		yuePerson: r.one.yuePerson({
			from: r.yueClient.personId,
			to: r.yuePerson.id
		}),
		yueCarts: r.many.yueCart(),
	},
	yueCart: {
		yueUser: r.one.yueUser({
			from: r.yueCart.userId,
			to: r.yueUser.id
		}),
		yueCartItems: r.many.yueCartItem(),
		yueClients: r.many.yueClient({
			from: r.yueCart.id.through(r.yueOrder.cartId),
			to: r.yueClient.id.through(r.yueOrder.clientId)
		}),
	},
	yueUser: {
		yueCarts: r.many.yueCart(),
		yueOrders: r.many.yueOrder(),
		yuePerson: r.one.yuePerson({
			from: r.yueUser.personId,
			to: r.yuePerson.id
		}),
	},
	yueCartItem: {
		yueCart: r.one.yueCart({
			from: r.yueCartItem.cartId,
			to: r.yueCart.id
		}),
		yueProduct: r.one.yueProduct({
			from: r.yueCartItem.productId,
			to: r.yueProduct.id
		}),
		yueProductVariant: r.one.yueProductVariant({
			from: r.yueCartItem.variantId,
			to: r.yueProductVariant.id
		}),
	},
	yueProduct: {
		yueCartItems: r.many.yueCartItem(),
		yueOrderItems: r.many.yueOrderItem(),
		yueProductAttributeValues: r.many.yueProductAttributeValue(),
		yueCategories: r.many.yueCategory(),
		yueProductMedias: r.many.yueProductMedia(),
		yueProductOptions: r.many.yueProductOption(),
		yueStorePolicies: r.many.yueStorePolicy(),
		yueTags: r.many.yueTag({
			from: r.yueProduct.id.through(r.yueProductTag.productId),
			to: r.yueTag.id.through(r.yueProductTag.tagId)
		}),
		yueProductVariants: r.many.yueProductVariant(),
	},
	yueProductVariant: {
		yueCartItems: r.many.yueCartItem(),
		yueInventoryMovements: r.many.yueInventoryMovement(),
		yueOrderItems: r.many.yueOrderItem(),
		yueProductAttributeValues: r.many.yueProductAttributeValue(),
		yueProduct: r.one.yueProduct({
			from: r.yueProductVariant.productId,
			to: r.yueProduct.id
		}),
		yueProductOptionValues: r.many.yueProductOptionValue(),
	},
	yueCategory: {
		yueCategory: r.one.yueCategory({
			from: r.yueCategory.parentId,
			to: r.yueCategory.id,
			alias: "yueCategory_parentId_yueCategory_id"
		}),
		yueCategories: r.many.yueCategory({
			alias: "yueCategory_parentId_yueCategory_id"
		}),
		yueProducts: r.many.yueProduct({
			from: r.yueCategory.id.through(r.yueProductCategory.categoryId),
			to: r.yueProduct.id.through(r.yueProductCategory.productId)
		}),
	},
	yuePerson: {
		yueClients: r.many.yueClient(),
		yueUsers: r.many.yueUser(),
	},
	yueInventoryMovement: {
		yueProductVariant: r.one.yueProductVariant({
			from: r.yueInventoryMovement.variantId,
			to: r.yueProductVariant.id
		}),
	},
	yueOrderItem: {
		yueOrder: r.one.yueOrder({
			from: r.yueOrderItem.orderId,
			to: r.yueOrder.id
		}),
		yueProduct: r.one.yueProduct({
			from: r.yueOrderItem.productId,
			to: r.yueProduct.id
		}),
		yueProductVariant: r.one.yueProductVariant({
			from: r.yueOrderItem.variantId,
			to: r.yueProductVariant.id
		}),
	},
	yueOrder: {
		yueOrderItems: r.many.yueOrderItem(),
		yueUsers: r.many.yueUser({
			from: r.yueOrder.id.through(r.yuePayments.orderId),
			to: r.yueUser.id.through(r.yuePayments.verifiedBy)
		}),
	},
	yueProductAttributeValue: {
		yueAttributeDefinition: r.one.yueAttributeDefinition({
			from: r.yueProductAttributeValue.attributeDefinitionId,
			to: r.yueAttributeDefinition.id
		}),
		yueProduct: r.one.yueProduct({
			from: r.yueProductAttributeValue.productId,
			to: r.yueProduct.id
		}),
		yueProductVariant: r.one.yueProductVariant({
			from: r.yueProductAttributeValue.variantId,
			to: r.yueProductVariant.id
		}),
	},
	yueAttributeDefinition: {
		yueProductAttributeValues: r.many.yueProductAttributeValue(),
	},
	yueProductMedia: {
		yueProduct: r.one.yueProduct({
			from: r.yueProductMedia.productId,
			to: r.yueProduct.id
		}),
	},
	yueProductOption: {
		yueProduct: r.one.yueProduct({
			from: r.yueProductOption.productId,
			to: r.yueProduct.id
		}),
		yueProductOptionValues: r.many.yueProductOptionValue(),
	},
	yueProductOptionValue: {
		yueProductOption: r.one.yueProductOption({
			from: r.yueProductOptionValue.optionId,
			to: r.yueProductOption.id
		}),
		yueProductVariants: r.many.yueProductVariant({
			from: r.yueProductOptionValue.id.through(r.yueVariantOptionValue.optionValueId),
			to: r.yueProductVariant.id.through(r.yueVariantOptionValue.variantId)
		}),
	},
	yueStorePolicy: {
		yueProducts: r.many.yueProduct({
			from: r.yueStorePolicy.id.through(r.yueProductPolicyOverride.policyId),
			to: r.yueProduct.id.through(r.yueProductPolicyOverride.productId)
		}),
	},
	yueTag: {
		yueProducts: r.many.yueProduct(),
	},
}))