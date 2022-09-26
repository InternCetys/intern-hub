import { createTRPCClient } from "@trpc/client";
import { z } from "zod";
import { createRouter } from "./context";

export const potwRouter = createRouter()
  .query("getCurrentWeek", {
    input: z.number(),
    resolve: async (req) => {
      return req.ctx.prisma.week.findUnique({ where: { number: req.input } });
    },
  })
  .query("getCurrentWeekById", {
    input: z.string(),
    resolve: async (req) => {
      return req.ctx.prisma.week.findUnique({ where: { id: req.input } });
    },
  })
  .query("getAllWeeks", {
    resolve: async (req) => {
      return req.ctx.prisma.week.findMany({ orderBy: { number: "desc" } });
    },
  })
  .mutation("updateWeek", {
    input: z.object({
      oldWeekNumber: z.number(),
      newWeekNumber: z.number(),
      title: z.string(),
    }),
    resolve: async (req) => {
      return req.ctx.prisma.week.update({
        where: { number: req.input.oldWeekNumber },
        data: {
          number: req.input.newWeekNumber,
          title: req.input.title,
        },
      });
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
        orderBy: {
          difficulty: "asc",
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
  .mutation("editProblem", {
    input: z.object({
      id: z.string(),
      week: z.string(),
      title: z.string(),
      link: z.string(),
      difficulty: z.enum(["EASY", "MEDIUM", "HARD", "INSANE"]),
    }),
    resolve: async (req) => {
      return req.ctx.prisma.problem.update({
        where: { id: req.input.id },
        data: {
          title: req.input.title,
          link: req.input.link,
          difficulty: req.input.difficulty,
        },
      });
    },
  })
  .mutation("deleteProblem", {
    input: z.string(),
    resolve: async (req) => {
      return req.ctx.prisma.problem.delete({
        where: { id: req.input },
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
  })
  .mutation("createResource", {
    input: z.object({
      week: z.string(),
      title: z.string(),
      link: z.string(),
      type: z.enum(["VIDEO", "DOCUMENT"]),
    }),
    resolve: async (req) => {
      return req.ctx.prisma.weekResource.create({
        data: {
          title: req.input.title,
          link: req.input.link,
          type: req.input.type,
          week: {
            connect: { id: req.input.week },
          },
        },
      });
    },
  })
  .mutation("updateResource", {
    input: z.object({
      id: z.string(),
      week: z.string(),
      title: z.string(),
      link: z.string(),
      type: z.enum(["VIDEO", "DOCUMENT"]),
    }),
    resolve: async (req) => {
      return req.ctx.prisma.weekResource.update({
        where: { id: req.input.id },
        data: {
          title: req.input.title,
          link: req.input.link,
          type: req.input.type,
          week: {
            connect: { id: req.input.week },
          },
        },
      });
    },
  });
