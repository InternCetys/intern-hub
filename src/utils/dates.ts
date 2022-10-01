import { getWeek } from "date-fns";

const STARTING_WEEK = 40;

export const getRelativeWeek = () => {
  return getWeek(new Date()) - STARTING_WEEK + 1;
};
