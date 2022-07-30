import { ActionHandler } from "@/util/action_handler";
import * as readline from "node:readline";
import { createBot } from "@/bot";
import { Config } from "@/config";
import { EventEmitter } from "@/util/event_emitter";

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false,
});

rl.on("line", function (line) {
  ActionHandler.handle(line);
});

const args = process.argv.slice(2);
const config: Config = JSON.parse(args[0]);
try {
  createBot(config);
} catch (err) {
  EventEmitter.error(err);
}
