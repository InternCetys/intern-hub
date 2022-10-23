import { getWeek, addDays } from "date-fns";

const STARTING_WEEK = 40;

export const getRelativeWeek = () => {
  // We subtract 5 days so the week 'starts' on Friday
  return getWeek(addDays(new Date(), -5)) - STARTING_WEEK + 1;
};
