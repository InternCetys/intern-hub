-- CreateTable
CREATE TABLE "InternSession" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "date" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "previousSessionId" TEXT,

    CONSTRAINT "InternSession_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "InternSession_date_key" ON "InternSession"("date");

-- CreateIndex
CREATE UNIQUE INDEX "InternSession_previousSessionId_key" ON "InternSession"("previousSessionId");

-- AddForeignKey
ALTER TABLE "InternSession" ADD CONSTRAINT "InternSession_previousSessionId_fkey" FOREIGN KEY ("previousSessionId") REFERENCES "InternSession"("id") ON DELETE SET NULL ON UPDATE CASCADE;
