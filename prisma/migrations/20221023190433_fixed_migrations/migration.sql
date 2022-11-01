/*
  Warnings:

  - A unique constraint covering the columns `[number]` on the table `Week` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `difficulty` to the `Problem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `number` to the `Week` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "ProblemDifficulty" AS ENUM ('EASY', 'MEDIUM', 'HARD', 'INSANE');

-- AlterTable
ALTER TABLE "Problem" ADD COLUMN     "difficulty" "ProblemDifficulty" NOT NULL;

-- AlterTable
ALTER TABLE "Week" ADD COLUMN     "number" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "Events" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Events_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Week_number_key" ON "Week"("number");

-- CreateIndex
CREATE INDEX "Week_number_idx" ON "Week" USING HASH ("number");
