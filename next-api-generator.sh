#!/bin/bash

mkdir test
cd test
# Step 1: Create a new Next.js app
npx create-next-app@latest my-next-app
cd my-next-app

# Step 2: Install dependencies
npm install prisma typescript ts-node @types/node --save-dev
npm install @prisma/client

# Step 3: Initialize TypeScript
npx tsc --init

# Step 4: Initialize Prisma
npx prisma init

# Step 5: Create the route.ts file
mkdir -p src/app/api
cat <<EOL > src/app/api/route.ts
import { NextResponse } from "next/server";

export async function GET() {
    return NextResponse.json({
        working: "Awesome"
    });
}
EOL

# Step 6: Update .env file with database URLs
cat <<EOL > .env
DATABASE_URL="mysql://business_upstock_api:Ramker123@192.64.80.67:3306/business_upstock_api"
SHADOW_DATABASE_URL="mysql://business_upstock_api_shadow:Ramker123@192.64.80.67:3306/business_upstock_api_shadow"
EOL

# Step 7: Update Prisma schema
cat <<EOL > prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider          = "mysql"
  url               = env("DATABASE_URL")
  shadowDatabaseUrl = env("SHADOW_DATABASE_URL")
}
EOL

# Step 8: Update next.config.mjs with headers configuration
cat <<EOL > next.config.mjs
/** @type {import('next').NextConfig} */
const nextConfig = {
  async headers() {
    return [
      {
        source: "/api/:path*",
        headers: [
          { key: "Access-Control-Allow-Credentials", value: "true" },
          { key: "Access-Control-Allow-Origin", value: "*" },
          { key: "Access-Control-Allow-Methods", value: "GET,OPTIONS,PATCH,DELETE,POST,PUT" },
          { key: "Access-Control-Allow-Headers", value: "*" },
        ],
      },
    ];
  },
};

export default nextConfig;
EOL

# Step 9: Output success message
echo "Setup complete. Your Next.js app with Prisma and TypeScript is ready."
