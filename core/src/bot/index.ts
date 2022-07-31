import { BotHelper } from "@/bot/bot_helper";
import { EventEmitter, Event } from "@/util/event_emitter";
import * as mineflayer from "mineflayer";
import autoeat from "mineflayer-auto-eat";
import * as readline from "readline";
import { ActionHandler } from "@/util/action_handler";
import { config } from "@/index";

export function createBot(reconnectTimes = 0) {
  const bot = mineflayer.createBot({
    username: config.email,
    password: config.password,
    auth: "microsoft",
    host: config.host,
    port: config.port,
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

  bot.once("end", () => {
    EventEmitter.emit(Event.disconnected);
    BotHelper.reconnect(config, reconnectTimes);
  });

  // Error handling
  bot.on("error", (err) => {
    EventEmitter.error(err.message);
  });
}

function listenBotEvent(bot: mineflayer.Bot) {
  bot.once("spawn", () => BotHelper.onSpawn(bot, config));

  bot.on("message", (message) => {
    EventEmitter.gameMessage(message.valueOf(), new Date().getTime());
  });

  // @ts-ignore
  bot.on("autoeat_started", () => {
    EventEmitter.info("Auto Eat started!");
  });

  // @ts-ignore
  bot.on("autoeat_stopped", () => {
    EventEmitter.info("Auto Eat stopped!");
  });

  bot.on("health", () => {
    if (bot.food == 20 || !config.autoEat) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (bot as any).autoEat.disable();
    } else {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (bot as any).autoEat.enable();
    }
  });

  bot.on("kicked", (reason) => {
    EventEmitter.error(`The bot was kicked by server: ${reason}`);
  });
}
