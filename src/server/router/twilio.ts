import { createRouter} from "./context";
import { z } from "zod";

// Router for both twilio & twilio-sendgrid
export const twilioRouter = createRouter()
  .query('getAllEmails', {
    async resolve(req) {
      return req.ctx.prisma.user.findMany({
        select: {
          email: true,
        }
      })
    }
  })
  .mutation('sendEmail', {
    input: z
      .object({
        email: z.string().array(),
      }),
    async resolve({ input }) {
      return {
        email: input.email
      }
    }
  })
