import { NextResponse } from "next/server";
import { prisma, standardFormatResponse } from "../../common"
import bcrypt from 'bcrypt';

export async function POST(request:Request) {
    let data:any = await request.json();
    const { email, password } = data;
    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = await prisma.user.create({
        data: { email, password: hashedPassword },
        });
        return NextResponse.json(standardFormatResponse(user), {status:200});
    } catch (error) {
        console.error("Signup error:", error);
        return NextResponse.json({ message: "Internal server error" }, {status:500});
    }
}