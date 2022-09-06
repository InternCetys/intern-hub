import { z } from "zod";
import { createRouter } from "./context";

export const attendanceRouter = createRouter()
  .mutation("createAttendance", {
    input: z.object({
      users: z.array(z.string()),
      day: z.string(),
    }),
    resolve: async (req) => {
      return req.ctx.prisma.attendance.create({
        data: {
          date: req.input.day,
          users: {
            create: req.input.users.map((user) => {
              return {
                user: {
                  connect: { id: user },
                },
              };
            }),
          },
        },
      });
    },
  })
  .query("getAttendanceByDate", {
    input: z.string(),
    resolve: async (req) => {
      return req.ctx.prisma.attendance.findUnique({
        where: { date: req.input },
        include: {
          users: {
            include: {
              user: { select: { name: true, email: true, image: true } },
            },
          },
        },
      });
    },
  });
