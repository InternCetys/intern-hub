import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export function middleware(request: NextRequest) {
  console.log(request.nextUrl.pathname);
  if (request.nextUrl.pathname === "/") {
    return NextResponse.rewrite(new URL("/login", request.url));
  }

  if (request.nextUrl.pathname === "/app") {
    return NextResponse.rewrite(new URL("/app/potw", request.url));
  }

  if (request.nextUrl.pathname === "/app/dashboard") {
    return NextResponse.rewrite(new URL("/app/potw", request.url));
  }
}
