import { resolve } from "path";
import { z } from "zod";
import { createRouter } from "./context";

export const badgesRouter = createRouter()
    .mutation("createBadge", {
        input: z.object({
            Name: z.string(),
            Description: z.string(),
        }),
        resolve: async (req) => {
            return req.ctx.prisma.badges.create({
                data: {
                    name: req.input.Name,
                    descrption : req.input.Description
                }
            })
        }
    })
    .mutation("assignBadge", {
        input: z.object({

        })
        resolve: async(req) => {
            return
        }
    });