import { NextResponse } from "next/server";
import { prisma, standardFormatResponse } from "../../common"
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

export async function POST(request:Request) {
    let data:any = await request.json();
    const { email, password } = data;
    try {
        const user:any = await prisma.user.findUnique({ where: { email } });
        if (!user) {
        return NextResponse.json({ message: "User not found" }, {status: 201});
        }
        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
        return NextResponse.json({ message: "Invalid credentials" }, {status: 201});
        }
        if (!user.approved) {
        return NextResponse.json({ message: "User not approved" }, {status: 201});
        }
        const token = jwt.sign({ user: user }, "your-secret-key", {
            expiresIn: "1h",
        });
        return NextResponse.json(standardFormatResponse(token), {status:200});
    } catch (error) {
        console.error("Login error:", error);
        return NextResponse.json({ message: "Internal server error" }, {status:500});
    }
}

export const OPTIONS = async (request: Request) => {
    return new NextResponse('', {
      status: 200
    })
  }