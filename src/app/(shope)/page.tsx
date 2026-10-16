import { ProductRepository } from "../../server/repositories/product.repo";

export default async function HomePage() {
  // Leemos la variable directamente
  const dbUrl = process.env.DATABASE_URL;
  // Ocultamos tu contraseña para imprimir de forma segura
  const safeUrl = dbUrl ? dbUrl.replace(/:([^:@]+)@/, ':***@') : "⚠️ INDEFINIDA (Vacía)";

  try {
    const products = await ProductRepository.getAllActive()
    return (
      <main className="p-10 font-sans">
        <h1 className="text-2xl font-bold text-green-600 mb-4">✅ Conexión exitosa</h1>
        <p>URL leída por Next.js: <strong>{safeUrl}</strong></p>
        <pre className="text-sm overflow-auto">
          {JSON.stringify(products, null, 2)}
        </pre>
      </main>
    );
  } catch (error: any) {
    return (
      <main className="p-10 font-sans">
        <h1 className="text-2xl font-bold mb-4 text-red-600">Error de Conexión</h1>
        <div className="bg-red-50 p-4 rounded-md border border-red-200 text-red-900 mb-4">
          <p className="font-bold border-b border-red-200 pb-2 mb-2">
            URL que está intentando usar Next.js:
          </p>
          <p className="font-mono text-sm text-blue-800">{safeUrl}</p>
        </div>
        <div className="bg-red-50 p-4 rounded-md border border-red-200 text-red-900">
          <p className="font-bold border-b border-red-200 pb-2 mb-2">Motivo del fallo:</p>
          <pre className="text-sm overflow-auto">
            {JSON.stringify(error, null, 2)}
          </pre>
        </div>
      </main>
    );
  }
}