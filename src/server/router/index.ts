// src/server/router/index.ts
import { createRouter } from "./context";
import superjson from "superjson";

import { userRouter } from "./user";
import { attendanceRouter } from "./attendance";

export const appRouter = createRouter()
  .transformer(superjson)
  .merge("user.", userRouter)
  .merge("attendance.", attendanceRouter);

// export type definition of API
export type AppRouter = typeof appRouter;
