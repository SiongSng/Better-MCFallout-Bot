import { BotHelper } from "@/bot/bot_helper";
import { BotActionMethod } from "@/model/bot_action";
import { Config } from "@/model/config";
import { EventEmitter } from "@/util/event_emitter";
import { BotAction, BotActionType } from "@/model/bot_action";
import { Bot } from "mineflayer";
import { config } from "@/index";

let _isRaiding = false;

export class ActionHandler {
  static handle(bot: Bot, json: string) {
    const action: BotAction = JSON.parse(json);

    switch (action.action) {
      case BotActionType.none:
        break;
      case BotActionType.raid:
        this._raid(bot, action);
        break;
      case BotActionType.command:
        this._command(bot, action);
        break;
      case BotActionType.updateConfig:
        this._updateConfig(bot, action);
        break;
      case BotActionType.disconnect:
        this._disconnect(bot);
        break;
    }
  }

  static _command(bot: Bot, action: BotAction) {
    const command: string | unknown = action.argument?.command;
    if (typeof command === "string") {
      bot.chat(command);

      EventEmitter.info(`Executed the command: ${command}`);
    } else {
      EventEmitter.error(`Invalid command action: ${action.argument}`);
    }
  }

  static _updateConfig(bot: Bot, action: BotAction) {
    const _config: Config | unknown = action.argument?.config;

    if (typeof _config === "object") {
      try {
        const newConfig = _config as Config;
        config.autoEat = newConfig.autoEat;
        config.autoThrow = newConfig.autoThrow;
        config.warpPublicity = newConfig.warpPublicity;
        config.tradePublicity = newConfig.tradePublicity;
        config.allowTpa = newConfig.allowTpa;

        BotHelper.autoEatConfig(bot);

        EventEmitter.info("Config updated.");
      } catch (error) {
        EventEmitter.error(`Invalid config argument: ${_config} (${error})`);
      }
    } else {
      EventEmitter.error(`Invalid config action: ${action.argument?.config}`);
    }
  }

  static _disconnect(bot: Bot) {
    bot.quit();
  }

  static _raid(bot: Bot, action: BotAction) {
    if (action.method == BotActionMethod.start) {
      if (_isRaiding)
        return EventEmitter.warning("The raid action is already running.");

      _isRaiding = true;

      // Auto attack passive mobs
      setInterval(async () => {
        if (!_isRaiding) clearInterval();
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        if ((bot as any).autoEat.isEating) return;

        const mob_list = [
          "blaze",
          "creeper",
          "drowned",
          "elder_guardian",
          "endermite",
          "evoker",
          "ghast",
          "guardian",
          "hoglin",
          "husk",
          "magma_cube",
          "phantom",
          "piglin_brute",
          "pillager",
          "ravager",
          "shulker",
          "silverfish",
          "skeleton",
          "slime",
          "stray",
          "vex",
          "vindicator",
          "witch",
          "wither_skeleton",
          "zoglin",
          "zombie_villager",
          "enderman",
          "piglin",
          "spider",
          "cave_spider",
          "zombified_piglin",
        ];

        const swords = ["netherite_sword", "diamond_sword", "iron_sword"];

        for (const entity_key in bot.entities) {
          const entity = bot.entities[entity_key];
          if (entity.name != null && mob_list.includes(entity.name)) {
            const isEquip = bot.player.entity.equipment.some((e) =>
              swords.includes(e.name)
            );
            if (!isEquip) {
              // Equip the best sword
              for (const sword of swords) {
                const bastSword = bot.inventory.findInventoryItem(
                  sword,
                  null,
                  false
                );

                if (bastSword != null) {
                  await bot.equip(bastSword, "hand");
                }
              }
            }

            bot.attack(entity);
          }
        }
      }, 1000);
    } else if (action.method == BotActionMethod.stop) {
      if (!_isRaiding)
        return EventEmitter.warning(
          "The raid action is not running, so it cannot be stopped."
        );

      _isRaiding = false;
    }
  }
}
