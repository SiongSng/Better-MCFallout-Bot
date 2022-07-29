import "module-alias/register";

import * as readline from "node:readline";
import { createBot } from "@/bot";
import { Config } from "@/config";

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false,
});

rl.on("line", function (line) {
  console.log("Received: " + line);
});

const args = process.argv.slice(2);
const config: Config = JSON.parse(args[0]);
createBot(config);
