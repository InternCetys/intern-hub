-- CreateEnum
CREATE TYPE "ResourceType" AS ENUM ('SLIDES', 'VIDEO', 'PDF', 'DOCUMENT', 'OTHER');

-- CreateTable
CREATE TABLE "Resource" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "link" TEXT NOT NULL,
    "type" "ResourceType" NOT NULL,
    "date" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "internSessionId" TEXT,

    CONSTRAINT "Resource_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Resource_date_key" ON "Resource"("date");

-- AddForeignKey
ALTER TABLE "Resource" ADD CONSTRAINT "Resource_internSessionId_fkey" FOREIGN KEY ("internSessionId") REFERENCES "InternSession"("id") ON DELETE SET NULL ON UPDATE CASCADE;
