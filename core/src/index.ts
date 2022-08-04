import { createBot } from "@/bot";
import { Config } from "@/model/config";
import { EventEmitter } from "@/util/event_emitter";

const args = process.argv.slice(2);
export const config: Config = JSON.parse(args[0]);

try {
  createBot();
} catch (err) {
  EventEmitter.error(err);
}
