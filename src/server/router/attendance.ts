import { z } from "zod";
import { createRouter } from "./context";

export const attendanceRouter = createRouter()
  .mutation("createAttendance", {
    input: z.object({
      users: z.array(z.string()),
      day: z.string(),
    }),
    resolve: async (req) => {
      req.ctx.prisma.project.create({data: {owner: {connect: {id: }}}})
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
  .mutation("updateAttendance", {
    input: z.object({
      users: z.array(z.string()),
      day: z.string(),
    }),
    resolve: async (req) => {
      const attendance = await req.ctx.prisma.attendance.findUnique({
        where: { date: req.input.day },
        select: { id: true },
      });

      if (!attendance) {
        throw new Error("Attendance not found");
      }

      await req.ctx.prisma.attendanceOnUsers.deleteMany({
        where: { attendance: { date: req.input.day } },
      });

      return req.ctx.prisma.attendanceOnUsers.createMany({
        data: req.input.users.map((user) => {
          return {
            attendanceId: attendance.id,
            userId: user,
          };
        }),
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
              user: {
                select: { name: true, email: true, image: true },
              },
            },
          },
        },
      });
    },
  })
  .query("isInternSession", {
    input: z.string(),
    resolve: async (req) => {
      return req.ctx.prisma.internSession.findUnique({
        where: { date: req.input },
      });
    },
  });
