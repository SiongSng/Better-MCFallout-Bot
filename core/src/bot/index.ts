import { BotHelper } from "@/bot/bot_helper";
import { MinecraftItem } from "@/bot/model/minecraft_item";
import { EventEmitter, Event } from "@/util/event_emitter";
import * as mineflayer from "mineflayer";
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

  bot.once("spawn", () => {
    EventEmitter.emit(Event.connected, {
      host: config.host,
      port: config.port,
      game_version: bot.version,
      uuid: bot.player.uuid,
      name: bot.player.displayName.valueOf(),
    });

    // Every second update bot's status
    setInterval(() => {
      EventEmitter.updateStatus(
        bot.health,
        bot.food,
        bot.time.bigTime.valueOf().toString(),
        bot.inventory.items().map((item) => {
          return new MinecraftItem(
            item.name,
            (item.customName != null
              ? JSON.parse(item.customName).extra?.[0]?.text
              : null) || item.displayName,
            item.stackSize,
            item.type
          );
        })
      );
    }, 1000);
  });

  bot.on("message", (message) => {
    EventEmitter.gameMessage(message.valueOf(), new Date().getTime());
  });

  bot.on("kicked", (reason) => {
    EventEmitter.error(reason);
    BotHelper.reconnect(config, reconnectTimes);
  });

  bot.once("end", () => {
    EventEmitter.emit(Event.disconnected);
    BotHelper.reconnect(config, reconnectTimes);
  });

  // Error handling
  bot.on("error", (err) => {
    EventEmitter.error(err.message);
  });
}
