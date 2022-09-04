import {
  TextInput,
  PasswordInput,
  Checkbox,
  Anchor,
  Paper,
  Title,
  Text,
  Container,
  Group,
  Button,
} from "@mantine/core";
import { signIn, useSession } from "next-auth/react";
import { useRouter } from "next/router";
import { useEffect } from "react";
import { GoogleIcon } from "./GoogleButton";

export default function LoginRoot() {
  const { data: session } = useSession();
  const router = useRouter();

  useEffect(() => {
    if (session) {
      router.push("/app/dashboard");
    }
  }, [session]);

  return (
    <Container size={520} my={40}>
      <Title
        align="center"
        sx={(theme) => ({
          fontFamily: `Greycliff CF, ${theme.fontFamily}`,
          fontWeight: 900,
        })}
      >
        ¡Bienvenido a Intern Hub!
      </Title>
      <Text color="dimmed" size="sm" align="center" mt={5}>
        Asegúrate de entrar con tu correo @cetys.edu.mx
      </Text>

      <Paper withBorder shadow="md" p={30} mt={30} radius="md">
        <Button
          fullWidth
          leftIcon={<GoogleIcon />}
          color={"gray"}
          variant="outline"
          onClick={() => signIn("google")}
        >
          Iniciar Sesión
        </Button>
      </Paper>
    </Container>
  );
}
