import { eq } from 'drizzle-orm';
import { db } from '../db';
import { yueProduct } from '../db/schema'; 

export class ProductRepository {
  static async getAllActive() {
    return await db
      .select()
      .from(yueProduct)
      .where(eq(yueProduct.status, 'active'));
  }

  static async getBySlug(slug: string) {
    const [product] = await db
      .select()
      .from(yueProduct)
      .where(eq(yueProduct.slug, slug))
      .limit(1);
      
    return product || null;
  }
}