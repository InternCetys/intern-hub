import { createRouter } from "./context";
import { z } from "zod";
import type { ResourceType } from "@prisma/client";

export const resourceRouter = createRouter()
  .mutation("createResource", {
    input: z.object({
      title: z.string(),
      description: z.string(),
      type: z.enum(["VIDEO", "PDF", "DOCUMENT", "SLIDES", "OTHER"]),
      session: z.string(),
      fileURL: z.string(),
    }),
    resolve: async (req) => {
      return req.ctx.prisma.resource.create({
        data: {
          title: req.input.title,
          description: req.input.description,
          type: req.input.type as ResourceType,
          internSession: {
            connect: { id: req.input.session },
          },
          link: req.input.fileURL,
        },
      });
    },
  })
  .query("getResources", {
    input: z.object({
      query: z.string().optional(),
    }),
    resolve: async (req) => {
      console.log(req.input.query);
      return req.ctx.prisma.resource.findMany({
        where: {
          OR: [
            {
              title: {
                contains: req.input.query?.trim().toLowerCase(),
                mode: "insensitive",
              },
            },
            {
              description: {
                contains: req.input.query?.trim().toLowerCase(),
                mode: "insensitive",
              },
            },
          ],
        },
      });
    },
  });
