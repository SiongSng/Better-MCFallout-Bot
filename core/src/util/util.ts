import { Bot } from "mineflayer";
export class Util {
  static delay(ms: number) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}

export function position(bot:Bot,x:number|null=null,y:number|null=null,z:number|null=null,onGround:boolean|null=null){
  bot._client.write(
    "position",{
      x:x ? x : bot.entity.position.x,
      y:y ? y : bot.entity.position.y,
      z:z ? z : bot.entity.position.z,
      onGround:(onGround != null) ? onGround : bot.entity.onGround
    }
  )
}