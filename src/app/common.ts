import { PrismaClient } from "@prisma/client";
export const prisma = new PrismaClient();

export const standardFormatResponse = (
  data: any,
  status = "success",
  statusCode = 200,
  message = ""
) => {
  return {
    status: status,
    statusCode: statusCode,
    data: data,
    message: message,
  };
};
