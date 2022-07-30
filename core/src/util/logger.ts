import { MinecraftItem } from "@/bot/minecraft_item";

export class EventEmitter {
  static emit(event: Event, data?: unknown) {
    const log = {
      event,
      data,
    };

    console.log(JSON.stringify(log));
  }

  static info(message: string) {
    this.emit(Event.info, message);
  }

  static error(message: string) {
    this.emit(Event.error, message);
  }

  static gameMessage(message: string, sent_time: number) {
    this.emit(Event.gameMessage, {
      message,
      sent_time,
    });
  }

  static updateStatus(
    ping: number,
    health: number,
    foodSaturation: number,
    time: number,
    inventoryItems: Array<any>
  ) {
    this.emit(Event.status, {
      ping,
      health,
      foodSaturation,
      time,
      inventoryItems,
    });
  }
}

export enum Event {
  info = "info",
  warn = "warn",
  error = "error",
  gameMessage = "gameMessage",
  connected = "connected",
  disconnected = "disconnected",
  status = "status",
}
