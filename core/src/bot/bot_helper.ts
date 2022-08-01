import { Util } from "@/util/util";
import { createBot } from "@/bot";
import { Config } from "@/config";
import { EventEmitter, Event } from "@/util/event_emitter";
import { Bot } from "mineflayer";
import { setTimeout } from "timers";
import { MinecraftItem } from "@/bot/model/minecraft_item";
import { Item } from "prismarine-item";

export class BotHelper {
  static reconnect(config: Config, times = 0) {
    if (config.autoReconnect && times <= 10) {
      setTimeout(() => {
        createBot(times++);
      }, 1000 * 30);
    }
  }

  static onSpawn(bot: Bot, config: Config) {
    let end = false;

    // Auto eat
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    (bot as any).autoEat.options = {
      eatingTimeout: 8,
      startAt: 18, // If the bot has less food points than that number, it will start eating.
      bannedFood: ["rotten_flesh", "suspicious_stew"],
    };

    EventEmitter.emit(Event.connected, {
      host: config.host,
      port: config.port,
      game_version: bot.version,
      uuid: bot.player.uuid,
      name: bot.player.displayName.valueOf(),
    });

    this.throwItems(bot, config);

    // Every second update bot's status
    setInterval(() => {
      if (end) clearInterval();

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
            item.count,
            item.type
          );
        })
      );
    }, 1000);

    bot.on("kicked", () => {
      end = true;
    });
    bot.once("end", () => {
      end = true;
    });
  }

  static async throwItems(bot: Bot, config: Config) {
    const inventory = bot.inventory;

    const bannedItem = [
      // Weapons
      "bow",
      "arrow",
      "iron_sword",
      "diamond_sword",
      "golden_sword",
      "spectral_arrow",
      "tipped_arrow",
      "trident",
      "netherite_sword",

      // Armor
      "turtle_helmet",
      "leather_helmet",
      "leather_chestplate",
      "leather_leggings",
      "leather_boots",
      "chainmail_helmet",
      "chainmail_chestplate",
      "chainmail_leggings",
      "chainmail_boots",
      "iron_helmet",
      "iron_chestplate",
      "iron_leggings",
      "iron_boots",
      "diamond_helmet",
      "diamond_chestplate",
      "diamond_leggings",
      "diamond_boots",
      "iron_horse_armor",
      "diamond_horse_armor",
      "shield",
      "elytra",
      "netherite_helmet",
      "netherite_chestplate",
      "netherite_leggings",
      "netherite_boots",

      // Tools
      "iron_shovel",
      "iron_pickaxe",
      "iron_axe",
      "flint_and_steel",
      "diamond_shovel",
      "diamond_pickaxe",
      "diamond_axe",
      "diamond_hoe",
      "netherite_shovel",
      "netherite_pickaxe",
      "netherite_axe",
      "netherite_hoe",

      // Food
      "apple",
      "mushroom_stew",
      "bread",
      "porkchop",
      "cooked_porkchop",
      "golden_apple",
      "enchanted_golden_apple",
      "cod",
      "salmon",
      "tropical_fish",
      "cooked_cod",
      "cooked_salmon",
      "cake",
      "cookie",
      "melon_slice",
      "beef",
      "cooked_beef",
      "chicken",
      "cooked_chicken",
      "carrot",
      "potato",
      "baked_potato",
      "golden_carrot",
      "pumpkin_pie",
      "rabbit",
      "cooked_rabbit",
      "rabbit_stew",
      "mutton",
      "cooked_mutton",
      "beetroot",
      "beetroot_soup",
      "sweet_berries",
      "honey_bottle",
      "glow_berries",

      // Shulker Box
      "shulker_box",
      "red_shulker_box",
      "lime_shulker_box",
      "pink_shulker_box",
      "gray_shulker_box",
      "cyan_shulker_box",
      "blue_shulker_box",
      "white_shulker_box",
      "brown_shulker_box",
      "green_shulker_box",
      "black_shulker_box",
      "orange_shulker_box",
      "yellow_shulker_box",
      "purple_shulker_box",
      "magenta_shulker_box",
      "light_blue_shulker_box",
      "light_gray_shulker_box",

      "ender_chest",
      "totem_of_undying",
    ];

    async function _throw(items: IterableIterator<Item>) {
      for (const item of items) {
        if (config.autoThrow) {
          if (!bannedItem.includes(item.name)) {
            await bot.tossStack(item);
          }
        }
      }

      // Wait for a while before throwing next items
      await Util.delay(3000);
      await _throw(inventory.items().values());
    }

    // Wait for connecting to the server
    await Util.delay(2000);
    await _throw(inventory.items().values());
  }
}
