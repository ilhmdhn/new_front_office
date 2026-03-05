enum PosType {
  oldPos('POS'),
  posWebBased('New POS'),
  restoOnlyOld('Resto'),
  restoOnlyWebBased('New Resto');

  final String label;
  const PosType(this.label);
  
  factory PosType.fromString(String value) {
    switch (value) {
      case 'POS':
        return PosType.oldPos;
      case 'New POS':
        return PosType.posWebBased;
      case 'Resto':
        return PosType.restoOnlyOld;
      case 'New Resto':
        return PosType.restoOnlyWebBased;
      default:
        return PosType.oldPos; // Default
    }
  }
}