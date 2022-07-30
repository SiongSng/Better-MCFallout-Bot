import { MinecraftItem } from "@/bot/minecraft_item";
import { EventEmitter, Event } from "@/util/event_emitter";
import { Config } from "@/config";
import * as mineflayer from "mineflayer";

export function createBot(config: Config) {
  const bot = mineflayer.createBot({
    username: config.email,
    password: config.password,
    auth: "microsoft",
    host: config.host,
    port: config.port,
  });

  bot.once("spawn", () => {
    EventEmitter.emit(Event.connected, {
      host: config.host,
      port: config.port,
      gameVersion: bot.version,
      uuid: bot.player.uuid,
    });

    // Every second update bot's status
    setInterval(() => {
      EventEmitter.updateStatus(
        bot.player.ping,
        bot.health,
        bot.foodSaturation,
        bot.time.time,
        bot.inventory.items().map((item) => {
          return new MinecraftItem(
            item.name,
            item.displayName,
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
