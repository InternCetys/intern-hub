Pagina inicial: http://localhost:3000/login
Deployment: https://intern-hub.vercel.app/

Comandos:
`yarn` instala todas las librerias
`yarn dev` inicia el servidor y cliente
`npx prisma migrate dev --name "Descripcion de la migracion que hiciste"` para migrar la base de datos y aplicar los cambios nuevos
`npx primsa studio` abrir la UI de prisma de manera local

## PARA REALIZAR UNA MIGRACION
- Cambiarte a Main
- Modifica `schema.prisma`
- `npx prisma migrate dev --name 'detalle de la migracion'
- `git push`
- Cambiate a tu rama
- `git merge main`
- Resuleve conflictos si los hay
- `git push`


**USAR NODE 16**

Stack:

- Next.js
- TRPC
- Typescript
- NextAuth
- Mantine UI

Deployment:

- Vercel
- Supabase (base de datos)
