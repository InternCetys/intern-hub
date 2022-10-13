export const capitalizeFirstLetter = (str: string) => {
  const firstLetter = str.charAt(0).toUpperCase();
  return firstLetter + str.slice(1);
};
