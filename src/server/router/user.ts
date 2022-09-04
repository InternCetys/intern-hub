import { createReactQueryHooks } from "@trpc/react";

import { createRouter } from "./context";
import { z } from "zod";

export const userRouter = createRouter().query("getIsInternMember", {
  async resolve(req) {
    if (!req.ctx.session) {
      throw new Error("not logged in");
    }

    const { user } = req.ctx.session;
    return req.ctx.prisma.user.findUnique({
      where: { id: user.id },
      select: { isInternMember: true },
    });
  },
});
