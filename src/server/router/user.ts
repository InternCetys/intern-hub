import { createReactQueryHooks } from "@trpc/react";

import { createRouter } from "./context";
import { z } from "zod";

export const userRouter = createRouter()
  .query("getUserRoles", {
    async resolve(req) {
      if (!req.ctx.session) {
        throw new Error("not logged in");
      }

      const { user } = req.ctx.session;
      return req.ctx.prisma.user.findUnique({
        where: { id: user.id },
        select: { isInternMember: true, admin: true },
      });
    },
  })
  .query("getAllUsersForSelectInput", {
    async resolve(req) {
      // Should be admin only
      if (!req.ctx.session) {
        throw new Error("not logged in");
      }
      const users = await req.ctx.prisma.user.findMany({
        where: { isInternMember: false },
        select: { id: true, name: true, email: true, image: true },
      });

      return users.map((user) => {
        return {
          label: user.name as string,
          value: user.id as string,
          image: user.image as string,
          description: user.email as string,
        };
      });
    },
  });
