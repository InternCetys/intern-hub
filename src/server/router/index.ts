// src/server/router/index.ts
import { createRouter } from "./context";
import superjson from "superjson";

import { userRouter } from "./user";
import { attendanceRouter } from "./attendance";
import { internSessionsRouter } from "./internSessions";
import { resourceRouter } from "./resource";
import { potwRouter } from "./potw";

export const appRouter = createRouter()
  .transformer(superjson)
  .middleware(async ({ ctx, next }) => {
    if (!ctx.session) {
      throw new Error("not logged in");
    }
    return next();
  })
  .merge("user.", userRouter)
  .merge("attendance.", attendanceRouter)
  .merge("internSessions.", internSessionsRouter)
  .merge("resource.", resourceRouter)
  .merge("potw.", potwRouter);

// export type definition of API
export type AppRouter = typeof appRouter;
