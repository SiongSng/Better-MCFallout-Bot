export class MinecraftItem {
  constructor(
    name: string,
    displayName: string,
    stackSize: number,
    type: number
  ) {
    this.name = name;
    this.displayName = displayName;
    this.stackSize = stackSize;
    this.type = type;
  }

  name: string;
  displayName: string;
  stackSize: number;

  /// Numerical id.
  type: number;
}
