import { MinecraftItem } from "@/bot/model/minecraft_item";

export class EventEmitter {
  static emit(event: Event, data: unknown = {}) {
    const _data = {
      event,
      data,
    };

    console.log(JSON.stringify(_data));
  }

  static info(message: string) {
    this.emit(Event.info, { message });
  }

  static error(message: unknown) {
    this.emit(Event.error, { message });
  }

  static warning(message: string) {
    this.emit(Event.warn, { message });
  }

  static gameMessage(message: string, sent_at: number) {
    this.emit(Event.gameMessage, {
      message,
      sent_at,
    });
  }

  static updateStatus(
    health: number,
    food: number,
    time: string,
    inventory_items: Array<MinecraftItem>
  ) {
    this.emit(Event.status, {
      health,
      food,
      time,
      inventory_items,
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
