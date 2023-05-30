import { Bot } from "mineflayer";
export class Util {
  static delay(ms: number) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}

export function position(bot:Bot,x:number|undefined=undefined,y:number|undefined=undefined,z:number|undefined=undefined,onGround:boolean|undefined=undefined){
  bot._client.write(
    "position",{
      x:x ? x : bot.entity.position.x,
      y:y ? y : bot.entity.position.y,
      z:z ? z : bot.entity.position.z,
      onGround:(onGround != undefined) ? onGround : bot.entity.onGround
    }
  )
}