export class Config {
  constructor(
    host: string,
    port: number,
    username: string,
    token: string,
    uuid: string,
    autoEat: boolean,
    autoThrow: boolean,
    warpPublicity: string | null,
    tradePublicity: string | null,
    allowTpa: string[]
  ) {
    this.host = host;
    this.port = port;
    this.username = username;
    this.token = token;
    this.uuid = uuid;
    this.autoEat = autoEat;
    this.autoThrow = autoThrow;
    this.warpPublicity = warpPublicity;
    this.tradePublicity = tradePublicity;
    this.allowTpa = allowTpa;
  }

  host: string;
  port: number;
  username: string;
  token: string;
  uuid: string;
  autoEat: boolean;
  autoThrow: boolean;
  warpPublicity: string | null;
  tradePublicity: string | null;
  allowTpa: string[];
}
