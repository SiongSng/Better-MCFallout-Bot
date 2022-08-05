import { BotHelper } from "@/bot/bot_helper";
import { EventEmitter, Event } from "@/util/event_emitter";
import * as mineflayer from "mineflayer";
import autoeat from "mineflayer-auto-eat";
import * as readline from "readline";
import { ActionHandler } from "@/util/action_handler";
import { config } from "@/index";

export function createBot() {
  const bot = mineflayer.createBot({
    username: config.email,
    password: config.password,
    auth: "microsoft",
    host: config.host,
    port: config.port,
    checkTimeoutInterval: 60 * 1000, // 60 seconds
  });

  bot.loadPlugin(autoeat);

  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false,
  });

  rl.on("line", function (line) {
    try {
      ActionHandler.handle(bot, line);
    } catch (error) {
      EventEmitter.error(`Error while handling action: ${error}`);
    }
  });

  listenBotEvent(bot);

  bot.once("end", (reason) => {
    EventEmitter.emit(Event.disconnected, { reason });
  });

  // Error handling
  bot.on("error", (err) => {
    EventEmitter.error(err.message);
  });
}

function listenBotEvent(bot: mineflayer.Bot) {
  bot.once("spawn", () => BotHelper.onSpawn(bot));

  bot.on("message", (jsonMsg) => {
    const message = jsonMsg.valueOf();

    const isTpa =
      message.startsWith("[系統] ") &&
      (message.includes("想要你傳送到 該玩家 的位置!") ||
        message.includes("想要傳送到 你 的位置"));

    if (isTpa) {
      const playerId = message.split("[系統] ")[1].split("想要")[0].trim();

      if (config.allowTpa.includes(playerId)) {
        bot.chat("/tok");
      } else {
        bot.chat("/tno");
      }
    }

    EventEmitter.gameMessage(message.valueOf(), new Date().getTime());
  });

  // @ts-ignore
  bot.on("autoeat_stopped", (err) => {
    if (err) {
      EventEmitter.warning(`Auto eat failed: ${err}`);
    }
  });

  bot.on("health", () => {
    BotHelper.autoEatConfig(bot);
  });

  bot.on("kicked", (reason) => {
    EventEmitter.error(`The bot was kicked by server: ${reason}`);
  });
}
