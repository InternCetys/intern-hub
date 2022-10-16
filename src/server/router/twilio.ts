import { createRouter} from "./context";
import { z } from "zod";

// Router for both twilio & twilio-sendgrid
export const twilioRouter = createRouter()
  .mutation('sendEmail', {
    input: z
      .object({
        email: z.string(),
      }),
    async resolve({ input }) {
      return {
        email: input.email
      }
    }
  })
