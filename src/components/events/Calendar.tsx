import React from "react";
import FullCalendar from "@fullcalendar/react"; // must go before plugins
import dayGridPlugin from "@fullcalendar/daygrid"; // a plugin!
import { trpc } from "../../utils/trpc";

interface Date {
  title: string;
  start: string;
}

const Calendar = () => {
  const data = trpc.useQuery(["events.getEvents"]).data;
  console.log(data);
  return (
    <FullCalendar
      plugins={[dayGridPlugin]}
      initialView="dayGridMonth"
      events={data}
    />
  );
};

export default Calendar;
