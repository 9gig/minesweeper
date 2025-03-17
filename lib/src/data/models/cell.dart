class Cell {
  bool isMine;
  bool isRevealed;
  bool isFlagged;
  int number;

  Cell({
    this.isMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.number = 0,
  });
}
