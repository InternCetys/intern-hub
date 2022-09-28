/*
  Warnings:

  - You are about to drop the `Project` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "ProblemStatus" AS ENUM ('SOLVED', 'ATTEMPTED', 'NOT_ATTEMPTED');

-- DropForeignKey
ALTER TABLE "Project" DROP CONSTRAINT "Project_projectId_fkey";

-- DropTable
DROP TABLE "Project";

-- CreateTable
CREATE TABLE "Problem" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "link" TEXT NOT NULL,
    "weekId" TEXT NOT NULL,

    CONSTRAINT "Problem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Week" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,

    CONSTRAINT "Week_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WeekResource" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "type" "ResourceType" NOT NULL,
    "link" TEXT NOT NULL,
    "weekId" TEXT NOT NULL,

    CONSTRAINT "WeekResource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserStatusOnProblem" (
    "userId" TEXT NOT NULL,
    "problemId" TEXT NOT NULL,
    "status" "ProblemStatus" NOT NULL,

    CONSTRAINT "UserStatusOnProblem_pkey" PRIMARY KEY ("userId","problemId")
);

-- AddForeignKey
ALTER TABLE "Problem" ADD CONSTRAINT "Problem_weekId_fkey" FOREIGN KEY ("weekId") REFERENCES "Week"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WeekResource" ADD CONSTRAINT "WeekResource_weekId_fkey" FOREIGN KEY ("weekId") REFERENCES "Week"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserStatusOnProblem" ADD CONSTRAINT "UserStatusOnProblem_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserStatusOnProblem" ADD CONSTRAINT "UserStatusOnProblem_problemId_fkey" FOREIGN KEY ("problemId") REFERENCES "Problem"("id") ON DELETE CASCADE ON UPDATE CASCADE;
