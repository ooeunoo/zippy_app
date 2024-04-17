export const isNumeric = (str: string) => {
  try {
    return !isNaN(parseInt(str)); // 12
  } catch (e) {
    return false;
  }
};
