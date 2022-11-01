import { z } from "zod";
import { createRouter } from "./context";

export const eventsRouter = createRouter().query("getEvents", {
  resolve: async (req) => {
    return "hello";
    // return req.ctx.prisma.events.findUnique({ where: { number: req.input } }); },
  },
});
