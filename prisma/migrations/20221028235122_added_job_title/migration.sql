/*
  Warnings:

  - You are about to drop the column `name` on the `Events` table. All the data in the column will be lost.
  - Added the required column `title` to the `Events` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Events" DROP COLUMN "name",
ADD COLUMN     "title" TEXT NOT NULL,
ALTER COLUMN "date" SET DATA TYPE TEXT;
