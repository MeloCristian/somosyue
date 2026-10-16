import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error("🚨 Faltan las credenciales en .env.local");
}

const client = postgres(connectionString, { 
  prepare: false,
  ssl: 'require' 
});

export const db = drizzle({ client, logger: true });
