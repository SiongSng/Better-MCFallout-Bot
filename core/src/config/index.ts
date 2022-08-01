export class Config {
  constructor(
    host: string,
    port: number,
    email: string,
    password: string,
    autoEat: boolean,
    autoThrow: boolean,
    autoReconnect: boolean,
    warpPublicity: string | null,
    tradePublicity: string | null,
    hideHealth: boolean,
  ) {
    this.host = host;
    this.port = port;
    this.email = email;
    this.password = password;
    this.autoEat = autoEat;
    this.autoThrow = autoThrow;
    this.autoReconnect = autoReconnect;
    this.warpPublicity = warpPublicity;
    this.tradePublicity = tradePublicity;
    this.hideHealth = hideHealth;
  }

  host: string;
  port: number;
  email: string;
  password: string;
  autoEat: boolean;
  autoThrow: boolean;
  autoReconnect: boolean;
  warpPublicity: string | null;
  tradePublicity: string | null;
  hideHealth: boolean;
}
