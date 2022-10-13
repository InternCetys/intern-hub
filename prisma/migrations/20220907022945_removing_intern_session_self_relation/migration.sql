/*
  Warnings:

  - You are about to drop the column `previousSessionId` on the `InternSession` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "InternSession" DROP CONSTRAINT "InternSession_previousSessionId_fkey";

-- DropIndex
DROP INDEX "InternSession_previousSessionId_key";

-- AlterTable
ALTER TABLE "InternSession" DROP COLUMN "previousSessionId";
