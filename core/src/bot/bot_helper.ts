import { Util } from "@/util/util";
import { EventEmitter, Event } from "@/util/event_emitter";
import { Bot } from "mineflayer";
import { MinecraftItem } from "@/model/minecraft_item";
import { Item } from "prismarine-item";
import { config } from "@/index";
import { Window } from "prismarine-windows"


export class BotHelper {
  static async onSpawn(bot: Bot) {
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
      start_at: new Date().getTime(),
    });

    await Util.delay(2000); // Wait for connecting to the server

    this.throwItems(bot);

    // Every second update bot's status
    const statusUpdateIntervalID = setInterval(() => {
      if (end) clearInterval(statusUpdateIntervalID);

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
        }),
        bot.experience
      );
    }, 1000);

    const warpPublicityIntervalID = setInterval(async () => {
      if (end) clearInterval(warpPublicityIntervalID);
      await Util.delay(1500); // Delay 1.5s to prevent sending message failed
      this.warpPublicity(bot);
    }, 1000 * 60 * 30);
    this.warpPublicity(bot);

    const tradePublicityIntervalID = setInterval(async () => {
      if (end) clearInterval(tradePublicityIntervalID);
      await Util.delay(1500); // Delay 1.5s to prevent sending message failed
      this.tradePublicity(bot);
    }, 1000 * 60 * 10);
    this.tradePublicity(bot);

    bot.on("kicked", () => {
      end = true;
    });
    bot.once("end", () => {
      end = true;
    });
  }

  static async throwItems(bot: Bot) {
    const inventory = bot.inventory;

    var bannedItem = [
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

    async function toss(items: Item[]) {
      let emerald_count = 0
      if (config.auto_deposit && !bannedItem.includes("emerald")){
        bannedItem.push("emerald")
      }
      for (const item of items) {
        const isEating: boolean = (bot as any).autoEat.isEating;

        if (config.auto_throw && !isEating) {
          if (!bannedItem.includes(item.name)) {
            await bot.tossStack(item);
          }
          else if (item.name == "totem_of_undying"){
            var totems = items.filter((item)=>item.name=="totem_of_undying");
            var totem_count = totems.length
            if (config.auto_deposit && totem_count >= 9){
              await bot.tossStack(item);
            }
          }
        }
        else if (item.name == "emerald"){
          emerald_count += item.count;
          if (emerald_count >= 1728){
            bot.chat("/bank");
            bot.once("windowOpen", (window) => {
              // @ts-ignore
              window.withdraw(226);
              // @ts-ignore
              window.close();
            });
            emerald_count = 0
          }
        }
      }

      // Wait for a while before throwing next items
      await Util.delay(3000);
      await toss(inventory.items());
    }

    // Wait for connecting to the server
    await Util.delay(2000);
    await toss(inventory.items());
  }

  static warpPublicity(bot: Bot) {
    if (config.warp_publicity?.startsWith("/warp ")) {
      bot.chat(`!${config.warp_publicity}`);
    } else if (config.warp_publicity != null) {
      EventEmitter.warning("Invalid warp publicity format");
    }
  }

  static tradePublicity(bot: Bot) {
    if ((config.trade_publicity?.trim().length || 0) > 0) {
      bot.chat(`$${config.trade_publicity}`);
    } else if (config.trade_publicity != null) {
      EventEmitter.warning("Invalid trade publicity format");
    }
  }

  static autoEatConfig(bot: Bot) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const autoEat = (bot as any).autoEat;

    if (bot.food == 20 || !config.auto_eat) {
      autoEat.disable();
    } else if (config.auto_eat) {
      autoEat.enable();
    }
  }
}
