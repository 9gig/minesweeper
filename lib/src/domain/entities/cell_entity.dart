class CellEntity {
  final bool isMine;
  final bool isRevealed;
  final bool isFlagged;
  final int number;

  CellEntity({
    this.isMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.number = 0,
  });
}
