import { createBot } from "@/bot";
import { Config } from "@/config";
import { EventEmitter } from "@/util/event_emitter";

const args = process.argv.slice(2);
const config: Config = JSON.parse(args[0]);
try {
  createBot(config);
} catch (err) {
  EventEmitter.error(err);
}
