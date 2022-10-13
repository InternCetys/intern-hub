import { createRouter } from "./context";
import { format } from "date-fns";
import { z } from "zod";

export const internSessionsRouter = createRouter()
  .mutation("addDayAsInternSession", {
    input: z.object({
      title: z.string(),
      date: z.string(),
    }),
    resolve: async (req) => {
      return req.ctx.prisma.internSession.create({
        data: { date: req.input.date, title: req.input.title },
      });
    },
  })
  .query("getInternSessionsForSelectInput", {
    resolve: async (req) => {
      const sessions = await req.ctx.prisma.internSession.findMany();
      return sessions.map((session) => {
        return {
          label: session.title,
          value: session.id,
          description: format(session.date, "PPPP"),
        };
      });
    },
  });
