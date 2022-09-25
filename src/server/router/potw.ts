import { z } from "zod";
import { createRouter } from "./context";

export const potwRouter = createRouter()
  .query("getCurrentWeek", {
    input: z.number(),
    resolve: async (req) => {
      return req.ctx.prisma.week.findUnique({ where: { number: req.input } });
    },
  })
  .query("getProblemsByWeek", {
    input: z.object({
      week: z.number().min(1),
      filter: z.enum(["DIFFICULTY", "FREQUENCY", "NOT_SOLVED", "ALL"]),
    }),
    resolve: async (req) => {
      const week = await req.ctx.prisma.week.findUnique({
        where: { number: req.input.week },
      });

      if (req.input.filter === "DIFFICULTY") {
        return req.ctx.prisma.problem.findMany({
          where: {
            weekId: week?.id,
          },
          orderBy: {
            difficulty: "desc",
          },
          include: {
            userStatus: { include: { user: true } },
          },
        });
      }

      const problems = await req.ctx.prisma.problem.findMany({
        where: {
          weekId: week?.id,
        },
        include: {
          userStatus: { include: { user: true } },
        },
      });

      if (req.input.filter === "ALL") {
        return problems;
      }

      if (req.input.filter === "NOT_SOLVED") {
        return problems.filter((problem) => {
          return !problem.userStatus.find(
            (status) =>
              status.userId === req.ctx.user?.id && status.status === "SOLVED"
          );
        });
      }

      if (req.input.filter === "FREQUENCY") {
        const mappedFrequency = problems.map((problem) => {
          const solvedStatus = problem.userStatus.filter(
            (status) => status.status === "SOLVED"
          );
          return { ...problem, frequency: solvedStatus.length };
        });

        return mappedFrequency.sort((a, b) => b.frequency - a.frequency);
      }
    },
  })
  .query("getResourcesByWeek", {
    input: z.object({
      week: z.number().min(1),
    }),
    resolve: async (req) => {
      const week = await req.ctx.prisma.week.findUnique({
        where: { number: req.input.week },
      });
      return req.ctx.prisma.weekResource.findMany({
        where: {
          weekId: week?.id,
        },
      });
    },
  })
  .mutation("createProblem", {
    input: z.object({
      week: z.string(),
      title: z.string(),
      link: z.string(),
      difficulty: z.enum(["EASY", "MEDIUM", "HARD", "INSANE"]),
    }),
    resolve: async (req) => {
      return req.ctx.prisma.problem.create({
        data: {
          title: req.input.title,
          link: req.input.link,
          difficulty: req.input.difficulty,
          week: {
            connect: { id: req.input.week },
          },
        },
      });
    },
  })
  .mutation("createWeek", {
    input: z.object({
      number: z.number().min(1),
      name: z.string(),
    }),
    resolve: async (req) => {
      return req.ctx.prisma.week.create({
        data: {
          title: req.input.name,
          number: req.input.number,
        },
      });
    },
  })
  .mutation("updateProblemUserStatus", {
    input: z.object({
      problem: z.string(),
      status: z.enum(["SOLVED", "ATTEMPTED", "NOT_ATTEMPTED"]),
    }),
    resolve: async (req) => {
      if (!req.ctx.user) {
        throw new Error("Not logged in");
      }

      return req.ctx.prisma.userStatusOnProblem.upsert({
        where: {
          userId_problemId: {
            userId: req.ctx.user.id,
            problemId: req.input.problem,
          },
        },
        update: {
          status: req.input.status,
        },
        create: {
          status: req.input.status,
          problemId: req.input.problem,
          userId: req.ctx.user.id,
        },
      });
    },
  });
