import { EventEmitter } from '@/util/event_emitter';
import { BotAction, BotActionType } from "@/bot/model/bot_action";
import { Bot } from "mineflayer";
export class ActionHandler {
  static handle(bot: Bot, json: string) {
    const action: BotAction = JSON.parse(json);

    switch (action.action) {
      case BotActionType.none:
        break;
      case BotActionType.raid:
        break;
      case BotActionType.command: {
        const command: string | unknown = action.argument?.command;
        if (typeof command === "string") {
          bot.chat(command);
        } else {
          EventEmitter.error(`Invalid command action: ${action.argument}`);
        }
        break;
      }
    }

    console.log("Received: " + action);
  }
}
