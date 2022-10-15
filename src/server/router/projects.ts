import { createRouter } from "./context";
import { z } from "zod";
import type { ResourceType } from "@prisma/client";

export const projectsRouter = createRouter().mutation('create-post', {})
.query('posts', {})
.query('single-post', {
    
})