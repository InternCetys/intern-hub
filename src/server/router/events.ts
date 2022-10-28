import { z } from "zod";
import { createRouter } from "./context";

export const eventsRouter = createRouter().query("getEvents", {
  resolve: async (req) => {
    return req.ctx.prisma.events.findMany();
  },
});
