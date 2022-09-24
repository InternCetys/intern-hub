import { trpc } from "../utils/trpc";

export const useUser = () => {
  const { data: user, isLoading } = trpc.useQuery(["user.getUser"]);

  return { user, isLoading };
};
