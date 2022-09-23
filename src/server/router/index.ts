// src/server/router/index.ts
import { createRouter } from "./context";
import superjson from "superjson";

import { userRouter } from "./user";
import { attendanceRouter } from "./attendance";
import { internSessionsRouter } from "./internSessions";
import { resourceRouter } from "./resource";

export const appRouter = createRouter()
  .transformer(superjson)
  .merge("user.", userRouter)
  .merge("attendance.", attendanceRouter)
  .merge("internSessions.", internSessionsRouter)
  .merge("resource.", resourceRouter);

// export type definition of API
export type AppRouter = typeof appRouter;
