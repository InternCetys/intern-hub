-- CreateTable
CREATE TABLE "Attendance" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Attendance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AttendanceOnUsers" (
    "userId" TEXT NOT NULL,
    "attendanceId" TEXT NOT NULL,

    CONSTRAINT "AttendanceOnUsers_pkey" PRIMARY KEY ("userId","attendanceId")
);

-- AddForeignKey
ALTER TABLE "AttendanceOnUsers" ADD CONSTRAINT "AttendanceOnUsers_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AttendanceOnUsers" ADD CONSTRAINT "AttendanceOnUsers_attendanceId_fkey" FOREIGN KEY ("attendanceId") REFERENCES "Attendance"("id") ON DELETE CASCADE ON UPDATE CASCADE;
