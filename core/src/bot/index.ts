import { MinecraftItem } from "@/bot/model/minecraft_item";
import { EventEmitter, Event } from "@/util/event_emitter";
import { Config } from "@/config";
import * as mineflayer from "mineflayer";
import * as readline from "readline";
import { ActionHandler } from "@/util/action_handler";

export function createBot(config: Config) {
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
    ActionHandler.handle(bot, line);
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
  });

  bot.once("end", () => {
    EventEmitter.emit(Event.disconnected);
  });

  // Error handling
  bot.on("error", (err) => {
    EventEmitter.error(err.message);
  });
}
