const DEFAULT_START_AGO = 1000;

const CHUNK_SIZE = 10;

export function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export const reSizeStartEnd = (saved: number, latest: number) => {
  let start = saved;
  let end = latest;
  if (start == null) {
    start = latest - DEFAULT_START_AGO;
  }

  if (end - start > CHUNK_SIZE) {
    end = start + CHUNK_SIZE;
  }
  return { start, end };
};
