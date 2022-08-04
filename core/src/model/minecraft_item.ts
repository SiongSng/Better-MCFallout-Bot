export class MinecraftItem {
  constructor(name: string, displayName: string, count: number, type: number) {
    this.name = name;
    this.displayName = displayName;
    this.count = count;
    this.type = type;
  }

  name: string;
  displayName: string;
  count: number;

  /// Numerical id.
  type: number;
}
