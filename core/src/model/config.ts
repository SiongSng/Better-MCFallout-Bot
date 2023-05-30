export class Config {
  constructor(
    host: string,
    port: number,
    username: string,
    token: string,
    uuid: string,
    auto_eat: boolean,
    auto_throw: boolean,
    warp_publicity: string | null,
    trade_publicity: string | null,
    allow_tpa: string[],
    attack_interval_ticks: number,
    auto_deposit: boolean,
    hide_warn: boolean
  ) {
    this.host = host;
    this.port = port;
    this.username = username;
    this.token = token;
    this.uuid = uuid;
    this.auto_eat = auto_eat;
    this.auto_throw = auto_throw;
    this.warp_publicity = warp_publicity;
    this.trade_publicity = trade_publicity;
    this.allow_tpa = allow_tpa;
    this.attack_interval_ticks = attack_interval_ticks;
    this.auto_deposit = auto_deposit;
    this.hide_warn = hide_warn
  }

  host: string;
  port: number;
  username: string;
  token: string;
  uuid: string;
  auto_eat: boolean;
  auto_throw: boolean;
  warp_publicity: string | null;
  trade_publicity: string | null;
  allow_tpa: string[];
  attack_interval_ticks: number;
  auto_deposit: boolean;
  hide_warn: boolean;
}
