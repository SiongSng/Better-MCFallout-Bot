export class Config {
  constructor(
    host: string,
    port: number,
    email: string,
    password: string,
    autoEat: boolean,
    autoThrow: boolean,
    autoReconnect: boolean
  ) {
    this.host = host;
    this.port = port;
    this.email = email;
    this.password = password;
    this.autoEat = autoEat;
    this.autoThrow = autoThrow;
    this.autoReconnect = autoReconnect;
  }

  host: string;
  port: number;
  email: string;
  password: string;
  autoEat: boolean;
  autoThrow: boolean;
  autoReconnect: boolean;
}
