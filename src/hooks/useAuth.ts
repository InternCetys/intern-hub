import { useRouter } from "next/router";
import { useSession } from "next-auth/react";

export const useAuth = () => {
  const router = useRouter();

  const { status, data: session } = useSession({
    required: true,
    onUnauthenticated: () => {
      router.push("/login");
    },
  });

  return { status, session };
};
