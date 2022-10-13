import { createReactQueryHooks } from "@trpc/react";

import { createRouter } from "./context";
import { z } from "zod";

export const userRouter = createRouter()
  .query("getUser", {
    async resolve(req) {
      return req.ctx.user;
    },
  })
  .query("getAllUsersForSelectInput", {
    async resolve(req) {
      const users = await req.ctx.prisma.user.findMany({
        where: { isInternMember: true },
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
