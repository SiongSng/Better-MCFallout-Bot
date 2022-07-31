import { createBot } from "@/bot";
import { Config } from "@/config";
import { setTimeout } from "timers";

export class BotHelper {
  static reconnect(config: Config, times = 0) {
    if (config.autoReconnect && times <= 10) {
      setTimeout(() => {
        createBot(times++);
      }, 1000 * 30);
    }
  }
}
